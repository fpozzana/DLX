library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.globals.all;
use work.myTypes.all;

entity NPCDIVFOUR is
  port(NPC_IN : IN std_logic_vector(31 downto 0);
       NPC_DIV : OUT std_logic_vector(31 downto 0));
end NPCDIVFOUR;

architecture BEHAVIORAL of NPCDIVFOUR is

  signal npcin : std_logic_vector(31 downto 0);
  signal npcdiv : std_logic_vector(31 downto 0);

  begin

    npcin <= NPC_IN;
    NPC_DIV <= npcdiv;

    JOFFSETPROCESS : process(npcin)
    begin
      npcdiv <= "00" & npcin(31 downto 2);
    end process;

end BEHAVIORAL;

configuration CFG_NPCDIVFOUR of NPCDIVFOUR is
  for BEHAVIORAL
  end for;
end CFG_NPCDIVFOUR;
