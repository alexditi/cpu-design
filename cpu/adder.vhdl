library ieee;
use ieee.std_logic_1164.all;

entity adder is
	generic(
	N		: integer := 8		-- Standardbreite 8 Bit
	);

	port(
	sub		: in std_logic := '0';

	inputA		: in std_logic_vector(N - 1 downto 0);
	inputB		: in std_logic_vector(N - 1 downto 0);
	cIn		: in std_logic;

	output		: out std_logic_vector(N - 1 downto 0);
	cOut		: out std_logic;
	overflow	: out std_logic;
	sign		: out std_logic
	);

end adder;

architecture rtl of adder is

	-- Carry zwischen den einzelnen Addierern
	signal c	: std_logic_vector(N downto 0);
	signal inB	: std_logic_vector(N - 1 downto 0);

	signal output_buf: std_logic_vector (N - 1 downto 0);
	signal overflow_buf: std_logic;

begin

	-- cin beschreiben
	c(0) <= cIn xor sub;

	-- cout beschreiben
	cOut <= c(N) xor sub;

	-- overflow beschreiben
	overflow_buf <= c(N) xor c(N - 1);
	overflow <= overflow_buf;

	-- sign beschreiben
	sign <= output_buf(N - 1) xor overflow_buf;

	-- intputB invertieren bei sub
	generate_inv: for i in 0 to N - 1 generate
		inB(i) <= inputB(i) xor sub;
	end generate generate_inv;

	-- N Volladdierer verketten und dabei c(i+1) beschreiben (=> cin für nächsten Addierer)
	generate_adder: for i in 0 to N - 1 generate
		output_buf(i) <= (inputA(i) xor inB(i)) xor c(i);
		c(i + 1) <= (inputA(i) and inB(i)) or (c(i) and (inputA(i) xor inB(i)));
	end generate generate_adder;
	output <= output_buf;

end rtl;