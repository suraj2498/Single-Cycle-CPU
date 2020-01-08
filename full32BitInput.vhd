library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full32BitInput is
  port (
	input: in std_logic_vector(7 downto 0);
	btn, Clk: in std_logic;
	output: out std_logic_vector(31 downto 0)
  ) ;
end entity ; -- full32BitInput

architecture arch of full32BitInput is

component debounce is
	port (
		inp: in std_logic;
		clk:	in std_logic;
		outp: out std_logic
	);
end component debounce;

component Clock_Divider is
	port (
	 	clk: in std_logic;
		clock_out: out std_logic
	);
end component Clock_Divider;

component Input32 is
	port (
		input: in std_logic_vector(7 downto 0) := (others => '0');
		pushEight: in std_logic:= '0';
		output: out std_logic_vector(31 downto 0) := (others => '0')
	);
end component Input32;

signal slow_clock: std_logic;
signal debouncedBtn: std_logic;

begin

	cd1: Clock_Divider port map (
		clk => Clk,
		clock_out => slow_clock
	);

	d1: debounce port map (
		inp => btn,
		clk => slow_clock,
		outp =>debouncedBtn
	);

	i1: Input32 port map (
		input => input,
		pushEight => debouncedBtn,
		output => output
	);
end architecture ; -- arch


