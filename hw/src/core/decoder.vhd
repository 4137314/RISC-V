library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Use your custom package for opcodes and types
library work;
use work.riscv_pkg.all;

entity decoder is
    port (
        instr_i          : in  std_logic_vector(31 downto 0);
        
        -- Register File Addresses
        rs1_addr_o       : out reg_addr_t;
        rs2_addr_o       : out reg_addr_t;
        rd_addr_o        : out reg_addr_t;
        
        -- Control Signals (Packed in a record from riscv_pkg)
        ctrl_o           : out control_signals_t;
        
        -- Immediate Selection
        imm_sel_o        : out std_logic_vector(2 downto 0)
    );
end entity decoder;

architecture rtl of decoder is
    signal opcode : std_logic_vector(6 downto 0);
begin
    opcode <= instr_i(6 downto 0);

    -- Map Source/Destination registers
    rs1_addr_o <= instr_i(19 downto 15);
    rs2_addr_o <= instr_i(24 downto 20);
    rd_addr_o  <= instr_i(11 downto  7);

    process(opcode, instr_i)
    begin
        -- Default values (Safe state)
        ctrl_o.reg_write  <= '0';
        ctrl_o.mem_read   <= '0';
        ctrl_o.mem_write  <= '0';
        ctrl_o.alu_src    <= '0';
        ctrl_o.alu_op     <= ALU_ADD;
        imm_sel_o         <= "000";

        case opcode is
            when OPC_IMM => -- I-type (addi, slti, etc.)
                ctrl_o.reg_write <= '1';
                ctrl_o.alu_src   <= '1';
                imm_sel_o        <= "001"; -- I-type Imm
                -- ALU op logic based on funct3 would go here
                
            when OPC_MADD => -- R-type (add, sub, or, etc.)
                ctrl_o.reg_write <= '1';
                ctrl_o.alu_src   <= '0';
                imm_sel_o        <= "000";
                
            when OPC_LOAD =>
                ctrl_o.reg_write <= '1';
                ctrl_o.mem_read  <= '1';
                ctrl_o.alu_src   <= '1';
                imm_sel_o        <= "001";

            when OPC_STORE =>
                ctrl_o.mem_write <= '1';
                ctrl_o.alu_src   <= '1';
                imm_sel_o        <= "010"; -- S-type Imm

            when others =>
                null; -- Handle illegal instructions or NOP
        end case;
    end process;

end architecture rtl;
