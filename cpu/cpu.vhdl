library ieee;
use ieee.std_logic_1164.all;

library cpu_design;

entity cpu is

	generic (
	N		: integer := 8;	-- Datenbreite
	DataAddrWidth	: integer := 12;-- Adressbreite Datenspeicher
	InstWidth	: integer := 16;-- Befehlsbreite
	InstAddrWidth	: integer := 11;-- Adressbreite Programmspeicher
	OpcodeSize	: integer := 5;	-- Breite Opcode im Befehl
	rCount		: integer := 8	-- Registeranzahl Registerfile
	);

	port (
	rst		: in std_logic;	-- CPU Reset
	clk		: in std_logic; -- CPU Clock

	-- Interface Programmspeicher
	PrStrDataOut	: in std_logic_vector(InstWidth - 1 downto 0);
	PrStrAddrIn	: out std_logic_vector(InstAddrWidth - 1 downto 0);

	-- Interface Datenspeicher
	DataStrAddrIn	: out std_logic_vector(DataAddrWidth - 1 downto 0);
	DataStrIn	: out std_logic_vector(N - 1 downto 0);
	DataStrOut	: in std_logic_vector(N - 1 downto 0);
	DataStrLd	: out std_logic

	);

end cpu;

architecture rtl of cpu is

	-- Steuersignale Fetch
	signal PrStrAddrSel	: std_logic_vector(1 downto 0);
	signal PCload		: std_logic;
	signal PCldInBuf	: std_logic;
	signal PCldOutBuf	: std_logic;
	signal PCselOutBuf	: std_logic;

	-- Steuersignale Decode
	signal IRload		: std_logic;

	-- Steuersignale Execute
	signal RegFileLoad	: std_logic;
	signal AluOpSel		: std_logic_vector(3 downto 0);
	signal RegFileDataSel	: std_logic_vector(1 downto 0);

	-- Steuersignale Writeback
	signal SPinc		: std_logic;
	signal SPdec		: std_logic;
	signal DataStrAddrSel	: std_logic_vector(1 downto 0);
	signal DataStrInSel	: std_logic;
	signal DataStrLoad	: std_logic;



	-- Interface Fetch <=> Writeback
	signal PCfromStack	: std_logic_vector(N - 1 downto 0);
	signal PCtoStack	: std_logic_vector(N - 1 downto 0);

	-- Interface Fetch <=> Decode
	signal FetchInstOut	: std_logic_vector(InstWidth - 1 downto 0);
	signal FetchAddrIn	: std_logic_vector(InstAddrWidth - 1 downto 0);
	signal FetchOffsIn	: std_logic_vector(4 downto 0);

	-- Interface Decode <=> Writeback
	signal DecodeDataAddrOut: std_logic_vector(N - 1 downto 0);
	signal DecodeDataOffsOut: std_logic_vector(4 downto 0);

	-- Interface Decode <=> Execute
	signal DataImmediate	: std_logic_vector(N - 1 downto 0);
	signal Rd		: integer range 0 to 7;
	signal Rs		: integer range 0 to 7;

	-- Interface Decode <=> Control Logic
	signal Opcode		: std_logic_vector(OpcodeSize - 1 downto 0);
	signal Condition	: std_logic_vector(2 downto 0);
	signal ConditionSign	: std_logic;

	-- Interface Execute <=> Control Logic
	signal StatusFlags	: std_logic_vector(4 downto 0);
	signal ControlBits	: std_logic_vector(N - 6 downto 0);
	signal StatusControlRegister: std_logic_vector(N - 1 downto 0);

	-- Interface Execute <=> Writeback
	signal r6Value		: std_logic_vector(N - 1 downto 0);
	signal r7Value		: std_logic_vector(N - 1 downto 0);
	signal ExecuteDataIn	: std_logic_vector(N - 1 downto 0);
	signal ExecuteDataOut	: std_logic_vector(N - 1 downto 0);

	-- Interface Writeback <=> Control Logic
	signal Pbit		: std_logic;

