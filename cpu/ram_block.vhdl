library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_block is

	generic (
	DataWidth	: integer := 8;	-- Datenbreite RAM
	AddrWidth	: integer := 12	-- Adressbreite RAM
	);

	port (

	-- CPU Reset
	rst		: in std_logic;

	-- Clock
	clk		: in std_logic;

	-- Steuersignal
	WriteEn		: in std_logic;

	-- Interface
	AddrIn		: in std_logic_vector(AddrWidth - 1 downto 0);
	DataIn		: in std_logic_vector(DataWidth - 1 downto 0);
	DataOut		: out std_logic_vector(DataWidth - 1 downto 0)

	);

end ram_block;

architecture rtl of ram_block is

	type ram_block_type is array(0 to 2**AddrWidth - 1) of std_logic_vector(DataWidth - 1 downto 0);
	signal ram	: ram_block_type;
	signal Addr	: integer range 0 to 2**AddrWidth - 1;

begin

	-- Convert Address
	Addr <= to_integer(unsigned(AddrIn));

	-- Process: Synchrones Schreiben
	ram_process: process(clk) is
	begin
		if rising_edge(clk) then
			if WriteEn = '1' then
				ram(Addr) <= DataIn;
			end if;
		end if;
	end process ram_process;

	-- Daten asynchron lesen
	DataOut <= ram(Addr);

end rtl;