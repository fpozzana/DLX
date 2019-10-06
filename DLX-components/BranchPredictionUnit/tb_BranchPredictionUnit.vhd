library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.globals.all;
use work.myTypes.all;

entity TB_BRANCHPREDICIONUNIT is
end TB_BRANCHPREDICIONUNIT;

architecture TEST of TB_BRANCHPREDICIONUNIT is

  signal OPCODE : std_logic_vector(5 downto 0) := (others => '0');
  signal JOFFSET : std_logic_vector(25 downto 0) := (others => '0');
  signal BOFFSET : std_logic_vector(15 downto 0) := (others => '0');
  signal NPC_IN : std_logic_vector(31 downto 0);
  signal NPC_OUT : std_logic_vector(31 downto 0);
  signal REG1_IN : std_logic_vector(31 downto 0) := (others => '0');
  signal REG2_IN : std_logic_vector(31 downto 0) := (others => '0');

  component BRANCHPREDICTIONUNIT
  port(OPCODE : IN std_logic_vector(5 downto 0);
       JOFFSET : IN std_logic_vector(25 downto 0);
       BOFFSET : IN std_logic_vector(15 downto 0);
       NPC_IN : IN std_logic_vector(31 downto 0);
       REG1_IN : IN std_logic_vector(31 downto 0);
       REG2_IN : IN std_logic_vector(31 downto 0);
       NPC_OUT : OUT std_logic_vector(31 downto 0));
  end component;

  begin

    DUT : BRANCHPREDICTIONUNIT
    port map(OPCODE,JOFFSET,BOFFSET,NPC_IN,REG1_IN,REG2_IN,NPC_OUT);

    OPCODE <= "000010" after 2 ns, "000100" after 4 ns, "000101" after 8 ns, "111111" after 14 ns;
    JOFFSET <= "00111111110000000011111111" after 2 ns, "11111111110000000011111111" after 4 ns, "11111111110000111100001111" after 8 ns, "11111111111111111111111111" after 14 ns;
    BOFFSET <= "0000000011111111" after 2 ns, "0000000011111111" after 4 ns, "0000111100001111" after 8 ns, "1111111111111111" after 14 ns;
    NPC_IN <= "00000000000000000000000000000011";
    REG1_IN <= (others => '1') after 6 ns, (others => '0') after 10 ns;

end TEST;

configuration CFG_TB_BRANCHPREDICIONUNIT of TB_BRANCHPREDICIONUNIT is
  for TEST
    for DUT: BRANCHPREDICTIONUNIT
      use configuration WORK.CFG_BRANCHPREDICTIONUNIT;
    end for;
  end for;
end CFG_TB_BRANCHPREDICIONUNIT;
