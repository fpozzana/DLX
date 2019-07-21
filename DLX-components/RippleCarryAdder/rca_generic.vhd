--The RCA has two architectures : a normal RCA capable only of ADD and an ADDSUB architecture, capable of making ADD/SUB.
--For the second architecture the driving signal for the ADD/SUB is the Ci : for an ADD Ci <= '0' and for a SUB Ci <= '1'

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity RCA_GENERIC is
	generic (NBIT : integer := NumBitRCA);
	port (A:	IN	std_logic_vector(NBIT-1 downto 0);
			  B:	IN	std_logic_vector(NBIT-1 downto 0);
				Ci:	IN	std_logic;
				S:	OUT	std_logic_vector(NBIT-1 downto 0);
				Co:	OUT	std_logic);
end RCA_GENERIC;

architecture STRUCTURAL of RCA_GENERIC is
  signal STMP : std_logic_vector(NBIT-1 downto 0);
  signal CTMP : std_logic_vector(NBIT downto 0);

  component FA
	port (A:	IN	std_logic;
		    B:	IN	std_logic;
		    Ci:	IN	std_logic;
		    S:	OUT	std_logic;
		    Co:	OUT	std_logic);
  end component;

begin

  CTMP(0) <= Ci;
  S <= STMP;
  Co <= CTMP(NBIT);

  ADDER1: for I in 1 to NBIT generate
    FAI : FA
	  Port Map (A(I-1), B(I-1), CTMP(I-1), STMP(I-1), CTMP(I));
  end generate;

end STRUCTURAL;

architecture ADDERSUB of RCA_GENERIC is
  signal STMP : std_logic_vector(NBIT-1 downto 0);
  signal CTMP : std_logic_vector(NBIT downto 0);
	signal BTOADD : std_logic_vector(NBIT-1 downto 0);

  component FA
	port (A:	IN	std_logic;
		    B:	IN	std_logic;
		    Ci:	IN	std_logic;
		    S:	OUT	std_logic;
		    Co:	OUT	std_logic);
  end component;

	component XORMASK
	generic(numbit : integer := NumBitRCA);
  port(operand : IN std_logic_vector(numbit-1 downto 0);
       carry : IN std_logic;
       result : OUT std_logic_vector(numbit-1 downto 0));
	end component;

begin

  CTMP(0) <= Ci;
  S <= STMP;
  Co <= CTMP(NBIT);

	XORMASKIN : XORMASK
	generic map(NBIT)
	port map(B,Ci,BTOADD);

  ADDER1: for I in 1 to NBIT generate
    FAI : FA
	  Port Map (A(I-1), BTOADD(I-1), CTMP(I-1), STMP(I-1), CTMP(I));
  end generate;

end ADDERSUB;

configuration CFG_RCA_GENERIC of RCA_GENERIC is
  for STRUCTURAL
    for ADDER1
      for all : FA
        use configuration WORK.CFG_FA_BEHAVIORAL;
      end for;
    end for;
  end for;
end CFG_RCA_GENERIC;

configuration CFG_ADDERSUB_GENERIC of RCA_GENERIC is
  for ADDERSUB
		for all : XORMASK
			use configuration WORK.CFG_XOR_MASK_GENERIC;
		end for;
    for ADDER1
      for all : FA
        use configuration WORK.CFG_FA_BEHAVIORAL;
      end for;
    end for;
  end for;
end CFG_ADDERSUB_GENERIC;
