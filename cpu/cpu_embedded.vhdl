library ieee;
use ieee.std_logic_1164.all;

library cpu_design;

entity cpu_embedded is

	generic (
	N		: integer := 8;	-- Datenbreite
	DataAddrWidth	: integer := 12;-- Adressbreite Datenspeicher
	InstWidth	: integer := 16;-- Befehlsbreite
	InstAddrWidth	: integer := 11;-- Adressbreite Programmspeicher

	-- Debugging / Simulation
	ProgrammNo	: integer := 1	-- Auszuführendes Programm
	);

	port (
	-- Externe Signale CLK und RST
	rst		: in std_logic;	-- CPU Reset
	clk		: in std_logic	-- CPU Takt
	);

end cpu_embedded;

architecture rtl of cpu_embedded is

	-- CPU <=> Programmspeicher
	signal PrStrDataOut	: std_logic_vector(InstWidth - 1 downto 0);
	signal PrStrAddrIn	: std_logic_vector(InstAddrWidth - 1 downto 0);

	-- CPU <=> Datenspeicher
	signal DataStrAddrIn	: std_logic_vector(DataAddrWidth - 1 downto 0);
	signal DataStrIn	: std_logic_vector(N - 1 downto 0);
	signal DataStrOut	: std_logic_vector(N - 1 downto 0);
	signal DataStrLd	: std_logic;
begin

	-- CPU
	cpu: entity cpu_design.cpu(rtl)
		generic map (
		N => N,
		DataAddrWidth => DataAddrWidth,
		InstWidth => InstWidth,
		InstAddrWidth => InstAddrWidth
		)
		port map (
		rst => rst,
		clk => clk,

		PrStrDataOut => PrStrDataOut,
		PrStrAddrIn => PrStrAddrIn,
		DataStrAddrIn => DataStrAddrIn,
		DataStrIn => DataStrIn,
		DataStrOut => DataStrOut,
		DataStrLd => DataStrLd
		);

	-- Program Storage (Interface zum Programmspeicher)
	program_storage: entity cpu_design.ram_block(rtl)
		generic map (
		DataWidth => InstWidth,
		AddrWidth => InstAddrWidth,

		-- Debugging / Simulation
		initPS => '1',
		ProgrammNo => ProgrammNo
		)
		port map (
		rst => rst,
		clk => clk,
		DataOut => PrStrDataOut,
		AddrIn => PrStrAddrIn
		);

	-- Data Storage (Interface zum Datenspeicher)
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