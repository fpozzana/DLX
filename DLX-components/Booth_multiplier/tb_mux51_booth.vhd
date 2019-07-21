library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity mux51_booth_tb is
end mux51_booth_tb;

architecture TEST of mux51_booth_tb is

  constant numBit : integer := 8;

  --  input
  signal A : std_logic_vector(numBit-1 downto 0) := (others => '0');
  signal B : std_logic_vector(numBit-1 downto 0) := (others => '0');
  signal C : std_logic_vector(numBit-1 downto 0) := (others => '0');
  signal D : std_logic_vector(numBit-1 downto 0) := (others => '0');
  signal E : std_logic_vector(numBit-1 downto 0) := (others => '0');
  signal S : std_logic_vector(2 downto 0) := (others => '0');

  -- output
  signal Y : std_logic_vector(numBit-1 downto 0);

  component MUX51_BOOTH_GENERIC
  generic(numBit_mux : integer := NumBitMuxBoothMultiplier);
	port(A :	In	std_logic_vector(numBit_mux-1 downto 0);					-- 0
			 B :	In	std_logic_vector(numBit_mux-1 downto 0);					-- A
			 C :	In	std_logic_vector(numBit_mux-1 downto 0);					-- 2A
			 D :	In	std_logic_vector(numBit_mux-1 downto 0);					-- -A
			 E :	In	std_logic_vector(numBit_mux-1 downto 0);					-- -2A
			 S :	In	std_logic_vector(2 downto 0);											--control signal
			 Y :	Out	std_logic_vector(numBit_mux-1 downto 0));					--output
  end component;

  begin
    mux51 : MUX51_BOOTH_GENERIC
    generic map(numBit)
		port map(A, B, C, D, E, S, Y);

    A <= "00000001";
    B <= "00000010";
    C <= "00000011";
    D <= "00000100";
    E <= "00000101";
    S <= "000", "001" after 5 ns, "010" after 10 ns, "011" after 15 ns, "100" after 20 ns, "101" after 25 ns, "110" after 30 ns, "111" after 35 ns;

end TEST;

configuration CFG_TB_MUX51 of mux51_booth_tb is
	for TEST
		for mux51 : MUX51_BOOTH_GENERIC
			use configuration WORK.CFG_MUX51_BOOTH_GENERIC_BEHAVIORAL  ;
		end for;
	end for;
end configuration;
