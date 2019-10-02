library ieee;
use ieee.std_logic_1164.all;
use work.myTypes.all;
use WORK.constants.all;

entity DLX is
  generic(IR_SIZE      : integer := 32;       -- Instruction Register Size
          PC_SIZE      : integer := 32);       -- Program Counter Size
  port(clk : IN std_logic;
       reset : IN std_logic;
       pc_in : IN std_logic_vector(PC_SIZE - 1 downto 0);
       npc_out_if : OUT std_logic_vector(IR_SIZE - 1 downto 0);
       ir_out : OUT std_logic_vector(IR_SIZE - 1 downto 0);
       rd_out_id : OUT std_logic_vector(4 downto 0);
       npc_out_id : OUT std_logic_vector(IR_SIZE - 1 downto 0);
       a_reg_out : OUT std_logic_vector(IR_SIZE - 1 downto 0);
       b_reg_out : OUT std_logic_vector(IR_SIZE - 1 downto 0);
       imm_reg_out : OUT std_logic_vector(IR_SIZE - 1 downto 0);
       alu_out : OUT std_logic_vector(IR_SIZE - 1 downto 0);
       rd_out_ex : OUT std_logic_vector(4 downto 0);
       b_reg_out_ex : OUT std_logic_vector(IR_SIZE - 1 downto 0);
       memory_out : OUT std_logic_vector(IR_SIZE - 1 downto 0);
       rd_out_mem : OUT std_logic_vector(4 downto 0);
       lmd_out : OUT std_logic_vector(IR_SIZE - 1 downto 0);
       alu_out_mem : OUT std_logic_vector(IR_SIZE - 1 downto 0);
       rd_out_wb : OUT std_logic_vector(4 downto 0);
       wb_stage_out : OUT std_logic_vector(IR_SIZE - 1 downto 0);
       address_error : OUT std_logic);
end DLX;


