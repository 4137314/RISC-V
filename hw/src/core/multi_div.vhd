-- multi_div.vhd - Multiply / Divide unit (minimal combinational multiply)
-- Copyright (C) 2025  4137314
-- GNU GPLv3

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multi_div is
    port (
        a     : in  std_logic_vector(31 downto 0);
        b     : in  std_logic_vector(31 downto 0);
        op    : in  std_logic_vector(1 downto 0); -- "00" MUL, "01" DIV, others NOP
        res   : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of multi_div is
    signal sa : signed(31 downto 0);
    signal sb : signed(31 downto 0);
    signal mult_res : signed(63 downto 0);
begin
    sa <= signed(a);
    sb <= signed(b);
    
    -- Combinational multiplication
    mult_res <= sa * sb;

    process(sa, sb, op, mult_res)
    begin
        case op is
            when "00" =>
                -- Use signal assignment <= for 'res'
                res <= std_logic_vector(mult_res(31 downto 0));
            when "01" =>
                if sb = 0 then
                    res <= (others => '0'); -- RISC-V spec: div by zero returns -1 or 0 depending on implementation
                else
                    -- CORRECTED: Assign result directly to output signal using <=
                    res <= std_logic_vector(sa / sb);
                end if;
            when others =>
                res <= (others => '0');
        end case;
    end process;
end architecture;
