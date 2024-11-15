library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library cpu_design;

entity fetch_tb is
end entity fetch_tb;

architecture tb of fetch_tb is

	constant clkPeriod	: time := 100 ns;

	signal rst		: std_logic := '0';
	signal clk		: std_logic := '0';

	-- Control Signals
	signal PrStrAddrSel	: std_logic_vector(1 downto 0) := "00";
	signaL PCload		: std_logic := '0';
	signal PCldInBuf	: std_logic := '0';
	signal PCldOutBuf	: std_logic := '0';
	signal PCselOutBuf	: std_logic := '0';

	-- Interface Program Storage
	signal PrStrDataOut	: std_logic_vector(15 downto 0);

	-- Interface RAM / Stack
	signal DataIn		: std_logic_vector(7 downto 0);

	-- Interface Decoder
	signal AddrIn		: std_logic_vector(10 downto 0);
	signal OffsetIn		: std_logic_vector(4 downto 0);

	-- Stack variables
	signal DataOut		: std_logic_vector(7 downto 0);
	signal Stack0		: std_logic_vector(7 downto 0);
	signal Stack1		: std_logic_vector(7 downto 0);

begin

	-- Instantiate the Design Under Test
	dut: entity cpu_design.fetch(rtl)
		generic map(
		N => 8,
		InstAddrWidth => 11,
		InstWidth => 16
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
		DataIn => DataIn,
		DataOut => DataOut,
		AddrIn => AddrIn,
		OffsetIn => OffsetIn
		);

	-- Generate clock signal
	clock:
	process begin
		wait for clkPeriod / 2;
		clk <= not clk;
	end process clock;

	-- Generate test stimulus
	stimulus:
	process begin
		wait for clkPeriod * 0.51;

		-- reset
		rst <= '1';
		wait for clkPeriod;
		rst <= '0';

		-- Normale Instruktion: PC ausgeben und erhöhen
		PrStrAddrSel <= "10";
		Pcload <= '1';
		wait for clkPeriod;

		-- Normale Instruktion: PC ausgeben und erhöhen
		PrStrAddrSel <= "10";
		PCload <= '1';
		wait for clkPeriod;

		-- jpa: Adresse von Dekoder ausgeben und +1 in PC laden
		PrStrAddrSel <= "11";
		PCload <= '1';
		AddrIn <= "00000001100";
		wait for clkPeriod;

		-- Normale Instruktion: PC ausgeben und erhöhen
		PrStrAddrSel <= "10";
		PCload <= '1';
		wait for clkPeriod;

		-- branch: Offset zu Adresse addieren und +1 in PC laden
		PrStrAddrSel <= "01";
		PCload <= '1';
		OffsetIn <= "11010";
		wait for clkPeriod;

		-- Normale Instruktion: PC ausgeben und erhöhen
		PrStrAddrSel <= "10";
		PCload <= '1';
		wait for clkPeriod;

		-- jsr: PC auf Stack speichern und zu Adresse springen
		AddrIn <= "00000111110"; -- jsr Ziel
		-- 1: Nicht laden, Buffer LSB laden, MSB Stack schreiben
		PrStrAddrSel <= "11";
		PCload <= '0';
		PCldOutBuf <= '1';
		PCselOutBuf <= '0';
		wait for clkPeriod;
		Stack0 <= DataOut;
		-- 2: PC laden, LSB von Buffer auf Stack schreiben
		PCload <= '1';
		PCldOutBuf <= '0';
		PCselOutBuf <= '1';
		wait for clkPeriod;
		Stack1 <= DataOut;

		-- Normale Instruktion: PC ausgeben und erhöhen
		PrStrAddrSel <= "10";
		PCload <= '1';
		wait for clkPeriod;

		-- ret: PC von Stack holen
		-- 1: Nicht laden, Buffer mit LSB laden
		DataIn <= Stack1;
		PrStrAddrSel <= "00";
		PCload <= '0';
		PCldInBuf <= '1';
		wait for clkPeriod;
		-- 2: MSBs von Stack holen und mit LSBs an PC geben. PC laden
		DataIn <= Stack0;
		PCload <= '1';
		PCldInBuf <= '0';
		wait for clkPeriod;

		-- Normale Instruktion: PC ausgeben und erhöhen
		PrStrAddrSel <= "10";
		PCload <= '1';

		wait;
	end process stimulus;
end architecture tb;