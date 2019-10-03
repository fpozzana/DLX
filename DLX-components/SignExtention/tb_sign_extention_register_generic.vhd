library IEEE;
use IEEE.std_logic_1164.all;
use WORK.globals.all;

entity TB_SIGN_EXTENTION is
end TB_SIGN_EXTENTION;

architecture TEST of TB_SIGN_EXTENTION is

  signal D_IN : std_logic_vector(15 downto 0);
  signal Q_OUT : std_logic_vector(31 downto 0);

  component SIGN_EXTENTION
  port(D : IN std_logic_vector(15 downto 0);
       Q : OUT std_logic_vector(31 downto 0));
  end component;

  begin
    DUT : SIGN_EXTENTION
    generic map(NBIT)
    port map(D_IN,Q_OUT);

    D_IN <= "0000111100001111", "1111000011110000" after 5 ns;

  end TEST;

configuration CFG_TB_SIGN_EXTENTION of TB_SIGN_EXTENTION is
  for TEST
    for DUT : SIGN_EXTENTION
      use configuration WORK.CFG_SIGN_EXTENTION_BEHAVIORAL;
    end for;
  end for;
end CFG_TB_SIGN_EXTENTION;
