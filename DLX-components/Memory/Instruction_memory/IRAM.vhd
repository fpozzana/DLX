--test : tested OK, the component works as expected when filled by hand

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use WORK.myTypes.all;
use WORK.constants.all;


-- Instruction memory for DLX
-- Memory filled by a process which reads from a file
-- file name is "test.asm.mem"
entity IRAM is
  generic(RAM_DEPTH : integer := RAM_DEPTH;
          I_SIZE : integer := I_SIZE);
  port(Rst  : in  std_logic;
       Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
       Dout : out std_logic_vector(I_SIZE - 1 downto 0));
end IRAM;

architecture IRam_Bhe of IRAM is

  --type RAMtype is array (0 to RAM_DEPTH - 1) of integer;
  --signal IRAM_mem : RAMtype;

  type RAMtype is array (0 to RAM_DEPTH - 1) of std_logic_vector(I_SIZE - 1 downto 0);
  signal IRAM_mem : RAMtype := (RTYPE & REG1 & REG2 & REG3 & RTYPE_ADD,
                                RTYPE & REG4 & REG5 & REG6 & RTYPE_SUB,
                                ITYPE_ADDI1 & REG7 & REG8 & "0000000000000000",
                                ITYPE_SUBI1 & REG9 & REG10 & "1111111111111111");

begin  -- IRam_Bhe

  --Dout <= conv_std_logic_vector(IRAM_mem(conv_integer(unsigned(Addr))),I_SIZE);
  Dout <= IRAM_mem(conv_integer(unsigned(Addr)));
  -- purpose: This process is in charge of filling the Instruction RAM with the firmware
  -- type   : combinational
  -- inputs : Rst
  -- outputs: IRAM_mem
  --FILL_MEM_P: process (Rst)
  --  file mem_fp: text;
  --  variable file_line : line;
  --  variable index : integer := 0;
  --  variable tmp_data_u : std_logic_vector(I_SIZE-1 downto 0);
  --begin  -- process FILL_MEM_P
  --  if (Rst = '0') then
  --    file_open(mem_fp,"C:\Users\FEDERICO\Desktop\Microelectronics system laboratory\DLX-Project\Memory\Instruction_memory\test.asm.mem",READ_MODE);
  --    while (not endfile(mem_fp)) loop
  --      readline(mem_fp,file_line);
  --      hread(file_line,tmp_data_u);
  --      IRAM_mem(index) <= conv_integer(unsigned(tmp_data_u));
  --      index := index + 1;
  --    end loop;
  --  end if;
  --end process FILL_MEM_P;

end IRam_Bhe;

configuration CFG_IRAM_BEHAVIORAL of IRAM is
	for IRam_Bhe
	end for;
end CFG_IRAM_BEHAVIORAL;
