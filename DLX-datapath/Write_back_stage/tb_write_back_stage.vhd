library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all;

entity TB_WRITE_BACK_STAGE is
end TB_WRITE_BACK_STAGE;

architecture TEST of TB_WRITE_BACK_STAGE is

  constant NBIT : integer := RISC_BIT;
  signal TB_LMD : std_logic_vector(NBIT-1 downto 0);
  signal TB_ALU_OUT : std_logic_vector(NBIT-1 downto 0);
  signal TB_CONTROL : std_logic;
  signal TB_WB_OUT : std_logic_vector(NBIT-1 downto 0);
  signal TB_CLOCK : std_logic := '0';
  signal TB_RESET : std_logic := '0';

  component WRITE_BACK_STAGE
  generic(N : integer := RISC_BIT);
  port(LMD : IN std_logic_vector(N-1 downto 0);
      ALUOUT : IN std_logic_vector(N-1 downto 0);
      CONTROL : IN std_logic;
      clock : IN std_logic;
      reset : IN std_logic;
      WB_OUT : OUT std_logic_vector(N-1 downto 0));
  end component;

  begin
    DUT : WRITE_BACK_STAGE
    generic map(NBIT)
    port map(TB_LMD,TB_ALU_OUT,TB_CONTROL,TB_CLOCK,TB_RESET,TB_WB_OUT);

    TB_LMD <= "00001111000011110000111100001111";
    TB_ALU_OUT <= "11110000111100001111000011110000";
    TB_CONTROL <= '0', '1' after 5 ns;
    TB_RESET <= '0', '1' after 11 ns;

    PCLOCK : process(TB_CLOCK)
    begin
      TB_CLOCK <= not(TB_CLOCK) after 1 ns;
    end process;

end TEST;

configuration CFG_TB_WRITE_BACK_STAGE of TB_WRITE_BACK_STAGE is
  for TEST
    for DUT : WRITE_BACK_STAGE
      use configuration WORK.CFG_WRITE_BACK_STAGE;
    end for;
  end for;
end CFG_TB_WRITE_BACK_STAGE;
