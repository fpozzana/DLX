library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use WORK.constants.all;

entity TB_ALU is
end TB_ALU;

architecture TEST of TB_ALU is

  constant NBIT: integer := NumBitALU;
	signal	FUNC_CODE:	std_logic_vector(3 downto 0);
	signal	OP1:	STD_LOGIC_VECTOR(NBIT-1 downto 0);
	signal	OP2:	STD_LOGIC_VECTOR(NBIT-1 downto 0);
	signal	RESULT:	STD_LOGIC_VECTOR(NBIT-1 downto 0);

	component ALU
    generic (NBIT : integer := NumBitALU);
    port 	 (FUNC: IN std_logic_vector(3 downto 0);
            DATA1, DATA2: IN std_logic_vector(NBIT-1 downto 0);
            OUTALU: OUT std_logic_vector(NBIT-1 downto 0));
	end component;

begin

	U1 : ALU
	Generic Map (NBIT)
	Port Map (FUNC_CODE, OP1, OP2,  RESULT);

  OP1 <= "00000000000000000000000000110101";          --testing only for one value of OP1
  OP2 <= "00000000000000000000000000010110";          --testing only for one value of OP2
	FUNC_CODE <= 	"0000" after 2 ns,                    --testing ADD
		     	      "0001" after 4 ns,                    --testing SUB
	             	"0010" after 6 ns,                    --testing MUL
			          "0011" after 8 ns,                    --testing AND
	             	"0100" after 10 ns,                   --testing OR
			          "0101" after 12 ns,                   --testing XOR
	             	"0110" after 14 ns,                   --testing LSL
			          "0111" after 16 ns,                   --testing LSR
	             	"1000" after 18 ns,                   --testing RL
			          "1001" after 20 ns;                   --testing RR
end TEST;

configuration CFG_TB_ALU of TB_ALU is
   for TEST
      for U1: ALU
         use configuration WORK.CFG_ALU_BEHAVIORAL;
      end for;
   end for;
end CFG_TB_ALU;
