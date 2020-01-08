library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Input32 is
port(input: in std_logic_vector(7 downto 0) := (others => '0');
pushEight: in std_logic:= '0';
output: out std_logic_vector(31 downto 0) := (others => '0'));
end entity Input32;

architecture arch of Input32 is
signal a,b,c,d : std_logic_vector(7 downto 0) := (others => '0');

begin
	process(pushEight)
	variable counter : Integer := 0;
		begin
			if (pushEight'event and pushEight = '0') then
				if(counter = 0) then
					a <= input;
					counter := counter + 1;
				elsif(counter = 1) then
					b <= input;
					counter := counter + 1;
				elsif(counter = 2) then
					c <= input;
					counter := counter + 1;
				elsif(counter = 3) then
					d <= input;
					counter := 0;
				end if;
			else
				null;
			end if;
		output <= a & b & c & d;
	end process;  

end arch;



