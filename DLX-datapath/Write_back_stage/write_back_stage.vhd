library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all;

entity WRITE_BACK_STAGE is
  generic(N : integer := NumBitWriteBack);
  port(LMD : IN std_logic_vector(N-1 downto 0);
      ALUOUT : IN std_logic_vector(N-1 downto 0);
      CONTROL : IN std_logic;
      WB_OUT : OUT std_logic_vector(N-1 downto 0));
end WRITE_BACK_STAGE;

architecture STRUCTURAL of WRITE_BACK_STAGE is

  component MUX21_GENERIC
  generic (NBIT : integer := NumBitMux21);
  port(A : IN std_logic_vector(NBIT-1 downto 0);
       B : IN std_logic_vector(NBIT-1 downto 0);
       SEL : IN std_logic;
       Y : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  begin
    UMUX : MUX21_GENERIC
    generic map(NumBitWriteBack)
    port map(LMD,ALUOUT,CONTROL,WB_OUT);

end STRUCTURAL;

configuration CFG_WRITE_BACK_STAGE of WRITE_BACK_STAGE is
  for STRUCTURAL
    for UMUX : MUX21_GENERIC
      use configuration WORK.CFG_MUX21_GENERIC_STRUCTURAL;
    end for;
  end for;
end CFG_WRITE_BACK_STAGE;
