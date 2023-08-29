----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mario Ivanov
-- 
-- Create Date: 08/06/2022 10:31:14 AM
-- Design Name: 
-- Module Name: Decoder - Behavioral
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

entity Decoder is
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
end Decoder;

architecture Behavioral of Decoder is

begin
decode: process(instruction, overflow, zero, lessThan)
variable opcode : std_logic_vector(6 downto 0) := instruction(6 downto 0);
variable destinationRegister : std_logic_vector(4 downto 0) := instruction(11 downto 7);
variable functionThreeBits: std_logic_vector(2 downto 0) := instruction(14 downto 12);
variable sourceRegisterOne :std_logic_vector(4 downto 0) := instruction(19 downto 15);
variable sourceRegisterTwo : std_logic_vector(4 downto 0) := instruction(24 downto 20);
variable functionSevenBits : std_logic_vector(6 downto 0) := instruction(31 downto 25);
begin

case opcode is 
    when "0110111" => --LUI 
       operationToexecute <= "XXXX";
       firstRegisterAddress <= "XXXXX";
       secondRegisterAddress <= "XXXXX";
       addressToWrite <= instruction(11 downto 7);
       firstRegisterIsImmediateOrProgramCounter <= "XX";
       secondRegisterIsImmediateOrProgramCounter <= "XX";
       immediateSource <= "111";
       memoryLoad <= '0';
       --branch <= '0';
       --offsetToJump <= (others => 'X');
       memoryStore <= '0';
       loadStoreSize <= "XX";
       writeEnabled <= '1';
       sourceOfWrite <= "00"; -- mux infront of the write port 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
       jumpSource <= "00"; --PC + 1
    when "0010111" => -- AUIPC
       operationToexecute <= "XXXX";
       firstRegisterAddress <= "XXXXX";
       secondRegisterAddress <= "XXXXX";
       addressToWrite <= (others => 'X');
       firstRegisterIsImmediateOrProgramCounter <= "XX";
       secondRegisterIsImmediateOrProgramCounter <= "XX";
       immediateSource <= "111";
       memoryLoad <= '0';
       --branch <= '0';
       --offsetToJump <= (others => 'X');
       memoryStore <= '0';
       loadStoreSize <= "XX";
       writeEnabled <= '0';
       sourceOfWrite <= "XX";
       jumpSource <= "01"; -- add immediate from sign extender    
    when "1101111" => --JAL
       operationToexecute <= "0000"; --ADD
       firstRegisterAddress <= "XXXXX";
       secondRegisterAddress <= "XXXXX";
       addressToWrite <= instruction(11 downto 7);
       firstRegisterIsImmediateOrProgramCounter <= "10"; -- 00 source is reg file, 01 source is sign extender, 10 --src is pc, 11 -hardcoded 1
       secondRegisterIsImmediateOrProgramCounter <= "11";
       immediateSource <= "011"; -- J-type
       memoryLoad <= '0';
       --branch <= '1'; --? do we need it given that the source of the adder changes 
       --offsetToJump <= (others => 'X'); -- prettu sure we don't need this
       memoryStore <= '0';
       loadStoreSize <= "XX"; -- 00 byte, 01 half, 10 word
       writeEnabled <= '1';
       sourceOfWrite <= "11";
       jumpSource <= "01";
    when "1100111" => -- JALR
       operationToexecute <= "0000"; --ADD
       firstRegisterAddress <= instruction(19 downto 15); --rs1
       secondRegisterAddress <= "XXXXX";
       addressToWrite <= instruction(11 downto 7); --rd
       firstRegisterIsImmediateOrProgramCounter <= "00"; -- 00 source is reg file, 01 source is sign extender, 10 --src is pc, 11 -hardcoded 1
       secondRegisterIsImmediateOrProgramCounter <= "01";
       immediateSource <= "000"; -- I-type
       memoryLoad <= '0';
       --branch <= '0'; --? do we need it given that the source of the adder changes 
       --offsetToJump <= (others => 'X'); -- prettu sure we don't need this
       memoryStore <= '0';
       loadStoreSize <= "XX"; -- 00 byte, 01 half, 10 word
       writeEnabled <= '1';
       sourceOfWrite <= "10"; --ALU
       jumpSource <= "00";
    when "1100011" => --BEQ, BNE, BLT, BGE, BLTU, BGEU 
        case functionThreeBits is 
            when "000" => --BEQ
                operationToexecute <= "0001"; --SUB
                firstRegisterAddress <= instruction(19 downto 15); --rs1
                secondRegisterAddress <= instruction(24 downto 20); --rs2
                addressToWrite <= instruction(11 downto 7); -- do not care
                firstRegisterIsImmediateOrProgramCounter <= "00"; -- 00 source is reg file, 01 source is sign extender, 10 --src is pc, 11 -hardcoded 1
                secondRegisterIsImmediateOrProgramCounter <= "00";
                immediateSource <= "010"; -- B-type
                memoryLoad <= '0';
                --branch <= zero; --? do we need it given that the source of the adder changes 
                --offsetToJump <= (others => 'X'); -- prettu sure we don't need this
                memoryStore <= '0';
                loadStoreSize <= "XX"; -- 00 byte, 01 half, 10 word
                writeEnabled <= '0';
                sourceOfWrite <= "10"; --ALU
                jumpSource <= "01"; --add immediate
            when "001" => --BNE
                operationToexecute <= "0001"; --SUB
                firstRegisterAddress <= instruction(19 downto 15); --rs1
                secondRegisterAddress <= instruction(24 downto 20); --rs2
                addressToWrite <= instruction(11 downto 7); -- do not care
                firstRegisterIsImmediateOrProgramCounter <= "00"; -- 00 source is reg file, 01 source is sign extender, 10 --src is pc, 11 -hardcoded 1
                secondRegisterIsImmediateOrProgramCounter <= "00";
                immediateSource <= "010"; -- B-type
                memoryLoad <= '0';
                --branch <= not zero; --? do we need it given that the source of the adder changes 
                --offsetToJump <= (others => 'X'); -- prettu sure we don't need this
                memoryStore <= '0';
                loadStoreSize <= "XX"; -- 00 byte, 01 half, 10 word
                writeEnabled <= '0';
                sourceOfWrite <= "10"; --ALU
                jumpSource <= "01"; --add immediate
            when "100" => -- BLT
                operationToexecute <= "0101"; --SLT
                firstRegisterAddress <= instruction(19 downto 15); --rs1
                secondRegisterAddress <= instruction(24 downto 20); --rs2
                addressToWrite <= instruction(11 downto 7); -- do not care
                firstRegisterIsImmediateOrProgramCounter <= "00"; -- 00 source is reg file, 01 source is sign extender, 10 --src is pc, 11 -hardcoded 1
                secondRegisterIsImmediateOrProgramCounter <= "00";
                immediateSource <= "010"; -- B-type
                memoryLoad <= '0';
                --branch <= lessThan; --? do we need it given that the source of the adder changes 
                --offsetToJump <= (others => 'X'); -- prettu sure we don't need this
                memoryStore <= '0';
                loadStoreSize <= "XX"; -- 00 byte, 01 half, 10 word
                writeEnabled <= '0';
                sourceOfWrite <= "10"; --ALU
                jumpSource <= "01"; --add immediate
            when "101" => --BGE
                operationToexecute <= "1010"; --SLTE
                firstRegisterAddress <= instruction(24 downto 20); --rs2
                secondRegisterAddress <= instruction(19 downto 15); --rs1
                addressToWrite <= instruction(11 downto 7); -- do not care
                firstRegisterIsImmediateOrProgramCounter <= "00"; -- 00 source is reg file, 01 source is sign extender, 10 --src is pc, 11 -hardcoded 1
                secondRegisterIsImmediateOrProgramCounter <= "00";
                immediateSource <= "010"; -- B-type
                memoryLoad <= '0';
                --branch <= lessThan; --? do we need it given that the source of the adder changes 
                --offsetToJump <= (others => 'X'); -- prettu sure we don't need this
                memoryStore <= '0';
                loadStoreSize <= "XX"; -- 00 byte, 01 half, 10 word
                writeEnabled <= '0';
                sourceOfWrite <= "10"; --ALU
                jumpSource <= "01"; --add immediate
            when "110" => -- BLTU
                operationToexecute <= "1011"; --SLTU
                firstRegisterAddress <= instruction(19 downto 15); --rs1
                secondRegisterAddress <= instruction(24 downto 20); --rs2
                addressToWrite <= instruction(11 downto 7); -- do not care
                firstRegisterIsImmediateOrProgramCounter <= "00"; -- 00 source is reg file, 01 source is sign extender, 10 --src is pc, 11 -hardcoded 1
                secondRegisterIsImmediateOrProgramCounter <= "00";
                immediateSource <= "010"; -- B-type
                memoryLoad <= '0';
                --branch <= lessThan; --? do we need it given that the source of the adder changes 
                --offsetToJump <= (others => 'X'); -- prettu sure we don't need this
                memoryStore <= '0';
                loadStoreSize <= "XX"; -- 00 byte, 01 half, 10 word
                writeEnabled <= '0';
                sourceOfWrite <= "10"; --ALU
                jumpSource <= "01"; --add immediate
            when "111" => -- BGEU
                operationToexecute <= "1011"; --SLTU
                firstRegisterAddress <= instruction(24 downto 20); --rs2
                secondRegisterAddress <=  instruction(19 downto 15); --rs1
                addressToWrite <= instruction(11 downto 7); -- do not care
                firstRegisterIsImmediateOrProgramCounter <= "00"; -- 00 source is reg file, 01 source is sign extender, 10 --src is pc, 11 -hardcoded 1
                secondRegisterIsImmediateOrProgramCounter <= "00";
                immediateSource <= "010"; -- B-type
                memoryLoad <= '0';
                --branch <= lessThan; --? do we need it given that the source of the adder changes 
                --offsetToJump <= (others => 'X'); -- prettu sure we don't need this
                memoryStore <= '0';
                loadStoreSize <= "XX"; -- 00 byte, 01 half, 10 word
                writeEnabled <= '0';
                sourceOfWrite <= "10"; --ALU
                jumpSource <= "01"; --add immediate
            when others => -- don't care
        end case;
    when "0000011" => --LB, LH, LW, LBU, LHU
        case functionThreeBits is 
            when "000" => --LB  -- I-type
                operationToexecute <= "0000"; --ADD
                firstRegisterAddress <= instruction(19 downto 15);
                secondRegisterAddress <= "XXXXX";
                addressToWrite <= instruction(11 downto 7);
                firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                secondRegisterIsImmediateOrProgramCounter <= "01"; -- sign extender
                immediateSource <= "000"; -- I-type
                memoryLoad <= '1';
                --branch <= '0';
                --offsetToJump <= (others => 'X');
                memoryStore <= '0';
                loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                writeEnabled <= '1';
                sourceOfWrite <= "01"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                jumpSource <= "00"; --PC + 1
                --memoryAddress <= (others => 'X'); -- do i need thi ?
                sourceOfmemoryAddress <= "01"; --  register, ALU, sign Extender
            when "001" => --LH
                operationToexecute <= "0000"; --ADD
                firstRegisterAddress <= instruction(19 downto 15);
                secondRegisterAddress <= "XXXXX";
                addressToWrite <= instruction(11 downto 7);
                firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                secondRegisterIsImmediateOrProgramCounter <= "01"; -- sign extender
                immediateSource <= "000"; -- I-type
                memoryLoad <= '1';
                --branch <= '0';
                --offsetToJump <= (others => 'X');
                memoryStore <= '0';
                loadStoreSize <= "01"; -- 00 byte, 01 half, 10 word.  
                writeEnabled <= '1';
                sourceOfWrite <= "01"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                jumpSource <= "00"; --PC + 1
                --memoryAddress <= (others => 'X'); -- do i need thi ?
                sourceOfmemoryAddress <= "01"; --  register, ALU, sign Extender
            when "010" => -- LW
                operationToexecute <= "0000"; --ADD
                firstRegisterAddress <= instruction(19 downto 15);
                secondRegisterAddress <= "XXXXX";
                addressToWrite <= instruction(11 downto 7);
                firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                secondRegisterIsImmediateOrProgramCounter <= "01"; -- sign extender
                immediateSource <= "000"; -- I-type
                memoryLoad <= '1';
                --branch <= '0';
                --offsetToJump <= (others => 'X');
                memoryStore <= '0';
                loadStoreSize <= "10"; -- 00 byte, 01 half, 10 word.  
                writeEnabled <= '1';
                sourceOfWrite <= "01"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                jumpSource <= "00"; --PC + 1
                --memoryAddress <= (others => 'X'); -- do i need thi ?
                sourceOfmemoryAddress <= "01"; --  register, ALU, sign Extender
            when "100" => --LBU
                operationToexecute <= "0000"; --ADD
                firstRegisterAddress <= instruction(19 downto 15);
                secondRegisterAddress <= "XXXXX";
                addressToWrite <= instruction(11 downto 7);
                firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                secondRegisterIsImmediateOrProgramCounter <= "01"; -- sign extender
                immediateSource <= "000"; -- I-type
                memoryLoad <= '1';
                --branch <= '0';
                --offsetToJump <= (others => 'X');
                memoryStore <= '0';
                loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                writeEnabled <= '1';
                sourceOfWrite <= "01"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                jumpSource <= "00"; --PC + 1
                --memoryAddress <= (others => 'X'); -- do i need thi ?
                sourceOfmemoryAddress <= "01"; --  register, ALU, sign Extender
            when "101" => -- LHU
                operationToexecute <= "0000"; --ADD
                firstRegisterAddress <= instruction(19 downto 15);
                secondRegisterAddress <= "XXXXX";
                addressToWrite <= instruction(11 downto 7);
                firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                secondRegisterIsImmediateOrProgramCounter <= "01"; -- sign extender
                immediateSource <= "000"; -- I-type
                memoryLoad <= '1';
                --branch <= '0';
                --offsetToJump <= (others => 'X');
                memoryStore <= '0';
                loadStoreSize <= "01"; -- 00 byte, 01 half, 10 word.  
                writeEnabled <= '1';
                sourceOfWrite <= "01"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                jumpSource <= "00"; --PC + 1
                --memoryAddress <= (others => 'X'); -- do i need thi ?
               sourceOfmemoryAddress <= "01"; --  register, ALU, sign Extender
            when others =>
        end case;
    when "0100011" => --SB, SH, SW
        case functionThreeBits is 
            when "000" => --SB
                operationToexecute <= "0000"; --ADD
                firstRegisterAddress <= sourceRegisterOne;
                secondRegisterAddress <= "XXXXX";
                addressToWrite <= sourceRegisterTwo;
                firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                secondRegisterIsImmediateOrProgramCounter <= "01"; -- sign extender
                immediateSource <= "001"; -- S-type
                memoryLoad <= '0';
                --branch <= '0';
                --offsetToJump <= (others => 'X');
                memoryStore <= '1';
                loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                writeEnabled <= '0';
                sourceOfWrite <= "01"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                jumpSource <= "00"; --PC + 1
                --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
            when "001" => --SH
                operationToexecute <= "0000"; --ADD
                firstRegisterAddress <= sourceRegisterOne;
                secondRegisterAddress <= "XXXXX";
                addressToWrite <= sourceRegisterTwo;
                firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                secondRegisterIsImmediateOrProgramCounter <= "01"; -- sign extender
                immediateSource <= "001"; -- S-type
                memoryLoad <= '0';
                --branch <= '0';
                --offsetToJump <= (others => 'X');
                memoryStore <= '1';
                loadStoreSize <= "01"; -- 00 byte, 01 half, 10 word.  
                writeEnabled <= '0';
                sourceOfWrite <= "01"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                jumpSource <= "00"; --PC + 1
                --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
            when "010" => --SW
                operationToexecute <= "0000"; --ADD
                firstRegisterAddress <= sourceRegisterOne;
                secondRegisterAddress <= "XXXXX";
                addressToWrite <= sourceRegisterTwo;
                firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                secondRegisterIsImmediateOrProgramCounter <= "01"; -- sign extender
                immediateSource <= "001"; -- S-type
                memoryLoad <= '0';
                --branch <= '0';
                --offsetToJump <= (others => 'X');
                memoryStore <= '1';
                loadStoreSize <= "10"; -- 00 byte, 01 half, 10 word.  
                writeEnabled <= '0';
                sourceOfWrite <= "01"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                jumpSource <= "00"; --PC + 1
                --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
            when others => 
        end case;
    when "0010011" => -- ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
        case functionThreeBits is
            when "000" => -- ADDI
                    operationToexecute <= "0000"; --ADD
                    firstRegisterAddress <= sourceRegisterOne;
                    secondRegisterAddress <= sourceRegisterTwo;
                    addressToWrite <= destinationRegister;
                    firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                    secondRegisterIsImmediateOrProgramCounter <= "01"; -- sign extender
                    immediateSource <= "000"; -- I-type
                    memoryLoad <= '0';
                    --branch <= '0';
                    --offsetToJump <= (others => 'X');
                    memoryStore <= '0';
                    loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                    writeEnabled <= '1';
                    sourceOfWrite <= "10"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                    jumpSource <= "00"; --PC + 1
                    --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                    sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
            when "010" => -- SLTI
                    operationToexecute <= "0101"; --SLT
                    firstRegisterAddress <= sourceRegisterOne;
                    secondRegisterAddress <= sourceRegisterTwo;
                    addressToWrite <= destinationRegister;
                    firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                    secondRegisterIsImmediateOrProgramCounter <= "01"; -- sign extender
                    immediateSource <= "000"; -- I-type
                    memoryLoad <= '0';
                    --branch <= '0';
                    --offsetToJump <= (others => 'X');
                    memoryStore <= '0';
                    loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                    writeEnabled <= '1';
                    sourceOfWrite <= "10"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                    jumpSource <= "00"; --PC + 1
                    --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                    sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
            when "011" => -- SLTIU
                    operationToexecute <= "0110"; --SLTU
                    firstRegisterAddress <= sourceRegisterOne;
                    secondRegisterAddress <= sourceRegisterTwo;
                    addressToWrite <= destinationRegister;
                    firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                    secondRegisterIsImmediateOrProgramCounter <= "01"; -- sign extender
                    immediateSource <= "000"; -- I-type
                    memoryLoad <= '0';
                    --branch <= '0';
                    --offsetToJump <= (others => 'X');
                    memoryStore <= '0';
                    loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                    writeEnabled <= '1';
                    sourceOfWrite <= "10"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                    jumpSource <= "00"; --PC + 1
                    --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                    sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
            when "100" => -- XORI
                    operationToexecute <= "0100"; --XOR
                    firstRegisterAddress <= sourceRegisterOne;
                    secondRegisterAddress <= sourceRegisterTwo;
                    addressToWrite <= destinationRegister;
                    firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                    secondRegisterIsImmediateOrProgramCounter <= "01"; -- sign extender
                    immediateSource <= "000"; -- I-type
                    memoryLoad <= '0';
                    --branch <= '0';
                    --offsetToJump <= (others => 'X');
                    memoryStore <= '0';
                    loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                    writeEnabled <= '1';
                    sourceOfWrite <= "10"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                    jumpSource <= "00"; --PC + 1
                    --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                    sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
            when "110" => -- ORI
                    operationToexecute <= "0011"; --OR
                    firstRegisterAddress <= sourceRegisterOne;
                    secondRegisterAddress <= sourceRegisterTwo;
                    addressToWrite <= destinationRegister;
                    firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                    secondRegisterIsImmediateOrProgramCounter <= "01"; -- sign extender
                    immediateSource <= "000"; -- I-type
                    memoryLoad <= '0';
                    --branch <= '0';
                    --offsetToJump <= (others => 'X');
                    memoryStore <= '0';
                    loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                    writeEnabled <= '1';
                    sourceOfWrite <= "10"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                    jumpSource <= "00"; --PC + 1
                    --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                   -- sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
            when "111" => -- ANDI
                    operationToexecute <= "0010"; --AND
                    firstRegisterAddress <= sourceRegisterOne;
                    secondRegisterAddress <= sourceRegisterTwo;
                    addressToWrite <= destinationRegister;
                    firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                    secondRegisterIsImmediateOrProgramCounter <= "01"; -- sign extender
                    immediateSource <= "000"; -- I-type
                    memoryLoad <= '0';
                    --branch <= '0';
                    --offsetToJump <= (others => 'X');
                    memoryStore <= '0';
                    loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                    writeEnabled <= '1';
                    sourceOfWrite <= "10"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                    jumpSource <= "00"; --PC + 1
                    --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                   -- sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
            when "001" => -- SLLI
                    operationToexecute <= "0111"; --SLL
                    firstRegisterAddress <= sourceRegisterOne;
                    secondRegisterAddress <= sourceRegisterTwo;
                    addressToWrite <= destinationRegister;
                    firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                    secondRegisterIsImmediateOrProgramCounter <= "01"; -- sign extender
                    immediateSource <= "000"; -- I-type
                    memoryLoad <= '0';
                    --branch <= '0';
                    --offsetToJump <= (others => 'X');
                    memoryStore <= '0';
                    loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                    writeEnabled <= '1';
                    sourceOfWrite <= "10"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                    jumpSource <= "00"; --PC + 1
                    --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                   -- sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
            when "101" => -- SRAI, SRLI
                if functionSevenBits(5) = '1' then --SRAI
                    operationToexecute <= "1000"; --SRA
                    firstRegisterAddress <= sourceRegisterOne;
                    secondRegisterAddress <= sourceRegisterTwo;
                    addressToWrite <= destinationRegister;
                    firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                    secondRegisterIsImmediateOrProgramCounter <= "01"; -- sign extender
                    immediateSource <= "000"; -- I-type
                    memoryLoad <= '0';
                    --branch <= '0';
                    --offsetToJump <= (others => 'X');
                    memoryStore <= '0';
                    loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                    writeEnabled <= '1';
                    sourceOfWrite <= "10"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                    jumpSource <= "00"; --PC + 1
                    --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                   -- sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
                elsif functionSevenBits(5) = '0' then -- SRLI
                    operationToexecute <= "1001"; --SRL
                    firstRegisterAddress <= sourceRegisterOne;
                    secondRegisterAddress <= sourceRegisterTwo;
                    addressToWrite <= destinationRegister;
                    firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                    secondRegisterIsImmediateOrProgramCounter <= "01"; -- sign extender
                    immediateSource <= "000"; -- I-type
                    memoryLoad <= '0';
                    --branch <= '0';
                    --offsetToJump <= (others => 'X');
                    memoryStore <= '0';
                    loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                    writeEnabled <= '1';
                    sourceOfWrite <= "10"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                    jumpSource <= "00"; --PC + 1
                    --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                   -- sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
                end if;
            when others =>
        end case;
    when "0110011" => -- ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
        case functionThreeBits is 
            when "000" => -- ADD, SUB
                if functionSevenBits(5) = '1' then --SUB
                    operationToexecute <= "0001"; --SUB
                    firstRegisterAddress <= sourceRegisterOne;
                    secondRegisterAddress <= sourceRegisterTwo;
                    addressToWrite <= destinationRegister;
                    firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                    secondRegisterIsImmediateOrProgramCounter <= "00"; -- sign extender
                    immediateSource <= "001"; -- S-type
                    memoryLoad <= '0';
                    --branch <= '0';
                    --offsetToJump <= (others => 'X');
                    memoryStore <= '0';
                    loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                    writeEnabled <= '1';
                    sourceOfWrite <= "10"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                    jumpSource <= "00"; --PC + 1
                    --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                   -- sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
                elsif functionSevenBits(5) = '0' then -- ADD
                    operationToexecute <= "0000"; --ADD
                    firstRegisterAddress <= sourceRegisterOne;
                    secondRegisterAddress <= sourceRegisterTwo;
                    addressToWrite <= destinationRegister;
                    firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                    secondRegisterIsImmediateOrProgramCounter <= "00"; -- sign extender
                    immediateSource <= "001"; -- S-type
                    memoryLoad <= '0';
                    --branch <= '0';
                    --offsetToJump <= (others => 'X');
                    memoryStore <= '0';
                    loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                    writeEnabled <= '1';
                    sourceOfWrite <= "10"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                    jumpSource <= "00"; --PC + 1
                    --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                   -- sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
                end if;
            when "001" => --SLL
                    operationToexecute <= "0111"; --SLL
                    firstRegisterAddress <= sourceRegisterOne;
                    secondRegisterAddress <= sourceRegisterTwo;
                    addressToWrite <= destinationRegister;
                    firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                    secondRegisterIsImmediateOrProgramCounter <= "00"; -- sign extender
                    immediateSource <= "001"; -- S-type
                    memoryLoad <= '0';
                    --branch <= '0';
                    --offsetToJump <= (others => 'X');
                    memoryStore <= '0';
                    loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                    writeEnabled <= '1';
                    sourceOfWrite <= "10"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                    jumpSource <= "00"; --PC + 1
                    --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                   -- sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
            when "010" => --SLT
                    operationToexecute <= "0101"; --SLT
                    firstRegisterAddress <= sourceRegisterOne;
                    secondRegisterAddress <= sourceRegisterTwo;
                    addressToWrite <= destinationRegister;
                    firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                    secondRegisterIsImmediateOrProgramCounter <= "00"; -- sign extender
                    immediateSource <= "001"; -- S-type
                    memoryLoad <= '0';
                    --branch <= '0';
                    --offsetToJump <= (others => 'X');
                    memoryStore <= '0';
                    loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                    writeEnabled <= '1';
                    sourceOfWrite <= "10"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                    jumpSource <= "00"; --PC + 1
                    --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                    --sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
            when "011" => --SLTU
                    operationToexecute <= "0110"; --SLTU
                    firstRegisterAddress <= sourceRegisterOne;
                    secondRegisterAddress <= sourceRegisterTwo;
                    addressToWrite <= destinationRegister;
                    firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                    secondRegisterIsImmediateOrProgramCounter <= "00"; -- sign extender
                    immediateSource <= "001"; -- S-type
                    memoryLoad <= '0';
                    --branch <= '0';
                    --offsetToJump <= (others => 'X');
                    memoryStore <= '0';
                    loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                    writeEnabled <= '1';
                    sourceOfWrite <= "10"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                    jumpSource <= "00"; --PC + 1
                    --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                    --sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
            when "100" => --XOR
                    operationToexecute <= "0100"; --XOR
                    firstRegisterAddress <= sourceRegisterOne;
                    secondRegisterAddress <= sourceRegisterTwo;
                    addressToWrite <= destinationRegister;
                    firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                    secondRegisterIsImmediateOrProgramCounter <= "00"; -- sign extender
                    immediateSource <= "001"; -- S-type
                    memoryLoad <= '0';
                    --branch <= '0';
                    --offsetToJump <= (others => 'X');
                    memoryStore <= '0';
                    loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                    writeEnabled <= '1';
                    sourceOfWrite <= "10"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                    jumpSource <= "00"; --PC + 1
                    --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                    --sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
            when "101" => --SRL, SRA
                if functionSevenBits(5) = '1' then --SRA
                    operationToexecute <= "1000"; --SRA
                    firstRegisterAddress <= sourceRegisterOne;
                    secondRegisterAddress <= sourceRegisterTwo;
                    addressToWrite <= destinationRegister;
                    firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                    secondRegisterIsImmediateOrProgramCounter <= "00"; -- sign extender
                    immediateSource <= "001"; -- S-type
                    memoryLoad <= '0';
                    --branch <= '0';
                    --offsetToJump <= (others => 'X');
                    memoryStore <= '0';
                    loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                    writeEnabled <= '1';
                    sourceOfWrite <= "10"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                    jumpSource <= "00"; --PC + 1
                   -- memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                    --sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
                elsif functionSevenBits(5) = '0' then -- SRL
                    operationToexecute <= "1001"; --SRL
                    firstRegisterAddress <= sourceRegisterOne;
                    secondRegisterAddress <= sourceRegisterTwo;
                    addressToWrite <= destinationRegister;
                    firstRegisterIsImmediateOrProgramCounter <= "00"; -- normal register
                    secondRegisterIsImmediateOrProgramCounter <= "00"; -- sign extender
                    immediateSource <= "001"; -- S-type
                    memoryLoad <= '0';
                    --branch <= '0';
                    --offsetToJump <= (others => 'X');
                    memoryStore <= '0';
                    loadStoreSize <= "00"; -- 00 byte, 01 half, 10 word.  
                    writeEnabled <= '1';
                    sourceOfWrite <= "10"; -- mux infront of the write port (register file) 00 - instruction supplied, 01 --from memory, 10 -- ALU, 11 -- PC
                    jumpSource <= "00"; --PC + 1
                    --memoryAddress <= sourceRegisterTwo; -- do i need thi ?
                    --sourceOfmemoryAddress <= "00"; --  register, ALU, sign Extender
                end if;
            when "110" => -- OR
            when "111" =>-- AND
            when others =>
        end case;
    when others =>
end case;

end process;

end Behavioral;
