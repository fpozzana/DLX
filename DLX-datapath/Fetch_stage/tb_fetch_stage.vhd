library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity TB_FETCH_STAGE is
end TB_FETCH_STAGE;

architecture TEST of TB_FETCH_STAGE is

  constant NBIT : integer := RISC_BIT;
  signal TB_PC : std_logic_vector(NBIT-1 downto 0) := (others => '0');
  signal TB_NPC_OUT : std_logic_vector(NBIT-1 downto 0);
  signal TB_INSTRUCTION_REG_OUT : std_logic_vector(NBIT-1 downto 0);
  signal TB_RESET : std_logic := '0';
  signal TB_CLOCK : std_logic := '0';

  component FETCH_STAGE
  generic(numbit : integer := RISC_BIT);
  port(program_counter : IN std_logic_vector(numbit-1 downto 0);
       clk : IN std_logic;
       reset : IN std_logic;
       npc_out : OUT std_logic_vector(numbit-1 downto 0);
       instruction_reg_out : OUT std_logic_vector(numbit-1 downto 0));
  end component;

  begin
    DUT : FETCH_STAGE
    generic map(NBIT)
    port map(TB_PC,TB_CLOCK,TB_RESET,TB_NPC_OUT,TB_INSTRUCTION_REG_OUT);

    test: process
    begin
      wait for 1 ns;
      NumROW : for i in 0 to RAM_DEPTH loop
        wait for 2 ns;
        TB_PC <= TB_PC + '1';
      end loop NumROW ;
    end process test;

    TB_RESET <= '0', '1' after 39 ns;

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
