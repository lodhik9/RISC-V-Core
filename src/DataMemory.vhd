----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mario Ivanov
-- 
-- Create Date: 08/06/2022 10:31:14 AM
-- Design Name: 
-- Module Name: DataMemory - Behavioral
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

entity DataMemory is
generic(XLEN: integer:= 32);
    Port ( clock: in std_logic;
           memoryLoad : in STD_LOGIC;
           memoryStore : in STD_LOGIC;
           loadStoreSize : in STD_LOGIC_VECTOR (1 downto 0);
           address : in std_logic_vector(XLEN - 1 downto 0);
           dataToWrite : in STD_LOGIC_VECTOR((XLEN - 1) downto 0);
           dataToRead : out STD_LOGIC_VECTOR((XLEN - 1) downto 0)
           );
end DataMemory;

architecture Behavioral of DataMemory is
    type RAM is array (XLEN - 1 downto 0) of std_logic_vector(7 downto 0);
    signal ramArray : RAM;
    signal byte: std_logic_vector(7 downto 0);
    signal halfWord: std_logic_vector(15 downto 0);
begin
process(clock)
    begin
        if falling_edge(clock) then
            if memoryStore = '1' then
                case loadStoreSize is
                    when "00" => ramArray(to_integer(unsigned(address))) <= dataToWrite(31 downto 24); --load byte
                    when "01" => ramArray(to_integer(unsigned(address))) <= dataToWrite(31 downto 24);
                    ramArray(to_integer(unsigned(address))) <= dataToWrite(23  downto 16); --load half
                    when "10" =>  
                    ramArray(to_integer(unsigned(address) + 3)) <= dataToWrite(31 downto 24);
                    ramArray(to_integer(unsigned(address) + 2)) <= dataToWrite(23 downto 16);
                    ramArray(to_integer(unsigned(address) + 1)) <= dataToWrite(15 downto 8);
                    ramArray(to_integer(unsigned(address))) <= dataToWrite(7 downto 0 ); --load word 
                    when others => ramArray(to_integer(unsigned(0))) <= "00000000";
                end case;
                
            elsif memoryLoad = '1' then
             case loadStoreSize is
                    when "00" => 
                    dataToRead <= (XLEN - 1 downto 8 => ramArray(to_integer(unsigned(address)))(7)) 
                    & ramArray(to_integer(unsigned(address)));    --load byte
                    when "01" => ramArray(to_integer(unsigned(address))) <= dataToRead(31 downto 24);
                    dataToRead <= (XLEN - 1 downto 15 => ramArray(to_integer(unsigned(address)+1))(7)) 
                    & ramArray(to_integer(unsigned(address) + 1))
                    & ramArray(to_integer(unsigned(address))); --load half
                    when "10" =>  
                    dataToRead(31 downto 24) <= ramArray(to_integer(unsigned(address) + 3)); 
                    dataToRead(23 downto 16) <= ramArray(to_integer(unsigned(address) + 2));
                    dataToRead(15 downto 8) <= ramArray(to_integer(unsigned(address) + 1));
                    dataToRead(7 downto 0 ) <= ramArray(to_integer(unsigned(address))); --load word 
                    when others => ramArray(to_integer(unsigned(0))) <= "00000000";
                end case;
                dataToRead <= ramArray(to_integer(unsigned(address)));
            else 
                dataToRead <= (others => '0');
            end if;
        end if;
    end process;

end Behavioral;
