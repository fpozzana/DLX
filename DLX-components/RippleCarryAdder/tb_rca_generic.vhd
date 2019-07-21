library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- we need a conversion to unsigned
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity TB_RCA_GENERIC is
end TB_RCA_GENERIC;

architecture TEST of TB_RCA_GENERIC is

  --constant NumBit : integer := NumBitRCA;
  constant NumBit : integer := 4;

  component RCA_GENERIC
  generic (NBIT : integer := NumBitRCA);
  port (A:	IN	std_logic_vector(NBIT-1 downto 0);
        B:	IN	std_logic_vector(NBIT-1 downto 0);
        Ci:	IN	std_logic;
        S:	OUT	std_logic_vector(NBIT-1 downto 0);
        Co:	OUT	std_logic);
  end component;

  --  input
  signal A : std_logic_vector(NumBit-1 downto 0) := (others => '0');
  signal B : std_logic_vector(NumBit-1 downto 0) := (others => '0');
  signal Ci : std_logic := '0';

  -- output
  signal S : std_logic_vector(NumBit-1 downto 0);
  signal Co : std_logic;

begin

  A <= "0011", "1110" after 2 ns, "0110" after 4 ns, "0111" after 6 ns, "1110" after 8 ns, "1111" after 10 ns, "0011" after 12 ns, "1110" after 14 ns, "0110" after 16 ns, "0111" after 18 ns, "1110" after 20 ns, "1111" after 22 ns;
  B <= "1001", "1101" after 2 ns, "1010" after 4 ns, "1000" after 6 ns, "0001" after 8 ns, "0110" after 10 ns, "1001" after 12 ns, "1101" after 14 ns, "1010" after 16 ns, "1000" after 18 ns, "0001" after 20 ns, "0110" after 22 ns;
  Ci <= '0', '1' after 10 ns;

  UADDER: RCA_GENERIC
     generic map (NumBit)
     port map (A, B, Ci, S, Co);


end TEST;

configuration CFG_TB_RCA_GENERIC of TB_RCA_GENERIC is
  for TEST
    for UADDER: RCA_GENERIC
      use configuration WORK.CFG_ADDERSUB_GENERIC;
    end for;
  end for;
end CFG_TB_RCA_GENERIC;
