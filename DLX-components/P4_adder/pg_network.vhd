--PG network for the P4 adder

library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all;

entity PG_NETWORK is
  generic(NBIT : integer := NumBitPGNetwork);
  port(a_in : IN std_logic_vector(NBIT-1 downto 0);
       b_in : IN std_logic_vector(NBIT-1 downto 0);
       propagate_out : OUT std_logic_vector(NBIT-1 downto 0);
       generate_out : OUT std_logic_vector(NBIT-1 downto 0));
end PG_NETWORK;

architecture BEHAVIORAL of PG_NETWORK is
  begin
    PG_GENERATE : for i in 0 to NBIT-1 generate
      propagate_out(i) <= a_in(i) XOR b_in(i);
      generate_out(i) <= a_in(i) AND b_in(i);
    end generate PG_GENERATE;
end BEHAVIORAL;

configuration CFG_PG_NETWORK_BEHAVIORAL of PG_NETWORK is
  for BEHAVIORAL
  end for;
end CFG_PG_NETWORK_BEHAVIORAL;
