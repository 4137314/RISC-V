library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package tb_utils_pkg is

    -- Simulation constants
    constant CLK_PERIOD : time := 10 ns;

    -- Clock generation procedure
    procedure clk_gen(signal clk : out std_logic; constant num_cycles : in integer);
    
    -- Helper to wait for N clock cycles
    procedure wait_cycles(signal clk : in std_logic; n : in integer);

    -- Print helpers for simulation console
    procedure log_info(msg : in string);

end package tb_utils_pkg;

package body tb_utils_pkg is

    procedure clk_gen(signal clk : out std_logic; constant num_cycles : in integer) is
    begin
        for i in 0 to num_cycles loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait; -- Stop simulation clock after cycles
    end procedure;

    procedure wait_cycles(signal clk : in std_logic; n : in integer) is
    begin
        for i in 1 to n loop
            wait until rising_edge(clk);
        end loop;
    end procedure;

    procedure log_info(msg : in string) is
    begin
        report "[TB_INFO] " & msg severity note;
    end procedure;

end package body tb_utils_pkg;
