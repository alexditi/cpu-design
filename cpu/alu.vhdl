library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library cpu_design;

entity alu is
	generic(
	N		: integer := 8				-- Datenbreite ALU
	);

	port(
	carryIn		: in std_logic;				-- Carry In von Control Unit für addc oder subc Befehl
	operand1	: in std_logic_vector(N - 1 downto 0);
	operand2	: in std_logic_vector(N - 1 downto 0);
	operation	: in std_logic_vector(3 downto 0);
	-- 0b0000	: nop
	-- 0b0001	: add
	-- 0b0010	: addc
	-- 0b0011	: sub
	-- 0b0100	: subc
	-- 0b0101	: inc
	-- 0b0110	: dec
	-- 0b0111	: and
	-- 0b1000	: or
	-- 0b1001	: xor
	-- 0b1010	: not
	-- 0b1011	: sll
	-- 0b1100	: slr

	result		: out std_logic_vector(N - 1 downto 0);
	flags		: out std_logic_vector(4 downto 0) );

end alu;

architecture rtl of alu is

	-- Addierer Inputs
	signal adderIn1	: std_logic_vector(N - 1 downto 0);
	signal adderIn2	: std_logic_vector(N - 1 downto 0);
	signal adderCin	: std_logic;
	signal adderSub	: std_logic;

	-- Operation outputs
	signal adder_out: std_logic_vector(N - 1 downto 0);
	signal and_out	: std_logic_vector(N - 1 downto 0);
	signal or_out	: std_logic_vector(N - 1 downto 0);
	signal xor_out	: std_logic_vector(N - 1 downto 0);
	signal not_out	: std_logic_vector(N - 1 downto 0);
	signal sll_out	: std_logic_vector(N - 1 downto 0);
	signal slr_out	: std_logic_vector(N - 1 downto 0);

	-- Operation carry
	signal sll_carry : std_logic;
	signal adder_carry: std_logic;

	-- ALU Flags
	signal carryOut	: std_logic := '0';
	signal overflow	: std_logic := '0';
	signal negative	: std_logic := '0';
	signal sign	: std_logic := '0';
	signal zero	: std_logic := '0';

begin

	-- adder inputs
	adderSub <= '1' when (operation = "0011" or operation = "0100" or operation = "0110") else	-- sub bei sub, subc, dec
		    '0';										-- sub=0 bei anderen
	adderCin <= '1' when (operation = "0101" or operation = "0110") else				-- cin=1 bei inc/dec
		    carryIn when (operation = "0010" or operation = "0100") else			-- cin=Flag bei addc/subc
		    '0';										-- cin=0 bei anderen
	adderIn1 <= operand1;
	adderIn2 <= (others => '0') when (operation = "0101" or operation = "0110") else		-- 0 bei inc/dec
		    operand2;										-- operand2 sonst

	-- adder operations
	adder: entity cpu_design.adder(rtl)
		port map (
			sub => adderSub,
			inputA => adderIn1,
			inputB => adderIn2,
			cIn => adderCin,
			output => adder_out,
			cOut => adder_carry
		);

	-- and
	and_out <= operand1 and operand2;

	-- or
	or_out <= operand1 or operand2;

	-- xor
	xor_out <= operand1 xor operand2;

	-- not
	not_out <= not operand1;

	-- sll
	sll_carry <= operand1(N - 1);
	sll_out(0) <= '0';
	generate_sll: for i in N - 2 downto 0 generate
		sll_out(i + 1) <= operand1(i);
	end generate generate_sll;

	-- slr
	slr_out(N - 1) <= '0';
	generate_slr: for i in 0 to N - 2 generate
		slr_out(i) <= operand1(i + 1);
	end generate generate_slr;

	-- Outputs der ALU beschreiben
	result <= operand2 when operation = "0000" else
		  adder_out when (operation ="0001" or operation = "0010" or operation ="0011" or operation = "0100" or operation = "0101" or operation = "0110") else
		  and_out when operation = "0111" else
		  or_out when operation = "1000" else
		  xor_out when operation = "1001" else
		  not_out when operation = "1010" else
		  sll_out when operation = "1011" else
		  slr_out when operation = "1100";

	-- Flags der ALU generieren

	-- Flags beschreiben
	flags(0) <= carryOut;
	flags(1) <= overflow;
	flags(2) <= negative;
	flags(3) <= sign;
	flags(4) <= zero;

end rtl;