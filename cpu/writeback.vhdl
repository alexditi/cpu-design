library ieee;
use ieee.std_logic_1164.all;

library cpu_design;

entity writeback is

	generic (
	N		: integer := 8;	-- Datenbreite Datenspeicher
	DataAddrWidth	: integer := 12	-- Adressbreite Datenspeicher
	);

	port (

	-- Reset
	rst		: in std_logic;

	-- Clock
	clk		: in std_logic;

	-- Control Signals
	SPinc		: in std_logic;
	SPdec		: in std_logic;
	DataStrAddrSel	: in std_logic_vector(1 downto 0);
	DataStrInSel	: in std_logic;
	DataStrLoad	: in std_logic;

	-- Interface Control Logic
	Pbit		: in std_logic;

	-- Interface Execute / ALU
	r6In		: in std_logic_vector(N - 1 downto 0);
	r7In		: in std_logic_vector(N - 1 downto 0);
	ALUDataIn	: in std_logic_vector(N - 1 downto 0);
	ALUDataOut	: out std_logic_vector(N - 1 downto 0);

	-- Interface Decoder
	DataAddressIn	: in std_logic_vector(N - 1 downto 0);
	DataOffsetIn	: in std_logic_vector(4 downto 0);

	-- Interface Fetch
	PCfromStack	: out std_logic_vector(N - 1 downto 0);
	PCtoStack	: in std_logic_vector(N - 1 downto 0);

	-- Interface to Data Storage
	DataStrAddressIn: out std_logic_vector(DataAddrWidth - 1 downto 0);
	DataStrIn	: out std_logic_vector(N - 1 downto 0);
	DataStrOut	: in std_logic_vector(N - 1 downto 0);
	DataStrLd	: out std_logic

	);

end writeback;

architecture rtl of writeback is

	-- Address MUX Inputs
	signal SPnext	: std_logic_vector(DataAddrWidth - 1 downto 0);	-- push
	signal SPprev	: std_logic_vector(DataAddrWidth - 1 downto 0);	-- pull
	signal r7Addr	: std_logic_vector(DataAddrWidth - 1 downto 0);	-- ld/str indirekt
	signal ImmAddr	: std_logic_vector(DataAddrWidth - 1 downto 0);	-- ld/str direkt

	signal r7OffsIn	: std_logic_vector(DataAddrWidth - 1 downto 0);
	signal OffsetIn	: std_logic_vector(DataAddrWidth - 1 downto 0);

	-- Memory Address Register
	signal MARin	: std_logic_vector(DataAddrWidth - 1 downto 0);
	signal MARclk	: std_logic;

	-- Page Register
	signal curPage	: std_logic_vector(DataAddrWidth - N - 1 downto 0);

begin

	-- Stackpointer
	stackpointer: entity cpu_design.stackpointer(rtl)
		generic map( DataAddrWidth => DataAddrWidth )
		port map (
		rst => rst,
		clk => clk,
		SPinc => SPinc,
		SPdec => SPdec,
		SPnext => SPnext,
		SPprev => SPprev
		);

	-- Page Register
	page_register: entity cpu_design.reg(rtl)
		generic map( N => (DataAddrWidth - N) )
		port map (
		clk => clk,
		clr => rst,
		dataWrite => Pbit,
		dataIn => r6In(DataAddrWidth - N - 1 downto 0),
		dataOut => curPage
		);

	-- Address Immediate erweitern um Page
	ImmAddr(DataAddrWidth - 1 downto N) <= curPage;
	ImmAddr(N - 1 downto 0) <= DataAddressIn;

	-- r7 um Page erweitern, Offset anpassen
	r7OffsIn(DataAddrWidth - 1 downto N) <= curPage;
	r7OffsIn(N - 1 downto 0) <= r7In;
	OffsetIn(DataAddrWidth - 1 downto 5) <= (others => DataOffsetIn(4));
	OffsetIn(4 downto 0) <= DataOffsetIn;

	-- Offset zu r7/Page addieren
 	r7_offset: entity cpu_design.adder(rtl)
		generic map( N => DataAddrWidth )
		port map(
		sub => '0',
		cin => '0',
		inputA => r7OffsIn,
		inputB => OffsetIn,
		output => r7Addr
		);

	-- MUX Auswahl DS Address
	MARin <= SPnext when DataStrAddrSel = "00" else
		 SPprev when DataStrAddrSel = "01" else
		 r7Addr when DataStrAddrSel = "10" else
		 ImmAddr when DataStrAddrSel = "11";

	-- Address Register
	MARclk <= not clk;
	memory_address_register: entity cpu_design.reg(rtl)
		generic map ( N => DataAddrWidth )
		port map (
		clk => MARclk,
		clr => rst,
		dataWrite => '1',
		dataIn => MARin,
		dataOut => DataStrAddressIn
		);

	-- DataIn MUX
	DataStrIn <= PCtoStack when DataStrInSel = '0' else
		     ALUDataIN when DataStrInSel = '1';

	-- DataOut
	PCfromStack <= DataStrOut;
	ALUDataOut <= DataStrOut;

	-- Control Signal
	DataStrLd <= DataStrLoad;

end rtl;