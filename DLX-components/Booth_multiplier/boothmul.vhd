--test : tested OK, the component works as expected, for some values the result is off

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.constants.all;

entity BOOTHMUL is
  generic (numbit : integer := NumBitBoothMultiplier);
  port(A : in std_logic_vector(numBit-1 downto 0);
       B : in std_logic_vector(numBit-1 downto 0);
       Y : out std_logic_vector(2*numBit-1 downto 0));
end BOOTHMUL;

architecture STRUCTURAL of BOOTHMUL is

  component RCA_GENERIC
  generic (NBIT : integer := NumBitRCA);
	port (A:	IN	std_logic_vector(NBIT-1 downto 0);
			  B:	IN	std_logic_vector(NBIT-1 downto 0);
				Ci:	IN	std_logic;
				S:	OUT	std_logic_vector(NBIT-1 downto 0);
				Co:	OUT	std_logic);
  end component;

  component MUX51_GENERIC
  generic(numBit_mux : integer := NumBitMuxBoothMultiplier);
  port(A :	In	std_logic_vector(numBit_mux-1 downto 0);		      -- 0
       B :	In	std_logic_vector(numBit_mux-1 downto 0);					-- A
       C :	In	std_logic_vector(numBit_mux-1 downto 0);					-- -A
       D :	In	std_logic_vector(numBit_mux-1 downto 0);					-- 2A
       E :	In	std_logic_vector(numBit_mux-1 downto 0);					-- -2A
       S :	In	std_logic_vector(2 downto 0);											--control signal
       Y :	Out	std_logic_vector(numBit_mux-1 downto 0));					--output
  end component;

  type A_vector is array(4 downto 0) of std_logic_vector(2*numbit-1 downto 0);              --vectors for each mux51
  type A_matrix is array(numbit/2 downto 0) of A_vector;                                    --matrix of A_vector for each mux51
  signal A_signals : A_matrix;

  type MUX_vector is array(numbit/2 downto 0) of std_logic_vector(2*numbit-1 downto 0);     --vectors for each mux51 output
  signal MUX_signal : MUX_vector;

  type SUM_vector is array(numbit/2-1 downto 0) of std_logic_vector(2*numbit-1 downto 0);   --vectors for each RCA output
  signal SUM_signal : SUM_vector;

  signal A_selection : std_logic_vector(2*numbit-1 downto 0);
  signal B_selection : std_logic_vector(numbit+2 downto 0);

  begin

    B_selection <= "00" & B & '0';                                              --initialize B_selection with B & '0' on the first bit and "00" as last bits
    A_selection(numbit-1 downto 0) <= A;                                        --initialize A_selection with A on the lower half and '0' on the upper half
    A_selection(2*numbit-1 downto numbit) <= (others => '0');

    --initial preparation of the matrix of values to be put as inputs of the mux51
    first_A_signals_generate  : A_signals(0)(0) <= (others => '0');
                                A_signals(0)(1) <= A_selection;
                                A_signals(0)(2) <= not A_signals(0)(1) + 1;
                                A_signals(0)(3) <= std_logic_vector(shift_left(signed(A_selection), 1));
                                A_signals(0)(4) <= not A_signals(0)(3) + 1;
    --generation of the complete matrix
    A_signals_generate : for I in 1 to numbit/2 generate
                                A_signals(I)(0) <= (others => '0');
                                A_signals(I)(1) <= std_logic_vector(shift_left(signed(A_signals(I-1)(1)), 2));
                                A_signals(I)(2) <= not A_signals(I)(1) + 1;
                                A_signals(I)(3) <= std_logic_vector(shift_left(signed(A_signals(I-1)(3)), 2));
                                A_signals(I)(4) <= not A_signals(I)(3) + 1;
    end generate;
    --generation of the muxes51
    MUX_generate : for I in 0 to numbit/2 generate
    muxes : MUX51_GENERIC
            generic map(2*numBit)
            port map(A_signals(I)(0),A_signals(I)(1),A_signals(I)(2),A_signals(I)(3),A_signals(I)(4),B_selection(2*I+2 downto 2*I),MUX_signal(I));
    end generate;
    --generation of the first RCA
    first_rca :  RCA_GENERIC
	               generic map(2*numBit)
                 port map(MUX_signal(0),MUX_signal(1),'0',SUM_signal(0),open);
    --generations of the other RCAs
    other_RCA_generate : for I in 1 to numbit/2-1 generate
    other_rcas : RCA_GENERIC
  	             generic map(2*numBit)
                 port map(MUX_signal(I+1),SUM_signal(I-1),'0',SUM_signal(I),open);
    end generate;

    Y <= SUM_signal(numBit/2-1);

end STRUCTURAL;

configuration CFG_BOOTHMUL_STRUCTURAL of BOOTHMUL is
	for STRUCTURAL
		for MUX_generate
        for all : MUX51_GENERIC
			     use configuration WORK.CFG_MUX51_BOOTH_GENERIC_BEHAVIORAL;
				end for;
    end for;
		for all : RCA_GENERIC
		  use configuration WORK.CFG_RCA_GENERIC;
		end for;
    for other_RCA_generate
	   for all : RCA_GENERIC
		   use configuration WORK.CFG_RCA_GENERIC;
	   end for;
	  end for;
	end for;
end CFG_BOOTHMUL_STRUCTURAL;
