library ieee;
use ieee.std_logic_1164.all;
use WORK.constants.all;
use WORK.myTypes.all;

entity DECODE_STAGE is
  generic(numbit : integer := RISC_BIT);
  port(IR_IN : IN std_logic_vector(numbit-1 downto 0);
       WB_STAGE_IN : IN std_logic_vector(numbit-1 downto 0);
       NPC_IN : IN std_logic_vector(numbit-1 downto 0);
       RD_IN : IN std_logic_vector(4 downto 0);
       CLK : IN std_logic;
       RESET : IN std_logic;
       ENABLE : IN std_logic;
       WRITE : IN std_logic;
       READ_ONE : IN std_logic;
       READ_TWO : IN std_logic;
       RD_OUT : OUT std_logic_vector(4 downto 0);
       NPC_OUT : OUT std_logic_vector(numbit-1 downto 0);
       A_REG_OUT : OUT std_logic_vector(numbit-1 downto 0);
       B_REG_OUT : OUT std_logic_vector(numbit-1 downto 0);
       IMM_REG_OUT : OUT std_logic_vector(numbit-1 downto 0));
end DECODE_STAGE;

architecture STRUCTURAL of DECODE_STAGE is

  signal sign_extention_signal : std_logic_vector(31 downto 0);
  signal RF_ONE_OUT : std_logic_vector(numbit-1 downto 0);
  signal RF_TWO_OUT : std_logic_vector(numbit-1 downto 0);
  signal rdmux_out : std_logic_vector(4 downto 0);
  signal npc_latch_out : std_logic_vector(numbit-1 downto 0);

  component REGISTER_FILE
  generic (numBit_data : integer := NumBitData;
	         numBit_address : integer := NumBitAddress;
	         numBit_registers : integer := NumBitRegisterFile);
  port (CK :	IN std_logic;
        Reset : IN std_logic;
	      Enable :	IN std_logic;
	      Write : IN std_logic;
	      Read_one :	IN std_logic;
	      Read_two :	IN std_logic;
	      Write_address : IN std_logic_vector(numBit_address-1 downto 0);
 	      Read_one_address :	IN std_logic_vector(numBit_address-1 downto 0);
 	      Read_two_address : IN std_logic_vector(numBit_address-1 downto 0);
 	      Data_in : IN std_logic_vector(numBit_data-1 downto 0);
        Data_one_out :	OUT std_logic_vector(numBit_data-1 downto 0);
 	      Data_two_out :	OUT std_logic_vector(numBit_data-1 downto 0));
  end component;

  component REGISTER_GENERIC
  generic (NBIT : integer := NumBitRegister);
  port(
    D : IN std_logic_vector(NBIT-1 downto 0);
    CK : IN std_logic;
    RESET : IN std_logic;
    Q : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  component LATCH_GENERIC
  generic (NBIT : integer := NumBitLatch);
  port(
    D : IN std_logic_vector(NBIT-1 downto 0);
    ENABLE : IN std_logic;
    Q : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  component SIGN_EXTENTION
  port(D : IN std_logic_vector(15 downto 0);
       Q : OUT std_logic_vector(31 downto 0));
  end component;

  component RDMUX
  port(rtype_in : IN std_logic_vector(4 downto 0);
       itype_in : IN std_logic_vector(4 downto 0);
       opcode_in : IN std_logic_vector(OP_CODE_SIZE - 1 downto 0);
       rd_out : OUT std_logic_vector(4 downto 0));
end component;

  begin

  SIGN_REG : SIGN_EXTENTION
  generic map(numbit)
  port map(IR_IN(15 downto 0),sign_extention_signal);

  RF : REGISTER_FILE
  generic map(numbit,5,numbit)
  port map(CLK,RESET,ENABLE,WRITE,READ_ONE,READ_TWO,RD_IN,IR_IN(25 downto 21),IR_IN(20 downto 16),WB_STAGE_IN,RF_ONE_OUT,RF_TWO_OUT);

  LATCHONE : LATCH_GENERIC
  generic map(numbit)
  port map(RF_ONE_OUT,ENABLE,A_REG_OUT);

  LATCHTWO : LATCH_GENERIC
  generic map(numbit)
  port map(RF_TWO_OUT,ENABLE,B_REG_OUT);

  IMMREG : REGISTER_GENERIC
  generic map(numbit)
  port map(sign_extention_signal,clk,reset,IMM_REG_OUT);

  LATCHFOUR : LATCH_GENERIC
  generic map(numbit)
  port map(npc_in,enable,npc_latch_out);

  NPC_REG : REGISTER_GENERIC
  generic map(numbit)
  port map(npc_latch_out,CLK,RESET,NPC_OUT);

  RDMUX_MUX : RDMUX
  port map(IR_IN(15 downto 11),IR_IN(20 downto 16),IR_IN(31 downto 26),rdmux_out);

  RD_OUT_REG : REGISTER_GENERIC
  generic map(5)
  port map(rdmux_out,CLK,RESET,RD_OUT);

end STRUCTURAL;

configuration CFG_DECODE_STAGE_STRUCTURAL of DECODE_STAGE is
	for STRUCTURAL
    for all : REGISTER_GENERIC
		  use configuration WORK.CFG_REGISTER_GENERIC_STRUCTURAL_SYNC;
    end for;
    for all : LATCH_GENERIC
      use configuration WORK.CFG_LATCH_GENERIC_STRUCTURAL_ASYNC;
    end for;
    for all : REGISTER_FILE
      use configuration WORK.CFG_REGISTER_FILE_BEHAVIORAL;
    end for;
    for all : SIGN_EXTENTION
      use configuration WORK.CFG_SIGN_EXTENTION_BEHAVIORAL;
    end for;
	end for;
end CFG_DECODE_STAGE_STRUCTURAL;
