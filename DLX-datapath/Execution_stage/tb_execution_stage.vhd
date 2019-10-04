library ieee;
use ieee.std_logic_1164.all;
use WORK.globals.all;

entity TB_EXECUTION_STAGE is
end TB_EXECUTION_STAGE;

architecture TEST of TB_EXECUTION_STAGE is

  constant NBIT : integer := 32;
  signal npc_in : std_logic_vector(NBIT-1 downto 0);
  signal a_reg_in : std_logic_vector(NBIT-1 downto 0);
  signal b_reg_in : std_logic_vector(NBIT-1 downto 0);
  signal imm_reg_in : std_logic_vector(NBIT-1 downto 0);
  signal mux_one_control : std_logic;
  signal mux_two_control : std_logic;
  signal alu_control : std_logic_vector(3 downto 0);
  signal clk : std_logic := '0';
  signal reset : std_logic := '0';
  signal execution_stage_out : std_logic_vector(NBIT-1 downto 0);
  signal b_reg_out : std_logic_vector(NBIT-1 downto 0);
  signal rd_reg_in : std_logic_vector(4 downto 0) := "11111";
  signal rd_reg_out : std_logic_vector(4 downto 0);
  signal alu_forwarding_one : std_logic := '0';
  signal mem_forwarding_one : std_logic := '0';
  signal alu_forwarding_two : std_logic := '0';
  signal mem_forwarding_two : std_logic := '0';
  signal alu_forwarding_value : std_logic_vector(NBIT - 1 downto 0) := (others => '0');
  signal mem_forwarding_value : std_logic_vector(NBIT - 1 downto 0) := (others => '0');

  component EXECUTION_STAGE
  generic(numbit : integer := RISC_BIT);
  port(alu_forwarding_one : IN std_logic;
       mem_forwarding_one : IN std_logic;
       alu_forwarding_two : IN std_logic;
       mem_forwarding_two : IN std_logic;
       alu_forwarding_value : IN std_logic_vector(numbit - 1 downto 0);
       mem_forwarding_value : IN std_logic_vector(numbit - 1 downto 0);
       npc_in : IN std_logic_vector(numbit-1 downto 0);
       a_reg_in : IN std_logic_vector(numbit-1 downto 0);
       b_reg_in : IN std_logic_vector(numbit-1 downto 0);
       imm_reg_in : IN std_logic_vector(numbit-1 downto 0);
       rd_reg_in : IN std_logic_vector(4 downto 0);
       mux_one_control : IN std_logic;
       mux_two_control : IN std_logic;
       alu_control : IN std_logic_vector(3 downto 0);
       clk : IN std_logic;
       reset : IN std_logic;
       execution_stage_out : OUT std_logic_vector(numbit-1 downto 0);
       b_reg_out : OUT std_logic_vector(numbit-1 downto 0);
       rd_reg_out : OUT std_logic_vector(4 downto 0));
  end component;

  begin

    DUT : EXECUTION_STAGE
    generic map(NBIT)
    port map(alu_forwarding_one,mem_forwarding_one,alu_forwarding_two,mem_forwarding_two,alu_forwarding_value,mem_forwarding_value,npc_in,a_reg_in,b_reg_in,imm_reg_in,rd_reg_in,mux_one_control,mux_two_control,alu_control,clk,reset,execution_stage_out,b_reg_out,rd_reg_out);

    npc_in <= "00000000000000000000000000000001";
    a_reg_in <= "00000000000000000000000000000010" , "00000000000000000000000000000000" after 31 ns;
    b_reg_in <= "00000000000000000000000000000011", "00000000000000000000000000000000" after 31 ns;
    imm_reg_in <= "00000000000000000000000000000100";

    mux_one_control <= '0', '1' after 9 ns, '0' after 19 ns, '1' after 31 ns;
    mux_two_control <= '1', '0' after 5 ns, '1' after 9 ns, '0' after 15 ns, '1' after 21 ns, '0' after 25 ns;

    alu_control <= "0000", "0001" after 3 ns, "0010" after 5 ns, "0011" after 7 ns, "0100" after 9 ns, "0101" after 11 ns, "0110" after 13 ns, "0111" after 15 ns, "1000" after 17 ns, "1001" after 19 ns, "0010" after 25 ns;

    alu_forwarding_one <= '1' after 31 ns, '0' after 35 ns;
    alu_forwarding_two <= '1' after 31 ns, '0' after 37 ns;
    mem_forwarding_one <= '1' after 31 ns;
    mem_forwarding_two <= '1' after 31 ns;
    alu_forwarding_value <= "00000000000000000000000000000100" after 31 ns;
    mem_forwarding_value <= "00000000000000000000000000000001" after 31 ns;

    PCLOCK : process(clk)
    begin
      clk <= not(clk) after 1 ns;
    end process;

end TEST;

configuration CFG_TB_EXECUTION_STAGE of TB_EXECUTION_STAGE is
  for TEST
    for DUT : EXECUTION_STAGE
      use configuration WORK.CFG_EXECUTION_STAGE_STRUCTURAL;
    end for;
  end for;
end CFG_TB_EXECUTION_STAGE;
