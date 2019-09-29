library ieee;
use ieee.std_logic_1164.all;
use WORK.constants.all;

entity DATAPATH is
  generic(numbit : integer := RISC_BIT);
  port(clk : IN std_logic;
       reset : IN std_logic;
       enable : IN std_logic;
       write : IN std_logic;
       read_one : IN std_logic;
       read_two : IN std_logic;
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
       wb_stage_out : OUT std_logic_vector(numbit - 1 downto 0);
       rd_out_wb : OUT std_logic_vector(4 downto 0));
end DATAPATH;

architecture STRUCTURAL of DATAPATH is
  signal iroutsignal : std_logic_vector(numbit - 1 downto 0);
  signal npcoutifsignal : std_logic_vector(numbit - 1 downto 0);

  signal rdoutidsignal : std_logic_vector(4 downto 0);
  signal npcoutidsignal : std_logic_vector(numbit - 1 downto 0);
  signal aregsignal : std_logic_vector(numbit - 1 downto 0);
  signal bregsignal : std_logic_vector(numbit - 1 downto 0);
  signal immregsignal : std_logic_vector(numbit - 1 downto 0);

  signal rdoutexsignal : std_logic_vector(4 downto 0);
  signal aluoutsignal : std_logic_vector(numbit - 1 downto 0);

  signal memstageoutsignal : std_logic_vector(numbit - 1 downto 0);
  signal rdoutmemsignal : std_logic_vector(4 downto 0);

  signal rdoutwbsignal : std_logic_vector(4 downto 0);
  signal wbstageoutsignal : std_logic_vector(numbit - 1 downto 0);

  component FETCH_STAGE
  generic(numbit : integer := RISC_BIT);
  port(program_counter : IN std_logic_vector(numbit-1 downto 0);
       to_IR : IN std_logic_vector(numbit-1 downto 0);
       clk : IN std_logic;
       reset : IN std_logic;
       to_IRAM : OUT std_logic_vector(numbit - 1 downto 0);
       npc_out : OUT std_logic_vector(numbit-1 downto 0);
       instruction_reg_out : OUT std_logic_vector(numbit-1 downto 0));
  end component;

  component DECODE_STAGE
  generic(numbit : integer := RISC_BIT);
  port(IR_IN : IN std_logic_vector(numbit-1 downto 0);
       WB_STAGE_IN : IN std_logic_vector(numbit-1 downto 0);
       NPC_IN : IN std_logic_vector(numbit-1 downto 0);
       RD_IN : IN std_logic_vector(4 downto 0);
       CLK : IN std_logic;
       RESET : IN std_logic;
       ENABLE : IN std_logic;
       WRITE : IN std_logic;
       READ_ONE : IN std_logic;
       READ_TWO : IN std_logic;
       RD_OUT : OUT std_logic_vector(4 downto 0);
       NPC_OUT : OUT std_logic_vector(numbit-1 downto 0);
       A_REG_OUT : OUT std_logic_vector(numbit-1 downto 0);
       B_REG_OUT : OUT std_logic_vector(numbit-1 downto 0);
       IMM_REG_OUT : OUT std_logic_vector(numbit-1 downto 0));
  end component;

  component EXECUTION_STAGE
  generic(numbit : integer := RISC_BIT);
  port(npc_in : IN std_logic_vector(numbit-1 downto 0);
       a_reg_in : IN std_logic_vector(numbit-1 downto 0);
       b_reg_in : IN std_logic_vector(numbit-1 downto 0);
       imm_reg_in : IN std_logic_vector(numbit-1 downto 0);
       rd_reg_in : IN std_logic_vector(4 downto 0);
       mux_one_control : IN std_logic;
       mux_two_control : IN std_logic;
       alu_control : IN std_logic_vector(3 downto 0);
       clk : IN std_logic;
       reset : IN std_logic;
       execution_stage_out : OUT std_logic_vector(numbit-1 downto 0);
       b_reg_out : OUT std_logic_vector(numbit-1 downto 0);
       rd_reg_out : OUT std_logic_vector(4 downto 0));
  end component;

  component MEMORY_STAGE
  generic(numbit : integer := RISC_BIT);
  port(rd_reg_in : IN std_logic_vector(4 downto 0);
       reset : IN std_logic;
       clk : IN std_logic;
       to_mem_stage_reg : IN std_logic_vector(numbit - 1 downto 0);
       rd_reg_out : OUT std_logic_vector(4 downto 0);
       memory_stage_out : OUT std_logic_vector(numbit-1 downto 0));
  end component;

  component WRITE_BACK_STAGE
  generic(N : integer := RISC_BIT);
  port(LMD : IN std_logic_vector(N-1 downto 0);
      ALUOUT : IN std_logic_vector(N-1 downto 0);
      RD_IN : IN std_logic_vector(4 downto 0);
      CONTROL : IN std_logic;
      CLOCK : IN std_logic;
      RESET : IN std_logic;
      RD_OUT : OUT std_logic_vector(4 downto 0);
      WB_OUT : OUT std_logic_vector(N-1 downto 0));
  end component;

  begin
    npc_out_if <= npcoutifsignal;
    ir_out <= iroutsignal;

    rd_out_id <= rdoutidsignal;
    npc_out_id <= npcoutidsignal;
    a_reg_out <= aregsignal;
    b_reg_out <= bregsignal;
    imm_reg_out <= immregsignal;

    rd_out_ex <= rdoutexsignal;
    alu_out <= aluoutsignal;

    rd_out_mem <= rdoutmemsignal;
    memory_stage_out <= memstageoutsignal;

    rd_out_wb <= rdoutwbsignal;
    wb_stage_out <= wbstageoutsignal;

    FETCH : FETCH_STAGE
    generic map(numbit)
    port map(to_pc, to_ir, clk, reset, to_iram, npcoutifsignal, iroutsignal);

    DECODE : DECODE_STAGE
    generic map(numbit)
    port map(iroutsignal, wbstageoutsignal, npcoutifsignal, rdoutwbsignal, clk, reset, enable, write, read_one, read_two, rdoutidsignal, npcoutidsignal, aregsignal, bregsignal, immregsignal);

    EXECUTE : EXECUTION_STAGE
    generic map(numbit)
    port map(npcoutidsignal, aregsignal, bregsignal, immregsignal, rdoutidsignal, mux_one_control, mux_two_control, alu_control, clk, reset, aluoutsignal, b_reg_out_ex, rdoutexsignal);

    MEMORY : MEMORY_STAGE
    generic map(numbit)
    port map(rdoutexsignal, reset, clk, to_mem_stage_reg, rdoutmemsignal, memstageoutsignal);

    WRITEBACK : WRITE_BACK_STAGE
    generic map(numbit)
    port map(memstageoutsignal, aluoutsignal, rdoutmemsignal, wb_control, clk, reset, rdoutwbsignal, wbstageoutsignal);

end STRUCTURAL;

configuration CFG_DATAPATH of DATAPATH is
	for STRUCTURAL
    for all : FETCH_STAGE
		  use configuration WORK.CFG_FETCH_STAGE;
    end for;
    for all : DECODE_STAGE
      use configuration WORK.CFG_DECODE_STAGE_STRUCTURAL;
    end for;
    for all : EXECUTION_STAGE
      use configuration WORK.CFG_EXECUTION_STAGE_STRUCTURAL;
    end for;
    for all : MEMORY_STAGE
      use configuration WORK.CFG_MEMORY_STAGE_STRUCTURAL;
    end for;
    for all : WRITE_BACK_STAGE
      use configuration WORK.CFG_WRITE_BACK_STAGE;
    end for;
	end for;
end CFG_DATAPATH;
