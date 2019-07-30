--test : tested OK, the component works as expected
--a read on clock cycle 0 produces the output memory_stage_out to change accordignly
--at clock cycle 0, a latch has been used instead of a register

library ieee;
use ieee.std_logic_1164.all;
use WORK.constants.all;

entity MEMORY_STAGE is
  generic(numbit : integer := RISC_BIT);
  port(execution_stage_in : IN std_logic_vector(numbit-1 downto 0);
       b_reg_in : IN std_logic_vector(numbit-1 downto 0);
       write_control : IN std_logic;
       read_control : IN std_logic;
       enable : IN std_logic;
       clk : IN std_logic;
       memory_stage_out : OUT std_logic_vector(numbit-1 downto 0));
end MEMORY_STAGE;

architecture STRUCTURAL of MEMORY_STAGE is
  signal data_memory_out : std_logic_vector(numbit-1 downto 0);

  component MEMORY_GENERIC
  generic(MBIT : integer := NumBitMemoryWord;
          NBIT : integer := NumBitMemoryAddress);
  port(address : IN std_logic_vector(NBIT-1 downto 0);
       data_in : IN std_logic_vector(MBIT-1 downto 0);
       clock : IN std_logic;
       write_enable : IN std_logic;
       read_enable : IN std_logic;
       data_out : OUT std_logic_vector(MBIT-1 downto 0));
  end component;

  component LATCH_GENERIC
  generic (NBIT : integer := NumBitLatch);
  port(
    D : IN std_logic_vector(NBIT-1 downto 0);
    ENABLE : IN std_logic;
    Q : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  begin

    DATA_MEMORY : MEMORY_GENERIC
    generic map(numbit,numbit)
    port map(execution_stage_in,b_reg_in,clk,write_control,read_control,data_memory_out);

    REGISTER_OUT : LATCH_GENERIC
    generic map(numbit)
    port map(data_memory_out,enable,memory_stage_out);

end STRUCTURAL;

configuration CFG_MEMORY_STAGE_STRUCTURAL of MEMORY_STAGE is
	for STRUCTURAL
    for all : MEMORY_GENERIC
		  use configuration WORK.CFG_MEMORY_BEHAVIORAL;
    end for;
    for all : LATCH_GENERIC
		  use configuration WORK.CFG_LATCH_GENERIC_STRUCTURAL_ASYNC;
    end for;
	end for;
end CFG_MEMORY_STAGE_STRUCTURAL;
