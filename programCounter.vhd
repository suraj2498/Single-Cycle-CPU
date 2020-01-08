library ieee;
use ieee.std_logic_1164.all;

entity programCounter is
	port (
		input: in std_logic_vector(31 downto 0) := x"00000000";
		clk, reset: in std_logic;
		output: out std_logic_vector(31 downto 0)
	);
end entity;

architecture arch of programCounter is

	begin

		process(clk) is
			begin
				if(clk'event and clk = '0') then
					if(reset = '1') then
						output <= x"00000000";
					else
						output <= input;
					end if;
				end if;	
			end process;
end architecture ; -- arch




