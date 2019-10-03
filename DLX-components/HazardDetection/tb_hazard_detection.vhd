library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.globals.all;
use work.myTypes.all;

entity TB_HAZARD_DETECTION is
end TB_HAZARD_DETECTION;

architecture TEST of TB_HAZARD_DETECTION is

  signal clk : std_logic := '1';
  signal reset : std_logic := '1';
  signal OPCODE : std_logic_vector(OP_CODE_SIZE - 1 downto 0) := "000000";
  signal R_TYPE_IN : std_logic_vector(4 downto 0);
  signal I_TYPE_IN : std_logic_vector(4 downto 0) := "00000";
  signal alu_forwarding_one : std_logic;
  signal mem_forwarding_one : std_logic;
  signal alu_forwarding_two : std_logic;
  signal mem_forwarding_two : std_logic;
  signal reg_one : std_logic_vector(4 downto 0);
  signal reg_two : std_logic_vector(4 downto 0);
  signal reg_three : std_logic_vector(4 downto 0);
  signal TYPE_OUT : std_logic_vector(4 downto 0);
  signal RS1_REG_IN : std_logic_vector(4 downto 0);
  signal RS1_OUT : std_logic_vector(4 downto 0);
  signal rs1_one : std_logic_vector(4 downto 0);
  signal rs1_two : std_logic_vector(4 downto 0);
  signal rs1_three : std_logic_vector(4 downto 0);
  signal RS2_REG_IN : std_logic_vector(4 downto 0);
  signal RS2_OUT : std_logic_vector(4 downto 0);
  signal rs2_one : std_logic_vector(4 downto 0);
  signal rs2_two : std_logic_vector(4 downto 0);
  signal rs2_three : std_logic_vector(4 downto 0);

  component HAZARD_DETECTION
  port(clk : IN std_logic;
       reset : IN std_logic;
       OPCODE : IN std_logic_vector(OP_CODE_SIZE - 1 downto 0);
       RS1_REG_IN : IN std_logic_vector(4 downto 0);
       RS2_REG_IN : IN std_logic_vector(4 downto 0);
       R_TYPE_IN : IN std_logic_vector(4 downto 0);
       I_TYPE_IN : IN std_logic_vector(4 downto 0);
       TYPE_OUT : OUT std_logic_vector(4 downto 0);
       reg_one : OUT std_logic_vector(4 downto 0);
       reg_two : OUT std_logic_vector(4 downto 0);
       reg_three : OUT std_logic_vector(4 downto 0);
       alu_forwarding_one : OUT std_logic;
       mem_forwarding_one : OUT std_logic;
       RS1_OUT : OUT std_logic_vector(4 downto 0);
       rs1_one : OUT std_logic_vector(4 downto 0);
       rs1_two : OUT std_logic_vector(4 downto 0);
       rs1_three : OUT std_logic_vector(4 downto 0);
       RS2_OUT : OUT std_logic_vector(4 downto 0);
       rs2_one : OUT std_logic_vector(4 downto 0);
       rs2_two : OUT std_logic_vector(4 downto 0);
       rs2_three : OUT std_logic_vector(4 downto 0);
       alu_forwarding_two : OUT std_logic;
       mem_forwarding_two : OUT std_logic);
  end component;

  begin
    DUT : HAZARD_DETECTION
    port map(clk,reset,OPCODE,RS1_REG_IN,RS2_REG_IN,R_TYPE_IN,I_TYPE_IN,TYPE_OUT,reg_one,reg_two,reg_three,alu_forwarding_one,mem_forwarding_one,RS1_OUT,rs1_one,rs1_two,rs1_three,RS2_OUT,rs2_one,rs2_two,rs2_three,alu_forwarding_two,mem_forwarding_two);

    R_TYPE_IN <= "00001", "00010" after 5 ns, "00011" after 7 ns, "00100" after 9 ns, "00101" after 11 ns;
    RS1_REG_IN <= "00000", "00010" after 7 ns;
    RS2_REG_IN <= "00000";

    clk <= not clk after 1 ns;
    reset <= '0' after 4 ns;

end TEST;

configuration CFG_TB_HAZARD_DETECTION of TB_HAZARD_DETECTION is
  for TEST
    for DUT: HAZARD_DETECTION
      use configuration WORK.CFG_HAZARD_DETECTION;
    end for;
  end for;
end CFG_TB_HAZARD_DETECTION;
