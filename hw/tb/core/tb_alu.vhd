library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;     -- Ensure this contains log_info or use report
use work.tb_utils_pkg.all;

entity tb_alu is
end entity tb_alu;

architecture sim of tb_alu is
    -- Signals to connect to the ALU
    signal a_i      : std_logic_vector(31 downto 0) := (others => '0');
    signal b_i      : std_logic_vector(31 downto 0) := (others => '0');
    -- ALU_OP is 4 bits in your alu.vhd
    signal alu_op_i : std_logic_vector(3 downto 0)  := "0000"; 
    signal res_o    : std_logic_vector(31 downto 0);
    signal zero_o   : std_logic;

begin

    -- Instantiate the Unit Under Test (UUT)
    dut: entity work.alu
        port map (
            a      => a_i,      -- Port 'a' from alu.vhd maps to signal a_i
            b      => b_i,      -- Port 'b' maps to signal b_i
            alu_op => alu_op_i, -- Port 'alu_op' maps to signal alu_op_i
            result => res_o,    -- Port 'result' maps to signal res_o
            zero   => zero_o    -- Port 'zero' maps to signal zero_o
        );

    -- Stimulus process
    stim_proc: process
    begin
        log_info("Starting ALU Testbench...");

        -- Test 1: Addition (10 + 20 = 30)
        -- alu_op "0000" = ADD
        a_i      <= std_logic_vector(to_signed(10, 32));
        b_i      <= std_logic_vector(to_signed(20, 32));
        alu_op_i <= "0000"; 
        wait for 10 ns;
        assert (to_integer(signed(res_o)) = 30) 
            report "Addition failed! Got " & integer'image(to_integer(signed(res_o))) severity error;

        -- Test 2: Subtraction (50 - 15 = 35)
        -- alu_op "0001" = SUB
        a_i      <= std_logic_vector(to_signed(50, 32));
        b_i      <= std_logic_vector(to_signed(15, 32));
        alu_op_i <= "0001";
        wait for 10 ns;
        assert (to_integer(signed(res_o)) = 35) 
            report "Subtraction failed!" severity error;

        -- Test 3: Logical AND (0xFFFF0000 AND 0x0000FFFF = 0)
        -- alu_op "0010" = AND
        a_i      <= x"FFFF0000";
        b_i      <= x"0000FFFF";
        alu_op_i <= "0010";
        wait for 10 ns;
        assert (res_o = x"00000000") 
            report "AND failed!" severity error;
        assert (zero_o = '1')
            report "Zero flag failed on AND!" severity error;

        -- Test 4: Set Less Than (SLT) (-5 < 10 = 1)
        -- alu_op "1000" = SLT
        a_i      <= std_logic_vector(to_signed(-5, 32));
        b_i      <= std_logic_vector(to_signed(10, 32));
        alu_op_i <= "1000";
        wait for 10 ns;
        assert (res_o = x"00000001") 
            report "SLT failed!" severity error;

        -- Test 5: Logical Shift Left (SLL) (1 << 4 = 16)
        -- alu_op "0101" = SLL
        a_i      <= x"00000001";
        b_i      <= x"00000004"; -- Shift amount is b(4:0)
        alu_op_i <= "0101";
        wait for 10 ns;
        assert (to_integer(unsigned(res_o)) = 16)
            report "SLL failed!" severity error;

        log_info("ALU Testbench Finished Successfully.");
        wait; -- Stop simulation
    end process;

end architecture sim;
