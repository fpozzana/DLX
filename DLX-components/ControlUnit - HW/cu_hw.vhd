--test : tested OK, the component works as expected
--the values in memory have to be changed to fit an actual implementation

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.myTypes.all;

entity CU_HARDWIRED is
       port (-- ID Control Signals
             -- EX Control Signal
             MUXA_CONTROL    : OUT std_logic;    -- MUX-A Sel
             MUXB_CONTROL    : OUT std_logic;    -- MUX-B Sel
             ALU_OPCODE      : OUT std_logic_vector(ALU_OPC_SIZE - 1 downto 0); -- ALU Operation Code
             -- MEM Control Signals
             DRAM_WE         : OUT std_logic;    -- Data RAM Write Enable
             DRAM_RE         : OUT std_logic;    -- Data RAM Read Enable
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

  --if bits in mem_array are (others => '0') it means that either the instruction
  --is not implemented or is a NTYPE_NOP
  type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);
  signal cw_mem_rtype : mem_array := ("0000000000",
      						                    "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "1000000011",     --RTYPE_SLL
                                      "0000000000",
                                      "1000010011",     --RTYPE_SRL
                                      "0000000000",     --RTYPE_SRA                   --not implemented
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",
                                      "1000100011",     --RTYPE_ADD
                                      "0000000000",     --RTYPE_ADDU
                                      "1000110011",     --RTYPE_SUB
                                      "0000000000",     --RTYPE_SUBU
                                      "1001000011",     --RTYPE_AND
                                      "1001010011",     --RTYPE_OR
                                      "1001100011",     --RTYPE_XOR
                                      "0000000000",
                                      "1001110011",     --RTYPE_SEQ
                                      "1010000011",     --RTYPE_SNE
                                      "1010010011",     --RTYPE_SLT
                                      "1010100011",     --RTYPE_SGT
                                      "1010110011",     --RTYPE_SLE
                                      "1011000011",     --RTYPE_SGE
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",     --RTYPE_MOVI2S                --not implemented
                                      "0000000000",     --RTYPE_MOVS2I                --not implemented
                                      "0000000000",     --RTYPE_MOVF                  --not implemented
                                      "0000000000",     --RTYPE_MOVD                  --not implemented
                                      "0000000000",     --RTYPE_MOVFP2I               --not implemented
                                      "0000000000",     --RTYPE_MOVI2FP               --not implemented
                                      "0000000000",     --RTYPE_MOVI2T                --not implemented
                                      "0000000000",     --RTYPE_MOVT2I                --not implemented
                                      "0000000000",
                                      "0000000000",
                                      "0000000000",     --RTYPE_SLTU                  --not implemented
                                      "0000000000",     --RTYPE_SGTU                  --not implemented
                                      "0000000000",     --RTYPE_SLEU                  --not implemented
                                      "0000000000"      --RTYPE_SGEU                  --not implemented
                                      );