-- This architecture is currently not complete
-- it just includes:
-- instruction register (complete)
-- program counter (complete)
-- instruction ram memory (complete)
-- control unit (UNCOMPLETE)
--
architecture dlx_rtl of DLX is

 --------------------------------------------------------------------
 -- Components Declaration
 --------------------------------------------------------------------

  --Instruction Ram
  component IRAM
  generic(RAM_DEPTH : integer := RAM_DEPTH;
          I_SIZE : integer := I_SIZE);
  port(Rst  : in  std_logic;
       Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
       Dout : out std_logic_vector(I_SIZE - 1 downto 0));
  end component;

  -- Data Ram
  component DRAM
  generic(NBIT : integer := NumBitMemoryWord;
          NCELL : integer := NumBitMemoryCells);
  port(address : IN std_logic_vector(NBIT-1 downto 0);
       data_in : IN std_logic_vector(NBIT-1 downto 0);
       write_enable : IN std_logic;
       read_enable : IN std_logic;
       data_out : OUT std_logic_vector(NBIT-1 downto 0);
       address_error : OUT std_logic);
  end component;

  -- Datapath
  component DATAPATH
  generic(numbit : integer := RISC_BIT);
  port(clk : IN std_logic;
       reset : IN std_logic;
       write_enable : IN std_logic;
       mux_one_control : IN std_logic;
       mux_two_control : IN std_logic;
       alu_control : IN std_logic_vector(3 downto 0);
       to_pc : IN std_logic_vector(numbit - 1 downto 0);
       to_ir : IN std_logic_vector(numbit - 1 downto 0);
       to_mem_stage_reg : IN std_logic_vector(numbit - 1 downto 0);
       wb_control : IN std_logic;
       to_iram : OUT std_logic_vector(numbit - 1 downto 0);
       npc_out_if : OUT std_logic_vector(numbit - 1 downto 0);
       ir_out : OUT std_logic_vector(numbit - 1 downto 0);
       rd_out_id : OUT std_logic_vector(4 downto 0);
       npc_out_id : OUT std_logic_vector(numbit - 1 downto 0);
       a_reg_out : OUT std_logic_vector(numbit - 1 downto 0);
       b_reg_out : OUT std_logic_vector(numbit - 1 downto 0);
       imm_reg_out : OUT std_logic_vector(numbit - 1 downto 0);
       alu_out : OUT std_logic_vector(numbit - 1 downto 0);
       rd_out_ex : OUT std_logic_vector(4 downto 0);
       b_reg_out_ex : OUT std_logic_vector(numbit - 1 downto 0);
       rd_out_mem : OUT std_logic_vector(4 downto 0);
       memory_stage_out : OUT std_logic_vector(numbit - 1 downto 0);
       alu_out_mem : OUT std_logic_vector(numbit - 1 downto 0);
       wb_stage_out : OUT std_logic_vector(numbit - 1 downto 0);
       rd_out_wb : OUT std_logic_vector(4 downto 0));
  end component;

  -- Control Unit
  --component dlx_cu
  --generic (
  --  MICROCODE_MEM_SIZE :     integer := 10;  -- Microcode Memory Size
  --  FUNC_SIZE          :     integer := 11;  -- Func Field Size for R-Type Ops
  --  OP_CODE_SIZE       :     integer := 6;  -- Op Code Size
    --ALU_OPC_SIZE       :     integer := 6;  -- ALU Op Code Word Size
  --  IR_SIZE            :     integer := 32;  -- Instruction Register Size
  --  CW_SIZE            :     integer := 15);  -- Control Word Size
  --port (
  --  Clk                : in  std_logic;  -- Clock
  --  Rst                : in  std_logic;  -- Reset:Active-Low
    -- Instruction Register
  --  IR_IN              : in  std_logic_vector(IR_SIZE - 1 downto 0);
    -- IF Control Signal
  --  IR_LATCH_EN        : out std_logic;  -- Instruction Register Latch Enable
  --  NPC_LATCH_EN       : out std_logic;
    -- ID Control Signals
  --  RegA_LATCH_EN      : out std_logic;  -- Register A Latch Enable
  --  RegB_LATCH_EN      : out std_logic;  -- Register B Latch Enable
  --  RegIMM_LATCH_EN    : out std_logic;  -- Immediate Register Latch Enable
    -- EX Control Signals
  --  MUXA_SEL           : out std_logic;  -- MUX-A Sel
  --  MUXB_SEL           : out std_logic;  -- MUX-B Sel
  --  ALU_OUTREG_EN      : out std_logic;  -- ALU Output Register Enable
  --  EQ_COND            : out std_logic;  -- Branch if (not) Equal to Zero
    -- ALU Operation Code
  --  ALU_OPCODE         : out aluOp; -- choose between implicit or exlicit coding, like std_logic_vector(ALU_OPC_SIZE -1 downto 0);
    -- MEM Control Signals
  --  DRAM_WE            : out std_logic;  -- Data RAM Write Enable
  --  LMD_LATCH_EN       : out std_logic;  -- LMD Register Latch Enable
  --  JUMP_EN            : out std_logic;  -- JUMP Enable Signal for PC input MUX
  --  PC_LATCH_EN        : out std_logic;  -- Program Counte Latch Enable
    -- WB Control signals
  --  WB_MUX_SEL         : out std_logic;  -- Write Back MUX Sel
  --  RF_WE              : out std_logic);  -- Register File Write Enable

  --end component;


  ----------------------------------------------------------------
  -- Signals Declaration
  ----------------------------------------------------------------




  -- Instruction Register (IR) and Program Counter (PC) declaration
  --signal IR : std_logic_vector(IR_SIZE - 1 downto 0);
  --signal PC : std_logic_vector(PC_SIZE - 1 downto 0);

  -- Instruction Ram Bus signals
  signal toiramfrompc : std_logic_vector(RISC_BIT - 1 downto 0);
  signal toirfromiram : std_logic_vector(RISC_BIT - 1 downto 0);

  -- Data Ram Bus signals
  signal todramfromaluout : std_logic_vector(RISC_BIT - 1 downto 0);
  signal todramfrombreg : std_logic_vector(RISC_BIT - 1 downto 0);
  signal tolmdfromdram : std_logic_vector(RISC_BIT - 1 downto 0);
  signal address_dram : std_logic_vector(RISC_BIT - 1 downto 0);

  -- Datapath Bus signals
  --signal PC_BUS : std_logic_vector(PC_SIZE -1 downto 0);

  -- Control Unit Bus signals
  --signal IR_LATCH_EN_i : std_logic;
  --signal NPC_LATCH_EN_i : std_logic;
  --signal RegA_LATCH_EN_i : std_logic;
  --signal RegB_LATCH_EN_i : std_logic;
  --signal RegIMM_LATCH_EN_i : std_logic;
  --signal EQ_COND_i : std_logic;
  --signal JUMP_EN_i : std_logic;
  --signal ALU_OPCODE_i : aluOp;
  --signal MUXA_SEL_i : std_logic;
  --signal MUXB_SEL_i : std_logic;
  --signal ALU_OUTREG_EN_i : std_logic;
  --signal DRAM_WE_i : std_logic;
  --signal LMD_LATCH_EN_i : std_logic;
  --signal PC_LATCH_EN_i : std_logic;
  --signal WB_MUX_SEL_i : std_logic;
  --signal RF_WE_i : std_logic;





  begin  -- DLX
    alu_out <= todramfromaluout;
    b_reg_out_ex <= todramfrombreg;
    memory_out <= tolmdfromdram;

    address_dram <= "0000000000000000" & todramfrombreg(15 downto 0);

    IRAM_I : IRAM
    generic map(RAM_DEPTH,I_SIZE)
    port map(reset, toiramfrompc, toirfromiram);

    DRAM_I : DRAM
    generic map(RISC_BIT, RISC_BIT)
    port map(todramfromaluout, address_dram, '1', '1', tolmdfromdram, address_error);

    --DATAPATH_I : DATAPATH
    --generic map(RISC_BIT)
    --port map(clk, reset, '0', '1', '1', (others => '0'), pc_in, toirfromiram, tolmdfromdram, '1', toiramfrompc, npc_out_if, ir_out, rd_out_id, npc_out_id, a_reg_out, b_reg_out, imm_reg_out, todramfromaluout, rd_out_ex, todramfrombreg, rd_out_mem, lmd_out, alu_out_mem, wb_stage_out, rd_out_wb);

    DATAPATH_I : DATAPATH
    generic map(RISC_BIT)
    port map(clk =>  clk,
             reset => reset,
             write_enable =>  '0',
             mux_one_control => '1',
             mux_two_control => '1',
             alu_control => (others => '0'),
             to_pc => pc_in,
             to_ir => toirfromiram,
             to_mem_stage_reg => tolmdfromdram,
             wb_control => '1',
             to_iram => toiramfrompc,
             npc_out_if => npc_out_if,
             ir_out => ir_out,
             rd_out_id => rd_out_id,
             npc_out_id => npc_out_id,
             a_reg_out => a_reg_out,
             b_reg_out => b_reg_out,
             imm_reg_out => imm_reg_out,
             alu_out => todramfromaluout,
             rd_out_ex => rd_out_ex,
             b_reg_out_ex => todramfrombreg,
             rd_out_mem => rd_out_mem,
             memory_stage_out => lmd_out,
             alu_out_mem => alu_out_mem,
             wb_stage_out => wb_stage_out,
             rd_out_wb => rd_out_wb);


    -- This is the input to program counter: currently zero
    -- so no uptade of PC happens
    -- TO BE REMOVED AS SOON AS THE DATAPATH IS INSERTED!!!!!
    -- a proper connection must be made here if more than one
    -- instruction must be executed
    --PC_BUS <= (others => '0');


    -- purpose: Instruction Register Process
    -- type   : sequential
    -- inputs : Clk, Rst, IRam_DOut, IR_LATCH_EN_i
    -- outputs: IR_IN_i
    --IR_P: process (Clk, Rst)
    --begin  -- process IR_P
    --  if Rst = '0' then                 -- asynchronous reset (active low)
    --    IR <= (others => '0');
    --  elsif Clk'event and Clk = '1' then  -- rising clock edge
    --    if (IR_LATCH_EN_i = '1') then
    --      IR <= IRam_DOut;
    --    end if;
    --  end if;
    --end process IR_P;


    -- purpose: Program Counter Process
    -- type   : sequential
    -- inputs : Clk, Rst, PC_BUS
    -- outputs: IRam_Addr
    --PC_P: process (Clk, Rst)
    --begin  -- process PC_P
    --  if Rst = '0' then                 -- asynchronous reset (active low)
    --    PC <= (others => '0');
    --  elsif Clk'event and Clk = '1' then  -- rising clock edge
    --    if (PC_LATCH_EN_i = '1') then
    --      PC <= PC_BUS;
    --    end if;
    --  end if;
    --end process PC_P;

    -- Control Unit Instantiation
    --CU_I: dlx_cu
    --  port map (
    --      Clk             => Clk,
    --      Rst             => Rst,
    --      IR_IN           => IR,
    --      IR_LATCH_EN     => IR_LATCH_EN_i,
    --      NPC_LATCH_EN    => NPC_LATCH_EN_i,
    --      RegA_LATCH_EN   => RegA_LATCH_EN_i,
    --      RegB_LATCH_EN   => RegB_LATCH_EN_i,
    --      RegIMM_LATCH_EN => RegIMM_LATCH_EN_i,
    --      MUXA_SEL        => MUXA_SEL_i,
    --      MUXB_SEL        => MUXB_SEL_i,
    --      ALU_OUTREG_EN   => ALU_OUTREG_EN_i,
    --      EQ_COND         => EQ_COND_i,
    --      ALU_OPCODE      => ALU_OPCODE_i,
    --      DRAM_WE         => DRAM_WE_i,
    --      LMD_LATCH_EN    => LMD_LATCH_EN_i,
    --      JUMP_EN         => JUMP_EN_i,
    --      PC_LATCH_EN     => PC_LATCH_EN_i,
    --      WB_MUX_SEL      => WB_MUX_SEL_i,
    --      RF_WE           => RF_WE_i);

    -- Instruction Ram Instantiation
    --IRAM_I: IRAM
    --  port map (
    --      Rst  => Rst,
    --      Addr => PC,
    --      Dout => IRam_DOut);



end dlx_rtl;

configuration CFG_DLX of DLX is
	for dlx_rtl
    for all : IRAM
		  use configuration WORK.CFG_IRAM_BEHAVIORAL;
    end for;
    for all : DATAPATH
		  use configuration WORK.CFG_DATAPATH;
    end for;
    for all : DRAM
      use configuration WORK.CFG_DRAM;
    end for;
	end for;
end CFG_DLX;
