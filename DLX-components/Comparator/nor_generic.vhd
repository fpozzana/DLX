library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity NOR_GENERIC IS
    generic(numbit: positive := NumBitComparator);
    port(inp : IN std_logic_vector(numbit-1 downto 0);
         outp : OUT std_logic);
end NOR_GENERIC;

architecture BEHAVIORAL of NOR_GENERIC is
  signal temp: std_logic_vector(numbit-1 downto 0);
  begin
    temp(0) <= inp(0);
    gen: for i in 1 to numbit-1 generate
        temp(i) <= temp(i-1) nor inp(i);
    end generate;
    outp <= temp(numbit-1);
end BEHAVIORAL;

configuration CFG_NOR_GENERIC of NOR_GENERIC is
  for BEHAVIORAL
  end for;
end CFG_NOR_GENERIC;
