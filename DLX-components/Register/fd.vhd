library IEEE;
use IEEE.std_logic_1164.all;

entity FD is
	Port (	D :	IN	std_logic;
					CK :	IN	std_logic;
					RESET :	IN	std_logic;
					Q :	OUT	std_logic);
end FD;

architecture SYNC of FD is 								-- flip flop D with syncronous reset
	begin
		PSYNCH : process(CK,RESET)
			begin
	  		if CK'event and CK='1' then 			-- positive edge triggered:
	    		if RESET='1' then 							-- active high reset
	      		Q <= '0';
	    		else
	      		Q <= D; 											-- input is written on output
	    		end if;
	  		end if;
			end process;
end SYNC;

architecture ASYNC of FD is 							-- flip flop D with asyncronous reset
	begin
		PASYNCH: process(CK,RESET)
			begin
	  		if RESET='1' then
	    		Q <= '0';
	  		elsif CK'event and CK='1' then 		-- positive edge triggered:
	    		Q <= D;
	  		end if;
			end process;
end ASYNC;

configuration CFG_FD_SYNC of FD is
	for SYNC
	end for;
end CFG_FD_SYNC;

configuration CFG_FD_ASYNC of FD is
	for ASYNC
	end for;
end CFG_FD_ASYNC;
