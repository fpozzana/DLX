library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.myTypes.all;

entity cu_test is
end cu_test;

architecture TEST of cu_test is

    component cu
    port (-- ID Control Signals

          -- EX Control Signal
          MUXA_CONTROL    : OUT std_logic;    -- MUX-A Sel
          MUXB_CONTROL    : OUT std_logic;    -- MUX-B Sel
          ALU_OPCODE      : OUT std_logic_vector(ALU_OPC_SIZE - 1 downto 0); -- ALU Operation Code
          -- MEM Control Signals
          DRAM_WE         : OUT std_logic;    -- Data RAM Write Enable
          DRAM_RE         : OUT std_logic;    -- Data RAM Read Enable
          -- WB Control Signals
          WB_MUX_SEL      : OUT std_logic;    -- Write Back MUX Sel
          RF_WE           : OUT std_logic;    -- Register File Write Enable
          -- INPUTS
          OPCODE : IN  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
          FUNC   : IN  std_logic_vector(FUNC_SIZE - 1 downto 0);
          Clk : IN std_logic;
          Rst : IN std_logic);                  -- Active high
    end component;

    signal Clock: std_logic := '0';
    signal Reset: std_logic := '0';

    signal cu_opcode_i: std_logic_vector(OP_CODE_SIZE - 1 downto 0) := (others => '0');
    signal cu_func_i: std_logic_vector(FUNC_SIZE - 1 downto 0) := (others => '0');
    signal MUXA_CONTROL, MUXB_CONTROL, DRAM_WE, DRAM_RE, WB_MUX_SEL, RF_WE : std_logic := '0';
    signal ALU_OPCODE : std_logic_vector(ALU_OPC_SIZE -1 downto 0) := (others => '0');

begin

        -- instance of DLX
       dut: cu
       port map (
                 -- OUTPUTS
                 ALU_OPCODE   => ALU_OPCODE,
                 MUXA_CONTROL => MUXA_CONTROL,
                 MUXB_CONTROL => MUXB_CONTROL,
                 DRAM_WE      => DRAM_WE,
                 DRAM_RE      => DRAM_RE,
                 WB_MUX_SEL   => WB_MUX_SEL,
                 RF_WE        => RF_WE,
                 -- INPUTS
                 OPCODE => cu_opcode_i,
                 FUNC   => cu_func_i,
                 Clk    => Clock,
                 Rst    => Reset
               );

        Clock <= not Clock after 1 ns;
	      Reset <= '1', '0' after 3 ns;


        CONTROL: process
        begin

        wait for 1 ns;

        -- ADD RS1,RS2,RD -> Rtype
        cu_opcode_i <= RTYPE;
        cu_func_i <= RTYPE_ADD;
        wait for 2 ns;

        cu_opcode_i <= RTYPE;
        cu_func_i <= RTYPE_SUB;
        wait for 2 ns;

        cu_opcode_i <= RTYPE;
        cu_func_i <= RTYPE_AND;
        wait for 2 ns;

        cu_opcode_i <= RTYPE;
        cu_func_i <= RTYPE_OR;
        wait for 2 ns;

        -- ADDI1 RS1,RD,INP1 -> Itype
        cu_opcode_i <= ITYPE_ADDI1;
        cu_func_i <= NOP;
        wait for 2 ns;

        cu_opcode_i <= ITYPE_SUBI1;
        cu_func_i <= NOP;
        wait for 2 ns;

        cu_opcode_i <= ITYPE_ANDI1;
        cu_func_i <= NOP;
        wait for 2 ns;

        cu_opcode_i <= ITYPE_ORI1;
        cu_func_i <= NOP;
        wait for 2 ns;

        cu_opcode_i <= ITYPE_ADDI2;
        cu_func_i <= NOP;
        wait for 2 ns;

        cu_opcode_i <= ITYPE_SUBI2;
        cu_func_i <= NOP;
        wait for 2 ns;

        cu_opcode_i <= ITYPE_ANDI2;
        cu_func_i <= NOP;
        wait for 2 ns;

        cu_opcode_i <= ITYPE_ORI2;
        cu_func_i <= NOP;
        wait for 2 ns;

        cu_opcode_i <= ITYPE_MOV;
        cu_func_i <= NOP;
        wait for 2 ns;

        cu_opcode_i <= ITYPE_S_REG1;
        cu_func_i <= NOP;
        wait for 2 ns;

        cu_opcode_i <= ITYPE_S_REG2;
        cu_func_i <= NOP;
        wait for 2 ns;

        --cu_opcode_i <= ITYPE_S_MEM1;
        --cu_func_i <= NOP;
        --wait for 2 ns;

        cu_opcode_i <= ITYPE_S_MEM2;
        cu_func_i <= NOP;
        wait for 2 ns;

        cu_opcode_i <= ITYPE_L_MEM1;
        cu_func_i <= NOP;
        wait for 2 ns;

        cu_opcode_i <= ITYPE_L_MEM2;
        cu_func_i <= NOP;
        wait for 2 ns;


        wait;
        end process;

end TEST;

configuration CFG_TB_CONTROL_UNIT_HARDWIRED of cu_test is
   for TEST
      for dut: cu
         use configuration WORK.CFG_CONTROL_UNIT_HW;
      end for;
   end for;
end CFG_TB_CONTROL_UNIT_HARDWIRED;
