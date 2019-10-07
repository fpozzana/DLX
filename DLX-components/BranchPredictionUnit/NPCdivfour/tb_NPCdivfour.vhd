library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.globals.all;
use work.myTypes.all;

entity TB_NPCDIVFOUR is
end TB_NPCDIVFOUR;

architecture TEST of TB_NPCDIVFOUR is

  signal npcin : std_logic_vector(31 downto 0) := (others => '0');
  signal npcplus : std_logic_vector(31 downto 0);

  component NPCDIVFOUR
  port(NPC_IN : IN std_logic_vector(31 downto 0);
       NPC_DIV : OUT std_logic_vector(31 downto 0));
  end component;

  begin

    DUT : NPCDIVFOUR
    port map(npcin,npcplus);

    npcin <= (others => '0'), "00000000000000000000000000001100" after 10 ns;

end TEST;

configuration CFG_TB_NPCDIVFOUR of TB_NPCDIVFOUR is
  for TEST
    for DUT: NPCDIVFOUR
      use configuration WORK.CFG_NPCDIVFOUR;
    end for;
  end for;
end CFG_TB_NPCDIVFOUR;
