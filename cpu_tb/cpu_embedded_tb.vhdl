library ieee;
use ieee.std_logic_1164.all;
library cpu_design;

entity cpu_embedded_tb is
end entity cpu_embedded_tb;

architecture tb of cpu_embedded_tb is

	constant clkPeriod	: time := 100 ns;

	signal rst		: std_logic := '0';
	signal clk		: std_logic := '0';

begin

	-- Instantiate the Design Under Test
	dut: entity cpu_design.cpu_embedded(rtl)
		generic map (
		N => 8,
		DataAddrWidth => 12,
		InstWidth => 16,
		InstAddrWidth => 11,

		-- Debugging / Simulation
		ProgrammNo => 1
		)
		port map (
		rst => rst,
		clk => clk
		);

	-- Generate clock signal
	clock:
	process begin
		wait for clkPeriod / 2;
		clk <= not clk;
	end process clock;

	-- Generate reset signal
	reset:
	process begin
		wait for clkPeriod * 0.45;
		rst <= '1';
		wait for clkPeriod * 0.1;
		rst <= '0';
		wait;
	end process reset;

end architecture tb;