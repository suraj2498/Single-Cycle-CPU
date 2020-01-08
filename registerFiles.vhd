library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerFiles is
	port (
		dataIn: in std_logic_vector(31 downto 0);
		readAddr1: in std_LOGIC_VECTOR(4 downto 0);
		readAddr2: in std_logic_vector(4 downto 0);
		writeAddr: in std_LOGIC_VECTOR(4 downto 0);
		clock, writeEn: in std_logic;
		output1, output2: out std_logic_vector(31 downto 0)
	);
end entity;

architecture arch of registerFiles is

type memory is array(0 to 31) of std_logic_vector(31 downto 0);
	
	signal predefinedMem: memory := (
			others => x"00000000"
		);

	begin

		process(clock)
		begin
			--write to instruction memory
			if(clock'event and clock = '0') then
				if(writeEn = '1') then
					predefinedMem(to_integer(unsigned(writeAddr))) <= dataIn;
				else
					null;
				end if;
			end if;
		end process;
		output1 <= predefinedMem(to_integer(unsigned(readAddr1)));
		output2 <= predefinedMem(to_integer(unsigned(readAddr2)));
end arch;


