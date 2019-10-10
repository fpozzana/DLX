library ieee;
use ieee.std_logic_1164.all;
use work.myTypes.all;
use WORK.globals.all;

entity DLX is
  generic(IR_SIZE      : integer := 32;       -- Instruction Register Size
          PC_SIZE      : integer := 32);       -- Program Counter Size
  port(clk : IN std_logic;
       reset : IN std_logic;
       --pc_in : IN std_logic_vector(PC_SIZE - 1 downto 0);
       npc_out_bpu : OUT std_logic_vector(IR_SIZE - 1 downto 0);
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
       address_error : OUT std_logic;
       --MUXA_CONTROL : OUT std_logic;
       MUXB_CONTROL : OUT std_logic;
       ALU_OPCODE : OUT std_logic_vector(ALU_OPC_SIZE - 1 downto 0);
       DRAM_WE : OUT std_logic;
       DRAM_RE : OUT std_logic;
       WB_MUX_SEL : OUT std_logic;
       RF_WE : OUT std_logic;
       alu_forwarding_one : OUT std_logic;
       mem_forwarding_one : OUT std_logic;
       alu_forwarding_two : OUT std_logic;
       mem_forwarding_two : OUT std_logic;
       alu_forwarding_value : OUT std_logic_vector(IR_SIZE - 1 downto 0);
       mem_forwarding_value : OUT std_logic_vector(IR_SIZE - 1 downto 0));
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
       reset : IN std_logic;
       data_out : OUT std_logic_vector(NBIT-1 downto 0);
       address_error : OUT std_logic);
  end component;

  -- Datapath
  component DATAPATH
  generic(numbit : integer := RISC_BIT);
  port(clk : IN std_logic;
       reset : IN std_logic;
       write_enable : IN std_logic;
       --mux_one_control : IN std_logic;
       mux_two_control : IN std_logic;
       alu_control : IN std_logic_vector(3 downto 0);
       --to_pc : IN std_logic_vector(numbit - 1 downto 0);
       to_ir : IN std_logic_vector(numbit - 1 downto 0);
       to_mem_stage_reg : IN std_logic_vector(numbit - 1 downto 0);
       wb_control : IN std_logic;
       to_iram : OUT std_logic_vector(numbit - 1 downto 0);
       npc_out_if : OUT std_logic_vector(numbit - 1 downto 0);
       npc_out_bpu : OUT std_logic_vector(numbit - 1 downto 0);
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
       rd_out_wb : OUT std_logic_vector(4 downto 0);
       alu_forwarding_one : OUT std_logic;
       mem_forwarding_one : OUT std_logic;
       alu_forwarding_two : OUT std_logic;
       mem_forwarding_two : OUT std_logic;
       alu_forwarding_value : OUT std_logic_vector(numbit - 1 downto 0);
       mem_forwarding_value : OUT std_logic_vector(numbit - 1 downto 0));
  end component;

  component CU_HARDWIRED
  port (-- ID Control Signals
        -- EX Control Signal
        --MUXA_CONTROL    : OUT std_logic;    -- MUX-A Sel
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
  end component;



  ----------------------------------------------------------------
  -- Signals Declaration
  ----------------------------------------------------------------

  -- Instruction Ram Bus signals
  signal toiramfrompc : std_logic_vector(RISC_BIT - 1 downto 0);
  signal toirfromiram : std_logic_vector(RISC_BIT - 1 downto 0);

  -- Data Ram Bus signals
  signal todramfromaluout : std_logic_vector(RISC_BIT - 1 downto 0);
  signal todramfrombreg : std_logic_vector(RISC_BIT - 1 downto 0);
  signal tolmdfromdram : std_logic_vector(RISC_BIT - 1 downto 0);
  signal address_dram : std_logic_vector(RISC_BIT - 1 downto 0);

  -- Control Unit Bus signals
  signal muxacontrolsignal : std_logic;
  signal muxbcontrolsignal : std_logic;
  signal dramwesignal : std_logic;
  signal dramresignal : std_logic;
  signal wbmuxselsignal : std_logic;
  signal rfwesignal : std_logic;
  signal aluopcodesignal : std_logic_vector(ALU_OPC_SIZE - 1 downto 0);

  --IR signal
  signal iroutsignal : std_logic_vector(RISC_BIT - 1 downto 0);



  begin  -- DLX
    ir_out <= iroutsignal;

    alu_out <= todramfromaluout;
    b_reg_out_ex <= todramfrombreg;
    memory_out <= tolmdfromdram;

    address_dram <= "0000000000000000" & todramfromaluout(15 downto 0);

    --MUXA_CONTROL <= muxacontrolsignal;
    MUXB_CONTROL <= muxbcontrolsignal;
    ALU_OPCODE <= aluopcodesignal;
    DRAM_WE <= dramwesignal;
    DRAM_RE <= dramresignal;
    WB_MUX_SEL <= wbmuxselsignal;
    RF_WE <= rfwesignal;

    IRAM_I : IRAM
    generic map(RAM_DEPTH,I_SIZE)
    port map(reset, toiramfrompc, toirfromiram);

    DRAM_I : DRAM
    generic map(RISC_BIT, RISC_BIT)
    port map(address_dram, todramfrombreg, dramwesignal, dramresignal, reset, tolmdfromdram, address_error);

    CONTROL_I : CU_HARDWIRED
    port map(--MUXA_CONTROL => muxacontrolsignal,
             MUXB_CONTROL => muxbcontrolsignal,
             ALU_OPCODE => aluopcodesignal,
             DRAM_WE => dramwesignal,
             DRAM_RE => dramresignal,
             WB_MUX_SEL => wbmuxselsignal,
             RF_WE => rfwesignal,
             OPCODE => iroutsignal(31 downto 26),
             FUNC => iroutsignal(10 downto 0),
             Clk => clk,
             Rst => reset);


    DATAPATH_I : DATAPATH
    generic map(RISC_BIT)
    port map(clk =>  clk,
             reset => reset,
             write_enable =>  rfwesignal,
             --mux_one_control => muxacontrolsignal,
             mux_two_control => muxbcontrolsignal,
             alu_control => aluopcodesignal,
             --to_pc => pc_in,
             to_ir => toirfromiram,
             to_mem_stage_reg => tolmdfromdram,
             wb_control => wbmuxselsignal,
             to_iram => toiramfrompc,
             npc_out_if => npc_out_if,
             npc_out_bpu => npc_out_bpu,
             ir_out => iroutsignal,
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
             rd_out_wb => rd_out_wb,
             alu_forwarding_one => alu_forwarding_one,
             mem_forwarding_one => mem_forwarding_one,
             alu_forwarding_two => alu_forwarding_two,
             mem_forwarding_two => mem_forwarding_two,
             alu_forwarding_value => alu_forwarding_value,
             mem_forwarding_value => mem_forwarding_value);


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
    for all : CU_HARDWIRED
      use configuration WORK.CFG_CONTROL_UNIT_HW;
    end for;
	end for;
end CFG_DLX;
