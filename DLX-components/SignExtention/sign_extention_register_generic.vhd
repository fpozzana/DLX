--This is the sign extention module, it extend NumBitSignExtentionRegister/2
--to NumBitSignExtentionRegister using D Flip-Flop. It maps the lower half
--of the D Flip-Flop to the input D and the higher half to D Flip-Flop
--with the input stuck to '0'. The clock signal and reset signal is common
--to every D Flip-Flop. The output Q is made of NumBitSignExtentionRegister bits.
--The configuration used for the D Flip-Flops is the synchronous one
--test : tested OK, the component works as expected

library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all;

entity SIGN_EXTENTION is
  port(D : IN std_logic_vector(15 downto 0);
       Q : OUT std_logic_vector(31 downto 0));
end SIGN_EXTENTION;

architecture BHEAVIORAL of SIGN_EXTENTION is

  begin
    process(D)
      begin
        Q <= "0000000000000000" & D;
      end process;

end BHEAVIORAL;

configuration CFG_SIGN_EXTENTION_BEHAVIORAL of SIGN_EXTENTION is
  for BHEAVIORAL
  end for;
end CFG_SIGN_EXTENTION_BEHAVIORAL;
