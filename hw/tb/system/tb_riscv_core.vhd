library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;
use work.tb_utils_pkg.all;

entity tb_riscv_core is
end entity tb_riscv_core;

architecture sim of tb_riscv_core is
    -- Global Signals
    signal clk   : std_logic := '0';
    signal rst   : std_logic := '1';

    -- Memory Interface (if exposed at top level)
    signal instr_addr : std_logic_vector(31 downto 0);
    signal instr_data : std_logic_vector(31 downto 0);

begin

    -- 1. Clock Generation (using your utility)
    clk_gen_proc: process
    begin
        while now < 1000 ns loop  -- Adjust simulation timeout as needed
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
        wait;
    end process;

    -- 2. Instantiate the RISC-V Top Level
    -- Note: Update the entity name and ports to match your 'hw/src/top/riscv.vhd'
    dut: entity work.riscv
        port map (
            clk_i => clk,
            rst_i => rst
            -- Add other ports like memory interfaces here
        );

    -- 3. Stimulus Process
    stim_proc: process
    begin
        log_info("Initializing RISC-V System Simulation...");
        
        -- Hold reset for a few cycles
        rst <= '1';
        wait_cycles(clk, 5);
        rst <= '0';
        
        log_info("System out of reset. Execution started.");

        -- Let the processor run for a while
        wait for 500 ns;

        log_info("Simulation window reached. Check waveforms for execution flow.");
        wait;
    end process;

end architecture sim;
