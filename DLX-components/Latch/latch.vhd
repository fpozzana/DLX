-- ENABLE is active high, so if ENABLE is 1 the latch latches the input

library IEEE;
use IEEE.std_logic_1164.all;

entity LATCH is
	Port (	D :	IN	std_logic;
					ENABLE :	IN	std_logic;
					Q :	OUT	std_logic);
end LATCH;

architecture BEHAVIORAL of LATCH is
	signal DATA : std_logic;
	begin
		DATA <= D when (ENABLE = '1') else DATA;
    Q <= DATA;
end BEHAVIORAL;


configuration CFG_LATCH_BEHAVIORAL of LATCH is
	for BEHAVIORAL
	end for;
end CFG_LATCH_BEHAVIORAL;
