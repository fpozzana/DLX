--test : tested OK, the component works as expected
--the values in memory have to be changed to fit an actual implementation

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.myTypes.all;

entity CU_HARDWIRED is
       port (-- ID Control Signals
             RegA_LATCH_EN   : OUT std_logic;    -- Register A Latch Enable
             RegB_LATCH_EN   : OUT std_logic;    -- Register B Latch Enable
             RegIMM_LATCH_EN : OUT std_logic;    -- Immediate Register Latch Enable
             RF_EN           : OUT std_logic;    -- RF enable
             RF_RE1          : OUT std_logic;    -- enables the read port 1 of the register file
             RF_RE2          : OUT std_logic;    -- enables the read port 2 of the register file
             -- EX Control Signal
             JUMP_EN         : OUT std_logic;    -- JUMP Enable Signal for PC input MUX
             ALU_OPCODE      : OUT std_logic_vector(ALU_OPC_SIZE -1 downto 0); -- ALU Operation Code
             MUXA_SEL        : OUT std_logic;    -- MUX-A Sel
             MUXB_SEL        : OUT std_logic;    -- MUX-B Sel
             -- MEM Control Signals
             DRAM_WE         : OUT std_logic;    -- Data RAM Write Enable
             DRAM_RE         : OUT std_logic;    -- Data RAM Read Enable
             LMD_LATCH_EN    : OUT std_logic;    -- LMD Register Latch Enable
             WB_MUX_SEL      : OUT std_logic;    -- Write Back MUX Sel
             RF_WE           : OUT std_logic;   -- Register File Write Enable
             -- INPUTS
             OPCODE : IN  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
             FUNC   : IN  std_logic_vector(FUNC_SIZE - 1 downto 0);
             Clk : IN std_logic;
             Rst : IN std_logic);                  -- Active high
end CU_HARDWIRED;

architecture BEHAVIORAL of CU_HARDWIRED is

  type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);
  signal cw_mem : mem_array := ("0101010101010101", --R TYPE_ADD
						                    "1010101010101010", --R TYPE_SUB
						                    "0101010101010101", --R TYPE_AND
						                    "1010101010101010", --R TYPE_OR
                                "0101010101010101", --ADDI1
                                "1010101010101010", --SUBI1
                                "0101010101010101", --ANDI1
                                "1010101010101010", --ORI1
                                "0101010101010101", --ADDI2
                                "1010101010101010", --SUBI2
                                "0101010101010101", --ANDI2
                                "1010101010101010", --ORI2
                                "0101010101010101", --MOV
                                "1010101010101010", --S_REG1
                                "0101010101010101", --S_REG2
                                "1010101010101010", --S_MEM2
                                "0101010101010101", --L_MEM1
                                "1010101010101010"); --L_MEM2

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
  signal cw1 : std_logic_vector(CW_SIZE - 1 downto 0); -- first stage
  signal cw2 : std_logic_vector(CW_SIZE - 1 - 6 downto 0); -- second stage
  signal cw3 : std_logic_vector(CW_SIZE - 1 - 6 - 3 - ALU_OPC_SIZE downto 0); -- third stage

  --signal next_address: integer range 0 to MICROCODE_MEM_SIZE - 1; --is the pointer to the first microcode address to execute, given an OPCODE and a FUNC

begin

  --cw <= cw_mem(conv_integer(OPCODE));

  -- stage one control signals
  RegA_LATCH_EN <= cw1(CW_SIZE - 1);
  RegB_LATCH_EN <= cw1(CW_SIZE - 2);
  RegIMM_LATCH_EN <= cw1(CW_SIZE - 3);
  RF_EN <= cw1(CW_SIZE - 4);
  RF_RE1 <= cw1(CW_SIZE - 5);
  RF_RE2 <= cw1(CW_SIZE - 6);

  -- stage two control signals
  JUMP_EN <= cw2(CW_SIZE - 7);
  ALU_OPCODE <= cw2(CW_SIZE - 8 downto CW_SIZE - 8 - ALU_OPC_SIZE + 1);
  MUXA_SEL <= cw2(CW_SIZE - 8 - ALU_OPC_SIZE);
  MUXB_SEL <= cw2(CW_SIZE - 8 - ALU_OPC_SIZE - 1);

  -- stage three control signals
  DRAM_WE <= cw3(CW_SIZE - 8 - ALU_OPC_SIZE - 2);
  DRAM_RE <= cw3(CW_SIZE - 8 - ALU_OPC_SIZE - 3);
  LMD_LATCH_EN <= cw3(CW_SIZE - 8 - ALU_OPC_SIZE - 4);
  WB_MUX_SEL <= cw3(CW_SIZE - 8 - ALU_OPC_SIZE - 5);
  RF_WE <= cw3(CW_SIZE - 8 - ALU_OPC_SIZE - 6);


	process(OPCODE, FUNC) --COMBINATIONAL PROCESS, calculates the address of the next microcode to execute given its OPCODE and FUNC.
	begin
		if (OPCODE = RTYPE) then
			cw <= cw_mem(conv_integer(FUNC)); --(opcode = 0 for rtype)->(FUNC+OPCODE)->FUNC directly points to RTYPE addresses in memory
		else
			cw <= cw_mem(conv_integer(OPCODE + 3));    -- +4 to point in the right stop on the memory
		end if;
	end process;


  -- process to pipeline control words
  CW_PIPE: process (Clk, Rst)
  begin  -- process Clk
    if Rst = '1' then                   -- asynchronous reset (active low)
      cw1 <= (others => '0');
      cw2 <= (others => '0');
      cw3 <= (others => '0');
    elsif Clk'event and Clk = '1' then  -- rising clock edge
      cw1 <= cw;
      cw2 <= cw1(CW_SIZE - 1 - 6 downto 0);
      cw3 <= cw2(CW_SIZE - 1 - 6 - 3 - ALU_OPC_SIZE downto 0);
    end if;
  end process CW_PIPE;

end BEHAVIORAL;

configuration CFG_CONTROL_UNIT_HW of CU_HARDWIRED is
  for BEHAVIORAL
  end for;
end CFG_CONTROL_UNIT_HW;
