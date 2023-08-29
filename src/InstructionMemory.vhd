----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mario Ivanov
-- 
-- Create Date: 08/06/2022 10:31:14 AM
-- Design Name: 
-- Module Name: InstructionMemory - Behavioral
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

entity InstructionMemory is
    generic(XLEN: integer:= 32);
    port(
        clock : in std_logic;
        readEnabled: in std_logic;
        writeEnabled: in std_logic;
        address : in std_logic_vector(XLEN - 1 downto 0);
        dataToWrite : in std_logic_vector((XLEN - 1) downto 0);
        dataToRead : out std_logic_vector(XLEN - 1 downto 0)
    );
end InstructionMemory;

architecture Behavioral of InstructionMemory is
    type RAM is array (XLEN - 1 downto 0) of std_logic_vector(XLEN - 1 downto 0);
    signal ramArray : RAM;
begin
write: process(clock)
    begin
        if rising_edge(clock) then
            if writeEnabled = '1' then
                ramArray(to_integer(signed(address))) <= dataToWrite;
            elsif readEnabled = '1' then
                dataToRead <= ramArray(to_integer(unsigned(address)));
            else 
                dataToRead <= (others => '0');
            end if;
        end if;
    end process;

end Behavioral;
