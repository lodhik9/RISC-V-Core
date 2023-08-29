----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mario Ivanov
-- Testing Engineer: Muhammad Khan Lodhi
-- 
-- Create Date: 08/06/2022 10:31:14 AM
-- Design Name: 
-- Module Name: Decoder_TB - Behavioral
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

entity Decoder_TB is
generic(XLEN : integer := 32);
end Decoder_TB;

architecture Behavioral of Decoder_TB is
component Decoder is
generic( XLEN: integer := 32);
    Port ( instruction : in STD_LOGIC_VECTOR (31 downto 0);
           overflow : in STD_LOGIC;
           zero : in STD_LOGIC;
           lessThan: in std_logic;
           operationToexecute : out STD_LOGIC_VECTOR (3 downto 0);
           firstRegisterAddress : out STD_LOGIC_VECTOR (4 downto 0);
           secondRegisterAddress : out STD_LOGIC_VECTOR (4 downto 0);
           firstRegisterIsImmediateOrProgramCounter : out std_logic_vector(1 downto 0);
           secondRegisterIsImmediateOrProgramCounter : out std_logic_vector(1 downto 0);
           writeEnabled : out STD_LOGIC;
           addressToWrite : out STD_LOGIC_VECTOR (4 downto 0);
           sourceOfWrite: out std_logic_vector(1 downto 0);
           immediateSource : out STD_LOGIC_VECTOR (2 downto 0);
           memoryLoad : out STD_LOGIC;
           -- branch : out STD_LOGIC;
           jumpSource: out std_logic_vector(1 downto 0);
           -- memoryAddress: out std_logic_vector(XLEN - 1 downto 0);
           sourceOfmemoryAddress: out std_logic_vector(1 downto 0);
           -- offsetToJump : out STD_LOGIC_VECTOR (31 downto 0);
           memoryStore : out STD_LOGIC;
           loadStoreSize : out STD_LOGIC_VECTOR (1 downto 0)
           );
end component Decoder;

signal instruction                              :  STD_LOGIC_VECTOR (31 downto 0);    
signal overflow                                 :  STD_LOGIC;
signal zero                                     :  STD_LOGIC;
signal lessThan                                 :  std_logic;
signal operationToexecute                       : STD_LOGIC_VECTOR (3 downto 0);
signal firstRegisterAddress                     : STD_LOGIC_VECTOR (4 downto 0);
signal secondRegisterAddress                    : STD_LOGIC_VECTOR (4 downto 0);
signal firstRegisterIsImmediateOrProgramCounter :  std_logic_vector(1 downto 0);
signal secondRegisterIsImmediateOrProgramCounter: std_logic_vector(1 downto 0);
signal writeEnabled                             :  STD_LOGIC;
signal addressToWrite                           :  STD_LOGIC_VECTOR (4 downto 0);
signal sourceOfWrite                            :  std_logic_vector(1 downto 0);
signal immediateSource                          :  STD_LOGIC_VECTOR (2 downto 0);
signal memoryLoad                               :  STD_LOGIC;
signal jumpSource                               :  std_logic_vector(1 downto 0);
signal sourceOfmemoryAddress                    :  std_logic_vector(1 downto 0);
signal memoryStore                              :  STD_LOGIC;
signal loadStoreSize                            :  STD_LOGIC_VECTOR (1 downto 0);
begin

-- Test Cases
instruction  <= x"00820133" after 5 ns, -- decodes into ADD the values of rs1 & rs2 and then write it on rd
                x"00620113" after 10 ns,-- decodes into ADDI the values of rs1 & imm and then write it on rd
                x"40820133" after 15 ns,-- decodes into SUBTRACT rs2 from rs1 and then write it on rd
                x"00827133" after 20 ns,-- decodes into AND rs1 & rs2 and then write it on rd
                x"00826133" after 25 ns,-- decodes into OR rs1 & rs2 and then write it on rd
                x"00824133" after 30 ns,-- decodes into XOR rs1 & rs2 and then write it on rd
                x"00001117" after 35 ns;-- decodes into ADD pc & imm and then write it on rd
overflow    <= "0" after 5 ns;
zero        <= "0" after 5 ns;
lessThan    <= "0" after 5 ns;

dut : Decoder port map(
instruction                                 => instruction,
overflow                                    => overflow,    
zero                                        => zero,    
lessThan                                    => lessThan,    
operationToexecute                          => operationToexecute,        
firstRegisterAddress                        => firstRegisterAddress,
secondRegisterAddress                       => secondRegisterAddress,
firstRegisterIsImmediateOrProgramCounter    => firstRegisterIsImmediateOrProgramCounter,    
secondRegisterIsImmediateOrProgramCounter   => secondRegisterIsImmediateOrProgramCounter,    
writeEnabled                                => writeEnabled,
addressToWrite                              => addressToWrite,
sourceOfWrite                               => sourceOfWrite,
immediateSource                             => immediateSource,
memoryLoad                                  => memoryLoad,
jumpSource                                  => jumpSource,
sourceOfmemoryAddress                       => sourceOfmemoryAddress,
memoryStore                                 => memoryStore,
loadStoreSize                               => loadStoreSize
);


end Behavioral;
