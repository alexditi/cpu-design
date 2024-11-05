library ieee;
use ieee.std_logic_1164.all;

entity adder is
	generic(
	N		: integer := 8		-- Standardbreite 8 Bit
	);

	port(
	inputA		: in std_logic_vector(N - 1 downto 0);
	inputB		: in std_logic_vector(N - 1 downto 0);
	cIn		: in std_logic;

	output		: out std_logic_vector(N - 1 downto 0);
	cOut		: out std_logic
	);

end adder;

architecture rtl of adder is

	-- Carry zwischen den einzelnen Addierern
	signal c	: std_logic_vector(N downto 0);

begin

	-- cin beschreiben
	c(0) <= cIn;

	-- cout beschreiben
	cOut <= c(N);

	-- N Volladdierer verketten und dabei c(i+1) beschreiben (=> cin für nächsten Addierer)
	generate_adder: for i in 0 to N - 1 generate
		output(i) <= (inputA(i) xor inputB(i)) xor c(i);
		c(i + 1) <= (inputA(i) and inputB(i)) or (c(i) and (inputA(i) xor inputB(i)));
	end generate generate_adder;

end rtl;