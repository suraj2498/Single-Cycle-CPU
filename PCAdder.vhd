library ieee;
library kumar;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use kumar.csc343Fall2019.all;

entity PCAdder is
	port (
		input: in std_logic_vector(31 downto 0);
		output: out std_logic_vector(31 downto 0)
	);
end entity;

architecture arch of PCAdder is

	begin

		add4: nBitFullAdder generic map(nBits => 32) port map(input1 => input, input2 => x"00000004", immediate => '0',
															   addOrSub => '0', signedUnsignedSwitch => '0',
															   sum => output);
end architecture ; -- arch


