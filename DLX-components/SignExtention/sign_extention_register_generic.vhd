--test : tested OK, the component works as expected
--extend the value given as input in a signed way on 32 bits

library IEEE;
use IEEE.std_logic_1164.all;
use WORK.globals.all;

entity SIGN_EXTENTION is
  port(D : IN std_logic_vector(15 downto 0);
       Q : OUT std_logic_vector(31 downto 0));
end SIGN_EXTENTION;

architecture BHEAVIORAL of SIGN_EXTENTION is

  begin
    process(D)
      begin
        if(D(15) = '0') then
          Q <= "0000000000000000" & D;
        elsif(D(15) = '1') then
          Q <= "1111111111111111" & D;
        end if;
      end process;

end BHEAVIORAL;

configuration CFG_SIGN_EXTENTION_BEHAVIORAL of SIGN_EXTENTION is
  for BHEAVIORAL
  end for;
end CFG_SIGN_EXTENTION_BEHAVIORAL;
