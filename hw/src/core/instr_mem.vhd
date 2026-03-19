-- instr_mem.vhd - Simple instruction ROM (read-only) with file init
-- Copyright (C) 2025  4137314
-- GNU GPLv3

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
-- Required for hread (hex read)
use ieee.std_logic_textio.all;

entity instr_mem is
    generic (
        ADDR_WIDTH : integer := 10; -- 2^10 = 1024 words
        INIT_FILE  : string  := ""  -- Path to hex file
    );
    port (
        clk     : in  std_logic;
        addr    : in  std_logic_vector(31 downto 0); -- byte address (PC)
        instr   : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of instr_mem is
    constant DEPTH : integer := 2**ADDR_WIDTH;
    type mem_t is array (0 to DEPTH-1) of std_logic_vector(31 downto 0);
    
    -- Initialize with NOPs (0x00000013 is 'addi x0, x0, 0' in RISC-V)
    signal rom : mem_t := (others => x"00000013");
    signal word_addr_idx : integer range 0 to DEPTH-1;
begin

    -- Combinational address decoding
    -- Shift right by 2 to convert byte address to word index
    word_addr_idx <= to_integer(unsigned(addr(ADDR_WIDTH + 1 downto 2)));

    -- Combinational read
    instr <= rom(word_addr_idx);

    -- Initialization process (Simulation only)
    init_proc: process
        file f           : text;
        variable line_in : line;
        variable i       : integer := 0;
        variable sval    : std_logic_vector(31 downto 0);
        variable status  : file_open_status;
        -- FIXED: Variable 's' moved here, before 'begin'
        variable s       : string(1 to 100); 
    begin
        if INIT_FILE /= "" then
            file_open(status, f, INIT_FILE, read_mode);
            
            if status = open_ok then
                while not endfile(f) and i < DEPTH loop
                    readline(f, line_in);
                    -- Use hread to parse hex strings directly into std_logic_vector
                    hread(line_in, sval);
                    rom(i) <= sval;
                    i := i + 1;
                end loop;
                file_close(f);
            else
                report "[INSTR_MEM] Could not open INIT_FILE: " & INIT_FILE severity warning;
            end if;
        end if;
        wait; -- Process runs only once at start of simulation
    end process init_proc;

end architecture;
