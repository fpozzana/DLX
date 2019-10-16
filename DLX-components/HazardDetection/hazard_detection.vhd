--tested OK
--samples on the falling edge the value of IR and outputs on the leading edge
--checks if there are data hazards (RAW) for I-type and R-type operations
--and forward the right value to the ALU

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.globals.all;
use work.myTypes.all;

entity HAZARD_DETECTION is
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
end HAZARD_DETECTION;

architecture STRUCTURAL of HAZARD_DETECTION is

component R1_HAZARD_DETECTION
port(clk : IN std_logic;
     reset : IN std_logic;
     OPCODE : IN std_logic_vector(OP_CODE_SIZE - 1 downto 0);
     RS1_REG_IN : IN std_logic_vector(4 downto 0);
     RD_REG_IN : IN std_logic_vector(4 downto 0);
     TYPE_OUT : OUT std_logic_vector(4 downto 0);
     reg_one : OUT std_logic_vector(4 downto 0);
     reg_two : OUT std_logic_vector(4 downto 0);
     reg_three : OUT std_logic_vector(4 downto 0);
     alu_forwarding_one : OUT std_logic;
     mem_forwarding_one : OUT std_logic;
     RS1_OUT : OUT std_logic_vector(4 downto 0);
     rs1_one : OUT std_logic_vector(4 downto 0);
     rs1_two : OUT std_logic_vector(4 downto 0);
     rs1_three : OUT std_logic_vector(4 downto 0));
end component;

component R2_HAZARD_DETECTION
port(clk : IN std_logic;
     reset : IN std_logic;
     OPCODE : IN std_logic_vector(OP_CODE_SIZE - 1 downto 0);
     RS2_REG_IN : IN std_logic_vector(4 downto 0);
     RD_REG_IN : IN std_logic_vector(4 downto 0);
     TYPE_OUT : OUT std_logic_vector(4 downto 0);
     reg_one : OUT std_logic_vector(4 downto 0);
     reg_two : OUT std_logic_vector(4 downto 0);
     reg_three : OUT std_logic_vector(4 downto 0);
     RS2_OUT : OUT std_logic_vector(4 downto 0);
     rs2_one : OUT std_logic_vector(4 downto 0);
     rs2_two : OUT std_logic_vector(4 downto 0);
     rs2_three : OUT std_logic_vector(4 downto 0);
     alu_forwarding_two : OUT std_logic;
     mem_forwarding_two : OUT std_logic);
end component;

component RDSELECT
port(OPCODE : IN std_logic_vector(OP_CODE_SIZE - 1 downto 0);
     RD_REG_IN_RTYPE : IN std_logic_vector(4 downto 0);
     RD_REG_IN_ITYPE : IN std_logic_vector(4 downto 0);
     RD_OUT : OUT std_logic_vector(4 downto 0));
end component;

signal rdselectoutsignal : std_logic_vector(4 downto 0);

begin

  RD_OUT <= rdselectoutsignal;

  RDSEL : RDSELECT
  port map(OPCODE,RD_REG_IN_RTYPE,RD_REG_IN_ITYPE,rdselectoutsignal);

  R1_HAZARD : R1_HAZARD_DETECTION
  port map(clk,reset,OPCODE,RS1_REG_IN,rdselectoutsignal,open,open,open,open,alu_forwarding_one,mem_forwarding_one,open,open,open,open);

  R2_HAZARD : R2_HAZARD_DETECTION
  port map(clk,reset,OPCODE,RS2_REG_IN,rdselectoutsignal,open,open,open,open,open,open,open,open,alu_forwarding_two,mem_forwarding_two);

end STRUCTURAL;

configuration CFG_HAZARD_DETECTION of HAZARD_DETECTION is
  for STRUCTURAL
    for all : R1_HAZARD_DETECTION
      use configuration WORK.CFG_R1_HAZARD_DETECTION;
    end for;
    for all : R2_HAZARD_DETECTION
      use configuration WORK.CFG_R2_HAZARD_DETECTION;
    end for;
  end for;
end CFG_HAZARD_DETECTION;
