library ieee;
use ieee.std_logic_1164.all;
use WORK.constants.all;

entity EXECUTION_STAGE is
  generic(numbit : integer := RISC_BIT);
  port(npc_in : IN std_logic_vector(numbit-1 downto 0);
       a_reg_in : IN std_logic_vector(numbit-1 downto 0);
       b_reg_in : IN std_logic_vector(numbit-1 downto 0);
       imm_reg_in : IN std_logic_vector(numbit-1 downto 0);
       mux_one_control : IN std_logic;
       mux_two_control : IN std_logic;
       alu_control : IN std_logic_vector(3 downto 0);
       clk : IN std_logic;
       reset : IN std_logic;
       execution_stage_out : OUT std_logic_vector(numbit-1 downto 0));
end EXECUTION_STAGE;

architecture STRUCTURAL of EXECUTION_STAGE is

  signal mux_one_out : std_logic_vector(numbit-1 downto 0);
  signal mux_two_out : std_logic_vector(numbit-1 downto 0);
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

    MUX_ONE : MUX21_GENERIC
    generic map(numbit)
    port map(npc_in,a_reg_in,mux_one_control,mux_one_out);

    MUX_TWO : MUX21_GENERIC
    generic map(numbit)
    port map(b_reg_in,imm_reg_in,mux_two_control,mux_two_out);

    ALU : ALU_BEHAVIORAL
    generic map(numbit)
    port map(alu_control,mux_one_out,mux_two_out,alu_out);

    REG : REGISTER_GENERIC
    generic map(numbit)
    port map(alu_out,clk,reset,execution_stage_out);

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
