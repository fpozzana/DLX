library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- we need a conversion to unsigned
use WORK.constants.all;

entity TB_RCA_GENERIC is
end TB_RCA_GENERIC;

architecture TEST of TB_RCA_GENERIC is

  --constant num_bit: integer := NumBitRCA;
  constant num_bit: integer := 4;

  component RCA_GENERIC
  generic (NBIT : integer := NumBitRCA);
  port (A:	IN	std_logic_vector(NBIT-1 downto 0);
        B:	IN	std_logic_vector(NBIT-1 downto 0);
        Ci:	IN	std_logic;
        S:	OUT	std_logic_vector(NBIT-1 downto 0);
        Co:	OUT	std_logic);
  end component;


  constant Period: time := 1 ns;
  signal A, B, S : std_logic_vector(num_bit-1 downto 0);
  signal Ci, Co : std_logic;

begin

  UADDER: RCA_GENERIC
	   generic map (num_bit)
	   port map (A, B, Ci, S, Co);

  --STIMULUS1: process
  --begin
    --A <= "00001000000101010000100000010101";
    --B <= "00000011001000010000001100100001";
    --Ci <= '0';
    --wait for 2 * PERIOD;
    --Ci <= '1';
    --A <= "10001000000101011000100000010101";
    --B <= "11000011001000011100001100100001";
    --wait for (65 * PERIOD);
  --end process STIMULUS1;

  A <= "0111";
  B <= "0100";
  Ci <= '0', '1' after 5 ns;

end TEST;

configuration CFG_TB_RCA_GENERIC of TB_RCA_GENERIC is
  for TEST
    for UADDER: RCA_GENERIC
      use configuration WORK.CFG_ADDERSUB_GENERIC;
    end for;
  end for;
end CFG_TB_RCA_GENERIC;
