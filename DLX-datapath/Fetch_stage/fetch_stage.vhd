library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.globals.all;

entity FETCH_STAGE is
  generic(numbit : integer := RISC_BIT);
  port(program_counter : IN std_logic_vector(numbit-1 downto 0);
       to_IR : IN std_logic_vector(numbit-1 downto 0);
       clk : IN std_logic;
       reset : IN std_logic;
       to_IRAM : OUT std_logic_vector(numbit - 1 downto 0);
       npc_out : OUT std_logic_vector(numbit-1 downto 0);
       instruction_reg_out : OUT std_logic_vector(numbit-1 downto 0));
end FETCH_STAGE;

architecture STRUCTURAL of FETCH_STAGE is
  signal pc_reg_out : std_logic_vector(numbit-1 downto 0);
  signal adder_out : std_logic_vector(numbit-1 downto 0);
  signal plus_four : std_logic_vector(numbit-1 downto 0) := ("00000000000000000000000000000100");

  component REGISTER_GENERIC
  generic (NBIT : integer := NumBitRegister);
  port(D : IN std_logic_vector(NBIT-1 downto 0);
       CK : IN std_logic;
       RESET : IN std_logic;
       Q : OUT std_logic_vector(NBIT-1 downto 0));
  end component;
  
  component LATCH_GENERIC
  generic (NBIT : integer := NumBitLatch);
  port(
    D : IN std_logic_vector(NBIT-1 downto 0);
    ENABLE : IN std_logic;
    Q : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  signal tomem : std_logic_vector(numbit - 1 downto 0);

  begin

    PC : LATCH_GENERIC
    generic map(numbit)
    port map(program_counter,'1',pc_reg_out);

    NPC : REGISTER_GENERIC
    generic map(numbit)
    port map(adder_out,clk,reset,npc_out);

    IR : REGISTER_GENERIC
    generic map(numbit)
    port map(to_IR,clk,reset,instruction_reg_out);

    tomem <= "00" & pc_reg_out(31 downto 2);
    adder_out <= pc_reg_out + plus_four;
    to_IRAM <= tomem;

end STRUCTURAL;

configuration CFG_FETCH_STAGE of FETCH_STAGE is
	for STRUCTURAL
    for all : REGISTER_GENERIC
		  use configuration WORK.CFG_REGISTER_GENERIC_STRUCTURAL_SYNC;
    end for;
    for all : LATCH_GENERIC
      use configuration WORK.CFG_LATCH_GENERIC_STRUCTURAL_ASYNC;
    end for;
	end for;
end CFG_FETCH_STAGE;
