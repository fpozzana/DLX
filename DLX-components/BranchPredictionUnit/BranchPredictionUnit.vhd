--tested OK
--depending on the OPCODE (instruction IN) jump or branches (it has regs as inputs)
--if no jump or branch instruction is input then npc_in is bypassed as npc_out

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.globals.all;
use work.myTypes.all;

entity BRANCHPREDICTIONUNIT is
  port(OPCODE : IN std_logic_vector(5 downto 0);
       JOFFSET_IN : IN std_logic_vector(25 downto 0);
       BOFFSET_IN : IN std_logic_vector(15 downto 0);
       NPC_IN : IN std_logic_vector(31 downto 0);
       REG1_IN : IN std_logic_vector(31 downto 0);
       REG2_IN : IN std_logic_vector(31 downto 0);
       NPC_OUT : OUT std_logic_vector(31 downto 0));
end BRANCHPREDICTIONUNIT;

architecture MIXED of BRANCHPREDICTIONUNIT is

  component BOFFSET
  port(BOFFSET_IN : IN std_logic_vector(15 downto 0);
       BOFFSET_OUT : OUT std_logic_vector(31 downto 0));
  end component;

  component JOFFSET
  port(JOFFSET_IN : IN std_logic_vector(25 downto 0);
       JOFFSET_OUT : OUT std_logic_vector(31 downto 0));
  end component;
  
  signal boffsetadjusted : std_logic_vector(31 downto 0);
  signal joffsetadjusted : std_logic_vector(31 downto 0);

  signal npcoutfinal : std_logic_vector(31 downto 0);


  begin

    BOFF : BOFFSET
    port map(BOFFSET_IN, boffsetadjusted);

    JOFF : JOFFSET
    port map(JOFFSET_IN, joffsetadjusted);


    OUT_PROCESS : process(OPCODE, NPC_IN, joffsetadjusted, boffsetadjusted, REG1_IN, REG2_IN)
    begin
  		if (OPCODE = "000010") then         --JTYPE_J
        npcoutfinal <= joffsetadjusted + NPC_IN;
  		elsif (OPCODE = "000100") then      --BTYPE_BEQZ
  			if(REG1_IN = "00000") then
          npcoutfinal <= NPC_IN + boffsetadjusted;
        else
          npcoutfinal <= NPC_IN;
        end if;
      elsif (OPCODE = "000101") then      --BTYPE_BNEZ
        if(REG1_IN /= "00000") then
          npcoutfinal <= NPC_IN + boffsetadjusted;
        else
          npcoutfinal <= NPC_IN;
        end if;
      else
        npcoutfinal <= NPC_IN;
  		end if;
  	end process;

    NPC_OUT <= npcoutfinal;


end MIXED;

configuration CFG_BRANCHPREDICTIONUNIT of BRANCHPREDICTIONUNIT is
  for MIXED
    for all : JOFFSET
      use configuration WORK.CFG_JOFFSET;
    end for;
    for all : BOFFSET
      use configuration WORK.CFG_BOFFSET;
    end for;
  end for;
end CFG_BRANCHPREDICTIONUNIT;
