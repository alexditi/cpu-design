library ieee;
use ieee.std_logic_1164.all;
library cpu_design;

entity register_file is

	generic (
	N		: integer := 8;
	rCount		: integer := 8
	);

	port (
	clk		: in std_logic;
	clr		: in std_logic;
	rWrite		: in std_logic;

	dataIn		: in std_logic_vector(N - 1 downto 0);
	Rs		: in integer range 0 to rCount - 1 := 0;
	Rd		: in integer range 0 to rCount - 1 := 0;

	OP1		: out std_logic_vector(N - 1 downto 0);
	OP2		: out std_logic_vector(N - 1 downto 0);
	r6		: out std_logic_vector(N - 1 downto 0);
	r7		: out std_logic_vector(N - 1 downto 0)
	);

end register_file;

architecture rtl of register_file is

	type DataArray is array(0 to rCount - 1) of std_logic_vector(N - 1 downto 0);

	signal rWriteBuf: std_logic_vector(rCount - 1 downto 0);
	signal Data	: DataArray;

begin

	-- Write Signal generieren
	write_signal: process(Rd)
	begin
	for i in 0 to rCount - 1 loop
		rWriteBuf(i) <= '1' when (i = Rd) else '0';
	end loop;
	end process;

	-- Ausgaben generieren

	-- Einzelne Register instanzieren
	generate_file: for i in 0 to rCount - 1 generate
		reg: entity cpu_design.reg(rtl)
			generic map ( N => N )
			port map (
			clk => clk,
			clr => clr,
			dataWrite => rWriteBuf(i),
			dataIn => dataIn,
			dataOut => Data(i)
			);
	end generate generate_file;
			

end rtl;
