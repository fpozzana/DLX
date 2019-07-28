library ieee;
use ieee.std_logic_1164.all;
use WORK.constants.all;

entity FETCH_STAGE is
  generic(numbit : integer := RISC_BIT);
  port(program_counter : IN std_logic_vector(numbit-1 downto 0);
       clk : IN std_logic;
       reset : IN std_logic;
       npc_out : OUT std_logic_vector(numbit-1 downto 0);
       instruction_reg_out : OUT std_logic_vector(numbit-1 downto 0));
end FETCH_STAGE;

architecture STRUCTURAL of FETCH_STAGE is
  signal pc_reg_out : std_logic_vector(numbit-1 downto 0);
  signal adder_out : std_logic_vector(numbit-1 downto 0);
  signal instruction_mem_out : std_logic_vector(numbit-1 downto 0);
  signal plus_four : std_logic_vector(numbit-1 downto 0) := ("00000000000000000000000000000100");

  component REGISTER_GENERIC
  generic (NBIT : integer := NumBitRegister);
  port(D : IN std_logic_vector(NBIT-1 downto 0);
       CK : IN std_logic;
       RESET : IN std_logic;
       Q : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  component IRAM
  generic(RAM_DEPTH : integer := RAM_DEPTH;
          I_SIZE : integer := I_SIZE);
  port(Rst  : in  std_logic;
       Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
       Dout : out std_logic_vector(I_SIZE - 1 downto 0));
  end component;

  component RCA_GENERIC
  generic (NBIT : integer := NumBitRCA);
	port (A:	IN	std_logic_vector(NBIT-1 downto 0);
			  B:	IN	std_logic_vector(NBIT-1 downto 0);
				Ci:	IN	std_logic;
				S:	OUT	std_logic_vector(NBIT-1 downto 0);
				Co:	OUT	std_logic);
  end component;

  component LATCH_GENERIC
  generic (NBIT : integer := NumBitLatch);
  port(
    D : IN std_logic_vector(NBIT-1 downto 0);
    ENABLE : IN std_logic;
    Q : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  begin
    PC : REGISTER_GENERIC
    generic map(numbit)
    port map(program_counter,clk,reset,pc_reg_out);

    IM : IRAM
    generic map(RAM_DEPTH,I_SIZE)
    port map(reset,pc_reg_out,instruction_mem_out);

    RCA : RCA_GENERIC
    generic map(numbit)
    port map(pc_reg_out,plus_four,'0',adder_out,open);

    NPC : LATCH_GENERIC
    generic map(numbit)
    port map(adder_out,'1',npc_out);

    IR : LATCH_GENERIC
    generic map(numbit)
    port map(instruction_mem_out,'1',instruction_reg_out);

end STRUCTURAL;

configuration CFG_FETCH_STAGE_STRUCTURAL of FETCH_STAGE is
	for STRUCTURAL
    for all : REGISTER_GENERIC
		  use configuration WORK.CFG_REGISTER_GENERIC_STRUCTURAL_SYNC;
    end for;
    for all : RCA_GENERIC
		  use configuration WORK.CFG_RCA_GENERIC;
    end for;
    for all : IRAM
		  use configuration WORK.CFG_IRAM_BEHAVIORAL;
    end for;
    for all : LATCH_GENERIC
      use configuration WORK.CFG_LATCH_GENERIC_STRUCTURAL_ASYNC;
    end for;
	end for;
end CFG_FETCH_STAGE_STRUCTURAL;
