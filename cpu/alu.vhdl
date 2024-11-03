library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is

	port(
	carry_in	: in std_logic;
	operand1	: in signed(7 downto 0);
	operand2	: in signed(7 downto 0);
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

	result		: out signed(7 downto 0);
	flags		: out std_logic_vector(4 downto 0) );

end alu;

architecture rtl of alu is

	-- ALU Flags
	signal carry_out: std_logic := '0';
	signal overflow	: std_logic := '0';
	signal negative	: std_logic := '0';
	signal sign	: std_logic := '0';
	signal zero	: std_logic := '0';

begin

	-- Flags beschreiben
	flags(0) <= carry_out;
	flags(1) <= overflow;
	flags(2) <= negative;
	flags(3) <= sign;
	flags(4) <= zero;

end rtl;