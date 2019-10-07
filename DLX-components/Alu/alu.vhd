--test : tested OK, the component works as expected for the values for which has been tested

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.globals.all;

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
         when "0000" => OUTALU <= std_logic_vector(shift_left(unsigned(DATA1), to_integer(unsigned(DATA2(4 downto 0)))));      --SLL
         when "0001" => OUTALU <= std_logic_vector(shift_right(unsigned(DATA1), to_integer(unsigned(DATA2(4 downto 0)))));     --SRL
	       when "0010" 	=> OUTALU <= (DATA1 + DATA2);                                                                            --ADD
         when "0011" 	=> OUTALU <= (DATA1 - DATA2);                                                                            --SUB
	       when "0100" 	=> OUTALU <= (DATA1 AND DATA2);                                                                          --AND
	       when "0101" 	=> OUTALU <= (DATA1 OR DATA2);                                                                           --OR
	       when "0110" 	=> OUTALU <= (DATA1 XOR DATA2);                                                                          --XOR
	       when "0111" 	=> if(unsigned(DATA1) = unsigned(DATA2)) then                                                            --SEQ
				                   OUTALU <= (0 => '1', others => '0');
                         else
				                   OUTALU <= (others => '0');
			                   end if;
         when "1000" 	=> if(unsigned(DATA1) /= unsigned(DATA2)) then                                                            --SNE
				                   OUTALU <= (0 => '1', others => '0');
                         else
				                   OUTALU <= (others => '0');
			                   end if;
         when "1001" 	=> if(unsigned(DATA1) < unsigned(DATA2)) then                                                            --SLT
				                   OUTALU <= (0 => '1', others => '0');
                         else
				                   OUTALU <= (others => '0');
			                   end if;
         when "1010" 	=> if(unsigned(DATA1) > unsigned(DATA2)) then                                                            --SGT
				                   OUTALU <= (0 => '1', others => '0');
                         else
				                   OUTALU <= (others => '0');
			                   end if;
         when "1011" 	=> if(unsigned(DATA1) <= unsigned(DATA2)) then                                                            --SLE
				                   OUTALU <= (0 => '1', others => '0');
                         else
				                   OUTALU <= (others => '0');
			                   end if;
         when "1100" 	=> if(unsigned(DATA1) >= unsigned(DATA2)) then                                                            --SGE
				                   OUTALU <= (0 => '1', others => '0');
                         else
				                   OUTALU <= (others => '0');
			                   end if;
	       when others => null;
      end case;
    end process ALU_PROCESS;

  end BEHAVIORAL;

configuration CFG_ALU_BEHAVIORAL of ALU_BEHAVIORAL is
  for BEHAVIORAL
  end for;
end CFG_ALU_BEHAVIORAL;
