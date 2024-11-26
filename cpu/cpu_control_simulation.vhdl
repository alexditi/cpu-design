library ieee;
use ieee.std_logic_1164.all;

library cpu_design;

entity cpu_control_simulation is

	generic (
	N		: integer := 8;	-- Datenbreite
	DataAddrWidth	: integer := 12;-- Adressbreite Datenspeicher
	InstWidth	: integer := 16;-- Befehlsbreite
	InstAddrWidth	: integer := 11;-- Adressbreite Programmspeicher
	OpcodeSize	: integer := 5;	-- Breite Opcode im Befehl
	rCount		: integer := 8	-- Registeranzahl Registerfile
	);

	-- Simulation der Control Logic
	-- => Alle Interface Datenleitungen von/zu Control Logic eintragen
	-- => Steuersignal eintragen (als in)
	port (

	-- CPU Reset
	rst		: in std_logic;

	-- CPU Clock
	clk		: in std_logic;

	-- Steuersignale
	-- Fetch
	PrStrAddrSel	: in std_logic_vector(1 downto 0);
	PCload		: in std_logic;
	PCldInBuf	: in std_logic;
	PCldOutBuf	: in std_logic;
	PCselOutBuf	: in std_logic;
	-- Decode
	IRload		: in std_logic;
	-- Execute
	RegFileLoad	: in std_logic;
	AluOpSel	: in std_logic_vector(3 downto 0);
	RegFIleDataSel	: in std_logic_vector(1 downto 0);
	-- Writeback
	SPinc		: in std_logic;
	SPdec		: in std_logic;
	DataStrAddrSel	: in std_logic_vector(1 downto 0);
	DataStrInSel	: in std_logic;
	DataStrLoad	: in std_logic;

	-- Interfaces
	-- Decode
	OpcodeIn	: out std_logic_vector(OpcodeSize - 1 downto 0);
	ConditionIn	: out std_logic_vector(2 downto 0);
	ConditionSign	: out std_logic;
	-- Execute
	SFin		: out std_logic_vector(4 downto 0);
	CBin		: out std_logic_vector(N - 6 downto 0);
	SCRout		: in std_logic_vector(N - 1 downto 0);
	-- Writeback
	Pbit		: in std_logic

	);

end cpu_control_simulation;

architecture rtl of cpu_control_simulation is

	-- Interface Fetch <=> Programmspeicher
	signal PrStrDataOut	: std_logic_vector(InstWidth - 1 downto 0);
	signal PrStrAddrIn	: std_logic_vector(InstAddrWidth - 1 downto 0);

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

	-- Interface Execute <=> Writeback
	signal r6Value		: std_logic_vector(N - 1 downto 0);
	signal r7Value		: std_logic_vector(N - 1 downto 0);
	signal ExecuteDataIn	: std_logic_vector(N - 1 downto 0);
	signal ExecuteDataOut	: std_logic_vector(N - 1 downto 0);

	-- Interface Writeback <=> Datenspeicher
	signal DataStrAddrIn	: std_logic_vector(DataAddrWidth - 1 downto 0);
	signal DataStrIn	: std_logic_vector(N - 1 downto 0);
	signal DataStrOut	: std_logic_vector(N - 1 downto 0);
	signal DataStrLd	: std_logic;

begin

	-- Program Storage
	program_storage: entity cpu_design.ram_block(rtl)
		generic map (
		DataWidth => InstWidth,
		AddrWidth => InstAddrWidth,
		initPS => '1'
		)
		port map (
		rst => rst,
		clk => clk,
		DataOut => PrStrDataOut,
		AddrIn => PrStrAddrIn
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
		Opcode => OpcodeIn,
		CondOut => ConditionIn,
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
		SFout => SFin,
		CBout => CBin,
		SCRin => SCRout,
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

	-- Data Storage
	data_storage: entity cpu_design.ram_block(rtl)
		generic map (
		DataWidth => N,
		AddrWidth => DataAddrWidth
		)
		port map (
		rst => rst,
		clk => clk,
		WriteEn => DataStrLd,
		AddrIn => DataStrAddrIn,
		DataIn => DataStrIn,
		DataOut => DataStrOut
		);

end rtl;