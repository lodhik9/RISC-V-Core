----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mario Ivanov
-- 
-- Create Date: 08/06/2022 10:31:14 AM
-- Design Name: 
-- Module Name: RegisterFIle - Behavioral
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

entity RegisterFIle is
generic(XLEN : integer := 32);
    Port ( clock : in STD_LOGIC;
           sinchroniusReset: in std_logic;
           writeEnabled : in STD_LOGIC;
           firstRegisterAddress : in STD_LOGIC_VECTOR (4 downto 0);
           secondRegisterAddress : in STD_LOGIC_VECTOR (4 downto 0);
           valueToWrite : in STD_LOGIC_VECTOR (31 downto 0);
           addressToWrite : in STD_LOGIC_VECTOR (4 downto 0);
           valueFirstRegister : out STD_LOGIC_VECTOR (31 downto 0);
           valueSecondRegister : out STD_LOGIC_VECTOR (31 downto 0));
end RegisterFile;

architecture Behavioral of RegisterFIle is
type RAM is array (XLEN / 2 - 1 downto 0) of std_logic_vector(XLEN - 1 downto 0);
signal registerArray : ram;
begin
write_reg: process(clock)
variable i : integer range 0 to XLEN;
begin
if rising_edge(clock) then
    if(sinchroniusReset = '0') then
        for i in 0 to ((XLEN/2) - 1) loop
            registerArray(i) <= (others => '0');
        end loop;                                 
    elsif writeEnabled = '1' then 
        registerArray(to_integer(unsigned(addressToWrite))) <= valueToWrite;
    end if;
end if;
end process write_reg;

read_reg: process(clock)
begin
    if(to_integer(unsigned(firstRegisterAddress)) = 0) then
        valueFirstRegister <= (XLEN - 1 downto 0 => '0');
    else
        valueFirstRegister <= registerArray(to_integer(unsigned(firstRegisterAddress)));
    end if;
    if to_integer(unsigned(secondRegisterAddress)) = 0 then
        valueSecondRegister <= (XLEN - 1 downto 0 => '0');
    else
        valueSecondRegister <=  registerArray(to_integer(unsigned(secondRegisterAddress)));
    end if;
end process read_reg;

end Behavioral;
