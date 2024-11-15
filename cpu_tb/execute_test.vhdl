library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library cpu_design;

entity execute_tb is
end entity execute_tb;

architecture tb of execute_tb is

	constant clkPeriod	: time := 100 ns;

	signal rst		: std_logic := '0';
	signal clk		: std_logic := '0';

	signal RegFileLoad	: std_logic := '0';
	signal AluOpSel		: std_logic_vector(3 downto 0) := "0000";
	signal RegFileDataSel	: std_logic_vector(1 downto 0) := "00";

	signal SCRin		: std_logic_vector(7 downto 0) := "00000000";

	signal DataIn		: std_logic_vector(7 downto 0) := "00000000";

	signal RdIn		: integer range 0 to 7 := 0;
	signal RsIn		: integer range 0 to 7 := 0;
	signal DataImmediate	: std_logic_vector(7 downto 0) := "00000000";

begin

	-- Instantiate the Design Under Test
	dut: entity cpu_design.execute(rtl)
		generic map(
		N => 8,
		rCount => 8,
		DataAddrWidth => 12
		)
		port map (
		rst => rst,
		clk => clk,
		RegFileLoad => RegFileLoad,
		AluOpSel => AluOpSel,
		RegFileDataSel => RegFileDataSel,
		SCRin => SCRin,
		DataIn => DataIn,
		RdIn => RdIn,
		RsIn => RsIn,
		DataImmediate => DataImmediate
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
		wait for clkPeriod / 4;

		-- reset
		rst <= '1';
		wait for clkPeriod;
		rst <= '0';

		-- Load Immediate r0=5
		RegFileLoad <= '1';
		AluOpSel <= "0000";
		RegFileDataSel <= "00";

		RdIn <= 0;
		DataImmediate <= "00000101";
		wait for clkPeriod;

		-- Load Immediate r1=10
		RdIn <= 1;
		DataImmediate <= "00001010";
		wait for clkPeriod;

		-- Load from RAM r2=35
		RegFileDataSel <= "01";

		RdIn <= 2;
		DataIn <= "00100011";
		wait for clkPeriod;

		-- Load from SCR r3="00000001"
		RegFileDataSel <= "10";

		RdIn <= 3;
		SCRin <= "00000001";
		wait for clkPeriod;

		-- Load from ALU r0 = r1 = r1 - r0
		RegFileDataSel <= "11";
		AluOpSel <= "0011";

		RdIn <= 1;
		RsIn <= 0;
		wait for clkPeriod;

		-- move r1 to r6
		AluOpSel <= "0000";

		RdIn <= 6;
		RsIn <= 1;
		wait for clkPeriod;

		-- move r6 to r7
		RdIn <= 7;
		RsIn <= 6;
		wait for clkPeriod;

		-- output r2 to RAM & SFR
		RegFileLoad <= '0';

		RsIn <= 2;
		wait for clkPeriod;

		wait;
	end process stimulus;
end architecture tb;