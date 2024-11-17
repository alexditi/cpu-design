library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real."ceil";
use ieee.math_real."log2";

library cpu_design;

entity decode is

	-- Definitionen
	generic (
	N		: integer := 8;		-- Datenbreite Decode Bereich
	OpcodeSize	: integer := 5;		-- Wortbreite Opcode
	InstAddrWidth	: integer := 11;	-- Programmspeicher Adressbreite
	InstWidth	: integer := 16;	-- Wortbreite Instruction
	rCount		: integer := 8		-- Registeranzahl Register File
	);

	port (

	-- CPU Reset
	rst		: in std_logic;

	-- Clock
	clk		: in std_logic;

	-- Control Signals
	IRload		: in std_logic;

	-- Interface Fetch
	InstIn		: in std_logic_vector(InstWidth - 1 downto 0);
	InstAddrOut	: out std_logic_vector(InstAddrWidth - 1 downto 0);
	InstOffsetOut	: out std_logic_vector(4 downto 0);

	-- Interface RAM / Stack
	DataAddrOut	: out std_logic_vector(N - 1 downto 0);
	DataOffsetOut	: out std_logic_vector(4 downto 0);

	-- Interface Execute / ALU
	DataImmediate	: out std_logic_vector(N - 1 downto 0);
	RdOut		: out integer range 0 to rCount - 1;
	RsOut		: out integer range 0 to rCount - 1;

	-- Interface Control Logic
	Opcode		: out std_logic_vector(OpcodeSize - 1 downto 0);
	CondOut		: out std_logic_vector(2 downto 0);
	CondSign	: out std_logic
	);

	function rBits return integer is
	begin
		return integer(ceil(log2(real(rCount))));
	end function;

end decode;

architecture rtl of decode is

	signal Instruction	: std_logic_vector(InstWidth - 1 downto 0);
	signal OpcodeBuf	: std_logic_vector(OpcodeSize - 1 downto 0);
	signal OffsetBuf	: std_logic_vector(4 downto 0);

begin

	-- Instruction Register
	instruction_register: entity cpu_design.reg(rtl)
		generic map ( N => InstWidth )
		port map (
		clk => clk,
		clr => rst,
		dataWrite => IRload,
		dataIn => InstIn,
		dataOut => Instruction
		);

	-- Decoder

	OpcodeBuf <= Instruction(InstWidth - 1 downto InstWidth - OpcodeSize);
	Opcode <= OpcodeBuf;
	CondOut <= Instruction(2 downto 0);
	CondSign <= Instruction(InstWidth - OpcodeSize - 1);

	RdOut <= to_integer(unsigned(Instruction(InstWidth - OpcodeSize - 1 downto InstWidth - OpcodeSize - rBits)));
	RsOut <= to_integer(unsigned(Instruction(rBits - 1 downto 0)));
	DataImmediate <= Instruction(N - 1 downto 0);

	OffsetBuf <= Instruction(InstWidth - OpcodeSize - rBits - 1 downto InstWidth - OpcodeSize - rBits - 5);
	DataOffsetOut <= OffsetBuf;
	DataAddrOut <= Instruction(InstWidth - OpcodeSize - 1 downto InstWidth - OpcodeSize - N) when OpcodeBuf = "10010" else
		       Instruction(N - 1 downto 0) when OpcodeBuf = "10011";

	InstOffsetOut <= OffsetBuf;
	InstAddrOut <= Instruction(InstAddrWidth - 1 downto 0);

end rtl;