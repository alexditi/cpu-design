library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library cpu_design;

entity cpu_control_simulation_tb_1 is
end entity cpu_control_simulation_tb_1;

architecture tb of cpu_control_simulation_tb_1 is

	constant clkPeriod	: time := 100 ns;

	signal rst		: std_logic := '0';
	signal clk		: std_logic := '0';

	-- Control Signals
	signal PrStrAddrSel	: std_logic_vector(1 downto 0) := "00";
	signal PCload		: std_logic := '0';
	signal PCldInBuf	: std_logic := '0';
	signal PCldOutBuf	: std_logic := '0';
	signal PCselOutBuf	: std_logic := '0';
	signal IRload		: std_logic := '0';
	signal RegFileLoad	: std_logic := '0';
	signal AluOpSel		: std_logic_vector(3 downto 0) := "0000";
	signal RegFIleDataSel	: std_logic_vector(1 downto 0) := "00";
	signal SPinc		: std_logic := '0';
	signal SPdec		: std_logic := '0';
	signal DataStrAddrSel	: std_logic_vector(1 downto 0) := "00";
	signal DataStrInSel	: std_logic := '0';
	signal DataStrLoad	: std_logic := '0';

	-- Decode
	signal OpcodeIn		: std_logic_vector(4 downto 0) := "00000";
	signal ConditionIn	: std_logic_vector(2 downto 0) := "000";
	signal ConditionSign	: std_logic := '0';

	-- Execute
	signal SFin		: std_logic_vector(4 downto 0) := "00000";
	signal CBin		: std_logic_vector(2 downto 0) := "000";
	signal SCRout		: std_logic_vector(7 downto 0) := "00000000";

	-- Writeback
	signal Pbit		: std_logic := '0';

