--test : tested OK, the component works as expected
--the values in memory have to be changed to fit an actual implementation

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.myTypes.all;

entity CU_HARDWIRED is
       port (-- ID Control Signals
             RF_EN           : OUT std_logic;    -- RF enable
             RF_RE1          : OUT std_logic;    -- enables the read port 1 of the register file
             RF_RE2          : OUT std_logic;    -- enables the read port 2 of the register file
             RESET_ID         : OUT std_logic;    -- reset signal
             -- EX Control Signal
             ALU_OPCODE      : OUT std_logic_vector(ALU_OPC_SIZE - 1 downto 0); -- ALU Operation Code
             RESET_EX        : OUT std_logic;    -- reset signal
             MUXA_SEL        : OUT std_logic;    -- MUX-A Sel
             MUXB_SEL        : OUT std_logic;    -- MUX-B Sel
             -- MEM Control Signals
             DRAM_WE         : OUT std_logic;    -- Data RAM Write Enable
             DRAM_RE         : OUT std_logic;    -- Data RAM Read Enable
             RESET_MEM       : OUT std_logic;    -- reset signal
             -- WB Control Signals
             WB_MUX_SEL      : OUT std_logic;    -- Write Back MUX Sel
             RF_WE           : OUT std_logic;    -- Register File Write Enable
             -- INPUTS
             OPCODE : IN  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
             FUNC   : IN  std_logic_vector(FUNC_SIZE - 1 downto 0);
             Clk : IN std_logic;
             Rst : IN std_logic);                  -- Active high
end CU_HARDWIRED;

architecture BEHAVIORAL of CU_HARDWIRED is

  type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);
  signal cw_mem : mem_array := ("1111111111111111", --R TYPE_ADD
						                    "0000000000000000", --R TYPE_SUB
						                    "1111111111111111", --R TYPE_AND
						                    "0000000000000000", --R TYPE_OR
                                "1111111111111111", --ADDI1
                                "0000000000000000", --SUBI1
                                "1111111111111111", --ANDI1
                                "0000000000000000", --ORI1
                                "1111111111111111", --ADDI2
                                "0000000000000000", --SUBI2
                                "1111111111111111", --ANDI2
                                "0000000000000000", --ORI2
                                "1111111111111111", --MOV
                                "0000000000000000", --S_REG1
                                "1111111111111111", --S_REG2
                                "0000000000000000", --S_MEM2
                                "1111111111111111", --L_MEM1
                                "0000000000000000"); --L_MEM2

--                                signal cw_mem : mem_array := ("1111011001000", --R TYPE_ADD
--                              						                    "1111011011000", --R TYPE_SUB
--                              						                    "1111011101000", --R TYPE_AND
--                              						                    "1111011111000", --R TYPE_OR
--                                                              "1011111001000", --ADDI1
--                                                              "1011111011000", --SUBI1
--                                                              "1011111101000", --ANDI1
--                                                              "1011111111000", --ORI1
--                                                              "1101001001000", --ADDI2
--                                                              "1101001011000", --SUBI2
--                                                              "1101001101000", --ANDI2
--                                                              "1101001111000", --ORI2
--                                                              "1101001001000", --MOV
--                                                              "1000000000000", --S_REG1
--                                                              "1000000000000", --S_REG2
--                                                              "1111001000010", --S_MEM2
--                                                              "1011111001101", --L_MEM1
--                                                              "1101001001101"); --L_MEM2

  signal cw : std_logic_vector(CW_SIZE - 1 downto 0); -- full control word read from cw_mem

  -- control word is shifted to the correct stage
  signal cw1 : std_logic_vector(CW_SIZE - 1 downto 0); -- decode stage
  signal cw2 : std_logic_vector(CW_SIZE - 1 - 4 downto 0); -- execution stage
  signal cw3 : std_logic_vector(CW_SIZE - 1 - 4 - 3 - ALU_OPC_SIZE downto 0); -- memory stage
  --signal cw4 : std_logic_vector(CW_SIZE - 1 - 6 - 3 - ALU_OPC_SIZE - 3 downto 0); -- write back stage

  --signal next_address: integer range 0 to MICROCODE_MEM_SIZE - 1; --is the pointer to the first microcode address to execute, given an OPCODE and a FUNC

begin

  --cw <= cw_mem(conv_integer(OPCODE));

  -- stage one control signals
  RF_EN <= cw1(CW_SIZE - 1);
  RF_RE1 <= cw1(CW_SIZE - 2);
  RF_RE2 <= cw1(CW_SIZE - 3);
  RESET_ID <= cw1(CW_SIZE - 4);

  -- stage two control signals
  ALU_OPCODE <= cw2(CW_SIZE - 5 downto CW_SIZE - 5 - ALU_OPC_SIZE + 1);
  RESET_EX <= cw2(CW_SIZE - 5 - ALU_OPC_SIZE);
  MUXA_SEL <= cw2(CW_SIZE - 5 - ALU_OPC_SIZE - 1);
  MUXB_SEL <= cw2(CW_SIZE - 5 - ALU_OPC_SIZE - 2);

  -- stage three control signals
  DRAM_WE <= cw3(CW_SIZE - 5 - ALU_OPC_SIZE - 3);
  DRAM_RE <= cw3(CW_SIZE - 5 - ALU_OPC_SIZE - 4);
  RESET_MEM <= cw3(CW_SIZE - 5 - ALU_OPC_SIZE - 5);
  WB_MUX_SEL <= cw3(CW_SIZE - 5 - ALU_OPC_SIZE - 6);
  RF_WE <= cw3(CW_SIZE - 5 - ALU_OPC_SIZE - 7);

  -- stage four control signals
  --WB_MUX_SEL <= cw4(CW_SIZE - 7 - ALU_OPC_SIZE - 6);
  --RF_WE <= cw4(CW_SIZE - 7 - ALU_OPC_SIZE - 7);
  --RESET_WB <= cw4(CW_SIZE - 7 - ALU_OPC_SIZE - 8);


	process(OPCODE, FUNC) --COMBINATIONAL PROCESS, calculates the address of the next microcode to execute given its OPCODE and FUNC.
	begin
		if (OPCODE = RTYPE) then
			cw <= cw_mem(conv_integer(FUNC)); --(opcode = 0 for rtype)->(FUNC+OPCODE)->FUNC directly points to RTYPE addresses in memory
		else
			cw <= cw_mem(conv_integer(OPCODE + 3));    -- +3 to point in the right spot on the memory
		end if;
	end process;


  -- process to pipeline control words
  CW_PIPE: process (Clk, Rst)
  begin  -- process Clk
    if Rst = '1' then                   -- asynchronous reset (active low)
      cw1 <= (others => '0');
      cw2 <= (others => '0');
      cw3 <= (others => '0');
      --cw4 <= (others => '0');
    elsif Clk'event and Clk = '0' then  -- falling clock edge
      cw1 <= cw;
      cw2 <= cw1(CW_SIZE - 1 - 4 downto 0);
      cw3 <= cw2(CW_SIZE - 1 - 4 - 3 - ALU_OPC_SIZE downto 0);
      --cw4 <= cw3(CW_SIZE - 1 - 6 - 3 - ALU_OPC_SIZE - 3 downto 0);
    end if;
  end process CW_PIPE;

end BEHAVIORAL;

configuration CFG_CONTROL_UNIT_HW of CU_HARDWIRED is
  for BEHAVIORAL
  end for;
end CFG_CONTROL_UNIT_HW;
