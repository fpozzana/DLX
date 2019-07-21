--This is the sign extention module, it extend NumBitSignExtentionRegister/2
--to NumBitSignExtentionRegister using D Flip-Flop. It maps the lower half
--of the D Flip-Flop to the input D and the higher half to D Flip-Flop
--with the input stuck to '0'. The clock signal and reset signal is common
--to every D Flip-Flop. The output Q is made of NumBitSignExtentionRegister bits.
--The configuration used for the D Flip-Flops is the synchronous one

library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all;

entity SIGN_EXTENTION_REGISTER_GENERIC is
  generic(NBIT : integer := NumBitSignExtentionRegister);
  port(D : IN std_logic_vector((NBIT/2)-1 downto 0);
       CK : IN std_logic;
       RESET : IN std_logic;
       Q : OUT std_logic_vector(NBIT-1 downto 0));
end SIGN_EXTENTION_REGISTER_GENERIC;

architecture STRUCTURAL of SIGN_EXTENTION_REGISTER_GENERIC is

  component FD
  port (D :	IN	std_logic;
		    CK :	IN	std_logic;
		    RESET :	IN	std_logic;
		    Q :	OUT	std_logic);
  end component;

  begin
    SIGN_EXTENTION_GENERATE : for i in 0 to NBIT-1 generate
      LOWER_HALF : if i < NBIT/2 generate
        LFD : FD
        port map(D(i),CK,RESET,Q(i));
      end generate LOWER_HALF;
      HIGHER_HALF : if i >= NBIT/2 generate
        HFD : FD
        port map('0',CK,RESET,Q(i));
      end generate HIGHER_HALF;
    end generate SIGN_EXTENTION_GENERATE;
  end STRUCTURAL;

configuration CFG_SIGN_EXTENTION_REGISTER_GENERIC of SIGN_EXTENTION_REGISTER_GENERIC is
  for STRUCTURAL
    for SIGN_EXTENTION_GENERATE
      for LOWER_HALF
        for all : FD
          use configuration WORK.CFG_FD_SYNC;
        end for;
      end for;
      for HIGHER_HALF
        for all : FD
          use configuration WORK.CFG_FD_SYNC;
        end for;
      end for;
    end for;
  end for;
end CFG_SIGN_EXTENTION_REGISTER_GENERIC;
