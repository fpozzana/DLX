library ieee;
use ieee.std_logic_1164.all;
use WORK.constants.all;

entity TB_DECODE_STAGE is
end TB_DECODE_STAGE;

architecture TEST of TB_DECODE_STAGE is

  constant NBIT : integer := 32;


  component TB_DECODE_STAGE
  generic(numbit : integer := RISC_BIT);
  port();
  end component;

  begin
    DUT : DECODE_STAGE
    generic map(NBIT)
    port map();

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
end CFG_TB_EXECUTION_STAGE;
