library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instructionMemory is
	port (
		input: in std_logic_vector(31 downto 0);
		clk: in std_logic;
		address: in std_logic_vector(4 downto 0);
		writeEn: in std_logic;
		output: out std_logic_vector(31 downto 0)
	);
end entity;

architecture arch of instructionMemory is
	type memory is array(0 to 31) of std_logic_vector(31 downto 0);	
	signal predefinedMem: memory := (
			"10001100000000010000000000000000", -- Loads Reg1 with data_mem[0]   --0
			"10001100000000100000000000000001", -- Loads Reg2 with data_mem[1]   --1
			"10001100000000110000000000000010", -- Loads Reg3 with data_mem[2]   --2
			"10001100000001000000000000000011", -- Loads Reg4 with data_mem[3]   --3
			"10001100000001010000000000000100", -- Loads Reg5 with data_mem[4]   --4
			"00000000001000100011100000100000", -- Add reg 1 and 2 store in reg 7 --5
			"00000000011001110011100000100000", -- Add reg 3 and 7 store in reg 7 --6
			"00000000100001110011100000100000", -- Add reg 4 and 7 store in reg 7  --7
			"00000000101001110011100000100000", -- Add reg 5 and 7 store in reg 7  -8
			"10101100000001110000000000000000", -- Store the result into mem address 0  -9
			others => x"00000000"
		);
	begin
		process(clk)
		begin
			if(clk'event and clk = '0') then 	--write to instruction memory
				if(writeEn = '1') then
					predefinedMem(to_integer(unsigned(address))) <= input;
				else
					null;
				end if;
			end if;
		end process;
		output <= predefinedMem(to_integer(unsigned(address)));
end architecture ; 

