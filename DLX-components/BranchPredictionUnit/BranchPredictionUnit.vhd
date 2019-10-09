--tested OK
--depending on the OPCODE (instruction IN) jump or branches (it has regs as inputs)
--if no jump or branch instruction is input then npc_in is bypassed as npc_out

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.globals.all;
use work.myTypes.all;

entity BRANCHPREDICTIONUNIT is
  port(OPCODE : IN std_logic_vector(5 downto 0);
       JOFFSET_IN : IN std_logic_vector(25 downto 0);
       BOFFSET_IN : IN std_logic_vector(15 downto 0);
       NPC_IN : IN std_logic_vector(31 downto 0);
       REG1_IN : IN std_logic_vector(31 downto 0);
       REG2_IN : IN std_logic_vector(31 downto 0);
       COND_TAKEN : OUT std_logic;
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

  component MUX21_GENERIC
  generic (NBIT : integer := NumBitMux21);
  port(A : IN std_logic_vector(NBIT-1 downto 0);
       B : IN std_logic_vector(NBIT-1 downto 0);
       SEL : IN std_logic;
       Y : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  signal boffsetadjusted : std_logic_vector(31 downto 0);
  signal joffsetadjusted : std_logic_vector(31 downto 0);
  signal npcoutfinal : std_logic_vector(31 downto 0);

  begin

    BOFF : BOFFSET
    port map(BOFFSET_IN, boffsetadjusted);

    JOFF : JOFFSET
    port map(JOFFSET_IN, joffsetadjusted);

    NPC_PROCESS : process(OPCODE, NPC_IN, joffsetadjusted, boffsetadjusted, REG1_IN, REG2_IN)
    begin
  		if (OPCODE = "000010") then         --JTYPE_J
        npcoutfinal <= std_logic_vector(unsigned(joffsetadjusted) + unsigned(NPC_IN));
  		elsif (OPCODE = "000100") then      --BTYPE_BEQZ
  			if (unsigned(REG1_IN) = 0) then
          npcoutfinal <= std_logic_vector(unsigned(NPC_IN) + unsigned(boffsetadjusted));
        end if;
      elsif (OPCODE = "000101") then      --BTYPE_BNEZ
        if (unsigned(REG1_IN) /= 0) then
          npcoutfinal <= std_logic_vector(unsigned(NPC_IN) + unsigned(boffsetadjusted));
        end if;
      end if;
  	end process;

    COND_PROCESS : process(OPCODE, REG1_IN)
    begin
      COND_TAKEN <= '0';
      case OPCODE is
        when "000010" => COND_TAKEN <= '1';
        when "000100" => if (unsigned(REG1_IN) = 0) then
                           COND_TAKEN <= '1';
                         end if;
        when "000101" => if (unsigned(REG1_IN) /= 0) then
                           COND_TAKEN <= '1';
                         end if;
        when others => COND_TAKEN <= '0';
      end case;
    end process;

    MUX : MUX21_GENERIC
    generic map(32)
    port map(NPC_IN, npcoutfinal, COND_TAKEN, NPC_OUT);

end MIXED;

configuration CFG_BRANCHPREDICTIONUNIT of BRANCHPREDICTIONUNIT is
  for MIXED
    for all : JOFFSET
      use configuration WORK.CFG_JOFFSET;
    end for;
    for all : BOFFSET
      use configuration WORK.CFG_BOFFSET;
    end for;
    for all : MUX21_GENERIC
      use configuration WORK.CFG_MUX21_GENERIC_BEHAVIORAL;
    end if;
  end for;
end CFG_BRANCHPREDICTIONUNIT;
