--test : tested OK, the component works as expected

library ieee;
use ieee.std_logic_1164.all;
use WORK.constants.all;

entity MEMORY_STAGE is
  generic(numbit : integer := RISC_BIT);
  port(rd_reg_in : IN std_logic_vector(4 downto 0);
       reset : IN std_logic;
       clk : IN std_logic;
       to_mem_stage_reg : IN std_logic_vector(numbit - 1 downto 0);
       rd_reg_out : OUT std_logic_vector(4 downto 0);
       memory_stage_out : OUT std_logic_vector(numbit-1 downto 0);
       to_dram_address : OUT std_logic_vector(numbit-1 downto 0);
       to_dram_data : OUT std_logic_vector(numbit-1 downto 0));
end MEMORY_STAGE;

architecture STRUCTURAL of MEMORY_STAGE is
  signal data_memory_out : std_logic_vector(numbit-1 downto 0);

  component REGISTER_GENRIC
  generic (NBIT : integer := NumBitRegister);
  port(
    D : IN std_logic_vector(NBIT-1 downto 0);
    CK : IN std_logic;
    RESET : IN std_logic;
    Q : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  begin

    RDREG : REGISTER_GENRIC
    generic map(5)
    port map(rd_reg_in,clk,reset,rd_reg_out);

    REG : REGISTER_GENRIC
    generic map(numbit)
    port map(to_mem_stage_reg,clk,reset,memory_stage_out);

end STRUCTURAL;

configuration CFG_MEMORY_STAGE_STRUCTURAL of MEMORY_STAGE is
	for STRUCTURAL
    for all : REGISTER_GENRIC
		  use configuration WORK.CFG_REGISTER_GENERIC_STRUCTURAL_SYNC;
    end for;
	end for;
end CFG_MEMORY_STAGE_STRUCTURAL;
