library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;

entity TB_MEMORY_GENERIC is
end TB_MEMORY_GENERIC;

architecture TEST of TB_MEMORY_GENERIC is
  constant NBITADDRESS : integer := NumBitMemoryAddress;
  constant NBITDATA : integer := NumBitMemoryWord;
  signal tb_address : std_logic_vector(NBITADDRESS-1 downto 0);
  signal tb_data_in : std_logic_vector(NBITDATA-1 downto 0);
  signal tb_clock : std_logic := '0';
  signal tb_write_enable : std_logic := '1';
  signal tb_read_enable : std_logic := '0';
  signal tb_data_out : std_logic_vector(NBITDATA-1 downto 0);

  component memory_generic
  generic(MBIT : integer := NumBitMemoryWord;
          NBIT : integer := NumBitMemoryAddress);
  port(address : IN std_logic_vector(NBIT-1 downto 0);
       data_in : IN std_logic_vector(MBIT-1 downto 0);
       clock : IN std_logic;
       write_enable : IN std_logic;
       read_enable : IN std_logic;
       data_out : OUT std_logic_vector(MBIT-1 downto 0));
  end component;

  begin
    DUT : memory_generic
    generic map(NBITDATA,NBITADDRESS)
    port map(tb_address,tb_data_in,tb_clock,tb_write_enable,tb_read_enable,tb_data_out);

    tb_data_in <= "00001111000011110000111100001111", "11111111111111111111111111111111" after 4 ns, "11110000111100001111000011110000" after 8 ns;
    tb_address <= "00000000", "00000001" after 4 ns, "00000010" after 8 ns, "00000011" after 12 ns, "00000100" after 16 ns, "00000101" after 20 ns, "00000000" after 24 ns, "00000001" after 28 ns;
    tb_write_enable <= '1','0' after 22 ns;
    tb_read_enable <= '0','1' after 4 ns, '0' after 12 ns, '1' after 22 ns;

    PCLOCK : process(tb_clock)
    begin
      tb_clock <= not(tb_clock) after 1 ns;
    end process;

  end TEST;

configuration CFG_TB_MEMORY_BEHAVIORAL of TB_MEMORY_GENERIC is
  for TEST
    for DUT : memory_generic
      use configuration WORK.CFG_MEMORY_BEHAVIORAL;
    end for;
  end for;
end CFG_TB_MEMORY_BEHAVIORAL;
