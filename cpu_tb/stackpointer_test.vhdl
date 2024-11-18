library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library cpu_design;

entity stackpointer_tb is
end entity stackpointer_tb;

architecture tb of stackpointer_tb is

	constant clkPeriod	: time := 100 ns;

	signal rst		: std_logic := '0';
	signal clk		: std_logic := '0';

	-- ControlSignals
	signal SPinc		: std_logic := '0';
	signal SPdec		: std_logic := '0';

begin

	-- Instantiate the Design Under Test
	dut: entity cpu_design.stackpointer(rtl)
		generic map(
		DataAddrWidth => 12
		)
		port map (
		rst => rst,
		clk => clk,
		SPinc => SPinc,
		SPdec => SPdec
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

		-- inc Test
		SPinc <= '1';
		wait for clkPeriod * 3;

		-- dec Test
		SPinc <= '0';
		SPdec <= '1';
		wait for clkPeriod * 3;

		wait;
	end process stimulus;
end architecture tb;