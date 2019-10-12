library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.globals.all;

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
  signal tb_reset : std_logic := '1';
  signal tb_clk : std_logic := '0';

  component DRAM
  generic(NBIT : integer := NumBitMemoryWord;
          NCELL : integer := NumBitMemoryCells);
  port(clk : IN std_logic;
       address : IN std_logic_vector(NBIT-1 downto 0);
       data_in : IN std_logic_vector(NBIT-1 downto 0);
       write_enable : IN std_logic;
       read_enable : IN std_logic;
       reset : IN std_logic;
       data_out : OUT std_logic_vector(NBIT-1 downto 0);
       address_error : OUT std_logic);
  end component;

  begin
    DUT : DRAM
    generic map(NBITDATA,NCELL)
    port map(tb_clk,tb_address,tb_data_in,tb_write_enable,tb_read_enable,tb_reset,tb_data_out,tb_address_error);

    tb_reset <= '0' after 2 ns;
    tb_data_in <= "11111111111111111111111111111111", "00000000000000000000000000000000" after 22 ns, "11111111111111111111111111111111" after 25 ns;
    tb_address <= (others => '0'), "00000000000000001111111111111111" after 20 ns;
    tb_write_enable <= '1','0' after 13 ns, '1' after 20 ns, '0' after 30 ns;
    tb_read_enable <= '0' after 4 ns, '1' after 13 ns,'0' after 20 ns, '1' after 25 ns;

    PCLOCK : process(tb_clk)
    begin
      tb_clk <= not(tb_clk) after 1 ns;
    end process;

  end TEST;

configuration CFG_TB_DRAM of TB_DRAM is
  for TEST
    for DUT : DRAM
      use configuration WORK.CFG_DRAM;
    end for;
  end for;
end CFG_TB_DRAM;
