library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library cpu_design;

entity control_logic is

	generic (
	N		: integer := 8;	-- Datenbreite Control Logic
	OpcodeSize	: integer := 5	-- Breite Opcode im Befehl
	);

	port (

	-- CPU Reset
	rst		: in std_logic;

	-- CPU Clock
	clk		: in std_logic;

	-- Steuersignale Fetch
	PrStrAddrSel	: out std_logic_vector(1 downto 0);
	PCload		: out std_logic;
	PCldInBuf	: out std_logic;
	PCldOutBuf	: out std_logic;
	PCselOutBuf	: out std_logic;

	-- Steuersignale Decode
	IRload		: out std_logic;

	-- Steuersignale Execute
	RegFileLoad	: out std_logic;
	AluOpSel	: out std_logic_vector(3 downto 0);
	RegFileDataSel	: out std_logic_vector(1 downto 0);

	-- Steuersignale Writeback
	SPinc		: out std_logic;
	SPdec		: out std_logic;
	DataStrAddrSel	: out std_logic_vector(1 downto 0);
	DataStrInSel	: out std_logic;
	DataStrLoad	: out std_logic;

	-- Interface Decode
	OpcodeIn	: in std_logic_vector(OpcodeSize - 1 downto 0) := (others => '0');
	ConditionIn	: in std_logic_vector(2 downto 0) := "000";
	ConditionSign	: in std_logic := '0';

	-- Interface Execute
	SFin		: in std_logic_vector(4 downto 0) := "00000";
	CBin		: in std_logic_vector(N - 6 downto 0) := (others => '0');
	SCRout		: out std_logic_vector(N - 1 downto 0);

	-- Interface Writeback
	Pbit		: out std_logic

	);

end control_logic;

architecture rtl of control_logic is

	-- Steuersignale intern
	signal SFRldCB		: std_logic; -- Lade Control Bits in SFR
	signal SFRldFlags	: std_logic; -- Lade Flags in SFR

	signal set2ndCycle	: std_logic; -- Setze zweiten Ausführungszyklus für Control Logic
	signal Cycle2active	: std_logic; -- Zweiter Zyklus aktiv

	signal takeBranch	: std_logic; -- Branch Condition erfüllt

	-- Status and Control Register output
	signal Flags		: std_logic_vector(4 downto 0);
	signal P		: std_logic;
	signal CBits		: std_logic_vector(N - 7 downto 0);
	signal Pload		: std_logic;
	signal ldP		: std_logic;

	-- Flags
	alias Cbit		: std_logic is Flags(0);
	alias Vbit		: std_logic is Flags(1);
	alias Nbit		: std_logic is Flags(2);
	alias Sbit		: std_logic is Flags(3);
	alias Zbit		: std_logic is Flags(4);

	-- Opcode Dekodierung
	signal Instruction	: std_logic_vector(2**OpcodeSize - 1 downto 0);
	alias I_nop		: std_logic is Instruction(0);
	alias I_add		: std_logic is Instruction(1);
	alias I_addc		: std_logic is Instruction(2);
	alias I_sub		: std_logic is Instruction(3);
	alias I_subc		: std_logic is Instruction(4);
	alias I_inc		: std_logic is Instruction(5);
	alias I_dec		: std_logic is Instruction(6);
	alias I_and		: std_logic is Instruction(7);
	alias I_or		: std_logic is Instruction(8);
	alias I_xor		: std_logic is Instruction(9);
	alias I_not		: std_logic is Instruction(10);
	alias I_sll		: std_logic is Instruction(11);
	alias I_slr		: std_logic is Instruction(12);
	alias I_mov		: std_logic is Instruction(13);
	alias I_psh		: std_logic is Instruction(14);
	alias I_pll		: std_logic is Instruction(15);
	alias I_stz		: std_logic is Instruction(16);
	alias I_ldz		: std_logic is Instruction(17);
	alias I_st		: std_logic is Instruction(18);
	alias I_ld		: std_logic is Instruction(19);
	alias I_ldi		: std_logic is Instruction(20);
	alias I_jpa		: std_logic is Instruction(21);
	alias I_bra		: std_logic is Instruction(22);
	alias I_brs		: std_logic is Instruction(23);
	alias I_brc		: std_logic is Instruction(24);
	alias I_call		: std_logic is Instruction(25);
	alias I_ret		: std_logic is Instruction(26);
	alias I_res1		: std_logic is Instruction(27);
	alias I_res2		: std_logic is Instruction(28);
	alias I_lcr		: std_logic is Instruction(29);
	alias I_stcr		: std_logic is Instruction(30);
	alias I_hlt		: std_logic is Instruction(31);

