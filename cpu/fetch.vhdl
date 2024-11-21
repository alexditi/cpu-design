library ieee;
use ieee.std_logic_1164.all;
library cpu_design;

entity fetch is
	generic (

	-- Definitionen
	N		: integer := 8; -- Datenbreite fetch Bereich
	InstAddrWidth	: integer := 11; -- Programmspeicher Adressbreite
	InstWidth	: integer := 16 -- Wortbreite Instruction
	);

	port (

	-- CPU Reset
	rst		: in std_logic;

	-- Clock
	clk		: in std_logic;

	-- Control Signals
	PrStrAddrSel	: in std_logic_vector(1 downto 0);
	PCload		: in std_logic;
	PCldInBuf	: in std_logic;
	PCldOutBuf	: in std_logic;
	PCselOutBuf	: in std_logic;

	-- Interface Program Storage
	PrStrDataOut	: in std_logic_vector(InstWidth - 1 downto 0);
	PrStrAddrIn	: out std_logic_vector(InstAddrWidth - 1 downto 0);

	-- Interface RAM / Stack
	DataIn		: in std_logic_vector(N - 1 downto 0);
	DataOut		: out std_logic_vector(N - 1 downto 0);

	-- Interface Decoder
	InstOut		: out std_logic_vector(InstWidth - 1 downto 0);
	AddrIn		: in std_logic_vector(InstAddrWidth - 1 downto 0);
	OffsetIn	: in std_logic_vector(4 downto 0)
	);

end fetch;

architecture rtl of fetch is

	signal PrStrAddr	: std_logic_vector(InstAddrWidth - 1 downto 0);

	signal OffsetAddr	: std_logic_vector(InstAddrWidth - 1 downto 0);
	signal OffsetBuf1	: std_logic_vector(InstAddrWidth - 1 downto 0);
	signal OffsetBuf2	: std_logic_vector(InstAddrWidth - 1 downto 0);

	signal PCin		: std_logic_vector(InstAddrWidth - 1 downto 0);
	signal PCout		: std_logic_vector(InstAddrWidth - 1 downto 0);

	signal AddrInputBuffer	: std_logic_vector(InstAddrWidth - 1 downto 0);
	signal InputBufferRout	: std_logic_vector(N - 1 downto 0);
	signal AddrOutputBuffer	: std_logic_vector(N - 1 downto 0);
	signal OutputBufferRout	: std_logic_vector(N - 1 downto 0);

	signal MARclk		: std_logic;

begin

	-- Instruction Bypass
	InstOut <= PrStrDataOut;

	-- MUX for PS Address
	PrStrAddr <= AddrInputBuffer when PrStrAddrSel = "00" else
		     OffsetAddr when PrStrAddrSel = "01" else
		     PCout when PrStrAddrSel = "10" else
		     AddrIn when PrStrAddrSel = "11";

	-- Address Register
	MARclk <= not clk;
	memory_address_register: entity cpu_design.reg(rtl)
		generic map ( N => InstAddrWidth )
		port map (
		clk => MARclk,
		clr => rst,
		dataWrite => '1',
		dataIn => PrStrAddr,
		dataOut => PrStrAddrIn
		);

	-- Calculate Offset Address
	OffsetBuf1(InstAddrWidth - 1 downto 5) <= (others => OffsetIn(4));
	OffsetBuf1(4 downto 0) <= OffsetIn;
	offset_adder: entity cpu_design.adder(rtl)
		generic map ( N => InstAddrWidth )
		port map (
		sub => '0',
		cin => '0',
		inputA => PCout,
		inputB => OffsetBuf1,
		output => OffsetBuf2
		);
	correct_adder: entity cpu_design.adder(rtl) -- Offsetwert muss um -1 korrigiert werden, da PC auf die Inst nach branch zeigt
		generic map ( N => InstAddrWidth )
		port map (
		sub => '1',
		cin => '1',
		inputA => OffsetBuf2,
		inputB => (others => '0'),
		output => OffsetAddr
		);

	-- Calculate Feedback Value for PC
	feedback_adder: entity cpu_design.adder(rtl)
		generic map ( N => InstAddrWidth )
		port map (
		sub => '0',
		cin => '1',
		inputA => PrStrAddr,
		inputB => (others => '0'),
		output => PCin
		);

	-- PC Register
	program_counter: entity cpu_design.reg(rtl)
		generic map ( N => InstAddrWidth )
		port map (
		clk => clk,
		clr => rst,
		dataWrite => PCload,
		dataIn => PCin,
		dataOut => PCout
		);

	-- Input Buffer
	AddrInputBuffer(InstAddrWidth - 1 downto N) <= DataIn(InstAddrWidth - N - 1 downto 0); -- Fülle die MSBs vom Puffer mit den Daten aus DataIn
	AddrInputBuffer(N - 1 downto 0) <= InputBufferRout; -- Fülle die LSBs mit den 8 Bit aus dem Pufferregister
	input_buffer: entity cpu_design.reg(rtl) -- Pufferregister für 8 Bit DataIn
		generic map ( N => N )
		port map (
		clk => clk,
		clr => rst,
		dataWrite => PCldInBuf,
		dataIn => DataIn,
		dataOut => InputBufferRout
		);

	-- Output Buffer
	AddrOutputBuffer(N - 1 downto InstAddrWidth - N) <= (others => '0');
	AddrOutputBuffer(InstAddrWidth - N - 1 downto 0) <= PCout(InstAddrWidth - 1 downto N); -- Fülle die LSBs von DataOut mit den MSBs von PCout
	DataOut <= AddrOutputBuffer when PCselOutBuf = '0' else -- Gebe entweder das Pufferregister (LSBs) oder die MSBs aus
		   OutputBufferRout when PCselOutBuf = '1';
	output_buffer: entity cpu_design.reg(rtl) -- Pufferregister für 8 Bit DataOut
		generic map ( N => N )
		port map (
		clk => clk,
		clr => rst,
		dataWrite => PCldOutBuf,
		dataIn => PCout(N - 1 downto 0),
		dataOut => OutputBufferRout
		);		

end rtl;