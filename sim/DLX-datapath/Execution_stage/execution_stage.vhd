--test : tested OK, the component works as expected
--during the risign clock the register samlples according to what
--has been provided before the rise of clock
--eg: at 2 ns clock rises, the sampled value which goes into execution stage out
--depends on which inputs the execution stage had right before the
--2 ns mark, even if at 2 ns the inputs change

library ieee;
use ieee.std_logic_1164.all;
use WORK.globals.all;

entity EXECUTION_STAGE is
  generic(numbit : integer := RISC_BIT);
  port(alu_forwarding_one : IN std_logic;
       mem_forwarding_one : IN std_logic;
       alu_forwarding_two : IN std_logic;
       mem_forwarding_two : IN std_logic;
       alu_forwarding_value : IN std_logic_vector(numbit - 1 downto 0);
       mem_forwarding_value : IN std_logic_vector(numbit - 1 downto 0);
       npc_in : IN std_logic_vector(numbit-1 downto 0);
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
end EXECUTION_STAGE;

architecture STRUCTURAL of EXECUTION_STAGE is

  signal mux_one_out_rf : std_logic_vector(numbit-1 downto 0);
  signal mux_one_out_mem_forwarding : std_logic_vector(numbit-1 downto 0);
  signal mux_one_out_alu_forwarding : std_logic_vector(numbit-1 downto 0);
  signal mux_two_out_rf : std_logic_vector(numbit-1 downto 0);
  signal mux_two_out_mem_forwarding : std_logic_vector(numbit-1 downto 0);
  signal mux_two_out_alu_forwarding : std_logic_vector(numbit-1 downto 0);
  signal alu_out : std_logic_vector(numbit-1 downto 0);

  component MUX21_GENERIC
  generic (NBIT : integer := NumBitMux21);
  port(A : IN std_logic_vector(NBIT-1 downto 0);
       B : IN std_logic_vector(NBIT-1 downto 0);
       SEL : IN std_logic;
       Y : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  component REGISTER_GENERIC
  generic (NBIT : integer := NumBitRegister);
  port(
    D : IN std_logic_vector(NBIT-1 downto 0);
    CK : IN std_logic;
    RESET : IN std_logic;
    Q : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  component ALU_BEHAVIORAL
  generic (NBIT : integer := NumBitALU);
  port 	 ( FUNC: IN std_logic_vector(3 downto 0);
           DATA1, DATA2: IN std_logic_vector(NBIT-1 downto 0);
           OUTALU: OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  begin

    MUX_ONE_RF : MUX21_GENERIC
    generic map(numbit)
    port map(npc_in,a_reg_in,mux_one_control,mux_one_out_rf);

    MUX_ONE_MEM : MUX21_GENERIC
    generic map(numbit)
    port map(mux_one_out_rf,mem_forwarding_value,mem_forwarding_one,mux_one_out_mem_forwarding);

    MUX_ONE_ALU : MUX21_GENERIC
    generic map(numbit)
    port map(mux_one_out_mem_forwarding,alu_forwarding_value,alu_forwarding_one,mux_one_out_alu_forwarding);

    MUX_TWO_RF : MUX21_GENERIC
    generic map(numbit)
    port map(b_reg_in,imm_reg_in,mux_two_control,mux_two_out_rf);

    MUX_TWO_MEM : MUX21_GENERIC
    generic map(numbit)
    port map(mux_two_out_rf,mem_forwarding_value,mem_forwarding_two,mux_two_out_mem_forwarding);

    MUX_TWO_ALU : MUX21_GENERIC
    generic map(numbit)
    port map(mux_two_out_mem_forwarding,alu_forwarding_value,alu_forwarding_two,mux_two_out_alu_forwarding);

    ALU : ALU_BEHAVIORAL
    generic map(numbit)
    port map(alu_control,mux_one_out_alu_forwarding,mux_two_out_alu_forwarding,alu_out);

    REG1 : REGISTER_GENERIC
    generic map(numbit)
    port map(alu_out,clk,reset,execution_stage_out);

    REG3 : REGISTER_GENERIC
    generic map(numbit)
    port map(b_reg_in,clk,reset,b_reg_out);

    REG4 : REGISTER_GENERIC
    generic map(5)
    port map(rd_reg_in,clk,reset,rd_reg_out);

end STRUCTURAL;

configuration CFG_EXECUTION_STAGE_STRUCTURAL of EXECUTION_STAGE is
	for STRUCTURAL
    for all : MUX21_GENERIC
		  use configuration WORK.CFG_MUX21_GENERIC_STRUCTURAL;
    end for;
    for all : ALU_BEHAVIORAL
		  use configuration WORK.CFG_ALU_BEHAVIORAL;
    end for;
    for all : REGISTER_GENERIC
		  use configuration WORK.CFG_REGISTER_GENERIC_STRUCTURAL_SYNC;
    end for;
	end for;
end CFG_EXECUTION_STAGE_STRUCTURAL;