begin

	-- Status and Control Register Flags
	SCRflags: entity cpu_design.reg(rtl)
		generic map ( N => 5 )
		port map (
		clk => clk,
		clr => rst,
		dataWrite => SFRldFlags,
		dataIn => SFin,
		dataOut => Flags
		);
	SCRout(4 downto 0) <= Flags;

	-- Status and Control Register P-Bit
	Pload <= CBin(0) when P = '0' else
		 '0' when P = '1';
	ldP <= SFRldCB or P;
	SCRp: entity cpu_design.reg(rtl)
		generic map ( N => 1)
		port map (
		clk => clk,
		clr => rst,
		dataWrite => ldP,
		dataIn(0) => Pload,
		dataOut(0) => P
		);
	SCRout(5) <= P;
	Pbit <= P;

	-- Status and Control Register Control Bits
	SCRcb: entity cpu_design.reg(rtl)
		generic map ( N => N - 6 )
		port map (
		clk => clk,
		clr => rst,
		dataWrite => SFRldCB,
		dataIn => CBin(N - 6 downto 1),
		dataOut => CBits
		);
	SCRout(N - 1 downto 6) <= CBits;

	-- Branch Condition Calculation
	takeBranch <=	Cbit when ConditionIn = "000" else
			Vbit when ConditionIn = "001" else
			Nbit when ConditionIn = "010" else
			Sbit when ConditionIn = "011" else
			Zbit when ConditionIN = "100" else
			Zbit when ConditionIn = "101" else
			Cbit when ConditionIn = "110" and ConditionSign = '0' else
			not (Cbit or Zbit) when ConditionIn = "111" and ConditionSign = '0' else
			Sbit when ConditionIn = "110" and ConditionSign = '1' else
			not (Sbit or Zbit) when ConditionIn = "111" and ConditionSign = '1' else
			'0';

	-- Two Cycle Instructions
	twoCycle: entity cpu_design.reg(rtl)
		generic map ( N => 1 )
		port map (
		clk => clk,
		clr => rst,
		dataWrite => '1',
		dataIn(0) => set2ndCycle,
		dataOut(0) => Cycle2active
		);

	-- Decode Opcode
	decodeOpcode: process(OpcodeIn)
	begin
		Instruction <= (others => '0');
		Instruction(to_integer(unsigned(OpcodeIn))) <= '1';
	end process;

	-- Control Signal Generation
	-- Fetch
	PrStrAddrSel(1) <= not(I_bra or (I_brs and takeBranch) or (I_brc and not takeBranch) or I_ret); -- NOP Default 1
	PrStrAddrSel(0) <= I_jpa or I_bra or (I_brs and takeBranch) or (I_brc and not takeBranch) or I_call; -- NOP Default 0
	PCload <= not ((I_call and not Cycle2active) or (I_ret and not Cycle2active) or I_hlt); -- NOP Default 1
	PCldInBuf <= I_ret and not Cycle2active; -- NOP Default 0
	PCldOutBuf <= I_call and not Cycle2active; -- NOP Default 0
	PCselOutBuf <= I_call and Cycle2active; -- NOP Default 0

	-- Decode
	IRload <= not ((I_call and not Cycle2active) or (I_ret and not Cycle2active) or I_hlt); -- NOP Default 1

	-- Execute
	RegFileLoad <= I_add or I_addc or I_sub or I_subc or I_inc or I_dec or I_and or I_or or I_xor or I_not or I_sll or I_slr or I_mov or I_pll or I_ldz or I_ld or I_ldi or I_lcr; -- NOP Default 0
	AluOpSel(3) <= I_or or I_xor or I_not or I_sll or I_slr; -- NOP Default 0
	AluOpSel(2) <= I_subc or I_inc or I_dec or I_and or I_slr; -- NOP Default 0
	AluOpSel(1) <= I_addc or I_sub or I_dec or I_and or I_not or I_sll; -- NOP Default 0
	AluOpSel(0) <= I_add or I_sub or I_inc or I_and or I_xor or I_sll; -- NOP Default 0
	RegFileDataSel(1) <= I_add or I_addc or I_sub or I_subc or I_inc or I_dec or I_and or I_or or I_xor or I_not or I_sll or I_slr or I_mov or I_lcr; -- NOP Default 0
	RegFileDataSel(0) <= I_add or I_addc or I_sub or I_subc or I_inc or I_dec or I_and or I_or or I_xor or I_not or I_sll or I_slr or I_mov or I_pll or I_ldz or I_ld; -- NOP Default 0

	-- Writeback
	SPinc <= I_psh or I_call; -- NOP Default 0
	SPdec <= I_pll or I_ret; -- NOP Default 0
	DataStrAddrSel(1) <= I_stz or I_ldz or I_st or I_ld; -- NOP Default 0
	DataStrAddrSel(0) <= I_pll or I_st or I_ld or I_ret; -- NOP Default 0
	DataStrInSel <= I_psh or I_stz or I_st; -- NOP Default 0
	DataStrLoad <= I_psh or I_stz or I_st or I_call; -- NOP Default 0

	-- Internal
	SFRldCB <= I_stcr; -- NOP Default 0
	SFRldFlags <= I_add or I_addc or I_sub or I_subc or I_inc or I_dec or I_and or I_or or I_xor or I_not or I_sll or I_slr; -- NOP Default 0
	set2ndCycle <= (I_call and not Cycle2active) or (I_ret and not Cycle2active); -- NOP Default 0

end rtl;