----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mario Ivanov
-- 
-- Create Date: 08/21/2022 10:20:57 AM
-- Design Name: 
-- Module Name: FourToOneMux - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FourToOneMux is
    Port ( sourceOne : in STD_LOGIC_VECTOR (31 downto 0);
           sourceTwo : in STD_LOGIC_VECTOR (31 downto 0);
           sourceThree : in STD_LOGIC_VECTOR (31 downto 0);
           sourceFour : in STD_LOGIC_VECTOR (31 downto 0);
           selector : in STD_LOGIC_VECTOR (1 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0));
end FourToOneMux;

architecture Behavioral of FourToOneMux is

begin
process(selector, sourceOne, sourceTwo, sourceThree, sourceFour)
begin
    case selector is 
     when "00" => result <= sourceOne;
     when "01" => result <= sourceTwo;
     when "10" => result <= sourceThree;
     when "11" => result <= sourceFour; 
     end case;
end process;

end Behavioral;
