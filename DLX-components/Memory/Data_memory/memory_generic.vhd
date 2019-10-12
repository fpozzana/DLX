--This is the memory used for the memory stage of the DLX.
--If you try to write and read the same address at the same time
--the ouput will give the previous value stored in memory, not the value
--that you are trying to write
--test : tested OK, the component works as expected

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.globals.all;

entity DRAM is
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
end DRAM;

architecture BEHAVIORAL of DRAM is
  type memory is array(NCELL - 1 downto 0) of std_logic_vector(NBIT-1 downto 0);
  signal data_memory : memory := (others => (others => '0')); --initialize my data memory to 0;

  begin

    read_and_write: process (clk)
   begin
      if rising_edge(clk) then
         if Reset = '1' then
            -- Synchronous reset to clear memory
            data_memory  <= (others => (others => '0'));
            data_out <= (others => '0');
            address_error <= '0';
         elsif write_enable = '1' then
           if (to_integer(unsigned(address))) < NCELL then
             -- Write Memory
             data_memory(to_integer(unsigned(address))) <= data_in;
             address_error <= '0';
           else
            address_error <= '1';
          end if;
         elsif read_enable = '1' then
           if (to_integer(unsigned(address))) < NCELL then
             data_out <= data_memory(to_integer(unsigned(address)));
             address_error <= '0';
           else
            address_error <= '1';
          end if;
        end if;
      end if;
   end process;

  end BEHAVIORAL;

configuration CFG_DRAM of DRAM is
  for BEHAVIORAL
  end for;
end CFG_DRAM;
