library ieee;
use ieee.std_logic_1164.all;

entity ALUController is
	port (
		input: in std_logic_vector(1 downto 0);
		func: in std_logic_vector(5 downto 0);
		output: out std_logic_vector(5 downto 0)
	);
end entity;

architecture arch of ALUController is

begin

	--for lw and store word control signal is 00
	-- for beq we make control signal 01
	-- for R - format we make control signla 10
	process(input, func)
	begin
		if(input = "00") then
			output <= "000000";
		elsif(input = "01") then --Branching, we need subtract op
			output <= "000001";
		elsif(input <= "10") then
			if(func = "100010") then
				output <= "000001";
			elsif (func = "100000") then
				output <= "000000";
			else
				output <= "111111";
			end if;
			else
				output <= "111111";
		end if;
	end process;
end architecture ; -- arch



