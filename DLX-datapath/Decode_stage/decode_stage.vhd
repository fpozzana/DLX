library ieee;
use ieee.std_logic_1164.all;
use WORK.constants.all;

entity DECODE_STAGE is
  generic(numbit : integer := RISC_BIT);
  port();
end DECODE_STAGE;

architecture STRUCTURAL of DECODE_STAGE is

  component MUX21_GENERIC
  generic (NBIT : integer := NumBitMux21);
  port(A : IN std_logic_vector(NBIT-1 downto 0);
       B : IN std_logic_vector(NBIT-1 downto 0);
       SEL : IN std_logic;
       Y : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

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

  component SIGN_EXTENTION_REGISTER_GENERIC
  generic(NBIT : integer := NumBitSignExtentionRegister);
  port(D : IN std_logic_vector((NBIT/2)-1 downto 0);
       CK : IN std_logic;
       RESET : IN std_logic;
       Q : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  begin



end STRUCTURAL;

configuration CFG_DECODE_STAGE_STRUCTURAL of EXECUTION_STAGE is
	for STRUCTURAL
    for all : MUX21_GENERIC
		  use configuration WORK.CFG_MUX21_GENERIC_STRUCTURAL;
    end for;
    for all : REGISTER_GENERIC
		  use configuration WORK.CFG_REGISTER_GENERIC_STRUCTURAL_SYNC;
    end for;
    for all : LATCH_GENERIC
      use configuration WORK.CFG_LATCH_GENERIC_STRUCTURAL_ASYNC;
    end for;
    for all : REGISTER_FILE
      use configuration WORK.CFG_REGISTER_FILE_BEHAVIORAL;
    end for;
    for all : SIGN_EXTENTION_REGISTER_GENERIC
      use configuration WORK.CFG_SIGN_EXTENTION_REGISTER_GENERIC;
    end for;
	end for;
end CFG_DECODE_STAGE_STRUCTURAL;
