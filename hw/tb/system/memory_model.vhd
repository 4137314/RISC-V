-- memory_model.vhd - Generic RAM model for simulation
-- Handles byte-enables for SB, SH, SW instructions.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_model is
    generic (
        ADDR_WIDTH : integer := 12; -- 4KB of RAM
        INIT_FILE  : string  := ""
    );
    port (
        clk_i    : in  std_logic;
        rst_i    : in  std_logic;
        -- Port Interface
        addr_i   : in  std_logic_vector(31 downto 0);
        data_i   : in  std_logic_vector(31 downto 0);
        data_o   : out std_logic_vector(31 downto 0);
        we_i     : in  std_logic;
        be_i     : in  std_logic_vector(3 downto 0) -- Byte Enables
    );
end entity memory_model;

architecture sim of memory_model is
    type ram_t is array (0 to (2**ADDR_WIDTH)/4 - 1) of std_logic_vector(31 downto 0);
    signal ram : ram_t := (others => (others => '0'));
begin

    process(clk_i)
        variable idx : integer;
    begin
        if rising_edge(clk_i) then
            -- Byte address to word index
            idx := to_integer(unsigned(addr_i(ADDR_WIDTH-1 downto 2)));
            
            if we_i = '1' then
                -- Byte-masked write (Essential for RISC-V)
                if be_i(0) = '1' then ram(idx)(7 downto 0)   <= data_i(7 downto 0);   end if;
                if be_i(1) = '1' then ram(idx)(15 downto 8)  <= data_i(15 downto 8);  end if;
                if be_i(2) = '1' then ram(idx)(23 downto 16) <= data_i(23 downto 16); end if;
                if be_i(3) = '1' then ram(idx)(31 downto 24) <= data_i(31 downto 24); end if;
            end if;
            
            -- Latched read
            data_o <= ram(idx);
        end if;
    end process;

end architecture sim;
