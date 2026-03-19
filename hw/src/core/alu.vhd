library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    port (
        a      : in  std_logic_vector(31 downto 0);
        b      : in  std_logic_vector(31 downto 0);
        alu_op : in  std_logic_vector(3 downto 0);
        result : out std_logic_vector(31 downto 0);
        zero   : out std_logic
    );
end entity alu;

architecture rtl of alu is
begin
    process(a, b, alu_op)
        variable sa, sb : signed(31 downto 0);
        variable ua, ub : unsigned(31 downto 0);
        variable v_res  : std_logic_vector(31 downto 0);
        -- Shift amount is always the lower 5 bits of operand B in RISC-V
        variable shamt  : integer range 0 to 31;
    begin
        sa := signed(a);
        sb := signed(b);
        ua := unsigned(a);
        ub := unsigned(b);
        shamt := to_integer(unsigned(b(4 downto 0)));
        
        case alu_op is
            when "0000" => v_res := std_logic_vector(sa + sb);            -- ADD
            when "0001" => v_res := std_logic_vector(sa - sb);            -- SUB
            when "0010" => v_res := a and b;                             -- AND
            when "0011" => v_res := a or b;                              -- OR
            when "0100" => v_res := a xor b;                             -- XOR
            when "0101" => v_res := std_logic_vector(shift_left(ua, shamt));  -- SLL
            when "0110" => v_res := std_logic_vector(shift_right(ua, shamt)); -- SRL
            when "0111" => v_res := std_logic_vector(shift_right(sa, shamt)); -- SRA
            
            when "1000" => -- SLT (Set Less Than Signed)
                if sa < sb then v_res := x"00000001";
                else v_res := x"00000000"; end if;
                
            when "1001" => -- SLTU (Set Less Than Unsigned)
                if ua < ub then v_res := x"00000001";
                else v_res := x"00000000"; end if;
                
            when others => v_res := (others => '0');
        end case;

        result <= v_res;
        
        -- Zero flag logic
        if v_res = x"00000000" then
            zero <= '1';
        else
            zero <= '0';
        end if;
    end process;
end architecture rtl;
