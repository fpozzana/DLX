library ieee;
use ieee.std_logic_1164.all;
use WORK.constants.all;

package myTypes is

-- Control unit input sizes
    constant OP_CODE_SIZE : integer :=  6;                                              -- OPCODE field size
    constant FUNC_SIZE    : integer :=  11;                                             -- FUNC field size
	  constant MICROCODE_MEM_SIZE : integer := 18;
    constant ALU_OPC_SIZE : integer := 4;
    constant CW_SIZE : integer := 15 + ALU_OPC_SIZE;


-- R-Type instruction -> FUNC field
    constant RTYPE_ADD : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000000000";    -- ADD RS1,RS2,RD
    constant RTYPE_SUB : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000000001";    -- SUB RS1,RS2,RD
    constant RTYPE_AND : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000000010";    -- AND RS1,RS2,RD
    constant RTYPE_OR : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000000011";    -- OR RS1,RS2,RD
    constant NOP : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000000000";

-- R-Type instruction -> OPCODE field
    constant RTYPE : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000000";          -- for ADD, SUB, AND, OR register-to-register operation

-- I-Type instruction -> OPCODE field
    constant ITYPE_ADDI1 : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000001";    -- ADDI1 RS1,RD,INP1
    constant ITYPE_SUBI1 : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000010";    -- SUBI1 RS1,RD,INP1
    constant ITYPE_ANDI1 : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000011";    -- ANDI1 RS1,RD,INP1
    constant ITYPE_ORI1 : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000100";    -- ORI1 RS1,RD,INP1
    constant ITYPE_ADDI2 : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000101";    -- ADDI2 RS1,RD,INP2
    constant ITYPE_SUBI2 : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000110";    -- SUBI2 RS1,RD,INP2
    constant ITYPE_ANDI2 : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000111";    -- ANDI2 RS1,RD,INP2
    constant ITYPE_ORI2 : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001000";    -- ORI2 RS1,RD,INP2
    constant ITYPE_MOV : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001001";    -- MOV RS,RD
    constant ITYPE_S_REG1 : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001010";    -- S_REG1 RD,INP1
    constant ITYPE_S_REG2 : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001011";    -- S_REG2 RD,INP2
    constant ITYPE_S_MEM2 : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001100";    -- S_MEM2 RD,INP2
    constant ITYPE_L_MEM1 : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001101";    -- L_MEM1 RD,INP1
    constant ITYPE_L_MEM2 : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001110";    -- L_MEM2 RD,INP2

--constant registers used to fill the IRAM
    constant REG0 : std_logic_vector(NumBitAddress-1 downto 0) := "00000";
    constant REG1 : std_logic_vector(NumBitAddress-1 downto 0) := "00001";
    constant REG2 : std_logic_vector(NumBitAddress-1 downto 0) := "00010";
    constant REG3 : std_logic_vector(NumBitAddress-1 downto 0) := "00011";
    constant REG4 : std_logic_vector(NumBitAddress-1 downto 0) := "00100";
    constant REG5 : std_logic_vector(NumBitAddress-1 downto 0) := "00101";
    constant REG6 : std_logic_vector(NumBitAddress-1 downto 0) := "00110";
    constant REG7 : std_logic_vector(NumBitAddress-1 downto 0) := "00111";
    constant REG8 : std_logic_vector(NumBitAddress-1 downto 0) := "01000";
    constant REG9 : std_logic_vector(NumBitAddress-1 downto 0) := "01001";
    constant REG10 : std_logic_vector(NumBitAddress-1 downto 0) := "01010";
    constant REG11 : std_logic_vector(NumBitAddress-1 downto 0) := "01011";
    constant REG12 : std_logic_vector(NumBitAddress-1 downto 0) := "01100";
    constant REG13 : std_logic_vector(NumBitAddress-1 downto 0) := "01101";
    constant REG14 : std_logic_vector(NumBitAddress-1 downto 0) := "01110";
    constant REG15 : std_logic_vector(NumBitAddress-1 downto 0) := "01111";
    constant REG16 : std_logic_vector(NumBitAddress-1 downto 0) := "10000";
    constant REG17 : std_logic_vector(NumBitAddress-1 downto 0) := "10001";
    constant REG18 : std_logic_vector(NumBitAddress-1 downto 0) := "10010";
    constant REG19 : std_logic_vector(NumBitAddress-1 downto 0) := "10011";
    constant REG20 : std_logic_vector(NumBitAddress-1 downto 0) := "10100";
    constant REG21 : std_logic_vector(NumBitAddress-1 downto 0) := "10101";
    constant REG22 : std_logic_vector(NumBitAddress-1 downto 0) := "10110";
    constant REG23 : std_logic_vector(NumBitAddress-1 downto 0) := "10111";
    constant REG24 : std_logic_vector(NumBitAddress-1 downto 0) := "11000";
    constant REG25 : std_logic_vector(NumBitAddress-1 downto 0) := "11001";
    constant REG26 : std_logic_vector(NumBitAddress-1 downto 0) := "11010";
    constant REG27 : std_logic_vector(NumBitAddress-1 downto 0) := "11011";
    constant REG28 : std_logic_vector(NumBitAddress-1 downto 0) := "11100";
    constant REG29 : std_logic_vector(NumBitAddress-1 downto 0) := "11101";
    constant REG30 : std_logic_vector(NumBitAddress-1 downto 0) := "11110";
    constant REG31 : std_logic_vector(NumBitAddress-1 downto 0) := "11111";

end myTypes;
