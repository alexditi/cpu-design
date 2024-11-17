library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library cpu_design;

entity decode_tb is
end entity decode_tb;

architecture tb of decode_tb is

	constant clkPeriod	: time := 100 ns;

	signal rst		: std_logic := '0';
	signal clk		: std_logic := '0';

	-- Control Signals
	signal IRload		: std_logic := '0';

	-- Interface Fetch
	signal InstIn		: std_logic_vector(15 downto 0);

begin

	-- Instantiate the Design Under Test
	dut: entity cpu_design.decode(rtl)
		generic map(
		N => 8,
		OpcodeSize => 5,
		InstAddrWidth => 11,
		InstWidth => 16,
		rCount => 8
		)
		port map (
		rst => rst,
		clk => clk,
		IRload => IRload,
		InstIn => InstIn
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
		wait for clkPeriod * 0.45;

		-- reset
		rst <= '1';
		wait for clkPeriod * 0.1;
		rst <= '0';

		-- IR jeden Takt laden
		IRload <= '1';

		-- nop
		InstIn <= "00000XXXXXXXXXXX";
		wait for clkPeriod;

		-- add
		InstIn <= "00001101XXXXX111";
		wait for clkPeriod;

		-- inc
		InstIn <= "00101110XXXXXXXX";
		wait for clkPeriod;

		-- psh
		InstIn <= "01110XXXXXXXX101";
		wait for clkPeriod;

		-- stz
		InstIn <= "10000XXX10101111";
		wait for clkPeriod;

		-- ldz
		InstIn <= "1000110111001XXX";
		wait for clkPeriod;

		-- st
		InstIn <= "1001011001100101";
		wait for clkPeriod;

		-- ld
		InstIn <= "1001110111001100";
		wait for clkPeriod;

		-- ldi
		InstIn <= "1010010110101100";
		wait for clkPeriod;

		-- jpa
		InstIn <= "1010111001100110";
		wait for clkPeriod;

		-- bra
		InstIn <= "10110XXX10101XXX";
		wait for clkPeriod;

		-- brs
		InstIn <= "101111XX10101110";
		wait for clkPeriod;

		-- call
		InstIn <= "1100111001100110";
		wait for clkPeriod;

		-- ret
		InstIn <= "11010XXXXXXXXXXX";
		wait for clkPeriod;

		wait;
	end process stimulus;
end architecture tb;