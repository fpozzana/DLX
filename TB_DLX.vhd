library IEEE;
use IEEE.std_logic_1164.all;
use WORK.globals.all;
use WORK.all;

entity tb_dlx is
end tb_dlx;

architecture TEST of tb_dlx is
    constant SIZE_IR      : integer := 32;       -- Instruction Register Size
    constant SIZE_PC      : integer := 32;       -- Program Counter Size
    constant SIZE_ALU_OPC : integer := 6;        -- ALU Op Code Word Size in case explicit coding is used
    signal clk: std_logic := '0';
    signal reset: std_logic := '1';
    signal npc_out_if : std_logic_vector(RISC_BIT - 1 downto 0);
    signal ir_out : std_logic_vector(RISC_BIT - 1 downto 0);
    signal pc_in : std_logic_vector(RISC_BIT - 1 downto 0);
    signal npctopc : std_logic_vector(RISC_BIT - 1 downto 0);
    signal rd_out_id : std_logic_vector(4 downto 0);
    signal npc_out_id : std_logic_vector(RISC_BIT - 1 downto 0);
    signal a_reg_out : std_logic_vector(RISC_BIT - 1 downto 0);
    signal b_reg_out : std_logic_vector(RISC_BIT - 1 downto 0);
    signal imm_reg_out : std_logic_vector(RISC_BIT - 1 downto 0);
    signal alu_out : std_logic_vector(RISC_BIT - 1 downto 0);
    signal rd_out_ex : std_logic_vector(4 downto 0);
    signal b_reg_out_ex : std_logic_vector(RISC_BIT - 1 downto 0);
    signal memory_out : std_logic_vector(RISC_BIT - 1 downto 0);
    signal lmd_out : std_logic_vector(RISC_BIT - 1 downto 0);
    signal rd_out_mem : std_logic_vector(4 downto 0);
    signal alu_out_mem : std_logic_vector(RISC_BIT - 1 downto 0);
    signal rd_out_wb : std_logic_vector(4 downto 0);
    signal wb_stage_out : std_logic_vector(RISC_BIT - 1 downto 0);
    signal address_error : std_logic;

    component DLX
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
    end component;

begin
  -- instance of DLX
	--U1: DLX
  --generic Map (SIZE_IR, SIZE_PC)
	--port Map (clk, reset, pc_in, npc_out_if, ir_out, rd_out_id, npc_out_id, a_reg_out, b_reg_out, imm_reg_out, alu_out, rd_out_ex, b_reg_out_ex, lmd_out, rd_out_mem);

  --U1: DLX
  --generic map (SIZE_IR, SIZE_PC)
	--port map (clk, reset, pc_in, npc_out_if, ir_out, rd_out_id, npc_out_id, a_reg_out, b_reg_out, imm_reg_out, alu_out, rd_out_ex, b_reg_out_ex, memory_out, rd_out_mem, lmd_out, alu_out_mem, rd_out_wb, wb_stage_out);

  U1 : DLX
  generic map(SIZE_IR, SIZE_PC)
  port map(clk => clk,
           reset => reset,
           pc_in => pc_in,
           npc_out_if => npc_out_if,
           ir_out => ir_out,
           rd_out_id => rd_out_id,
           npc_out_id => npc_out_id,
           a_reg_out => a_reg_out,
           b_reg_out => b_reg_out,
           imm_reg_out => imm_reg_out,
           alu_out => alu_out,
           rd_out_ex => rd_out_ex,
           b_reg_out_ex => b_reg_out_ex,
           memory_out => memory_out,
           rd_out_mem => rd_out_mem,
           lmd_out => lmd_out,
           alu_out_mem => alu_out_mem,
           rd_out_wb => rd_out_wb,
           wb_stage_out => wb_stage_out,
           address_error => address_error);

  npctopc <= npc_out_if;
  pc_in <= npctopc;

  PCLOCK : process(clk)
	begin
		clk <= not(clk) after 1 ns;
	end process;

	reset <= '0' after 4 ns;


end TEST;

-------------------------------

configuration CFG_TB_DLX of tb_dlx  is
	for TEST
    for U1 : DLX
      use configuration WORK.CFG_DLX;
    end for;
	end for;
end CFG_TB_DLX;
