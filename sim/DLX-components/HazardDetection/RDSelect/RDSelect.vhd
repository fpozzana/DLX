library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.globals.all;
use work.myTypes.all;

entity RDSELECT is
  port(OPCODE : IN std_logic_vector(OP_CODE_SIZE - 1 downto 0);
       RD_REG_IN_RTYPE : IN std_logic_vector(4 downto 0);
       RD_REG_IN_ITYPE : IN std_logic_vector(4 downto 0);
       RD_OUT : OUT std_logic_vector(4 downto 0));
end RDSELECT;

architecture BEHAVIORAL of RDSELECT is

  begin

    OUT_PROCESS : process(OPCODE,RD_REG_IN_RTYPE,RD_REG_IN_ITYPE)
  	begin
  		if (OPCODE = RTYPE) then
  			RD_OUT <= RD_REG_IN_RTYPE;
  		else
  			RD_OUT <= RD_REG_IN_ITYPE;
  		end if;
  	end process;

end BEHAVIORAL;

configuration CFG_RD_SELECT of RDSELECT is
  for BEHAVIORAL
  end for;
end CFG_RD_SELECT;
