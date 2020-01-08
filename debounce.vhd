library ieee;
use ieee.std_logic_1164.all;

entity debounce is 
port(
		inp: in std_logic;
		clk:	in std_logic;
		outp: out std_logic);
end debounce;

architecture arch of debounce is

signal delay1, delay2, delay3: std_logic := '0';

begin 
	process(clk)
		begin
		if(clk'event and clk='1') then
			delay1 <= inp;
			delay2 <= delay1;
			delay3 <= delay2;
		end if;
	end process;
	outp <= delay1 and delay2 and delay3;
end arch;





