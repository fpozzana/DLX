library ieee;
use ieee.std_logic_1164.all;
use WORK.globals.all;
use WORK.myTypes.all;

entity TB_DECODE_STAGE is
end TB_DECODE_STAGE;

architecture TEST of TB_DECODE_STAGE is

  constant NBIT : integer := 32;
  signal IR_IN  : std_logic_vector(NBIT-1 downto 0) := "00001010101010101010101010101010";  --RTYPE ADD RS1 1 RS2 2 RD 3
  signal WB_STAGE_IN :  std_logic_vector(NBIT-1 downto 0) := "00000000000000000000000000001111";    --F is data in
  signal CLK : std_logic := '0';
  signal RESET : std_logic := '1';
  signal WRITE_ENABLE : std_logic := '1';
  signal A_REG_OUT :  std_logic_vector(NBIT-1 downto 0);
  signal B_REG_OUT :  std_logic_vector(NBIT-1 downto 0);
  signal IMM_REG_OUT :  std_logic_vector(NBIT-1 downto 0);
  signal NPC_OUT :  std_logic_vector(NBIT-1 downto 0);
  signal NPC_IN :  std_logic_vector(NBIT-1 downto 0) := "00000000000000000000000000000000";
  signal RD_IN : std_logic_vector(4 downto 0) := "00000";
  signal RD_OUT : std_logic_vector(4 downto 0);
  signal alu_forwarding_one : std_logic;
  signal mem_forwarding_one : std_logic;
  signal alu_forwarding_two : std_logic;
  signal mem_forwarding_two : std_logic;

  component DECODE_STAGE
  generic(numbit : integer := RISC_BIT);
  port(IR_IN : IN std_logic_vector(numbit-1 downto 0);
       WB_STAGE_IN : IN std_logic_vector(numbit-1 downto 0);
       NPC_IN : IN std_logic_vector(numbit-1 downto 0);
       RD_IN : IN std_logic_vector(4 downto 0);
       CLK : IN std_logic;
       RESET : IN std_logic;
       WRITE_ENABLE : IN std_logic;
       RD_OUT : OUT std_logic_vector(4 downto 0);
       NPC_OUT : OUT std_logic_vector(numbit-1 downto 0);
       A_REG_OUT : OUT std_logic_vector(numbit-1 downto 0);
       B_REG_OUT : OUT std_logic_vector(numbit-1 downto 0);
       IMM_REG_OUT : OUT std_logic_vector(numbit-1 downto 0);
       alu_forwarding_one : OUT std_logic;
       mem_forwarding_one : OUT std_logic;
       alu_forwarding_two : OUT std_logic;
       mem_forwarding_two : OUT std_logic);
  end component;

  begin
    DUT : DECODE_STAGE
    generic map(NBIT)
    port map(IR_IN,WB_STAGE_IN,NPC_IN,RD_IN,CLK,RESET,WRITE_ENABLE,RD_OUT,NPC_OUT,A_REG_OUT,B_REG_OUT,IMM_REG_OUT,alu_forwarding_one,mem_forwarding_one,alu_forwarding_two,mem_forwarding_two);

    IR_IN <= "00001011101110111011101110111011" after 5 ns;    --ITYPE add RS1 1 RD 3 IMM F
    NPC_IN <= "00000000000000000000000000000001" after 10 ns, "00000000000000000000000000000010" after 13 ns;
    RESET <= '0' after 4 ns;

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
