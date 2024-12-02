library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library cpu_design;

entity control_logic_tb is
end entity control_logic_tb;

architecture tb of control_logic_tb is

	constant clkPeriod	: time := 100 ns;

	signal rst		: std_logic := '0';
	signal clk		: std_logic := '0';

	signal OpcodeIn		: std_logic_vector( 4 downto 0) := "00000";

begin

	-- Instantiate the Design Under Test
	dut: entity cpu_design.control_logic(rtl)
		generic map (
		N => 8,
		OpcodeSize => 5
		)
		port map (

		-- CPU Reset
		rst => rst,

		-- CPU Clock
		clk => clk,

		-- Opcode
		OpcodeIn => OpcodeIn

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

		for i in 0 to 31 loop
			OpcodeIn <= std_logic_vector(to_unsigned(i, 5));
			wait for clkPeriod;
		end loop;

		wait;
	end process stimulus;
end architecture tb;