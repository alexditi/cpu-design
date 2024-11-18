library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library cpu_design;

entity stackpointer is

generic (
	DataAddrWidth	: integer := 12
	);

	port (

	-- Reset
	rst		: in std_logic;

	-- Clock
	clk		: in std_logic;

	-- Control Signals
	SPinc		: in std_logic;
	SPdec		: in std_logic;		-- dec ist SPload für aktuellen Wert - 1

	-- Interface DataAddr Selector
	SPnext		: out std_logic_vector(DataAddrWidth - 1 downto 0);
	SPprev		: out std_logic_vector(DataAddrWidth - 1 downto 0)

	);

end stackpointer;

architecture rtl of stackpointer is

	signal SP	: std_logic_vector(DataAddrWidth - 1 downto 0);
	signal SPin	: std_logic_vector(DataAddrWidth - 1 downto 0);

begin

	inc_register : process(clk)
	begin

	if rst = '1' then
		SP <= (others => '0');
	elsif rising_edge(clk) then
		if SPinc = '1' and SPdec = '0' then
			-- erhöhen
			SP <= std_logic_vector(unsigned(SP) + 1);
		elsif SPdec = '1' then
			-- dekrementierten Eingang speichern
			SP <= SPin;
		end if;
	end if;

	end process inc_register;

	-- decrement berechnen
	decrement: entity cpu_design.adder(rtl)
		generic map ( N => DataAddrWidth )
		port map (
		sub => '1',
		cin => '1',
		inputA => SP,
		inputB => (others => '0'),
		output => SPin
		);

	-- SP write outputs
	SPnext <= SP;
	SPprev <= SPin;

end rtl;