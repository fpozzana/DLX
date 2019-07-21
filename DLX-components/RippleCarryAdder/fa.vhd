library ieee;
use ieee.std_logic_1164.all;

entity FA is
	port (A:	IN	std_logic;
		    B:	IN	std_logic;
		    Ci:	IN	std_logic;
		    S:	OUT	std_logic;
		    Co:	OUT	std_logic);
end FA;

architecture BEHAVIORAL of FA is
  begin
    S <= A xor B xor Ci;
    Co <= (A and B) or (B and Ci) or (A and Ci);
end BEHAVIORAL;

configuration CFG_FA_BEHAVIORAL of FA is
  for BEHAVIORAL
  end for;
end CFG_FA_BEHAVIORAL;
