-- SHOULD WORK WITH ALL BINARY VALUES WHOSE BITWISE LENGTH IS A MULTIPLE OF 4
library kumar;
library ieee;
use kumar.csc343Fall2019.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sevenSegDecoder is
	generic(n: Integer := 32); --Total Number of Bits
	port(input: in std_logic_vector(n-1 downto 0);
		  output: out std_logic_vector(55 downto 0)); -- Use Formula (7n/4)-1 to decide upper range
end entity;

architecture arch of SevenSegDecoder is
	signal decodedOutput: std_logic_vector(((n/4)*7)-1 downto 0):= (others => '1');
	signal loopNumber: Integer := n/4;
	begin
		process(input, loopNumber, decodedOutput)
			variable sliceOfInput: std_logic_vector(3 downto 0);
			begin
					for i in 0 to loopNumber - 1 loop
						sliceOfInput := input((4*i)+3 downto 4*i);
						decodedOutput((7*i)+6 downto 7*i) <= sevenSegmentDecoderToHex(sliceOfInput);
					end loop;
		end process;
		output <= decodedOutput;
end architecture ;

-- Format of Output Hex3 -> Output[20 downto 14], Hex2 -> Output[13 down to 7], Hex1 -> Output[6 downto 0]

