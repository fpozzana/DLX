library ieee;
use ieee.std_logic_1164.all;
use WORK.globals.all;
use WORK.myTypes.all;

entity TB_DECODE_STAGE is
end TB_DECODE_STAGE;

architecture TEST of TB_DECODE_STAGE is

  constant NBIT : integer := 32;
  signal IR_IN  : std_logic_vector(NBIT-1 downto 0) := (others => '0');  --RTYPE ADD RS1 1 RS2 2 RD 3
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
  signal NPC_OUT_BPU : std_logic_vector(NBIT - 1 downto 0);

  component DECODE_STAGE
  generic(numbit : integer := RISC_BIT);
  port(IR_IN : IN std_logic_vector(numbit-1 downto 0);
       WB_STAGE_IN : IN std_logic_vector(numbit-1 downto 0);
       NPC_IN : IN std_logic_vector(numbit-1 downto 0);
       RD_IN : IN std_logic_vector(4 downto 0);
       CLK : IN std_logic;
       RESET : IN std_logic;
       WRITE_ENABLE : IN std_logic;
       NPC_OUT_BPU : OUT std_logic_vector(numbit - 1 downto 0);
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
    port map(IR_IN,WB_STAGE_IN,NPC_IN,RD_IN,CLK,RESET,WRITE_ENABLE,NPC_OUT_BPU,RD_OUT,NPC_OUT,A_REG_OUT,B_REG_OUT,IMM_REG_OUT,alu_forwarding_one,mem_forwarding_one,alu_forwarding_two,mem_forwarding_two);

    IR_IN <= "00100000000000010000000001100100" after 3 ns, "00101000001000010000000000001010" after 5 ns, "00100000011000110000000000001010" after 7 ns, "00000000011000010010000000100000" after 9 ns, "00010100001000001111111111110000" after 11 ns, "00001011111111111111111111111100" after 13 ns;
    NPC_IN <= "00000000000000000000000000000100" after 3 ns, "00000000000000000000000000001000" after 5 ns, "00000000000000000000000000001100" after 7 ns, "00000000000000000000000000010000" after 9 ns, "00000000000000000000000000010100" after 11 ns, "00000000000000000000000000011000" after 13 ns;

    WB_STAGE_IN <= (others => '1') after 8 ns;
    RD_IN <= "00001" after 8 ns;

    RESET <= '0' after 3 ns;

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
