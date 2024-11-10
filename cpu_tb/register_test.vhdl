library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library cpu_design;

entity register_tb is
end entity register_tb;

architecture tb of register_tb is
	signal clk	: std_logic := '0';
	signal clr	: std_logic := '0';
	signal load	: std_logic := '0';
	signal DataIn	: std_logic_vector(7 downto 0);
	signal DataOut	: std_logic_vector(7 downto 0);

begin

	-- Instantiate the Design Under Test
	dut: entity cpu_design.reg(rtl)
		port map (
			clk => clk,
			clr => clr,
			dataWrite => load,
			dataIn => DataIn,
			dataOut => DataOut
		
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

		DataIn <= "10100101";
		load <= '1';
		wait for 100 ns;

		DataIn <= "11110000";
		load <= '0';
		wait for 100 ns;

		clr <= '1';
		wait for 100 ns;

		clr <= '0';
		load <= '1';
		wait for 100 ns;

		load <= '0';
		dataIn <= "00000000";

		wait;
	end process stimulus;
end architecture tb;