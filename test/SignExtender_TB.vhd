----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mario Ivanov
-- 
-- Create Date: 08/06/2022 10:37:40 AM
-- Design Name: 
-- Module Name: SignExtender_TB - Behavioral
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

entity SignExtender_TB is
generic(INST_XLEN : integer := 32; XLEN : integer := 32);
end SignExtender_TB;

architecture Behavioral of SignExtender_TB is
component SignExtender is
    generic(INST_XLEN : integer := 32; XLEN : integer := 32);
    Port ( signExtendedImmediate : out STD_LOGIC_VECTOR (XLEN - 1 downto 0);
           immediateSource : in STD_LOGIC_VECTOR (2 downto 0);
           instructionWithImmediate : in STD_LOGIC_VECTOR (INST_XLEN - 1 downto 0));
end component SignExtender;
signal signExtendedImmediate :  STD_LOGIC_VECTOR (XLEN - 1 downto 0);
signal immediateSource : STD_LOGIC_VECTOR (1 downto 0);
signal instructionWithImmediate :  STD_LOGIC_VECTOR (INST_XLEN - 1 downto 0);
begin
immediateSource <=  "000",            --I-type
                    "001" after 20ns,--S-type
                    "010" after 40ns,--B-type
                    "011" after 60ns;--J-type
signExtendedImmediate <= "1111_1111_1100_0000_0000_0000_0000_0000",
                         "1111_1110_0000_0000_0000_0000_0000_0000" after 20 ns,
                         "1111_1110_0000_0000_0000_1111_1000_0000" after 40 ns,
                         "1111_1111_1111_1111_1111_1000_0000_0000" after 60 ns;
dut : SignExtender
    port map (
        signExtendedImmediate => signExtendedImmediate,
        immediateSource => immediateSource,
        instructionWithImmediate => instructionWithImmediate
      );

end Behavioral; 