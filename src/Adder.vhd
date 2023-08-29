----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mario Ivanov
-- 
-- Create Date: 08/06/2022 10:37:40 AM
-- Design Name: 
-- Module Name: Adder - Behavioral
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

entity Adder is
    Port ( offsetToJump : in STD_LOGIC_VECTOR (31 downto 0);
           programCounter : in STD_LOGIC_VECTOR (31 downto 0);
           resultingProgramCounter : out STD_LOGIC_VECTOR (31 downto 0)
           );
end Adder;

architecture Behavioral of Adder is
begin

process(offsetToJump, programCounter)
begin
    resultingProgramCounter <= std_logic_vector(signed(offsetToJump) + signed(programCounter));
end process;

end Behavioral;
