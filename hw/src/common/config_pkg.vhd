library ieee;
use ieee.std_logic_1164.all;

package config_pkg is
    constant CLK_FREQ_MHZ : integer := 100;
    constant RESET_VECTOR : std_logic_vector(31 downto 0) := x"00000000";
    constant DATA_WIDTH   : integer := 32;
end package config_pkg;
