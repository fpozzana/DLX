library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.globals.all;

entity XORMASK is
  generic(numbit : integer := NumBitRCA);
  port(operand : IN std_logic_vector(numbit-1 downto 0);
       carry : IN std_logic;
       result : OUT std_logic_vector(numbit-1 downto 0));
end XORMASK;

architecture BEHAVIORAL of XORMASK is
  begin
    XORGENERATE : for i in 0 to numbit-1 generate
    result(i) <= operand(i) XOR carry;
    end generate;
end BEHAVIORAL;

configuration CFG_XOR_MASK_GENERIC of XORMASK is
  for BEHAVIORAL
  end for;
end CFG_XOR_MASK_GENERIC;
