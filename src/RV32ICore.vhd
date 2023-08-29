----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mario Ivanov
-- 
-- Create Date: 08/06/2022 10:31:14 AM
-- Design Name: 
-- Module Name: RV32ICore - Behavioral
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

entity RV32ICore is
generic(XLEN:integer := 32);
    Port ( clock : in STD_LOGIC;
           reset: in std_logic;
           instructionFromSystemMemory : in std_logic_vector(XLEN - 1 downto 0);
           dataFromSystemMemory: in std_logic_vector(XLEN - 1 downto 0);
           readInstruction : out STD_LOGIC;
           writeRam : out STD_LOGIC;
           ramAddress : out STD_LOGIC_VECTOR (XLEN - 1 downto 0);
           valueWrittenToRAM: out std_logic_vector(XLEN - 1 downto 0);
           loadStoreSize: out std_logic_vector(1 downto 0);
           readDataFromRAM: out std_logic
           );
end RV32ICore;

architecture Behavioral of RV32ICore is
signal genericInputForMux: std_logic_vector(XLEN - 1 downto 0) := std_logic_vector(to_unsigned(0, XLEN));

signal PC : std_logic_vector(XLEN - 1 downto 0) := std_logic_vector(to_unsigned(8, XLEN));--0x1000
signal one: std_logic_vector(XLEN - 1 downto 0) := std_logic_vector(to_unsigned(1, XLEN));
 
-- fetch signals
signal instructionFromMemory :std_logic_vector(XLEN - 1 downto 0);
signal resultingPC: std_logic_vector(XLEN - 1 downto 0);

signal offsetToJump: std_logic_vector(XLEN - 1 downto 0);

--decode signals
signal firstALURegister: std_logic_vector(XLEN - 1 downto 0);
signal secondALURegister: std_logic_vector(XLEN - 1 downto 0);
signal operationToExecute: std_logic_vector(3 downto 0);
signal firstRegisterAddress: std_logic_vector(4 downto 0);
signal secondRegisterAddress: std_logic_vector(4 downto 0);
signal firstRegisterIsImmediateOrProgramCounter: std_logic_vector(1 downto 0);
signal secondRegisterIsImmediateOrProgramCounter: std_logic_vector(1 downto 0);
signal writeEnabled: std_logic;
signal addressToWrite: std_logic_vector(4 downto 0);
signal sourceOfWrite: std_logic_vector(1 downto 0);
signal immediateSource: std_logic_vector(2 downto 0);
signal memoryLoad: std_logic;
signal jumpSource: std_logic_vector(1 downto 0);
signal memoryAddress: std_logic_vector(XLEN - 1 downto 0);
signal memoryStore: std_logic;
--signal loadStoreSize: std_logic_vector(1 downto 0);

-- execute/WriteBack signals
signal valueFirstRegister: std_logic_vector(XLEN - 1 downto 0);
signal valueSecondRegister: std_logic_vector(XLEN - 1 downto 0);
signal signExtendedImmediate: std_logic_vector(XLEN - 1 downto 0);
signal zero: std_logic;
signal overflow: std_logic;
signal lessThan: std_logic;
signal valueResultOfOperationTMP: std_logic_vector(XLEN - 1 downto 0);
signal dataToRead: std_logic_vector(XLEN - 1 downto 0);

