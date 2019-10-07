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
       JOFFSET : IN std_logic_vector(25 downto 0);
       BOFFSET : IN std_logic_vector(15 downto 0);
       NPC_IN : IN std_logic_vector(31 downto 0);
       REG1_IN : IN std_logic_vector(31 downto 0);
       REG2_IN : IN std_logic_vector(31 downto 0);
       NPC_OUT : OUT std_logic_vector(31 downto 0));
end BRANCHPREDICTIONUNIT;

architecture BEHAVIORAL of BRANCHPREDICTIONUNIT is

  begin

    OUT_PROCESS : process(OPCODE, NPC_IN, JOFFSET, BOFFSET, REG1_IN, REG2_IN)
  	begin
  		if (OPCODE = "000010") then         --JTYPE_J
  			NPC_OUT <= "000000" & JOFFSET;
  		elsif (OPCODE = "000100") then      --BTYPE_BEQZ
  			if(REG1_IN = "00000") then
          NPC_OUT <= "0000000000000000" & BOFFSET;
        else
          NPC_OUT <= NPC_IN;
        end if;
      elsif (OPCODE = "000101") then      --BTYPE_BNEZ
        if(REG1_IN /= "00000") then
          NPC_OUT <= "0000000000000000" & BOFFSET;
        else
          NPC_OUT <= NPC_IN;
        end if;
      else
        NPC_OUT <= NPC_IN;
  		end if;
  	end process;

end BEHAVIORAL;

configuration CFG_BRANCHPREDICTIONUNIT of BRANCHPREDICTIONUNIT is
  for BEHAVIORAL
  end for;
end CFG_BRANCHPREDICTIONUNIT;
