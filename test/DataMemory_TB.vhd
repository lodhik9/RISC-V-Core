----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mario Ivanov
-- 
-- Create Date: 08/06/2022 10:31:14 AM
-- Design Name: 
-- Module Name: DataMemory_TB - Behavioral
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
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity DataMemory_TB is
generic(XLEN: integer:= 32);
end DataMemory_TB;

architecture Behavioral of DataMemory_TB is
component DataMemory is
generic(XLEN: integer:= 32);
    Port ( clock: in std_logic;
           memoryLoad : in STD_LOGIC;
           memoryStore : in STD_LOGIC;
           loadStoreSize : in STD_LOGIC_VECTOR (1 downto 0);
           address : in std_logic_vector(XLEN - 1 downto 0);
           dataToWrite : in STD_LOGIC_VECTOR((XLEN - 1) downto 0);
           dataToRead : out STD_LOGIC_VECTOR((XLEN - 1) downto 0)
           );
end component;
signal clock: std_logic;
signal memoryLoad: STD_LOGIC;
signal memoryStore: STD_LOGIC;
signal loadStoreSize: STD_LOGIC_VECTOR (1 downto 0);
signal address: std_logic_vector(XLEN - 1 downto 0);
signal dataToWrite: STD_LOGIC_VECTOR((XLEN - 1) downto 0);
signal dataToRead: STD_LOGIC_VECTOR((XLEN - 1) downto 0);
begin
clock <= '0', '1' after 10 ns,
         '0' after 20ns, '1' after 30ns,
         '0' after 40ns, '1' after 50ns,
         '0' after 60ns, '1' after 70ns,
         '0' after 80ns, '1' after 90ns;
         
loadStoreSize <= "00", "01" after 20ns, "10" after 30ns; 
memoryLoad <= '0', '1' after 10 ns,
         '0' after 20ns, '1' after 30ns,
         '0' after 40ns, '1' after 50ns,
         '0' after 60ns, '1' after 70ns,
         '0' after 80ns, '1' after 90ns;

memoryStore <= '0', '1' after 10 ns,
         '1' after 20ns, '0' after 30ns,
         '1' after 40ns, '0' after 50ns,
         '1' after 60ns, '0' after 70ns,
         '1' after 80ns, '0' after 90ns;

address <= std_logic_vector(unsigned(7)), std_logic_vector(unsigned(8)) after 30 ns;
dataToWrite <= "01010101010101010101010101010101010101";
-- Expected value for dataToRead after 1 CLK period passed is equal to dataToWrite
-- dataToRead after 1 CLK period == 01010101010101010101010101010101010101
 
 dut : DataMemory port map(
             clock => clock,
             memoryLoad => memoryLoad,
             memoryStore => memoryStore,
             loadStoreSize => loadStoreSize,
             address => address,
             dataToWrite => dataToWrite,
             dataToRead => dataToRead
        );
end Behavioral;
