library ieee;
library kumar;
use kumar.csc343Fall2019.all;
use ieee.std_logic_1164.all;

entity leftShifter is
	port (
		input: in std_logic_vector(31 downto 0);
		output: out std_logic_vector(31 downto 0)
	);
end entity;

architecture arch of leftShifter is

	begin
		process(input)
		begin
			output <= shiftLeftLogical(input, 2, input'length);
		end process;
end architecture ; -- arch



