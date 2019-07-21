--testbench of the sum network for the P4 adder

library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all;

entity TB_SUM_NETWORK is
end TB_SUM_NETWORK;

architecture TEST of TB_SUM_NETWORK is
  constant NBIT : integer := NumBitP4Data;
  constant MBIT : integer := NumBitP4Distance;
  signal a_in : std_logic_vector(NBIT-1 downto 0);
  signal b_in : std_logic_vector(NBIT-1 downto 0);
  signal c_in_vector : std_logic_vector(NBIT/MBIT-1 downto 0);
  signal sum_out : std_logic_vector(NBIT-1 downto 0);

  component SUM_NETWORK
  generic(MBIT : integer := NumBitP4Distance;
          NBIT : integer := NumBitP4Data);
  port(a_in : IN std_logic_vector(NBIT-1 downto 0);
       b_in : IN std_logic_vector(NBIT-1 downto 0);
       c_in_vector : IN std_logic_vector(NBIT/MBIT-1 downto 0);
       sum_out : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  begin
    DUT : SUM_NETWORK
    generic map(MBIT,NBIT)
    port map(a_in,b_in,c_in_vector,sum_out);

    a_in <= "00001111000011110000111100001111", "00000000000000000000000000000000" after 10 ns;
    b_in <= "11110000111100001111000011110000", "00000000000000000000000000000000" after 10 ns;
    c_in_vector <= "11111111", "00000000" after 5 ns, "11111111" after 10 ns, "00000000" after 15 ns;

end TEST;

configuration CFG_TB_SUM_NETWORK_STRUCTURAL of TB_SUM_NETWORK is
  for TEST
    for DUT : SUM_NETWORK
      use configuration WORK.CFG_SUM_NETWORK_STRUCTURAL;
    end for;
  end for;
end CFG_TB_SUM_NETWORK_STRUCTURAL;
