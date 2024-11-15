library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library cpu_design;

entity register_file_tb is
end entity register_file_tb;

architecture tb of register_file_tb is
	signal clk	: std_logic := '0';
	signal clr	: std_logic := '0';
	signal load	: std_logic := '0';

	signal DataIn	: std_logic_vector(7 downto 0);
	signal Rd	: integer range 0 to 7;
	signal Rs	: integer range 0 to 7;

begin

	-- Instantiate the Design Under Test
	dut: entity cpu_design.register_file(rtl)
		port map (
			clk => clk,
			clr => clr,
			rWrite => load,
			dataIn => DataIn,
			Rs => Rs,
			Rd => Rd
		);

	-- Generate clock signal
	clock:
	process begin
		wait for 50 ns;
		clk <= not clk;
	end process clock;

	-- Generate test stimulus
	stimulus:
	process begin

		-- Generate Input for Register
		wait for 25 ns;

		load <= '1';
		for i in 0 to 7 loop
			dataIn <= std_logic_vector(to_unsigned(i, 8));
			Rd <= i;
			Rs <= i;
			wait for 100 ns;
		end loop;

		load <= '0';
		dataIn <= (others => '0');

		for i in 0 to 6 loop
			Rd <= i;
			Rs <= i + 1;
			wait for 100 ns;
		end loop;

		wait;
	end process stimulus;
end architecture tb;