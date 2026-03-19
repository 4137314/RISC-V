library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.tb_utils_pkg.all;

entity tb_regfile is
end entity tb_regfile;

architecture sim of tb_regfile is
    -- Signals
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';
    signal rs1_addr  : std_logic_vector(4 downto 0) := (others => '0');
    signal rs2_addr  : std_logic_vector(4 downto 0) := (others => '0');
    signal rd_addr   : std_logic_vector(4 downto 0) := (others => '0');
    signal rs1_data  : std_logic_vector(31 downto 0);
    signal rs2_data  : std_logic_vector(31 downto 0);
    signal rd_data   : std_logic_vector(31 downto 0) := (others => '0');
    signal reg_write : std_logic := '0';

begin

    -- Instantiate Regfile
    dut: entity work.regfile
        port map (
            clk       => clk,
            rst       => rst,
            rs1_addr  => rs1_addr,
            rs2_addr  => rs2_addr,
            rd_addr   => rd_addr,
            rs1_data  => rs1_data,
            rs2_data  => rs2_data,
            rd_data   => rd_data,
            reg_write => reg_write
        );

    -- Clock Generation
    clk_process : process
    begin
        while now < 500 ns loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
        wait;
    end process;

    -- Stimulus
    stim_proc: process
    begin
        log_info("Starting Regfile Testbench...");
        
        -- Reset system
        rst <= '1';
        wait_cycles(clk, 2);
        rst <= '0';
        wait_cycles(clk, 1);

        -- Test 1: Write to x1 and x2
        log_info("Testing basic write/read...");
        rd_addr   <= "00001"; -- x1
        rd_data   <= x"DEADBEEF";
        reg_write <= '1';
        wait_cycles(clk, 1);
        
        rd_addr   <= "00010"; -- x2
        rd_data   <= x"CAFEBABE";
        wait_cycles(clk, 1);
        
        reg_write <= '0';
        
        -- Read back x1 and x2
        rs1_addr <= "00001";
        rs2_addr <= "00010";
        wait for 1 ns;
        assert (rs1_data = x"DEADBEEF") report "Read x1 failed" severity error;
        assert (rs2_data = x"CAFEBABE") report "Read x2 failed" severity error;

        -- Test 2: Ensure x0 is always 0
        log_info("Testing x0 hardwire...");
        rd_addr   <= "00000"; -- x0
        rd_data   <= x"FFFFFFFF";
        reg_write <= '1';
        wait_cycles(clk, 1);
        reg_write <= '0';
        
        rs1_addr <= "00000";
        wait for 1 ns;
        assert (rs1_data = x"00000000") report "x0 was overwritten! Error!" severity error;

        log_info("Regfile Testbench Finished.");
        wait;
    end process;

end architecture sim;
