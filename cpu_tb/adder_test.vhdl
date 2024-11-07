library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library cpu_design;

entity adder_tb is
end entity adder_tb;

architecture tb of adder_tb is
	signal cin	: std_logic := '0';
	signal A	: integer := 0;
	signal B	: integer := 0;
	signal cout	: std_logic := '0';
	signal result	: std_logic_vector(7 downto 0);
	signal A_in	: std_logic_vector(7 downto 0);
	signal B_in	: std_logic_vector(7 downto 0);

begin

	-- Instantiate the Design Under Test
	dut: entity cpu_design.adder(rtl)
		generic map ( N => 8 ) -- 8 Bit Adder
		port map (
			inputA => A_in,
			inputB => B_in,
			cIn => cin,
			output => result,
			cOut => cout
		);

	-- Convert ALU inputs
	A_in <= std_logic_vector(to_signed(A, 8));
	B_in <= std_logic_vector(to_signed(B, 8));

	-- Generate test stimulus
	stimulus:
	process begin

		-- Generate Inputs for Adder
		A <= 5;
		B <= 11;
		wait for 200 ns;
		A <= 200;
		B <= 56;
		wait for 200 ns;
		A <= -5;
		B <= -13;
		wait for 200 ns;
		A <= 10;
		B <= -5;
		wait for 200 ns;

		wait;
	end process stimulus;
end architecture tb;