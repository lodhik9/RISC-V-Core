----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mario Ivanov
-- 
-- Create Date: 08/06/2022 10:31:14 AM
-- Design Name: 
-- Module Name: InstructionMemory_TB - Behavioral
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

entity InstructionMemory_TB is
generic(XLEN: integer:= 32);
end InstructionMemory_TB;
architecture Behavioral of InstructionMemory_TB is
component InstructionMemory is
    generic(XLEN: integer:= 32);
    port(
        clock : in std_logic;
        readEnabled: in std_logic;
        writeEnabled: in std_logic;
        address : in std_logic_vector(XLEN - 1 downto 0);
        dataToWrite : in std_logic_vector(8*(XLEN - 1) downto 0);
        dataToRead : out std_logic_vector(XLEN - 1 downto 0)
    );
end component;
signal clock : std_logic;
signal readEnabled: std_logic;
signal writeEnabled: std_logic;
signal address : std_logic_vector(XLEN - 1 downto 0);
signal dataToWrite : std_logic_vector(8*(XLEN - 1) downto 0);
signal dataToRead : std_logic_vector(XLEN - 1 downto 0);

begin 
clock <= '0' , '1' after 20 ns, '0' after 40 ns, '1' after 60 ns; 
writeEnabled <= '0', '1' after 20 ns, '0';
readEnabled <= '0', '1' after 60 ns;
address <= "00000000000000000000000001000000";
dataToWrite <= "00000000000000000000000001000000"; 
-- Expected value for dataToRead after 1 CLK period passed is equal to dataToWrite
-- dataToRead after 1 CLK period == 00000000000000000000000001000000 

dut : InstructionMemory
    port map (
        clock       => clock,
        readEnabled => readEnabled,
        writeEnabled=> writeEnabled,
        address     => address,
        dataToWrite => dataToWrite,
        dataToRead  => dataToRead 
      );


end Behavioral;
