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
  signal OPCODE : std_logic_vector(OP_CODE_SIZE - 1 downto 0) := "000001";
  signal RD_REG_IN_ITYPE : std_logic_vector(4 downto 0);
  signal RD_REG_IN_RTYPE : std_logic_vector(4 downto 0);
  signal RS1_REG_IN : std_logic_vector(4 downto 0);
  signal RS2_REG_IN : std_logic_vector(4 downto 0);
  signal alu_forwarding_one : std_logic;
  signal mem_forwarding_one : std_logic;
  signal alu_forwarding_two : std_logic;
  signal mem_forwarding_two : std_logic;
  signal RD_OUT : std_logic_vector(4 downto 0);

  component HAZARD_DETECTION
  port(clk : IN std_logic;
       reset : IN std_logic;
       OPCODE : IN std_logic_vector(OP_CODE_SIZE - 1 downto 0);
       RD_REG_IN_ITYPE : IN std_logic_vector(4 downto 0);
       RD_REG_IN_RTYPE : IN std_logic_vector(4 downto 0);
       RS1_REG_IN : IN std_logic_vector(4 downto 0);
       RS2_REG_IN : IN std_logic_vector(4 downto 0);
       alu_forwarding_one : OUT std_logic;
       mem_forwarding_one : OUT std_logic;
       alu_forwarding_two : OUT std_logic;
       mem_forwarding_two : OUT std_logic;
       RD_OUT : OUT std_logic_vector(4 downto 0));
  end component;

  begin
    DUT : HAZARD_DETECTION
    port map(clk,reset,OPCODE,RD_REG_IN_ITYPE,RD_REG_IN_RTYPE,RS1_REG_IN,RS2_REG_IN,alu_forwarding_one,mem_forwarding_one,alu_forwarding_two,mem_forwarding_two,RD_OUT);

    RD_REG_IN_ITYPE <= "00000" , "00010" after 4 ns, "00011" after 6 ns, "00100" after 8 ns;
    OPCODE <= "000000", "000001" after 4 ns, "000000" after 6 ns,"000001" after 8 ns, "000000" after 10 ns,"000001" after 12 ns, "000000" after 14 ns,"000001" after 16 ns, "000000" after 18 ns,"000001" after 20 ns, "000000" after 22 ns,"000001" after 24 ns, "000000" after 26 ns;
    RD_REG_IN_RTYPE <= "00000" , "00010" after 4 ns, "00011" after 6 ns, "00100" after 8 ns;
    RS2_REG_IN <= "00000", "00010" after 8 ns, "00011" after 10 ns, "00100" after 12 ns;
    RS1_REG_IN <= "00000", "11111" after 6 ns, "11111" after 8 ns, "11111" after 10 ns;

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
