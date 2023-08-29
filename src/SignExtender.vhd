----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mario Ivanov
-- 
-- Create Date: 08/06/2022 10:37:40 AM
-- Design Name: 
-- Module Name: SignExtender - Behavioral
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

entity SignExtender is
    generic(INST_XLEN : integer := 32; XLEN : integer := 32);
    Port ( signExtendedImmediate : out STD_LOGIC_VECTOR (XLEN - 1 downto 0);
           immediateSource : in STD_LOGIC_VECTOR (2 downto 0);
           instructionWithImmediate : in STD_LOGIC_VECTOR (INST_XLEN - 1 downto 0));
end SignExtender;

architecture Behavioral of SignExtender is

begin
sign_extend : process(instructionWithImmediate, immediateSource)
begin
    case immediateSource is
        -- I-type instruction
        when "000" => 
            signExtendedImmediate <= (XLEN - 1 downto 12 => instructionWithImmediate(INST_XLEN - 1)) 
                                                            & instructionWithImmediate(INST_XLEN - 1 downto INST_XLEN - 12);
        -- S-type instruction
        when "001" => 
            signExtendedImmediate <= (XLEN - 1 downto 12 => instructionWithImmediate(INST_XLEN - 1)) 
                                                            & instructionWithImmediate(INST_XLEN - 1 downto INST_XLEN - 7) 
                                                            & instructionWithImmediate(11 downto 7);
        -- B-type instruction
        when "010" => 
            signExtendedImmediate <= (XLEN - 1 downto 12 => instructionWithImmediate(INST_XLEN - 1)) 
                                                            & instructionWithImmediate(7) 
                                                            & instructionWithImmediate(INST_XLEN - 2 downto INST_XLEN - 7)
                                                            & instructionWithImmediate(11 downto 8) & '0';
        -- J-type instruction
        when "011" => 
            signExtendedImmediate <= (XLEN - 1 downto 20 => instructionWithImmediate(INST_XLEN - 1)) 
                                                            & instructionWithImmediate(19 downto 12) 
                                                            & instructionWithImmediate(20) 
                                                            & instructionWithImmediate(30 downto 21) & '0';
        when "111" => --LUI
            signExtendedImmediate <= instructionWithImmediate(INST_XLEN - 1 downto 12)  & "000000000000";
        when "110" => --JALR
             signExtendedImmediate <= instructionWithImmediate(INST_XLEN - 1)
                                        & instructionWithImmediate(19 downto 12)
                                        & instructionWithImmediate(20)
                                        & instructionWithImmediate(30 downto 21)
                                        & "000000000000";
        when others => 
            signExtendedImmediate <= (XLEN - 1 downto 0 => '0');
    end case;
end process;

end Behavioral;