signal valueToWriteToRegisterOrMemory: std_logic_vector(XLEN - 1 downto 0);
signal fetchedData: std_logic_vector(XLEN - 1 downto 0);
signal sourceOfmemoryAddress: std_logic_vector(1 downto 0);
--components making signal
component FourToOneMux is
    Port ( sourceOne : in STD_LOGIC_VECTOR (31 downto 0);
           sourceTwo : in STD_LOGIC_VECTOR (31 downto 0);
           sourceThree : in STD_LOGIC_VECTOR (31 downto 0);
           sourceFour : in STD_LOGIC_VECTOR (31 downto 0);
           selector : in STD_LOGIC_VECTOR (1 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component Adder is
    Port ( offsetToJump : in STD_LOGIC_VECTOR (31 downto 0);
           programCounter : in STD_LOGIC_VECTOR (31 downto 0);
           resultingProgramCounter : out STD_LOGIC_VECTOR (31 downto 0)
           );
end component Adder;

component ArithmeticLogicUnit is
generic(XLEN: integer := 32);
    Port ( valueFirstRegister : in STD_LOGIC_VECTOR (31 downto 0);
           valueSecondRegister : in STD_LOGIC_VECTOR (31 downto 0);
           valueResultOfOperation : inout STD_LOGIC_VECTOR (31 downto 0);
           operationToexecute : in STD_LOGIC_VECTOR (3 downto 0);
           zero : out STD_LOGIC;
           overflow : out STD_LOGIC;
           lessThan: out STD_LOGIC
           );
end component ArithmeticLogicUnit;

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
           --branch : out STD_LOGIC;
           jumpSource: out std_logic_vector(1 downto 0);
           --memoryAddress: out std_logic_vector(XLEN - 1 downto 0);
           sourceOfmemoryAddress: out std_logic_vector(1 downto 0);
           --ffsetToJump : out STD_LOGIC_VECTOR (31 downto 0);
           memoryStore : out STD_LOGIC;
           loadStoreSize : out STD_LOGIC_VECTOR (1 downto 0)
           );
end component Decoder;

component RegisterFile is
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
end component RegisterFIle;

component SignExtender is
    generic(INST_XLEN : integer := 32; XLEN : integer := 32);
    Port ( signExtendedImmediate : out STD_LOGIC_VECTOR (XLEN - 1 downto 0);
           immediateSource : in STD_LOGIC_VECTOR (2 downto 0);
           instructionWithImmediate : in STD_LOGIC_VECTOR (INST_XLEN - 1 downto 0));
end component SignExtender;

begin
--process variables declaration
offsetMux: FourToOneMux port map(
           sourceOne => one,
           sourceTwo => signExtendedImmediate,
           sourceThree => genericInputForMux,
           sourceFour => genericInputForMux,
           selector => jumpSource,
           result => offsetToJump
        );
        
pcAdder: Adder port map(
           offsetToJump => offsetToJump,
           programCounter => PC,
           resultingProgramCounter => resultingPC
        );
aluPortOneMux: FourToOneMux port map(
           sourceOne => valueFirstRegister,
           sourceTwo => signExtendedImmediate,
           sourceThree => PC,
           sourceFour => one,
           selector => firstRegisterIsImmediateOrProgramCounter,
           result => firstALURegister
        );
aluPortTwoMux: FourToOneMux port map(
           sourceOne => valueSecondRegister,
           sourceTwo => signExtendedImmediate,
           sourceThree => PC,
           sourceFour => one,
           selector => secondRegisterIsImmediateOrProgramCounter,
           result => secondALURegister
        );
ALU: ArithmeticLogicUnit port map(
           valueFirstRegister => firstALURegister,
           valueSecondRegister => secondALURegister,
           valueResultOfOperation => valueResultOfOperationTMP,
           operationToexecute => operationToExecute,
           zero => zero,
           overflow => overflow,
           lessThan => lessThan
);

signExtenderComponnet: SignExtender port map( 
           signExtendedImmediate => signExtendedImmediate,
           immediateSource => immediateSource,
           instructionWithImmediate => instructionFromMemory
           );

registerFileMux: FourToOneMux port map(
           sourceOne => signExtendedImmediate,
           sourceTwo => fetchedData,
           sourceThree => valueResultOfOperationTMP,
           sourceFour => PC,
           selector => sourceOfWrite,
           result => valueToWriteToRegisterOrMemory
        );
        
DataMemoryMux: FourToOneMux port map(
           sourceOne => fetchedData,
           sourceTwo => valueResultOfOperationTMP,
           sourceThree => signExtendedImmediate,
           sourceFour => PC,
           selector => sourceOfmemoryAddress,
           result => valueToWriteToRegisterOrMemory
        );
mainDecoder: Decoder port map( 
           instruction => instructionFromSystemMemory,
           overflow => overflow,
           zero => zero,
           lessThan => lessThan,
           operationToexecute => operationToExecute,
           firstRegisterAddress => firstRegisterAddress,
           secondRegisterAddress => secondRegisterAddress,
           firstRegisterIsImmediateOrProgramCounter => firstRegisterIsImmediateOrProgramCounter,
           secondRegisterIsImmediateOrProgramCounter => secondRegisterIsImmediateOrProgramCounter,
           writeEnabled => writeEnabled,
           addressToWrite => addressToWrite,
           sourceOfWrite => sourceOfWrite,
           immediateSource => immediateSource,
           memoryLoad => memoryLoad,
           --branch : out STD_LOGIC;
           jumpSource => jumpSource,
           --memoryAddress => memoryAddress,
           sourceOfmemoryAddress => sourceOfmemoryAddress,
           --ffsetToJump : out STD_LOGIC_VECTOR (31 downto 0);
           memoryStore => memoryStore,
           loadStoreSize => loadStoreSize
           );
           
regFile: RegisterFile port map ( 
           clock => clock,
           sinchroniusReset => reset,
           writeEnabled => writeEnabled,
           firstRegisterAddress => firstRegisterAddress,
           secondRegisterAddress => secondRegisterAddress,
           valueToWrite  => valueToWriteToRegisterOrMemory,
           addressToWrite  => addressToWrite,
           valueFirstRegister  => valueFirstRegister,
           valueSecondRegister  => valueSecondRegister
           );
           
process(clock, reset)
begin 
if(rising_edge(clock)) then
    if(reset = '0') then
        PC <= std_logic_vector(to_unsigned(8, XLEN));
    else
        readInstruction <= '1';
        ramAddress <= PC;
        instructionFromMemory <=  instructionFromSystemMemory;
        valueWrittenToRAM <= valueToWriteToRegisterOrMemory;
        fetchedData <= dataFromSystemMemory;
        writeRam <= memoryStore;
        readDataFromRAM <= memoryLoad;
        ramAddress <= memoryAddress;
    end if;

end if;

end process;

end Behavioral;
