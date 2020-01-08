library ieee;
use ieee.std_logic_1164.all;

entity two_one_mux is
	generic (
		inputWidth: Integer := 5
		);
	port (
		inputA, inputB: in std_logic_vector(inputWidth-1 downto 0);
		sel: in std_logic;
		output: out std_logic_vector(inputWidth-1 downto 0)
	);
end entity;

architecture arch of two_one_mux is

	begin
		process(inputA, inputB, sel)
		begin
			if(sel = '0') then
				output <= inputA;
			else
				output <= inputB;
			end if;
		end process;
end architecture ; -- arch



