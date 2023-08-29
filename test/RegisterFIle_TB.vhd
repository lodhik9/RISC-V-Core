----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mario Ivanov
-- 
-- Create Date: 08/06/2022 10:31:14 AM
-- Design Name: 
-- Module Name: RegisterFIle_TB - Behavioral
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

entity RegisterFIle_TB is
end RegisterFIle_TB;

architecture Behavioral of RegisterFIle_TB is
component RegisterFile is
 Port ( clock : in STD_LOGIC;
           sinchroniusReset: in std_logic;
           writeEnabled : in STD_LOGIC;
           firstRegisterAddress : in STD_LOGIC_VECTOR (4 downto 0);
           secondRegisterAddress : in STD_LOGIC_VECTOR (4 downto 0);
           valueToWrite : in STD_LOGIC_VECTOR (31 downto 0);
           addressToWrite : in STD_LOGIC_VECTOR (4 downto 0);
           valueFirstRegister : out STD_LOGIC_VECTOR (31 downto 0);
           valueSecondRegister : out STD_LOGIC_VECTOR (31 downto 0));
end component RegisterFIle;
signal clock : STD_LOGIC := '0';
signal sinchroniusReset: std_logic;
signal writeEnabled : STD_LOGIC;
signal firstRegisterAddress : STD_LOGIC_VECTOR (4 downto 0);
signal secondRegisterAddress : STD_LOGIC_VECTOR (4 downto 0);
signal valueToWrite : STD_LOGIC_VECTOR (31 downto 0);
signal addressToWrite : STD_LOGIC_VECTOR (4 downto 0);
signal valueFirstRegister : STD_LOGIC_VECTOR (31 downto 0);
signal valueSecondRegister : STD_LOGIC_VECTOR (31 downto 0);
begin
clock <= not clock after 20 ns;
firstRegisterAddress <= std_logic_vector(unsigned(7));
secondRegisterAddress <= std_logic_vector(unsigned(14));
writeEnabled <= '1' , '0' after 20 ns;
addressToWrite <= std_logic_vector(unsigned(7));
-- valueToWrite <= std_logic_vector(unsigned(7));
valueToWrite <= "01010101010101010101010101010101010101";
-- Expected value of valueFirstRegister after 
-- 1 CLK period is 01010101010101010101010101010101010101
-- Since we assign the value of "valueToWrite"
-- referring to the address of firstRegisterAddress


dut : RegisterFile
    port map (
        clock => clock,
        sinchroniusReset => sinchroniusReset,
        writeEnabled => writeEnabled,
        firstRegisterAddress => firstRegisterAddress,
        secondRegisterAddress =>secondRegisterAddress,
        valueToWrite => valueToWrite,
        addressToWrite => addressToWrite,
        valueFirstRegister => valueFirstRegister,
        valueSecondRegister => valueSecondRegister
      );
end Behavioral;
// store smth in both registers, then read from one expected to be same