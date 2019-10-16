--tested OK
--outputs a different input depending on the OPCODE in
--it is used to have the right rd depending on r-type or I-tpye operation

library IEEE;
use IEEE.std_logic_1164.all;
use WORK.myTypes.all;
use WORK.globals.all;

entity RDMUX is
  port(rtype_in : IN std_logic_vector(4 downto 0);
       itype_in : IN std_logic_vector(4 downto 0);
       opcode_in : IN std_logic_vector(OP_CODE_SIZE - 1 downto 0);
       rd_out : OUT std_logic_vector(4 downto 0));
end RDMUX;

architecture BEHAVIORAL of RDMUX is
  begin
    process(opcode_in,rtype_in,itype_in)
    begin
      if(opcode_in <= RTYPE) then
        rd_out <= rtype_in;
      else
        rd_out <= itype_in;
      end if;
    end process;
end BEHAVIORAL;

configuration CFG_RDMUX_BEHAVIORAL of RDMUX is
	for BEHAVIORAL
	end for;
end CFG_RDMUX_BEHAVIORAL;
