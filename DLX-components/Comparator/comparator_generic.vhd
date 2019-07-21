library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity COMPARATOR_GENERIC is
  generic(numbit : integer := NumBitComparator);
  port(A : IN std_logic_vector(numbit-1 downto 0);
       B : IN std_logic_vector(numbit-1 downto 0);
       less : OUT std_logic;
       more : OUT std_logic;
       equal : OUT std_logic);
end COMPARATOR_GENERIC;

architecture MIXED of COMPARATOR_GENERIC is
  signal norsum : std_logic;
  signal carry : std_logic;
  signal notcarry : std_logic;
  signal sumtemp : std_logic_vector(numbit-1 downto 0);

  component RCA_GENERIC
  generic (NBIT : integer := NumBitRCA);
	port (A:	IN	std_logic_vector(NBIT-1 downto 0);
			  B:	IN	std_logic_vector(NBIT-1 downto 0);
				Ci:	IN	std_logic;
				S:	OUT	std_logic_vector(NBIT-1 downto 0);
				Co:	OUT	std_logic);
  end component;

  component NOR_GENERIC
  generic(numbit: positive := NumBitComparator);
  port(inp : IN std_logic_vector(numbit-1 downto 0);
       outp : OUT std_logic);
  end component;

  begin
    RCA : RCA_GENERIC                             --always A - B
    generic map(numbit)
    port map(A,B,'1',sumtemp,carry);

    NORIN : NOR_GENERIC
    generic map(numbit)
    port map(sumtemp,norsum);

    notcarry <= not carry;

    less <= notcarry;
    equal <= norsum;
    more <= carry AND (not(norsum));

end MIXED;

configuration CFG_COMPARATOR_GENERIC of COMPARATOR_GENERIC is
  for MIXED
		for all : RCA_GENERIC
			use configuration WORK.CFG_ADDERSUB_GENERIC;
		end for;
    for all : NOR_GENERIC
      use configuration WORK.CFG_NOR_GENERIC;
    end for;
  end for;
end CFG_COMPARATOR_GENERIC;
