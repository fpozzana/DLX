library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity TB_COMPARATOR_GENERIC is
end TB_COMPARATOR_GENERIC;

architecture TEST of TB_COMPARATOR_GENERIC is
  constant numbit : integer := 4;

  signal A : std_logic_vector(numbit-1 downto 0);
  signal B : std_logic_vector(numbit-1 downto 0);
  signal less : std_logic;
  signal more : std_logic;
  signal equal : std_logic;

  component COMPARATOR_GENERIC
  generic(numbit : integer := NumBitComparator);
  port(A : IN std_logic_vector(numbit-1 downto 0);
       B : IN std_logic_vector(numbit-1 downto 0);
       less : OUT std_logic;
       more : OUT std_logic;
       equal : OUT std_logic);
  end component;

  begin
    DUT : COMPARATOR_GENERIC
    generic map(numbit)
    port map(A,B,less,more,equal);

    A <= "0000", "1000" after 5 ns, "0111" after 10 ns;
    B <= "0000", "0111" after 5 ns, "1000" after 10 ns;

end TEST;

configuration CFG_TB_COMPARATOR_GENERIC of TB_COMPARATOR_GENERIC is
  for TEST
    for DUT: COMPARATOR_GENERIC
      use configuration WORK.CFG_COMPARATOR_GENERIC;
    end for;
  end for;
end CFG_TB_COMPARATOR_GENERIC;
