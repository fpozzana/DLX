library IEEE;
use work.constants.all;
use IEEE.std_logic_1164.all;

entity TB_REGISTER_FILE is
end TB_REGISTER_FILE;

architecture TEST of TB_REGISTER_FILE is

       signal CK: std_logic := '0';
       signal Reset: std_logic := '0';
       signal Enable: std_logic := '1';
       signal Write: std_logic := '0';
       signal Read_one: std_logic := '1';
       signal Read_two: std_logic := '1';
       signal Write_address: std_logic_vector(NumBitAddress-1 downto 0) := (others => '0');
       signal Read_one_address: std_logic_vector(NumBitAddress-1 downto 0) := (others => '0');
       signal Read_two_address: std_logic_vector(NumBitAddress-1 downto 0) := (others => '0');
       signal Data_in: std_logic_vector(NumBitData-1 downto 0) := (others => '0');
       signal Data_one_out: std_logic_vector(NumBitData-1 downto 0) := (others => '0');
       signal Data_two_out: std_logic_vector(NumBitData-1 downto 0) := (others => '0');

component register_file
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
end component;

begin

RG:register_file
GENERIC MAP(NumBitData, NumBitAddress, NumBitRegisterFile)
PORT MAP (CK,Reset,Enable,Write,Read_one,Read_two,Write_address,Read_one_address,Read_two_address,Data_in,Data_one_out,Data_two_out);
	Reset <= '1','0' after 5 ns;
	Enable <= '0','1' after 3 ns, '0' after 10 ns, '1' after 15 ns;
	Write <= '0','1' after 6 ns, '0' after 7 ns, '1' after 10 ns, '0' after 20 ns;
	Read_one <= '1','0' after 5 ns, '1' after 13 ns, '0' after 20 ns;
	Read_two <= '0','1' after 17 ns;
	Write_address <= "11111", "00000" after 9 ns, "00001" after 13 ns, "00010" after 18 ns, "00011" after 23 ns;
	Read_one_address <="00000", "11111" after 4 ns, "00000" after 10 ns, "11111" after 15 ns;
	Read_two_address <= "11101", "11111" after 9 ns, "00110" after 14 ns, "00010" after 19 ns;
	Data_in<=(others => '0'),(others => '1') after 8 ns, (others => '0') after 13 ns, (others => '1') after 17 ns;



	PCLOCK : process(CK)
	begin
		CK <= not(CK) after 0.5 ns;
	end process;

end TEST;

configuration CFG_TB_REGISTER_FILE of TB_REGISTER_FILE is
  for TEST
	  for RG : register_file
		  use configuration WORK.CFG_REGISTER_FILE_BEHAVIORAL;
	  end for;
  end for;
end CFG_TB_REGISTER_FILE;
