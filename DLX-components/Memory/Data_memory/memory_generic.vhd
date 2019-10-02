--This is the memory used for the memory stage of the DLX.
--If you try to write and read the same address at the same time
--the ouput will give the previous value stored in memory, not the value
--that you are trying to write
--test : tested OK, the component works as expected

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.constants.all;

entity DRAM is
  generic(NBIT : integer := NumBitMemoryWord;
          NCELL : integer := NumBitMemoryCells);
  port(address : IN std_logic_vector(NBIT-1 downto 0);
       data_in : IN std_logic_vector(NBIT-1 downto 0);
       write_enable : IN std_logic;
       read_enable : IN std_logic;
       data_out : OUT std_logic_vector(NBIT-1 downto 0);
       address_error : OUT std_logic);
end DRAM;

architecture BEHAVIORAL of DRAM is
  type memory is array(NCELL - 1 downto 0) of std_logic_vector(NBIT-1 downto 0);
  signal data_memory : memory := (others => (others => '0')); --initialize my data memory to 0;

  begin

    memory_process_write : process(address, data_in, write_enable, read_enable)
      begin
        if((to_integer(unsigned(address))) < NCELL) then
          if write_enable = '1' and read_enable = '1' then                                       --if write enable is high
            data_out <= data_memory(to_integer(unsigned(address)));
          end if;
          if write_enable = '1' and read_enable = '0' then                                       --if write enable is high
            data_memory(to_integer(unsigned(address))) <= data_in;         --put data in in the right location
            data_out <= data_in;
          end if;
          if write_enable = '0' and read_enable = '1' then                                       --if write enable is high
            data_out <= data_memory(to_integer(unsigned(address)));
          end if;
          if write_enable = '0' and read_enable = '0' then                                       --if write enable is high
            data_out <= data_in;
          end if;
          address_error <= '0';
        elsif((to_integer(unsigned(address))) > NCELL - 1) then
          address_error <= '1';
          data_out <= (others => '0');
        end if;
    end process memory_process_write;

  end BEHAVIORAL;

configuration CFG_DRAM of DRAM is
  for BEHAVIORAL
  end for;
end CFG_DRAM;
