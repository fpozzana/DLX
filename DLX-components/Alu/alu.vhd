--test : tested OK, the component works as expected for the values for which has been tested

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use WORK.constants.all;

entity ALU_BEHAVIORAL is
  generic (NBIT : integer := NumBitALU);
  port 	 ( FUNC: IN std_logic_vector(3 downto 0);
           DATA1, DATA2: IN std_logic_vector(NBIT-1 downto 0);
           OUTALU: OUT std_logic_vector(NBIT-1 downto 0));
end ALU_BEHAVIORAL;

architecture BEHAVIORAL of ALU_BEHAVIORAL is
  begin

    ALU_PROCESS : process (FUNC, DATA1, DATA2)
    begin
      case FUNC is
	       when "0000" 	=> OUTALU <= (DATA1 + DATA2);                                               --ADD
	       when "0001" 	=> OUTALU <= (DATA1 - DATA2);                                               --SUB
	       when "0010" 	=> OUTALU <= (DATA1((NBIT/2)-1 downto 0) * DATA2((NBIT/2)-1 downto 0));     --MUL
	       when "0011" 	=> OUTALU <= (DATA1 AND DATA2);                                             --AND
	       when "0100" 	=> OUTALU <= (DATA1 OR DATA2);                                              --OR
	       when "0101" 	=> OUTALU <= (DATA1 XOR DATA2);                                             --XOR
	       when "0110" 	=> OUTALU <= DATA1(NBIT-2 downto 0) & '0';                                  -- logical shift left, HELP: use the concatenation operator &
	       when "0111" 	=> OUTALU <= '0' & DATA1(NBIT-1 downto 1);                                  -- logical shift right
	       when "1000" 	=> OUTALU <= DATA1(NBIT-2 downto 0) & DATA1(NBIT-1);                        -- rotate left
	       when "1001" 	=> OUTALU <= DATA1(0) & DATA1(NBIT-1 downto 1);                             -- rotate right
	       when others => null;
      end case;
    end process ALU_PROCESS;

  end BEHAVIORAL;

configuration CFG_ALU_BEHAVIORAL of ALU_BEHAVIORAL is
  for BEHAVIORAL
  end for;
end CFG_ALU_BEHAVIORAL;
