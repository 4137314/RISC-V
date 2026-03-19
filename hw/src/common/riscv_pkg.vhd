library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package riscv_pkg is

    -- Global Constants
    constant XLEN : integer := 32;
    
    -- Register Addresses
    subtype reg_addr_t is std_logic_vector(4 downto 0);
    
    -- Opcodes (RV32I Base Instruction Set)
    constant OPC_LOAD     : std_logic_vector(6 downto 0) := "0000011";
    constant OPC_STORE    : std_logic_vector(6 downto 0) := "0100011";
    constant OPC_MADD     : std_logic_vector(6 downto 0) := "0110011"; -- R-type
    constant OPC_IMM      : std_logic_vector(6 downto 0) := "0010011"; -- I-type
    constant OPC_BRANCH   : std_logic_vector(6 downto 0) := "1100011";
    constant OPC_LUI      : std_logic_vector(6 downto 0) := "0110111";
    constant OPC_AUIPC    : std_logic_vector(6 downto 0) := "0010111";
    constant OPC_JAL      : std_logic_vector(6 downto 0) := "1101111";
    constant OPC_JALR     : std_logic_vector(6 downto 0) := "1100111";
    constant OPC_SYSTEM   : std_logic_vector(6 downto 0) := "1110011";

    -- ALU Operations
    type alu_op_t is (
        ALU_ADD, ALU_SUB, ALU_SLL, ALU_SLT, 
        ALU_SLTU, ALU_XOR, ALU_SRL, ALU_SRA, 
        ALU_OR, ALU_AND, ALU_COPY_B
    );

    -- Branch Types
    type branch_t is (
        BR_NONE, BR_EQ, BR_NE, BR_LT, BR_GE, BR_LTU, BR_GEU
    );

    -- Pipeline Records (Helpful for passing data between stages)
    type control_signals_t is record
        reg_write : std_logic;
        mem_to_reg: std_logic;
        mem_read  : std_logic;
        mem_write : std_logic;
        alu_src   : std_logic;
        alu_op    : alu_op_t;
    end record;

end package riscv_pkg;

package body riscv_pkg is
    -- Functions would go here if needed
end package body riscv_pkg;
