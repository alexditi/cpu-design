library ieee;
use ieee.std_logic_1164.all;

library cpu_design;

entity execute is

	-- Definitionen
	generic (
	N		: integer := 8;	-- Datenbreite execute  Bereich
	rCount		: integer := 8;	-- Registeranzahl Register File
	DataAddrWidth	: integer := 12	-- RAM Adressbreite
	);

	port (

	-- CPU Reset
	rst		: in std_logic;

	-- Clock
	clk		: in std_logic;

	-- Control Signals
	RegFileLoad	: in std_logic;
	AluOpSel	: in std_logic_vector(3 downto 0);
	RegFileDataSel	: in std_logic_vector(1 downto 0);

	-- Interface Control Logic
	SFout		: out std_logic_vector(4 downto 0);
	CBout		: out std_logic_vector(N - 6 downto 0);
	SCRin		: in std_logic_vector(N - 1 downto 0);

	-- Interface RAM Writeback
	PageOut		: out std_logic_vector(DataAddrWidth - N - 1 downto 0);
	AddressOut	: out std_logic_vector(N - 1 downto 0);
	DataOut		: out std_logic_vector(N - 1 downto 0);
	DataIn		: in std_logic_vector(N - 1 downto 0);

	-- Interface Decoder
	RdIn		: in integer range 0 to rCount - 1;
	RsIn		: in integer range 0 to rCount - 1;
	DataImmediate	: in std_logic_vector(N - 1 downto 0)
	);

end execute;

architecture rtl of execute is

	signal RegFileDataIn	: std_logic_vector(N - 1 downto 0);
	signal r6Buf		: std_logic_vector(N - 1 downto 0);
	signal ALUoperand1	: std_logic_vector(N - 1 downto 0);
	signal ALUoperand2	: std_logic_vector(N - 1 downto 0);
	signal ALUout		: std_logic_vector(N - 1 downto 0);

begin

	-- MUX Register File Data In
	RegFileDataIn <= DataImmediate when RegFileDataSel = "00" else
			 DataIn when RegFileDataSel = "01" else
			 SCRin when RegFileDataSel = "10" else
			 ALUout when RegFileDataSel = "11";

	-- Datenbreite r6 an Datenbreite Page Register anpassen
	PageOut <= r6Buf(DataAddrWidth - N - 1 downto 0);

	-- Control Bits ausgeben an Control Logic
	CBout <= ALUout(N - 1 downto 5);

	-- Data Out an RAM Writeback
	DataOut <= ALUout;

	-- Register File
	register_file: entity cpu_design.register_file(rtl)
		generic map (
		N => N,
		rCount => rCount
		)

		port map (
		clk => clk,
		clr => rst,
		rWrite => RegFileLoad,

		dataIn => RegFileDataIn,
		Rd => RdIn,
		Rs => RsIn,

		OP1 => ALUoperand1,
		OP2 => ALUoperand2,
		r6 => r6Buf,
		r7 => AddressOut
		);

	-- ALU
	alu: entity cpu_design.alu(rtl)
		generic map (
		N => N
		)

		port map (
		carryIn => SCRin(0),
		operand1 => ALUoperand1,
		operand2 => ALUoperand2,
		operation => AluOpSel,

		result => ALUout,
		flags => SFout
		);

end rtl;