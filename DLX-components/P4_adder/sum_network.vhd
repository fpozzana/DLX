--sum network for the P4 adder

library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all;

entity SUM_NETWORK is
  generic(MBIT : integer := NumBitP4Distance;
          NBIT : integer := NumBitP4Data);
  port(a_in : IN std_logic_vector(NBIT-1 downto 0);
       b_in : IN std_logic_vector(NBIT-1 downto 0);
       c_in_vector : IN std_logic_vector(NBIT/MBIT-1 downto 0);
       sum_out : OUT std_logic_vector(NBIT-1 downto 0));
end SUM_NETWORK;

architecture STRUCTURAL of SUM_NETWORK is
  signal sum_zero : std_logic_vector(NBIT-1 downto 0);
  signal sum_one : std_logic_vector(NBIT-1 downto 0);

  component RCA_GENERIC
  generic (NBIT : integer := NumBitRCA);
	port (A:	IN	std_logic_vector(NBIT-1 downto 0);
			  B:	IN	std_logic_vector(NBIT-1 downto 0);
				Ci:	IN	std_logic;
				S:	OUT	std_logic_vector(NBIT-1 downto 0);
				Co:	OUT	std_logic);
  end component;

  component MUX21_GENERIC
  generic (NBIT : integer := NumBitMux21);
  port(A : IN std_logic_vector(NBIT-1 downto 0);
       B : IN std_logic_vector(NBIT-1 downto 0);
       SEL : IN std_logic;
       Y : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  begin
    SUM_BLOCK : for i in 0  to NumBitP4Data/NumBitP4Distance-1 generate

      RCA_ZERO : RCA_GENERIC
      generic map(NumBitP4Distance)
      port map(a_in(NumBitP4Distance*i + NumBitP4Distance-1 downto NumBitP4Distance*i),b_in(NumBitP4Distance*i + NumBitP4Distance-1 downto NumBitP4Distance*i),'0',sum_zero(NumBitP4Distance*i + NumBitP4Distance-1 downto NumBitP4Distance*i),open);

      RCA_ONE : RCA_GENERIC
      generic map(NumBitP4Distance)
      port map(a_in(NumBitP4Distance*i + NumBitP4Distance-1 downto NumBitP4Distance*i),b_in(NumBitP4Distance*i + NumBitP4Distance-1 downto NumBitP4Distance*i),'1',sum_one(NumBitP4Distance*i + NumBitP4Distance-1 downto NumBitP4Distance*i),open);

      SUM_MUX : MUX21_GENERIC
      generic map(NumBitP4Distance)
      port map(sum_zero(NumBitP4Distance*i + NumBitP4Distance-1 downto NumBitP4Distance*i),sum_one(NumBitP4Distance*i + NumBitP4Distance-1 downto NumBitP4Distance*i),c_in_vector(i),sum_out(NumBitP4Distance*i + NumBitP4Distance-1 downto NumBitP4Distance*i));

    end generate SUM_BLOCK;
end STRUCTURAL;

configuration CFG_SUM_NETWORK_STRUCTURAL of SUM_NETWORK is
  for STRUCTURAL
    for SUM_BLOCK
      for all : RCA_GENERIC
        use configuration WORK.CFG_RCA_GENERIC;
      end for;
      for all : MUX21_GENERIC
        use configuration WORK.CFG_MUX21_GENERIC_STRUCTURAL;
      end for;
    end for;
  end for;
end CFG_SUM_NETWORK_STRUCTURAL;
