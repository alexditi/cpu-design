library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
	-- 0b0010	: sub
	-- 0b0011	: inc
	-- 0b0100	: dec
	-- 0b0101	: and
	-- 0b0110	: or
	-- 0b0111	: xor
	-- 0b1000	: not
	-- 0b1001	: sll
	-- 0b1010	: slr

	result		: out std_logic_vector(N - 1 downto 0);
	flags		: out std_logic_vector(4 downto 0) );

end alu;

architecture rtl of alu is

	-- ALU Flags
	signal carryOut	: std_logic := '0';
	signal overflow	: std_logic := '0';
	signal negative	: std_logic := '0';
	signal sign	: std_logic := '0';
	signal zero	: std_logic := '0';

begin

	aluOperation : process(operand1, operand2, carryIn, operation)
	begin

	-- Hier wird die ALU Operation ausgeführt und auf den Ausgang geschrieben
	case operation is
	when "0001" =>
		-- add
	when "0010" =>
		-- sub
	when "0011" =>
		-- inc
	when "0100" =>
		-- dec
	when "0101" =>
		-- and
		result <= operand1 and operand2;
	when "0110" =>
		-- or
		result <= operand1 and operand2;
	when "0111" =>
		-- xor
		result <= operand1 xor operand2;
	when "1000" =>
		-- not
		result <= not operand1;
	when "1001" =>
		-- sll
		carryOut <= operand1(N - 1);
		for i in N - 2 downto 0 loop
			result(i + 1) <= operand1(i);
		end loop;
		result(0) <= '0';
	when "1010" =>
		-- slr
		for i in 0 to N - 2 loop
			result (i) <= operand1(i + 1);
		end loop;
		result(N - 1) <= '0';
	when others =>
		-- nop
		result <= operand2;
	end case;

	end process aluOperation;

	-- NOTIZ: Wenn das zu komisch / zu kompliziert wird mit dem Process für die ALU Operationen,
	-- dann für alle Operationen (logische einzlen und ALU 1x) die outputs außerhalb eines Process generieren
	-- und dann mit when zusammenlegen
	-- entspricht auch mehr dem Sinn der eigentlichen Synthese
	-- ABER: Zuerst über den Process probieren und testen

	-- Flags beschreiben
	flags(0) <= carryOut;
	flags(1) <= overflow;
	flags(2) <= negative;
	flags(3) <= sign;
	flags(4) <= zero;

end rtl;