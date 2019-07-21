--fix the address; how many bits? look at Patterson

library ieee;
use ieee.std_logic_1164.all;
use WORK.constants.all;

entity TB_MEMORY_STAGE is
end TB_MEMORY_STAGE;

architecture TEST of TB_MEMORY_STAGE is
  constant NBIT : integer := 32;

  signal execution_stage_in : std_logic_vector(NBIT-1 downto 0);
  signal b_reg_in : std_logic_vector(NBIT-1 downto 0);
  signal write_control : std_logic;
  signal read_control : std_logic;
  signal reset : std_logic;
  signal clk : std_logic;
  signal memory_stage_out : std_logic_vector(NBIT-1 downto 0);

  component MEMORY_STAGE
  generic(numbit : integer := RISC_BIT);
  port(execution_stage_in : IN std_logic_vector(numbit-1 downto 0);
       b_reg_in : IN std_logic_vector(numbit-1 downto 0);
       write_control : IN std_logic;
       read_control : IN std_logic;
       reset : IN std_logic;
       --npc_in : IN std_logic_vector(numbit-1 downto 0);
       --branch_condition : IN std_logic;
       clk : IN std_logic;
       memory_stage_out : OUT std_logic_vector(numbit-1 downto 0));
  end component;

  begin
    DUT : MEMORY_STAGE
    generic map(NBIT)
    port map(execution_stage_in,b_reg_in,write_control,read_control,reset,clk,memory_stage_out);



    PCLOCK : process(clk)
    begin
      clk <= not(clk) after 1 ns;
    end process;

end TEST;
