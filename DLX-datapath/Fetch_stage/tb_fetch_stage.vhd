--connected the npc out to pc in to simulate a program running
--unit works as expected

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.globals.all;

entity TB_FETCH_STAGE is
end TB_FETCH_STAGE;

architecture TEST of TB_FETCH_STAGE is

  constant NBIT : integer := RISC_BIT;
  signal TB_PC : std_logic_vector(NBIT-1 downto 0) := (others => '0');
  signal TB_TO_IRAM : std_logic_vector(NBIT-1 downto 0);
  signal TB_TO_IR : std_logic_vector(NBIT-1 downto 0) := (others => '0');
  signal TB_NPC_OUT : std_logic_vector(NBIT-1 downto 0);
  signal TB_INSTRUCTION_REG_OUT : std_logic_vector(NBIT-1 downto 0);
  signal TB_RESET : std_logic := '1';
  signal TB_CLOCK : std_logic := '0';
  signal npctopc : std_logic_vector(NBIT - 1 downto 0);

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

  begin
    DUT : FETCH_STAGE
    generic map(NBIT)
    port map(TB_PC,TB_TO_IR,TB_CLOCK,TB_RESET,TB_TO_IRAM,TB_NPC_OUT,TB_INSTRUCTION_REG_OUT);

    npctopc <= TB_NPC_OUT;
    TB_PC <= npctopc;

    TB_TO_IR <= (others => '1') after 2 ns;
    TB_RESET <= '1', '0' after 3 ns;

    PCLOCK : process(TB_CLOCK)
    begin
      TB_CLOCK <= not(TB_CLOCK) after 1 ns;
    end process;

end TEST;

configuration CFG_TB_FETCH_STAGE of TB_FETCH_STAGE is
  for TEST
    for DUT : FETCH_STAGE
      use configuration WORK.CFG_FETCH_STAGE;
    end for;
  end for;
end CFG_TB_FETCH_STAGE;
