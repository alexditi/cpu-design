library ieee;
use ieee.std_logic_1164.all;
library cpu_design;

entity andgate_tb is
end entity andgate_tb;

architecture test of andgate_tb is

	signal and_in : std_logic_vector(1 downto 0) := (others => '0');
	alias in_1 is and_in(0);
	alias in_2 is and_in(1);
	signal out_1 : std_logic;

begin

	-- Instantiate the Design Under Test
	dut: entity cpu_design.and_gate(rtl)
		port map (
			input_1 => in_1,
			input_2 => in_2,
			and_output => out_1
		);

	-- Generate test stimulus
	stimulus:
	process begin

		-- Generate Inputs for AND Gate
		and_in <= "00";
		wait for 100 ns;
		and_in <= "01";
		wait for 100 ns;
		and_in <= "10";
		wait for 100 ns;
		and_in <= "11";
		wait for 100 ns;

		wait;
	end process stimulus;
end architecture test;
