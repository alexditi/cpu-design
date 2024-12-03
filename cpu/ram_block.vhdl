library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity ram_block is

	generic (
	DataWidth	: integer := 8;	-- Datenbreite RAM
	AddrWidth	: integer := 12;-- Adressbreite RAM

	-- Debug
	initPS		: std_logic := '0'-- Programmspeicher mit Initialisierungswerten beschreiben
	);

	port (

	-- CPU Reset
	rst		: in std_logic := '0';

	-- Clock
	clk		: in std_logic := '0';

	-- Steuersignal
	WriteEn		: in std_logic := '0';

	-- Interface
	AddrIn		: in std_logic_vector(AddrWidth - 1 downto 0) := (others => '0');
	DataIn		: in std_logic_vector(DataWidth - 1 downto 0) := (others => '0');
	DataOut		: out std_logic_vector(DataWidth - 1 downto 0) := (others => '0')

	);

end ram_block;

architecture rtl of ram_block is

	-- RAM Block Type
	type ram_block_type is array(0 to 2**AddrWidth - 1) of std_logic_vector(DataWidth - 1 downto 0);

	-- Function to initialize RAM from txt-File
	impure function initRAM return ram_block_type is
		file text_input_file	: text open read_mode is "C:\cpu-design\cpu\Program.txt";
		variable text_line	: line;
		variable ram_buf	: ram_block_type;
	begin
		ram_buf := (others => (others => '0'));
		for i in 0 to 2**AddrWidth - 1 loop
			if endfile(text_input_file) then
				return ram_buf;
			end if;
			readline(text_input_file, text_line);
			hread(text_line, ram_buf(i));
		end loop;
		return ram_buf;
	end function;

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
			elsif rst = '1' and initPS = '1' then
				-- Programmspeicher mit Programm initialisieren
				ram <= initRam;
			end if;
		end if;
	end process ram_process;

	-- Daten asynchron lesen
	DataOut <= ram(Addr);

end rtl;