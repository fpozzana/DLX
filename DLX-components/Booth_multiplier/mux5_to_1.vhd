--test : tested OK, the component works as expected for the values for which has been tested

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.constants.all;

entity MUX51_BOOTH_GENERIC is
	generic(numBit_mux : integer := NumBitMuxBoothMultiplier);
	port(A :	In	std_logic_vector(numBit_mux-1 downto 0);					-- 0
			 B :	In	std_logic_vector(numBit_mux-1 downto 0);					-- A
			 C :	In	std_logic_vector(numBit_mux-1 downto 0);					-- -A
			 D :	In	std_logic_vector(numBit_mux-1 downto 0);					-- 2A
			 E :	In	std_logic_vector(numBit_mux-1 downto 0);					-- -2A
			 S :	In	std_logic_vector(2 downto 0);											--control signal
			 Y :	Out	std_logic_vector(numBit_mux-1 downto 0));					--output
end MUX51_BOOTH_GENERIC;


--0 A -A 2A -2A

architecture BEHAVIORAL of MUX51_BOOTH_GENERIC is
	begin
		pmux: process(A,B,S)
		begin
			if (S="111" or S="000") then 		--S = 7 or S = 0 => Y = A
				Y <= A;
			elsif (S="001" or S="010") then	--S = 1 or S = 2 => Y = B
				Y <= B;
			elsif S="011" then 							--S = 3 => Y = C
				Y <= D;
			elsif (S="101" or S="110") then	--S = 5 or S = 6 => Y = D
				Y <= C;
			elsif S="100" then							--S = 4 => Y = E
				Y <= E;
			end if;
		end process;
end BEHAVIORAL;

configuration CFG_MUX51_BOOTH_GENERIC_BEHAVIORAL of MUX51_BOOTH_GENERIC is
	for BEHAVIORAL
	end for;
end CFG_MUX51_BOOTH_GENERIC_BEHAVIORAL ;
