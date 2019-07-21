--testbench of the PG network for the P4 adder

library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all;

entity TB_PG_NETWORK is
end TB_PG_NETWORK;

architecture TEST of TB_PG_NETWORK is

  constant NBIT : integer := NumBitPGNetwork;
  signal A_IN : std_logic_vector(NBIT-1 downto 0);
  signal B_IN : std_logic_vector(NBIT-1 downto 0);
  signal PROPAGATE_OUT : std_logic_vector(NBIT-1 downto 0);
  signal GENERATE_OUT : std_logic_vector(NBIT-1 downto 0);

  component PG_NETWORK
  generic(NBIT : integer := NumBitPGNetwork);
  port(a_in : IN std_logic_vector(NBIT-1 downto 0);
       b_in : IN std_logic_vector(NBIT-1 downto 0);
       propagate_out : OUT std_logic_vector(NBIT-1 downto 0);
       generate_out : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  begin

    DUT : PG_NETWORK
    generic map(NBIT)
    port map(A_IN,B_IN,PROPAGATE_OUT,GENERATE_OUT);

    A_IN <= "00000000000000000000000000000000" , "11111111111111111111111111111111" after 10 ns;
    B_IN <= "00000000000000000000000000000000" , "11111111111111111111111111111111" after 10 ns;

end TEST;

configuration CFG_TB_PG_NETWORK_BEHAVIORAL of TB_PG_NETWORK is
  for TEST
    for DUT : PG_NETWORK
      use configuration WORK.CFG_PG_NETWORK_BEHAVIORAL;
    end for;
  end for;
end CFG_TB_PG_NETWORK_BEHAVIORAL;
