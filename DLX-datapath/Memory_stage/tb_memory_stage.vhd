--fix the address; how many bits? look at Patterson

library ieee;
use ieee.std_logic_1164.all;
use WORK.constants.all;

entity TB_MEMORY_STAGE is
end TB_MEMORY_STAGE;

architecture TEST of TB_MEMORY_STAGE is
  constant NBIT : integer := 32;

  signal execution_stage_in : std_logic_vector(NBIT-1 downto 0) := "00000000000000000000000000000000";
  signal b_reg_in : std_logic_vector(NBIT-1 downto 0) := "00000000000000000000000000000000";
  signal write_control : std_logic := '1';
  signal read_control : std_logic := '0';
  signal reset : std_logic := '0';
  signal clk : std_logic := '0';
  signal memory_stage_out : std_logic_vector(NBIT-1 downto 0);

  component MEMORY_STAGE
  generic(numbit : integer := RISC_BIT);
  port(execution_stage_in : IN std_logic_vector(numbit-1 downto 0);
       b_reg_in : IN std_logic_vector(numbit-1 downto 0);
       write_control : IN std_logic;
       read_control : IN std_logic;
       reset : IN std_logic;
       clk : IN std_logic;
       memory_stage_out : OUT std_logic_vector(numbit-1 downto 0));
  end component;

  begin
    DUT : MEMORY_STAGE
    generic map(NBIT)
    port map(execution_stage_in,b_reg_in,write_control,read_control,reset,clk,memory_stage_out);

    execution_stage_in <= "00000000000000000000000000000001" after 3 ns, "00000000000000000000000000000010" after 5 ns, "00000000000000000000000000000011" after 7 ns, "00000000000000000000000000000100" after 9 ns, "00000000000000000000000000000000" after 11 ns, "00000000000000000000000000000001" after 13 ns, "00000000000000000000000000000010" after 15 ns, "00000000000000000000000000000011" after 17 ns, "00000000000000000000000000000100" after 19 ns;
    b_reg_in <= "00000000000000000000000000000001" after 3 ns, "00000000000000000000000000000010" after 5 ns, "00000000000000000000000000000011" after 7 ns, "00000000000000000000000000000100" after 9 ns;
    write_control <= '0' after 11 ns;
    read_control <= '1' after 11 ns;
    reset <= '1' after 29 ns;

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
