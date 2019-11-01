library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.globals.all;
--use ieee.std_logic_arith.all;
use WORK.myTypes.all;

entity FETCH_STAGE is
  generic(numbit : integer := RISC_BIT);
  port(program_counter : IN std_logic_vector(numbit-1 downto 0);
       to_IR : IN std_logic_vector(numbit-1 downto 0);
       clk : IN std_logic;
       reset : IN std_logic;
       to_IRAM : OUT std_logic_vector(numbit - 1 downto 0);
       npc_out : OUT std_logic_vector(numbit-1 downto 0);
       instruction_reg_out : OUT std_logic_vector(numbit-1 downto 0);
       instruction_fetched : OUT std_logic_vector(numbit-1 downto 0));
end FETCH_STAGE;

architecture STRUCTURAL of FETCH_STAGE is
  signal pc_reg_out : std_logic_vector(numbit-1 downto 0);
  signal adder_out : std_logic_vector(numbit-1 downto 0);
  signal plus_four : std_logic_vector(numbit-1 downto 0) := ("00000000000000000000000000000100");

  component REGISTER_GENERIC
  generic (NBIT : integer := NumBitRegister);
  port(D : IN std_logic_vector(NBIT-1 downto 0);
       CK : IN std_logic;
       RESET : IN std_logic;
       Q : OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  signal tomem : std_logic_vector(numbit - 1 downto 0);

  begin

    pc_reg_out <= program_counter;

    NPC : REGISTER_GENERIC
    generic map(numbit)
    port map(adder_out,clk,reset,npc_out);

    instruction_fetched <= to_IR;

    IR : REGISTER_GENERIC
    generic map(numbit)
    port map(to_IR,clk,reset,instruction_reg_out);

    tomem <= "00" & pc_reg_out(31 downto 2);
    adder_out <= std_logic_vector(unsigned(pc_reg_out) + 4);

    --process to check if a forbidden memory address is being accessed
    IRAM_PROC : process(tomem)
    begin
      if((unsigned(tomem)) < RAM_DEPTH) then
        to_IRAM <= tomem;
      end if;
    end process;

end STRUCTURAL;

configuration CFG_FETCH_STAGE of FETCH_STAGE is
	for STRUCTURAL
    for all : REGISTER_GENERIC
		  use configuration WORK.CFG_REGISTER_GENERIC_STRUCTURAL_SYNC;
    end for;
	end for;
end CFG_FETCH_STAGE;
