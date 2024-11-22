library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library cpu_design;

entity ram_tb is
end entity ram_tb;

architecture tb of ram_tb is

	constant clkPeriod	: time := 100 ns;

	signal clk		: std_logic := '0';
	signal rst		: std_logic := '0';
	signal WriteEn		: std_logic := '0';
	signal AddrIn		: std_logic_vector(11 downto 0);
	signal DataIn		: std_logic_vector(7 downto 0);

begin

	-- Instantiate the Design Under Test
	dut: entity cpu_design.ram_block(rtl)
		generic map (
		DataWidth => 8,
		AddrWidth => 12
		)
		port map (
		clk => clk,
		rst => rst,
		WriteEn => WriteEn,
		AddrIn => AddrIn,
		DataIn => DataIn
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

		-- Schreiben
		WriteEn <= '1';

		-- Daten verteilen
		DataIn <= "10101010";
		AddrIn <= X"001";
		wait for clkPeriod;

		DataIn <= "01010101";
		AddrIn <= X"00F";
		wait for clkPeriod;
		WriteEn <= '0';

		AddrIn <= X"000";
		wait for clkPeriod;

		AddrIn <= X"001";
		wait for clkPeriod;

		AddrIn <= X"00F";

		wait;
	end process stimulus;
end architecture tb;