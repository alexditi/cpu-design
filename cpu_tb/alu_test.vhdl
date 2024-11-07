library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library cpu_design;

entity alu_tb is
end entity alu_tb;

architecture tb of alu_tb is
	signal cin	: std_logic := '0';
	signal A	: integer := 0;
	signal B	: integer := 0;
	signal A_in	: std_logic_vector(7 downto 0);
	signal B_in	: std_logic_vector(7 downto 0);

	signal operation: std_logic_vector(3 downto 0) := "0100";

	signal result	: std_logic_vector(7 downto 0);
	signal flags	: std_logic_vector(4 downto 0);

begin

	-- Instantiate the Design Under Test
	dut: entity cpu_design.alu(rtl)
		port map (
			carryIn => cin,
			operand1 => A_in,
			operand2 => B_in,
			operation => operation,
			result => result,
			flags => flags
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
		cin <= '1';
		wait for 100 ns;
		A <= 200;
		B <= 56;
		cin <= '0';
		wait for 100 ns;
		A <= -5;
		B <= -13;
		cin <= '1';
		wait for 100 ns;
		A <= 10;
		B <= -5;
		cin <= '0';
		wait for 100 ns;
		A <= 127;
		B <= 3;
		cin <= '1';

		wait;
	end process stimulus;
end architecture tb;