--This is the memory used for the memory stage of the DLX.
--If you try to write and read the same address at the same time
--the ouput will give the previous value stored in memory, not the value
--that you are trying to write
--test : tested OK, the component works as expected

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;

entity MEMORY_GENERIC is
  generic(MBIT : integer := NumBitMemoryWord;
          NBIT : integer := NumBitMemoryAddress);
  port(address : IN std_logic_vector(NBIT-1 downto 0);
       data_in : IN std_logic_vector(MBIT-1 downto 0);
       clock : IN std_logic;
       write_enable : IN std_logic;
       read_enable : IN std_logic;
       data_out : OUT std_logic_vector(MBIT-1 downto 0));
end MEMORY_GENERIC;

architecture BEHAVIORAL of MEMORY_GENERIC is
  type memory is array(NBIT-1 downto 0) of std_logic_vector(MBIT-1 downto 0);
  signal data_memory : memory := (others => (others => '0')); --initialize my data memory to 0;

  begin
    memory_process : process(clock)
      begin
        if rising_edge(clock) then                                         --perform actions on the rising clock edge
          if write_enable = '1' then                                       --if write enable is high
            data_memory(to_integer(unsigned(address))) <= data_in;         --put data in in the right location
          end if;
          if read_enable = '1' then                                        --if read enable is high
            data_out <= data_memory(to_integer(unsigned(address)));        --output the memory value at address_in
          end if;
        end if;
      end process memory_process;

  end BEHAVIORAL;

configuration CFG_MEMORY_BEHAVIORAL of MEMORY_GENERIC is
  for BEHAVIORAL
  end for;
end CFG_MEMORY_BEHAVIORAL;
