--test : tested OK, the component works as expected

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.constants.all;

entity REGISTER_FILE is
  generic (numBit_data : integer := NumBitData;
	         numBit_address : integer := NumBitAddress;
	         numBit_registers : integer := NumBitRegisterFile);
  port (CK :	IN std_logic;
        Reset : IN std_logic;
	      Enable :	IN std_logic;
	      Write : IN std_logic;
	      Read_one :	IN std_logic;
	      Read_two :	IN std_logic;
	      Write_address : IN std_logic_vector(numBit_address-1 downto 0);
 	      Read_one_address :	IN std_logic_vector(numBit_address-1 downto 0);
 	      Read_two_address : IN std_logic_vector(numBit_address-1 downto 0);
 	      Data_in : IN std_logic_vector(numBit_data-1 downto 0);
        Data_one_out :	OUT std_logic_vector(numBit_data-1 downto 0);
 	      Data_two_out :	OUT std_logic_vector(numBit_data-1 downto 0));
end REGISTER_FILE;

architecture BEHAVIORAL of REGISTER_FILE is

	type REG_ARRAY is array(numBit_registers-1 downto 0) of std_logic_vector(numBit_data-1 downto 0);
	signal REGISTERS : REG_ARRAY := (others => (others => '0')); --initialize my registers to 0

  begin
    rf_process : process (CK)
	   begin
		     if CK'event and CK='1' then
			     if (RESET = '1') then
				     REGISTERS <= (others => (others => '0'));
				     Data_one_out <= (others => '0');
				     Data_two_out <= (others => '0');
			     elsif (ENABLE = '1') then
				     if (Write='1' and Read_one='1' and Read_two='1') then
               data_one_out <= REGISTERS(to_integer(unsigned(Read_one_address)));
					     data_two_out <= REGISTERS(to_integer(unsigned(Read_two_address)));
					     REGISTERS(to_integer(unsigned(Write_address))) <= Data_in;
				     end if;
				     if (Write='1' and Read_one='1' and Read_two='0') then
               data_one_out <= REGISTERS(to_integer(unsigned(Read_one_address)));
					     REGISTERS(to_integer(unsigned(Write_address))) <= Data_in;
				     end if;
				     if (Write='1' and Read_one='0' and Read_two='1') then
               data_two_out <= REGISTERS(to_integer(unsigned(Read_two_address)));
               REGISTERS(to_integer(unsigned(Write_address))) <= Data_in;
				     end if;
				     if (Write='0' and Read_one='1' and Read_two='1') then
               data_one_out <= REGISTERS(to_integer(unsigned(Read_one_address)));
               data_two_out <= REGISTERS(to_integer(unsigned(Read_two_address)));
				     end if;
				     if (Write='0' and Read_one='0' and Read_two='1') then
               data_two_out <= REGISTERS(to_integer(unsigned(Read_two_address)));
				     end if;
				     if (Write='0' and Read_one='1' and Read_two='0') then
               data_one_out <= REGISTERS(to_integer(unsigned(Read_one_address)));
				     end if;
			     end if;
		     end if;
       end process;
     end BEHAVIORAL;

configuration CFG_REGISTER_FILE_BEHAVIORAL of REGISTER_FILE is
  for BEHAVIORAL
  end for;
end configuration;
