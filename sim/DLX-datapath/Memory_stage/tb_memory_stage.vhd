--fix the address; how many bits? look at Patterson

library ieee;
use ieee.std_logic_1164.all;
use WORK.globals.all;

entity TB_MEMORY_STAGE is
end TB_MEMORY_STAGE;

architecture TEST of TB_MEMORY_STAGE is
  constant NBIT : integer := 32;

  signal reset : std_logic := '0';
  signal clk : std_logic := '0';
  signal memory_stage_out : std_logic_vector(NBIT - 1 downto 0);
  signal rd_reg_in : std_logic_vector(4 downto 0) := "10101";
  signal rd_reg_out : std_logic_vector(4 downto 0);
  signal to_mem_stage_reg : std_logic_vector(NBIT - 1 downto 0) := "11110000111100001111000011110000";
  signal alu_in : std_logic_vector(NBIT - 1 downto 0) := (others => '1');
  signal alu_out : std_logic_vector(NBIT - 1 downto 0);

  component MEMORY_STAGE
  generic(numbit : integer := RISC_BIT);
  port(alu_in : IN std_logic_vector(numbit - 1 downto 0);
       rd_reg_in : IN std_logic_vector(4 downto 0);
       reset : IN std_logic;
       clk : IN std_logic;
       to_mem_stage_reg : IN std_logic_vector(numbit - 1 downto 0);
       rd_reg_out : OUT std_logic_vector(4 downto 0);
       memory_stage_out : OUT std_logic_vector(numbit-1 downto 0);
       alu_out : OUT std_logic_vector(numbit - 1 downto 0));
  end component;

  begin
    DUT : MEMORY_STAGE
    generic map(NBIT)
    port map(alu_in, rd_reg_in, reset, clk, to_mem_stage_reg, rd_reg_out, memory_stage_out, alu_out);

    reset <= '1' after 29 ns;
    alu_in <= (others => '0') after 8 ns;

    PCLOCK : process(clk)
    begin
      clk <= not(clk) after 1 ns;
    end process;

end TEST;

configuration CFG_TB_MEMORY_STAGE of TB_MEMORY_STAGE is
  for TEST
    for DUT : MEMORY_STAGE
      use configuration WORK.CFG_MEMORY_STAGE_STRUCTURAL;
    end for;
  end for;
end CFG_TB_MEMORY_STAGE;
