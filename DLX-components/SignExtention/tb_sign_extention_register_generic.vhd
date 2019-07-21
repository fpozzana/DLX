library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all;

entity TB_SIGN_EXTENTION_REGISTER_GENERIC is
end TB_SIGN_EXTENTION_REGISTER_GENERIC;

architecture TEST of TB_SIGN_EXTENTION_REGISTER_GENERIC is

  constant NBIT : integer := NumBitSignExtentionRegister;
  signal D_IN : std_logic_vector((NBIT/2)-1 downto 0);
  signal CLK_IN : std_logic := '0';
  signal RESET_IN : std_logic := '0';
  signal Q_OUT : std_logic_vector(NBIT-1 downto 0);

  component SIGN_EXTENTION_REGISTER_GENERIC
  generic(NBIT : integer := NumBitSignExtentionRegister);
  port(D : IN std_logic_vector((NBIT/2)-1 downto 0);
      CK : IN std_logic;
      RESET : IN std_logic;
      Q : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  begin
    DUT : SIGN_EXTENTION_REGISTER_GENERIC
    generic map(NBIT)
    port map(D_IN,CLK_IN,RESET_IN,Q_OUT);

    PCLOCK : process(CLK_IN)
    begin
      CLK_IN <= not(CLK_IN) after 1 ns;
    end process;

    D_IN <= "0000111100001111", "1111000011110000" after 5 ns;
    RESET_IN <= '0','1' after 10 ns;
  end TEST;

configuration CFG_TB_SIGN_EXTENTION_REGISTER_GENERIC of TB_SIGN_EXTENTION_REGISTER_GENERIC is
  for TEST
    for DUT : SIGN_EXTENTION_REGISTER_GENERIC
      use configuration WORK.CFG_SIGN_EXTENTION_REGISTER_GENERIC;
    end for;
  end for;
end CFG_TB_SIGN_EXTENTION_REGISTER_GENERIC;
