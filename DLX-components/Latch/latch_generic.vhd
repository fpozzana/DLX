-- ENABLE is active high, so if ENABLE is 1 the latch latches the input
-- if ENABLE is low the latch output the value previously stored
--test : tested OK, the component works as expected

library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all;

entity LATCH_GENERIC is
  generic (NBIT : integer := NumBitLatch);
  port(
    D : IN std_logic_vector(NBIT-1 downto 0);
    ENABLE : IN std_logic;
    Q : OUT std_logic_vector(NBIT-1 downto 0));
end LATCH_GENERIC;

architecture STRUCTURAL_ASYNC of LATCH_GENERIC is
  component LATCH
  port (	D :	IN	std_logic;
		      ENABLE : IN	std_logic;
		      Q :	OUT	std_logic);
  end component;

  begin
    LATCH_GENERATE_ASYNC : for i in 0 to NBIT-1 generate
      ULATCH : LATCH
      port map(D(i),ENABLE,Q(i));
    end generate LATCH_GENERATE_ASYNC;
end STRUCTURAL_ASYNC;


configuration CFG_LATCH_GENERIC_STRUCTURAL_ASYNC of LATCH_GENERIC is
  for STRUCTURAL_ASYNC
    for LATCH_GENERATE_ASYNC
      for all : LATCH
        use configuration WORK.CFG_LATCH_BEHAVIORAL;
      end for;
    end for;
  end for;
end CFG_LATCH_GENERIC_STRUCTURAL_ASYNC;
