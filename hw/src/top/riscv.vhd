-- riscv.vhd - Top-level wrapper for the RV32I Core
-- Copyright (C) 2025  4137314

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity riscv is
    port (
        clk_i : in  std_logic;
        rst_i : in  std_logic;
        
        -- Basic External Interface (for debugging/RAM)
        trap_o : out std_logic
    );
end entity riscv;
architecture top of riscv is
    -- Internal signals
    signal pc_next    : std_logic_vector(31 downto 0);
    signal pc_current : std_logic_vector(31 downto 0);
    signal instr      : std_logic_vector(31 downto 0);
begin

    -- 1. Instruction Memory Instance
    i_imem : entity work.instr_mem
        generic map (
            ADDR_WIDTH => 12,           -- 4KB
            INIT_FILE  => "program.hex" -- Ensure this file exists in your project root
        )
        port map (
            clk   => clk_i,
            addr  => pc_current,
            instr => instr
        );

    -- 2. PC Update Logic
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' then
                pc_current <= (others => '0');
            else
                pc_current <= pc_next;
            end if;
        end if;
    end process;

    -- 3. Next PC (Simple increment for now, until we handle Branches/Jumps)
    pc_next <= std_logic_vector(unsigned(pc_current) + 4);

end architecture;