begin

	-- Control Logic
	control_logic: entity cpu_design.control_logic(rtl)
		generic map (
		N => N,
		OpcodeSize => OpcodeSize
		)
		port map (
		rst => rst,
		clk => clk,
		PrStrAddrSel => PrStrAddrSel,
		PCload => PCload,
		PCldInBuf => PCldInBuf,
		PCldOutBuf =>PCldOutBuf,
		PCselOutBuf => PCselOutBuf,
		IRload => IRload,
		RegFileLoad => RegFileLoad,
		AluOpSel => AluOpSel,
		RegFileDataSel => RegFileDataSel,
		SPinc => SPinc,
		SPdec => SPdec,
		DataStrAddrSel => DataStrAddrSel,
		DataStrInSel => DataStrInSel,
		DataStrLoad => DataStrLoad,
		OpcodeIn => Opcode,
		ConditionIn => Condition,
		ConditionSign => ConditionSign,
		SFin => StatusFlags,
		CBin => ControlBits,
		SCRout => StatusControlRegister,
		Pbit => Pbit
		);

	-- Fetch
	fetch: entity cpu_design.fetch(rtl)
		generic map (
		N => N,
		InstAddrWidth => InstAddrWidth,
		InstWidth => InstWidth
		)
		port map (
		rst => rst,
		clk => clk,
		PrStrAddrSel => PrStrAddrSel,
		PCload => PCload,
		PCldInBuf => PCldInBuf,
		PCldOutBuf => PCldOutBuf,
		PCselOutBuf => PCselOutBuf,
		PrStrDataOut => PrStrDataOut,
		PrStrAddrIn => PrStrAddrIn,
		DataIn => PCfromStack,
		DataOut => PCtoStack,
		InstOut => FetchInstOut,
		AddrIn => FetchAddrIn,
		OffsetIn => FetchOffsIn
		);

	-- Decode
	decode: entity cpu_design.decode(rtl)
		generic map (
		N => N,
		OpcodeSize => OpcodeSize,
		InstAddrWidth => InstAddrWidth,
		InstWidth => InstWidth,
		rCount => rCount
		)
		port map (
		rst => rst,
		clk => clk,
		IRload => IRload,
		InstIn => FetchInstOut,
		InstAddrOut => FetchAddrIn,
		InstOffsetOut => FetchOffsIn,
		DataAddrOut => DecodeDataAddrOut,
		DataOffsetOut => DecodeDataOffsOut,
		DataImmediate => DataImmediate,
		RdOut => Rd,
		RsOut => Rs,
		Opcode => Opcode,
		CondOut => Condition,
		CondSign => ConditionSign
		);

	-- Execute
	execute: entity cpu_design.execute(rtl)
		generic map (
		N => N,
		rCount => rCount,
		DataAddrWidth => DataAddrWidth
		)
		port map (
		rst => rst,
		clk => clk,
		RegFileLoad => RegFileLoad,
		AluOpSel => AluOpSel,
		RegFileDataSel => RegFileDataSel,
		SFout => StatusFlags,
		CBout => ControlBits,
		SCRin => StatusControlRegister,
		PageOut => r6Value,
		AddressOut => r7Value,
		DataOut => ExecuteDataIn,
		DataIn => ExecuteDataOut,
		DataImmediate => DataImmediate,
		RdIn => Rd,
		RsIn => Rs
		);

	-- Writeback
	writeback: entity cpu_design.writeback(rtl)
		generic map (
		N => N,
		DataAddrWidth => DataAddrWidth
		)
		port map (
		rst => rst,
		clk => clk,
		SPinc => SPinc,
		SPdec => SPdec,
		DataStrAddrSel => DataStrAddrSel,
		DataStrInSel => DataStrInSel,
		DataStrLoad => DataStrLoad,
		Pbit => Pbit,
		r6In => r6Value,
		r7In => r7Value,
		ALUDataIn => ExecuteDataIn,
		ALUDataOut => ExecuteDataOut,
		DataAddressIn => DecodeDataAddrOut,
		DataOffsetIn => DecodeDataOffsOut,
		PCfromStack => PCfromStack,
		PCtoStack => PCtoStack,
		DataStrAddressIn => DataStrAddrIn,
		DataStrIn => DataStrIn,
		DataStrOut => DataStrOut,
		DataStrLd => DataStrLd
		);

end rtl;