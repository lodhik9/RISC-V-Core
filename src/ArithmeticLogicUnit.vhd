----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mario Ivanov
-- 
-- Create Date: 08/06/2022 10:31:14 AM
-- Design Name: 
-- Module Name: ArithmeticLogicUnit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_1164;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ArithmeticLogicUnit is
generic(XLEN: integer := 32);
    Port ( valueFirstRegister : in STD_LOGIC_VECTOR (31 downto 0);
           valueSecondRegister : in STD_LOGIC_VECTOR (31 downto 0);
           valueResultOfOperation : inout STD_LOGIC_VECTOR (31 downto 0);
           operationToexecute : in STD_LOGIC_VECTOR (3 downto 0);
           zero : out STD_LOGIC;
           overflow : out STD_LOGIC;
           lessThan: out STD_LOGIC
           );
end ArithmeticLogicUnit;

architecture Behavioral of ArithmeticLogicUnit is

begin
process(valueFirstRegister, valueSecondRegister, operationToexecute)
variable lessThanBool: boolean;
begin
    case operationToexecute is 
    when "0000" =>  --ADD, ADDI
        valueResultOfOperation <= std_logic_vector(unsigned(valueFirstRegister) + unsigned(valueSecondRegister));
        overflow <= valueFirstRegister(XLEN -1) and valueSecondRegister(XLEN -1); 
    when "0001" => --SUB
        valueResultOfOperation <= std_logic_vector(unsigned(valueFirstRegister) + unsigned(valueSecondRegister));
    when "0010" => --AND
        valueResultOfOperation <= std_logic_vector(valueFirstRegister and valueSecondRegister);
    when "0011" => --OR  
        valueResultOfOperation <= std_logic_vector(valueFirstRegister or valueSecondRegister);
    when "0100" => --XOR
        valueResultOfOperation <= std_logic_vector(valueFirstRegister xor valueSecondRegister);
    when "0101" => -- SLT
        if signed(valueFirstRegister) < signed(valueSecondRegister) then valueResultOfOperation <= "00000000000000000000000000000001"; else
         valueResultOfOperation <= "00000000000000000000000000000000"; end if;
        lessThanBool := (signed(valueFirstRegister) < signed(valueSecondRegister));
         if lessThanBool then lessThan <= '1'; else  lessThan <= '0'; end if;
    when "0110" => --SLTU 
         if unsigned(valueFirstRegister) < unsigned(valueSecondRegister) then valueResultOfOperation <= "00000000000000000000000000000001"; else
         valueResultOfOperation <= "00000000000000000000000000000000"; end if;
        lessThanBool := (signed(valueFirstRegister) < signed(valueSecondRegister));
        if lessThanBool then lessThan <= '1'; else  lessThan <= '0'; end if;
    when "0111" => --SLL
        valueResultOfOperation <= std_logic_vector(unsigned(valueFirstRegister) sll to_integer(signed(valueSecondRegister(4 downto 0))));
    when "1000" => --SRA  
        valueResultOfOperation <= to_stdlogicvector(to_bitvector(valueFirstRegister) sra to_integer(signed(valueSecondRegister(4 downto 0))));
    when "1001" => --SRL  
        valueResultOfOperation <= to_stdlogicvector(to_bitvector(valueFirstRegister) srl to_integer(signed(valueSecondRegister(4 downto 0))));
    when "1010" => --std_logic(signed(valueFirstRegister) <= signed(valueSecondRegister)); -- SLTE
                   if signed(valueFirstRegister) <= signed(valueSecondRegister)then lessThan <= '1'; else  lessThan <= '0'; end if;
    when "1011" =>   if unsigned(valueFirstRegister) <= unsigned(valueSecondRegister) then valueResultOfOperation <= "00000000000000000000000000000001"; else
         valueResultOfOperation <= "00000000000000000000000000000000"; end if; --SLTEU
                    if signed(valueFirstRegister) <= signed(valueSecondRegister)then lessThan <= '1'; else  lessThan <= '0'; end if;
    when "1100" =>  valueResultOfOperation <= (others => 'X');
    when "1101" =>  valueResultOfOperation <= (others => 'X');
    when "1110" =>  valueResultOfOperation <= (others => 'X');
    when "1111" =>  valueResultOfOperation <= (others => 'X');
    end case;
    if to_integer(unsigned(valueResultOfOperation)) = integer(0) then
        zero <= '1';
     else zero <= '0';
     end if;
end process;
end Behavioral;
