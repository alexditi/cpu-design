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
	signal Data	: integer := 0;
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

	-- Convert ALU inputs
	DataIn <= std_logic_vector(to_signed(Data, 8));

	-- Generate test stimulus
	stimulus:
	process begin

		-- Generate Clock
		clk <= not clk after 50 ns;

		-- Generate Input for Register
		wait for 25 ns;
		

		wait;
	end process stimulus;
end architecture tb;