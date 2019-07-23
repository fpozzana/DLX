library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all;

entity TB_LATCH_GENERIC is
end TB_LATCH_GENERIC;

architecture TEST of TB_LATCH_GENERIC is

  constant NBIT : integer := NumBitRegister;
  signal D_IN : std_logic_vector(NBIT-1 downto 0) := "00000000000000000000000000000000";
  signal ENABLE_IN : std_logic := '1';
  signal Q_OUT : std_logic_vector(NBIT-1 downto 0);

  component LATCH_GENERIC
  generic (NBIT : integer := NumBitLatch);
  port(
    D : IN std_logic_vector(NBIT-1 downto 0);
    ENABLE : IN std_logic;
    Q : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  begin

    DUT : LATCH_GENERIC
    generic map(NBIT)
    port map(D_IN,ENABLE_IN,Q_OUT);

    D_IN <= "10001000100010001000100010001000", "00010001000100010001000100010001" after 5 ns;
    ENABLE_IN <= '1','0' after 10 ns,'1' after 15 ns,'0' after 18.5 ns;

  end TEST;

configuration CFG_TB_LATCH_GENERIC of TB_LATCH_GENERIC is
  for TEST
    for DUT : LATCH_GENERIC
      use configuration WORK.CFG_LATCH_GENERIC_STRUCTURAL_ASYNC;
    end for;
  end for;
end CFG_TB_LATCH_GENERIC;