begin

	-- Instantiate the Design Under Test
	dut: entity cpu_design.cpu_control_simulation(rtl)
		generic map (
		DataAddrWidth => 12,		-- Adressbreite Datenspeicher
		InstWidth => 16,		-- Befehlsbreite
		InstAddrWidth => 11,		-- Adressbreite Programmspeicher
		OpcodeSize => 5,		-- Breite Opcode im Befehl
		rCount => 8			-- Registeranzahl Registerfile
		)
		port map (

		-- CPU Reset
		rst => rst,

		-- CPU Clock
		clk => clk,

		-- Steuersignale
		PrStrAddrSel => PrStrAddrSel,
		PCload => PCload,
		PCldInBuf => PCldInBuf,
		PCldOutBuf => PCldOutBuf,
		PCselOutBuf => PCselOutBuf,
		IRload => IRload,
		RegFileLoad => RegFileLoad,
		AluOpSel => AluOpSel,
		RegFIleDataSel => RegFIleDataSel,
		SPinc => SPinc,
		SPdec => SPdec,
		DataStrAddrSel => DataStrAddrSel,
		DataStrInSel => DataStrInSel,
		DataStrLoad => DataStrLoad,

		-- Decode
		OpcodeIn => OpcodeIn,
		ConditionIn => ConditionIn,
		ConditionSign => ConditionSign,

		-- Execute
		SFin => SFin,
		CBin => CBin,
		SCRout => SCRout,

		-- Writeback
		Pbit => Pbit

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

		-- Steuersignale NOP ausgeben (da InstIn = "00000")
		PrStrAddrSel <= "10";
		PCload <= '1';
		PCldInBuf <= '0';
		PCldOutBuf <= '0';
		PCselOutBuf <= '0';
		IRload <= '1';
		RegFileLoad <= '0';
		AluOpSel <= "0000";
		RegFIleDataSel <= "00";
		SPinc <= '0';
		SPdec <= '0';
		DataStrAddrSel <= "00";
		DataStrInSel <= '0';
		DataStrLoad <= '0';
		wait for clkPeriod;

		-- Steuersignale LDI ausgeben (da InstIn = "10100")
		PrStrAddrSel <= "10";
		PCload <= '1';
		PCldInBuf <= '0';
		PCldOutBuf <= '0';
		PCselOutBuf <= '0';
		IRload <= '1';
		RegFileLoad <= '1';
		AluOpSel <= "0000";
		RegFIleDataSel <= "00";
		SPinc <= '0';
		SPdec <= '0';
		DataStrAddrSel <= "00";
		DataStrInSel <= '0';
		DataStrLoad <= '0';
		wait for clkPeriod;

		-- Steuersignale MOV ausgeben (da InstIn = "01101")
		PrStrAddrSel <= "10";
		PCload <= '1';
		PCldInBuf <= '0';
		PCldOutBuf <= '0';
		PCselOutBuf <= '0';
		IRload <= '1';
		RegFileLoad <= '1';
		AluOpSel <= "0000";
		RegFIleDataSel <= "11";
		SPinc <= '0';
		SPdec <= '0';
		DataStrAddrSel <= "00";
		DataStrInSel <= '0';
		DataStrLoad <= '0';
		wait for clkPeriod;

		-- Steuersignale STR ausgeben (da InstIn = "10010")
		PrStrAddrSel <= "10";
		PCload <= '1';
		PCldInBuf <= '0';
		PCldOutBuf <= '0';
		PCselOutBuf <= '0';
		IRload <= '1';
		RegFileLoad <= '0';
		AluOpSel <= "0000";
		RegFIleDataSel <= "00";
		SPinc <= '0';
		SPdec <= '0';
		DataStrAddrSel <= "11";
		DataStrInSel <= '1';
		DataStrLoad <= '1';
		wait for clkPeriod;

		-- Steuersignale LD ausgeben (da InstIn = "10011")
		PrStrAddrSel <= "10";
		PCload <= '1';
		PCldInBuf <= '0';
		PCldOutBuf <= '0';
		PCselOutBuf <= '0';
		IRload <= '1';
		RegFileLoad <= '1';
		AluOpSel <= "0000";
		RegFIleDataSel <= "01";
		SPinc <= '0';
		SPdec <= '0';
		DataStrAddrSel <= "11";
		DataStrInSel <= '0';
		DataStrLoad <= '0';
		wait for clkPeriod;

		-- Steuersignale ADD ausgeben (da InstIn = "00001")
		PrStrAddrSel <= "10";
		PCload <= '1';
		PCldInBuf <= '0';
		PCldOutBuf <= '0';
		PCselOutBuf <= '0';
		IRload <= '1';
		RegFileLoad <= '1';
		AluOpSel <= "0001";
		RegFIleDataSel <= "11";
		SPinc <= '0';
		SPdec <= '0';
		DataStrAddrSel <= "00";
		DataStrInSel <= '0';
		DataStrLoad <= '0';
		wait for clkPeriod;

		-- Steuersignale SUB ausgeben (da InstIn = "00011")
		PrStrAddrSel <= "10";
		PCload <= '1';
		PCldInBuf <= '0';
		PCldOutBuf <= '0';
		PCselOutBuf <= '0';
		IRload <= '1';
		RegFileLoad <= '1';
		AluOpSel <= "0011";
		RegFIleDataSel <= "11";
		SPinc <= '0';
		SPdec <= '0';
		DataStrAddrSel <= "00";
		DataStrInSel <= '0';
		DataStrLoad <= '0';
		wait for clkPeriod;

		-- Steuersignale INC ausgeben (da InstIn = "00101")
		PrStrAddrSel <= "10";
		PCload <= '1';
		PCldInBuf <= '0';
		PCldOutBuf <= '0';
		PCselOutBuf <= '0';
		IRload <= '1';
		RegFileLoad <= '1';
		AluOpSel <= "0101";
		RegFIleDataSel <= "11";
		SPinc <= '0';
		SPdec <= '0';
		DataStrAddrSel <= "00";
		DataStrInSel <= '0';
		DataStrLoad <= '0';
		wait for clkPeriod;

		-- Steuersignale DEC ausgeben (da InstIn = "00110")
		PrStrAddrSel <= "10";
		PCload <= '1';
		PCldInBuf <= '0';
		PCldOutBuf <= '0';
		PCselOutBuf <= '0';
		IRload <= '1';
		RegFileLoad <= '1';
		AluOpSel <= "0110";
		RegFIleDataSel <= "11";
		SPinc <= '0';
		SPdec <= '0';
		DataStrAddrSel <= "00";
		DataStrInSel <= '0';
		DataStrLoad <= '0';
		wait for clkPeriod;

		-- Steuersignale NOP ausgeben (da InstIn = "00000")
		PrStrAddrSel <= "10";
		PCload <= '1';
		PCldInBuf <= '0';
		PCldOutBuf <= '0';
		PCselOutBuf <= '0';
		IRload <= '1';
		RegFileLoad <= '0';
		AluOpSel <= "0000";
		RegFIleDataSel <= "00";
		SPinc <= '0';
		SPdec <= '0';
		DataStrAddrSel <= "00";
		DataStrInSel <= '0';
		DataStrLoad <= '0';
		wait for clkPeriod;

		wait;
	end process stimulus;
end architecture tb;