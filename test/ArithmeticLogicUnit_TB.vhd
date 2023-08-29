----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mario Ivanov
-- Testing Engineer: Muhammad Khan Lodhi
--
-- Create Date: 08/06/2022 10:31:14 AM
-- Design Name: 
-- Module Name: ArithmeticLogicUnit_TB - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ArithmeticLogicUnit_TB is
generic(XLEN: integer := 32);  ---- I should remove this line? am I right
end ArithmeticLogicUnit_TB;

architecture Behavioral of ArithmeticLogicUnit_TB is
component ArithmeticLogicUnit is
generic(XLEN: integer := 32);
    Port ( valueFirstRegister : in STD_LOGIC_VECTOR (31 downto 0);
           valueSecondRegister : in STD_LOGIC_VECTOR (31 downto 0);
           valueResultOfOperation : inout STD_LOGIC_VECTOR (31 downto 0);
           operationToexecute : in STD_LOGIC_VECTOR (3 downto 0);
           zero : out STD_LOGIC;
           overflow : out STD_LOGIC
           );
end component;
signal valueFirstRegister , valueSecondRegister, valueResultOfOperation : std_logic_vector(XLEN - 1 downto 0);
signal operationToexecute : std_logic_vector(3 downto 0);
signal zero, overflow : std_logic;
begin

-- fill with values for testing !!!
valueFirstRegister <= x"00000001" after 5 ns,
                      x"00000010" after 10 ns,
                      x"00000100" after 15 ns,
                      x"00001000" after 20 ns,
                      x"00010000" after 25 ns,
                      x"00100000" after 30 ns,
                      x"11100000" after 35 ns,
                      x"01110000" after 40 ns,
                      x"00111000" after 45 ns,
                      x"00011100" after 50 ns,
                      x"00001110" after 55 ns,
                      x"00000111" after 60 ns,
                      x"11111111" after 65 ns,
                      x"11111111" after 70 ns,
                      x"00000000" after 75 ns,
                      x"11111111" after 80 ns,
                      x"11111111" after 81 ns,
                      x"00000000" after 82 ns,
                      x"11111111" after 84 ns,
                      x"11111111" after 85 ns,
                      x"00000000" after 86 ns,;    
valueSecondRegister <= x"00000010" after 5 ns,
                       x"00000100" after 10 ns,
                       x"00001000" after 15 ns,
                       x"00010000" after 20 ns,
                       x"00100000" after 25 ns,
                       x"01000000" after 30 ns,
                       x"01100000" after 35 ns,
                       x"00110000" after 40 ns,
                       x"00011000" after 45 ns,
                       x"00001100" after 50 ns,
                       x"00000110" after 55 ns,
                       x"00000011" after 60 ns,
                       x"11111111" after 65 ns,
                       x"00000000" after 70 ns,
                       x"11111111" after 75 ns,
                       x"11111111" after 80 ns,
                       x"00000000" after 81 ns,
                       x"11111111" after 82 ns,
                       x"00000000" after 83 ns,
                       x"11111111" after 84 ns,
                       x"00000000" after 85 ns,
                       x"11111111" after 86 ns,
                       x"00000000" after 87 ns;  
operationToexecute <= x"0010" after 5 ns, -- 0010 is for add
                        x"0110" after 35 ns, -- 0010 is for subtract
                        x"0000" after 65 ns, -- 0010 is for AND
                        x"0001" after 80 ns; -- 0010 is for OR
                        x"1100" after 84 ns; -- 0010 is for NOR
-- end of fill;

dut : ArithmeticLogicUnit
    port map (
           valueFirstRegister => valueFirstRegister,
           valueSecondRegister => valueSecondRegister,
           valueResultOfOperation => valueResultOfOperation,
           operationToexecute => operationToexecute,
           zero => zero,
           overflow => overflow
      );
end Behavioral;
