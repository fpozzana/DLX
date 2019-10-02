library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;

entity TB_DRAM is
end TB_DRAM;

architecture TEST of TB_DRAM is
  constant NCELL : integer := NumBitMemoryCells;
  constant NBITDATA : integer := NumBitMemoryWord;
  signal tb_address : std_logic_vector(NBITDATA-1 downto 0) := (others => '0');
  signal tb_data_in : std_logic_vector(NBITDATA-1 downto 0);
  signal tb_write_enable : std_logic := '1';
  signal tb_read_enable : std_logic := '1';
  signal tb_data_out : std_logic_vector(NBITDATA-1 downto 0);
  signal tb_address_error : std_logic;

  component DRAM
  generic(NBIT : integer := NumBitMemoryWord;
          NCELL : integer := NumBitMemoryCells);
  port(address : IN std_logic_vector(NBIT-1 downto 0);
       data_in : IN std_logic_vector(NBIT-1 downto 0);
       write_enable : IN std_logic;
       read_enable : IN std_logic;
       data_out : OUT std_logic_vector(NBIT-1 downto 0);
       address_error : OUT std_logic);
  end component;

  begin
    DUT : DRAM
    generic map(NBITDATA,NCELL)
    port map(tb_address,tb_data_in,tb_write_enable,tb_read_enable,tb_data_out,tb_address_error);

    tb_data_in <= "11111111111111111111111111111111", "00000000000000000000000000000000" after 20 ns, "11111111111111111111111111111111" after 25 ns;
    tb_address <= (others => '0'), "00000000000000001111111111111111" after 20 ns;
    tb_write_enable <= '1','0' after 13 ns, '1' after 22 ns, '0' after 30 ns;
    tb_read_enable <= '0' after 4 ns, '1' after 13 ns,'0' after 20 ns, '1' after 25 ns;

  end TEST;

configuration CFG_TB_DRAM of TB_DRAM is
  for TEST
    for DUT : DRAM
      use configuration WORK.CFG_DRAM;
    end for;
  end for;
end CFG_TB_DRAM;
