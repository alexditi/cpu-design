library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library cpu_design;

entity writeback_tb is
end entity writeback_tb;

architecture tb of writeback_tb is

	constant clkPeriod	: time := 100 ns;

	signal rst		: std_logic := '0';
	signal clk		: std_logic := '0';

	-- Control Signals
	signal SPinc		: std_logic := '0';
	signal SPdec		: std_logic := '0';
	signal DataStrAddrSel	: std_logic_vector(1 downto 0) := "00";
	signal DataStrInSel	: std_logic := '0';
	signal DataStrLoad	: std_logic := '0';

	-- Interface Control Logic
	signal Pbit		: std_logic;

	-- Interface Execute / ALU
	signal r6In		: std_logic_vector(7 downto 0);
	signal r7In		: std_logic_vector(7 downto 0);
	signal ALUDataIn	: std_logic_vector(7 downto 0);

	-- Interface Decoder
	signal DataAddressIn	: std_logic_vector(7 downto 0);
	signal DataOffsetIn	: std_logic_vector(4 downto 0);

	-- Interface Fetch
	signal PCtoStack	: std_logic_vector(7 downto 0);

	-- Interface to Data Storage
	signal DataStrOut	: std_logic_vector(7 downto 0);

begin

	-- Instantiate the Design Under Test
	dut: entity cpu_design.writeback(rtl)
		generic map(
		N => 8,
		DataAddrWidth => 12
		)
		port map (
		rst => rst,
		clk => clk,
		SPinc => SPinc,
		SPdec => SPdec,
		DataStrAddrSel => DataStrAddrSel,
		DataStrInSel => DataStrInSel,
		DataStrLoad => DataStrLoad,
		Pbit => Pbit,
		r6In => r6In,
		r7In => r7In,
		ALUDataIn => ALUDataIn,
		DataAddressIn => DataAddressIn,
		DataOffsetIn => DataOffsetIn,
		PCtoStack => PCtoStack,
		DataStrOut => DataStrOut
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

		-- write Page Register
		Pbit <= '1';
		r6In <= "10100110";
		wait for clkPeriod;
		Pbit <= '0';

		-- Stack (from PC)
		PCtoStack <= "00001100";
		DataStrAddrSel <= "00";
		DataStrInSel <= '0';
		SPinc <= '1';
		wait for clkPeriod;

		-- Stack 2 (from PC)
		PCtoStack <= "10101010";
		DataStrAddrSel <= "00";
		wait for clkPeriod;
		SPinc <= '0';

		-- Stack 2 (to PC)
		DataStrAddrSel <= "01";
		SPdec <= '1';
		wait for clkPeriod;
		
		-- Stack (to PC)
		wait for clkPeriod;
		SPdec <= '0';

		-- indirekt
		ALUDataIn <= "11110000";
		r7In <= "00111100";
		DataOffsetIn <= "00001";
		DataStrAddrSel <= "10";
		wait for clkPeriod;

		-- direkt
		ALUDataIn <= "10100101";
		DataAddressIn <= "11100011";
		DataStrAddrSel <= "11";

		wait;
	end process stimulus;
end architecture tb;