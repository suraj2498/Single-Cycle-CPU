library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dataMemory is
	port (
		input: in std_logic_vector(31 downto 0);
		clk: in std_logic;
		addr: in std_logic_vector(4 downto 0);
		writeEn, readEn: in std_logic;
		output: out std_logic_vector(31 downto 0)
	);
end entity;

architecture arch of dataMemory is

	type memory is array (0 to 31) of std_logic_vector(31 downto 0);
	
	signal predefinedMem: memory := (
			x"00000007",
			x"00000011",
			x"000F0600",
			x"000000AD",
			x"C0000000",
			others => x"00000000"
		);

	begin

	process(clk)
	begin
		if (clk = '0' and clk'event) then
			if(writeEn = '1') then -- write to memory
				predefinedMem(to_integer(unsigned(addr))) <= input;
			end if;
		end if;
		
	end process;

		output <= predefinedMem(to_integer(unsigned(addr))) when (readEn = '1') else x"00000000";

end architecture ; -- arch


