library ieee;
use ieee.std_logic_1164.all;

entity reg is

	generic (
	N		: integer := 8
	);

	port (
	clk		: in std_logic;
	clr		: in std_logic;
	dataWrite	: in std_logic;
	dataIn		: in std_logic_vector(N - 1 downto 0);

	dataOut		: out std_logic_vector(N - 1 downto 0)
	);

end reg;

architecture rtl of reg is

begin

	latch_register : process(clk)
	begin

	if clr = '0' then
		dataOut <= (others => '0');
	elsif rising_edge(clk) then
		if dataWrite = '1' then
			dataOut <= dataIn;
		end if;
	end if;

	end process latch_register;

end rtl;