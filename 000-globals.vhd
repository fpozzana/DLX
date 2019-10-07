library ieee;
use work.log_pkg.all;                               --package that contains the definition of log2(x)
use ieee.std_logic_1164.all;

package globals is
--constants used for the testbenches of every component--
	-------------mux---------------------------
	constant NumBitMux21 : integer := 32;
	-------------register----------------------
	constant NumBitRegister : integer := 32;
	-------------latch-------------------------
	constant NumBitLatch : integer := 32;
	-------------ripple carry adder------------
	constant NumBitRCA : integer := 32;
	-------------comparator--------------------
	constant NumBitComparator : integer := 32;
	-------------accumulator-------------------
	constant NumBitAccumulator : integer := 32;
	-------------ALU---------------------------
	constant NumBitALU : integer := 32;
	-------------sign extention----------------
	constant NumBitSignExtentionRegister : integer := 32;
	-------------num bit of RISC core----------
	constant RISC_BIT : integer := 32;
	-------------memory------------------------
	constant NumBitMemoryWord : integer := 32;
	constant NumBitMemoryCells : integer := 32;
	-------------register file-----------------
	constant NumBitData : integer := 32;
	constant NumBitRegisterFile : integer := 32;
	constant NumBitAddress : integer := log2N(NumBitRegisterFile);
	-------------p4 adder----------------------
	constant NumBitPGNetwork : integer := 32;
	constant NumBitP4Distance : integer := 4;
	constant NumBitP4Data : integer := 32;
	-------------booth multiplier--------------
	constant NumBitMuxBoothMultiplier : integer := 8;
	constant NumBitBoothMultiplier : integer := 8;
	-------------instruction memory------------
	constant RAM_DEPTH : integer := 8;
	constant I_SIZE : integer := 32;


end globals;
