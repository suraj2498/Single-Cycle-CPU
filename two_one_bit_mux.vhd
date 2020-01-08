library ieee;
use ieee.std_logic_1164.all;

entity two_one_bit_mux is
	port (
		inputA, inputB, sel: in std_logic;
		output: out std_logic
	);
end entity;

architecture arch of two_one_bit_mux is

	begin
		process(inputA, inputB, sel)
		begin
			if(sel = '0') then
				output <= sel or inputA;
			else
				output <= sel xnor inputB;
			end if;
		end process;
end architecture ; -- arch




