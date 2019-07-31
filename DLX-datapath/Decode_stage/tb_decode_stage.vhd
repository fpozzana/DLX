library ieee;
use ieee.std_logic_1164.all;
use WORK.constants.all;

entity TB_DECODE_STAGE is
end TB_DECODE_STAGE;

architecture TEST of TB_DECODE_STAGE is

  constant NBIT : integer := 32;
  signal IR_IN  : std_logic_vector(NBIT-1 downto 0) := "00000000000000000000000000000000";  --RTYPE ADD RS1 1 RS2 2 RD 3
  signal WB_STAGE_IN :  std_logic_vector(NBIT-1 downto 0) := "00000000000000000000000000001111";    --F is data in
  signal MUX_ONE_SEL : std_logic := '0';    --RTYPE selection
  signal MUX_TWO_SEL : std_logic := '0';    --RTPYE selection
  signal CLK : std_logic := '0';
  signal RESET : std_logic := '0';
  signal ENABLE : std_logic := '1';
  signal WRITE : std_logic := '1';
  signal READ_ONE : std_logic := '1';
  signal READ_TWO : std_logic := '1';
  signal A_REG_OUT :  std_logic_vector(NBIT-1 downto 0);
  signal B_REG_OUT :  std_logic_vector(NBIT-1 downto 0);
  signal IMM_REG_OUT :  std_logic_vector(NBIT-1 downto 0);

  component DECODE_STAGE
  generic(numbit : integer := RISC_BIT);
  port(IR_IN : IN std_logic_vector(NBIT-1 downto 0);
       WB_STAGE_IN : std_logic_vector(NBIT-1 downto 0);
       MUX_ONE_SEL : IN std_logic;
       MUX_TWO_SEL : IN std_logic;
       CLK : IN std_logic;
       RESET : IN std_logic;
       ENABLE : IN std_logic;
       WRITE : IN std_logic;
       READ_ONE : IN std_logic;
       READ_TWO : IN std_logic;
       --NPC_OUT : OUT std_logic_vector(NBIT-1 downto 0);
       A_REG_OUT : OUT std_logic_vector(NBIT-1 downto 0);
       B_REG_OUT : OUT std_logic_vector(NBIT-1 downto 0);
       IMM_REG_OUT : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  begin
    DUT : DECODE_STAGE
    generic map(NBIT)
    port map(IR_IN,WB_STAGE_IN,MUX_ONE_SEL,MUX_TWO_SEL,CLK,RESET,ENABLE,WRITE,READ_ONE,READ_TWO,A_REG_OUT,B_REG_OUT,IMM_REG_OUT);

    IR_IN <= "00000000001000100001100000000000" after 1 ns, "00000100001000110000000000001111" after 3 ns;    --ITYPE add RS1 1 RD 3 IMM F
    MUX_ONE_SEL <= '1' after 2 ns;
    MUX_TWO_SEL <= '1' after 2 ns;

    PCLOCK : process(clk)
    begin
      clk <= not(clk) after 1 ns;
    end process;

end TEST;

configuration CFG_TB_DECODE_STAGE of TB_DECODE_STAGE is
  for TEST
    for DUT : DECODE_STAGE
      use configuration WORK.CFG_DECODE_STAGE_STRUCTURAL;
    end for;
  end for;
end CFG_TB_DECODE_STAGE;
