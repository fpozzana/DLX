library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity MULTIPLIER_tb is
end MULTIPLIER_tb;


architecture TEST of MULTIPLIER_tb is

  constant numBit : integer := NumBitBoothMultiplier;

  --  input
  signal A : std_logic_vector(numBit-1 downto 0) := (others => '0');
  signal B : std_logic_vector(numBit-1 downto 0) := (others => '0');

  -- output
  signal Y : std_logic_vector(2*numBit-1 downto 0);


  component BOOTHMUL is
  generic (numbit : integer := NumBitBoothMultiplier);
  port(A : in std_logic_vector(numBit-1 downto 0);
       B : in std_logic_vector(numBit-1 downto 0);
       Y : out std_logic_vector(2*numBit-1 downto 0));
  end component;


  begin

    boothmuls : BOOTHMUL generic map(numBit)
		port map(A, B, Y);

    --A <= "0000110000001111", "0000111100001111" after 10 ns;
    --B <= "0001111001000101";
    A <= "00111110";
    B <= "10101111";
-- PROCESS FOR TESTING TEST - COMLETE CYCLE ---------
    --test: process
    --begin
    -- cycle for operand A
    --NumROW : for i in 0 to 2**(numBit)-1 loop
      -- cycle for operand B
    	--NumCOL : for i in 0 to 2**(numBit)-1 loop
	    --wait for 10 ns;
	    --B <= B + '1';
	    --end loop NumCOL ;
	  --A <= A + '1';
    --end loop NumROW ;
    --wait;
    --end process test;


end TEST;

configuration CFG_TB_BOOTHMUL of MULTIPLIER_tb is
	for TEST
		for boothmuls : BOOTHMUL
			use configuration WORK.CFG_BOOTHMUL_STRUCTURAL;
		end for;
	end for;
end configuration;
