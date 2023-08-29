----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mario Ivanov
-- Testing Engineer: Muhammad Khan Lodhi
-- 
-- Create Date: 08/06/2022 10:31:14 AM
-- Design Name: 
-- Module Name: RV32ICore_TB - Behavioral
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

entity RV32ICore_TB is
generic(XLEN: integer:= 32);
end RV32ICore_TB;

architecture Behavioral of RV32ICore_TB is
signal clock:                       std_logic;
signal reset:                       std_logic;
signal instructionFromSystemMemory: std_logic_vector(XLEN - 1 downto 0);
signal dataFromSystemMemory:        std_logic_vector(XLEN - 1 downto 0);
signal readInstruction:             std_logic;

signal writeRam :  STD_LOGIC;
signal ramAddress :  STD_LOGIC_VECTOR (XLEN - 1 downto 0);
signal valueWrittenToRAM:  std_logic_vector(XLEN -1 downto 0);
--signal loadStoreSize:  std_logic_vector(1 downto 0);
signal readDataFromRAM:  std_logic;

component RV32ICore is 
    Port ( clock : in STD_LOGIC;
           reset: in std_logic;
           instructionFromSystemMemory : in std_logic_vector(XLEN - 1 downto 0);
           dataFromSystemMemory: in std_logic_vector(XLEN - 1 downto 0);
           readInstruction : out STD_LOGIC; -- readEnabled of IM
           writeRam : out STD_LOGIC; -- write enabled to data memory
           ramAddress : out STD_LOGIC_VECTOR (XLEN - 1 downto 0); --adress to read or write
           valueWrittenToRAM: out std_logic_vector(XLEN - 1 downto 0);
           loadStoreSize: out std_logic_vector(1 downto 0); -- loadStoreSize of DataMemory
           readDataFromRAM: out std_logic);
end component;

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

component InstructionMemory is
    generic(XLEN: integer:= 32);
    port(
        clock : in std_logic;
        readEnabled: in std_logic;
        writeEnabled: in std_logic;
        address : in std_logic_vector(XLEN - 1 downto 0);
        dataToWrite : in std_logic_vector((XLEN - 1) downto 0);
        dataToRead : out std_logic_vector(XLEN - 1 downto 0)
    );
end component;

begin

clock                        <= '0',
                             '1' after 5ns,
                              '0' after 6ns,
                               '1' after 7ns,
                               '0' after 8ns,
                               '1' after 10ns,
                               '0' after 12ns,
                               '1' after 15ns,
                               '0' after 17ns,
                               '1' after 20ns,
                               '0' after 22ns,
                               '1' after 25ns,
                               '0' after 27ns,
                               '1' after 30ns,
                               '0' after 32ns,
                               '1' after 35ns,
                               '0' after 37ns,
                               '1' after 40ns,
                               '0' after 42ns,
                               '1' after 45ns,
                               '0' after 47ns,
                               '1' after 50ns;      
reset                        <= '1', '0' after 5ns; 
instructionFromSystemMemory  <= x"00000000",
                                 x"00208103" after 5ns, -- loading 2 to the rs1
                                 x"00108103" after 7ns, -- loading 1 to the rs2
                                  x"00820133" after 10ns, -- for ADD rs1 and rs2
                                   x"00620113" after 15ns, -- for ADDI rs1 and imm
                                   x"40820133" after 20ns, -- for SUBTRACT rs2 from rs1
                                   x"00308103" after 22ns, -- loading 3 to the rs1 
                                   x"00827133" after 25ns, -- for AND rs1 rs2 
                                   x"00826133" after 30ns, -- for OR rs1 rs2
                                   x"00824133" after 35ns, -- for XOR rs1 rs2
                                   x"00001117" after 40ns, -- for AUIPC 
                                   x"00413963" after 45ns, -- for BGEU
                                   x"0000216F" after 50ns; -- for JAL

dut : RV32ICore
    port map (
        clock => clock,
        reset => reset,
        instructionFromSystemMemory => instructionFromSystemMemory,
        firstRegisterAddress => firstRegisterAddress,
        dataFromSystemMemory =>dataFromSystemMemory,
        writeRam => writeRam,
        valueWrittenToRAM => valueWrittenToRAM,
        loadStoreSize => loadStoreSize,
        readDataFromRAM => readDataFromRAM
      );

end Behavioral;