signal cw_mem_itype : mem_array := ("0000000000",     --START NOT R_TYPE
                                    "0000000000",
                                    "0011010000",     --JTYPE_J                     --implemented in the branch prediction unit
                                    "0000000000",     --JTYPE_JAL                   --not implemented
                                    "0011010000",     --ITYPE_BEQZ                  --implemented in the branch prediction unit
                                    "0011010000",     --ITYPE_BNEZ                  --implemented in the branch prediction unit
                                    "0000000000",     --ITYPE_BFPT                  --not implemented
                                    "0000000000",     --ITYPE_BFPF                  --not implemented
                                    "1100100011",     --ITYPE_ADD
                                    "0000000000",     --ITYPE_ADDU                  --not implemented
                                    "1100110011",     --ITYPE_SUB
                                    "0000000000",     --ITYPE_SUBU                  --not implemented
                                    "1101000011",     --ITYPE_AND
                                    "1101010011",     --ITYPE_OR
                                    "1101100011",     --ITYPE_XOR
                                    "0000000000",     --ITYPE_LH                    --not implemented
                                    "0000000000",     --ITYPE_RFE                   --not implemented
                                    "0000000000",     --ITYPE_TRAP                  --not implemented
                                    "0000000000",     --JTYPE_JR                    --not implemented
                                    "0000000000",     --JTYPE_JALR                  --not implemented
                                    "1100000011",     --ITYPE_SLL
                                    "0011010000",     --NTYPE_NOP
                                    "1100010011",     --ITYPE_SRL
                                    "0000000000",     --ITYPE_SRA                   --not implemented
                                    "1101110011",     --ITYPE_SEQ
                                    "1110000011",     --ITYPE_SNE
                                    "1110010011",     --ITYPE_SLT
                                    "1110100011",     --ITYPE_SGT
                                    "1110110011",     --ITYPE_SLE
                                    "1111000011",     --ITYPE_SGE
                                    "0000000000",
                                    "0000000000",
                                    "0000000000",     --ITYPE_LB                    --not implemented
                                    "0000000000",     --ITYPE_LH                    --not implemented
                                    "0000000000",
                                    "1100100101",     --ITYPE_LW
                                    "0000000000",     --ITYPE_LBU                   --not implemented
                                    "0000000000",     --ITYPE_LHU                   --not implemented
                                    "0000000000",     --ITYPE_LF                    --not implemented
                                    "0000000000",     --ITYPE_LD                    --not implemented
                                    "0000000000",     --ITYPE_SB                    --not implemented
                                    "0000000000",     --ITYPE_SH                    --not implemented
                                    "0000000000",
                                    "1100101000",     --ITYPE_SW
                                    "0000000000",
                                    "0000000000",
                                    "0000000000",     --ITYPE_SF                    --not implemented
                                    "0000000000",     --ITYPE_SD                    --not implemented
                                    "0000000000",
                                    "0000000000",
                                    "0000000000",
                                    "0000000000",
                                    "0000000000",
                                    "0000000000",
                                    "0000000000",
                                    "0000000000",
                                    "0000000000",     --NTYPE_ITLB                  --not implemented
                                    "0000000000",
                                    "0000000000",     --ITYPE_SLTU                  --not implemented
                                    "0000000000",     --ITYPE_SGTU                  --not implemented
                                    "0000000000",     --ITYPE_SLEU                  --not implemented
                                    "0000000000"      --ITYPE_SGEU                  --not implemented
                                    );

  signal cw : std_logic_vector(CW_SIZE - 1 downto 0); -- full control word read from cw_mem

  -- control word is shifted to the correct stage
  --signal cw1 : std_logic_vector(CW_SIZE - 1 downto 0);                        -- decode stage
  signal cw1 : std_logic_vector(CW_SIZE - 1 downto 0);                        -- execution stage
  signal cw2 : std_logic_vector(CW_SIZE - 1 - 2 - ALU_OPC_SIZE downto 0);     -- memory stage
  signal cw3 : std_logic_vector(CW_SIZE - 1 - 2 - ALU_OPC_SIZE - 2 downto 0); -- write back stage

begin

  -- stage one control signals

  -- stage two control signals
  MUXA_CONTROL <= cw1(CW_SIZE - 1);
  MUXB_CONTROL <= cw1(CW_SIZE - 2);
  ALU_OPCODE <= cw1(CW_SIZE - 3 downto CW_SIZE - 3 - ALU_OPC_SIZE + 1);

  -- stage three control signals
  DRAM_WE <= cw2(CW_SIZE - 3 - ALU_OPC_SIZE);
  DRAM_RE <= cw2(CW_SIZE - 4 - ALU_OPC_SIZE);

  --stage four control singals
  WB_MUX_SEL <= cw3(CW_SIZE - 5 - ALU_OPC_SIZE);
  RF_WE <= cw3(CW_SIZE - 6 - ALU_OPC_SIZE);

	process(OPCODE, FUNC) --COMBINATIONAL PROCESS, calculates the address of the next microcode to execute given its OPCODE and FUNC.
	begin
		if (OPCODE = RTYPE) then
			cw <= cw_mem_rtype(conv_integer(FUNC)); --(opcode = 0 for rtype)->(FUNC+OPCODE)->FUNC directly points to RTYPE addresses in memory
		else
			cw <= cw_mem_itype(conv_integer(OPCODE));
		end if;
	end process;

  --3D = 61
  -- process to pipeline control words
  CW_PIPE: process (Clk, Rst)
  begin  -- process Clk
    if Rst = '1' then                   -- asynchronous reset (active low)
      --cw1 <= (others => '0');
      cw1 <= (others => '0');
      cw2 <= (others => '0');
      cw3 <= (others => '0');
    elsif Clk'event and Clk = '1' then  -- rising clock edge
      cw1 <= cw;
      cw2 <= cw1(CW_SIZE - 1 - 2 - ALU_OPC_SIZE downto 0);
      cw3 <= cw2(CW_SIZE - 1 - 2 - ALU_OPC_SIZE - 2 downto 0);
      --cw4 <= cw3(CW_SIZE - 1 - 2 - ALU_OPC_SIZE - 2 downto 0);
    end if;
  end process CW_PIPE;

end BEHAVIORAL;

configuration CFG_CONTROL_UNIT_HW of CU_HARDWIRED is
  for BEHAVIORAL
  end for;
end CFG_CONTROL_UNIT_HW;
