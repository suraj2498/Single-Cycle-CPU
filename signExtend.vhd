library ieee;
use ieee.std_logic_1164.all;

entity signExtend is
	port (
		input: in std_logic_vector(15 downto 0);
		output: out std_logic_vector(31 downto 0)
	);
end entity;

architecture arch of signExtend is

	signal tempOut: std_logic_vector(15 downto 0);
begin
	process(input, tempOut)
		variable msb: std_logic;
		begin
			msb := input(15);
			tempOut <= (others => msb);
	end process;

	output <= tempOut & input;

end architecture ; 




