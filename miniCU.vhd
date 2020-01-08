library ieee;
library kumar;
use kumar.csc343Fall2019.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity miniCU is
  port (
	opCode: in std_logic_vector(5 downto 0);
	a,b: in std_logic_vector(31 downto 0);
	output : out std_logic_vector(31 downto 0);
	carry, overflow_flag, negative_flag, zero_flag: out std_logic
  );
end entity; -- CULite

architecture arch of miniCU is

	signal sum: std_logic_vector(31 downto 0);
	signal addCarry: std_logic;
	signal addOverflow_flag: std_logic;
	signal addNegative_flag: std_logic;
	signal addZero_flag: std_logic;

	signal subSum: std_logic_vector(31 downto 0);
	signal subCarry: std_logic;
	signal subOverflow_flag: std_logic;
	signal subnegative_flag: std_logic;
	signal subzero_flag: std_logic;

begin
		A1: nBitFullAdder generic map(nBits => 32) port map(input1 => a, input2 => b, immediate => '0',
															   addOrSub => '0', signedUnsignedSwitch => '0',
															   sum => sum, carry => addCarry, overflow_flag => addOverflow_flag,
															   negative_flag => addNegative_flag, zero_flag => addZero_flag);
		
		S1: nBitFullAdder generic map(nBits => 32) port map(input1 => a, input2 => b, immediate => '0',
															   addOrSub => '1', signedUnsignedSwitch => '0',
															   sum => subSum, carry => subCarry, overflow_flag => subOverflow_flag,
															   negative_flag => subNegative_flag, zero_flag => subzero_flag);

		process(opCode, a, b, sum, addCarry, addOverflow_flag, addZero_flag, addNegative_flag, subSum, subCarry, subOverflow_flag, 
				subZero_flag, subnegative_flag) 
		begin
			if opCode = "000000" then
				output <= sum; carry <= addCarry; overflow_flag <= addOverflow_flag; 
				zero_flag <= addZero_flag; negative_flag <= addNegative_flag;
			elsif opCode = "000001" then
				 output <= subSum; carry <= subCarry; overflow_flag <= subOverflow_flag; 
				 zero_flag <= subZero_flag; negative_flag <= subNegative_flag;
			else 
				 output <= (others => '0'); carry <= '0'; overflow_flag <= '0'; 
				 zero_flag <= '0'; negative_flag <= '0';
			end if;
		end process; -- 
end architecture ; -- arch







