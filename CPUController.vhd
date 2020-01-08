library ieee;
use ieee.std_logic_1164.all;

entity CPUController is
	port (
		OpCode: in std_logic_vector(5 downto 0);
		destReg, ALUinput, fillReg, registerWrite: out std_logic;
		readMem, writeMemory, branch: out std_logic;
		ALUOp: out std_logic_vector(1 downto 0)
	);
end entity;

architecture arch of CPUController is

begin
	process(OpCode)
	begin
		if(OpCode = "000000") then
			destReg <= '1';
			ALUinput <= '0';
			fillReg <= '0';
			registerWrite <= '1';
			readMem <= '0';
			writeMemory <= '0';
			branch <= '0';
			ALUOp <= "10";
		elsif(OpCode = "100011") then --Load word
			destReg <= '0';
			ALUinput <= '1';
			fillReg <= '1';
			registerWrite <= '1';
			readMem <= '1';
			writeMemory <= '0';
			branch <= '0';
			ALUOp <= "00";
		elsif(OpCode = "101011") then --Store Word
			destReg <= '0';
			ALUinput <= '1';
			fillReg <= '0';
			registerWrite <= '0';
			readMem <= '0';
			writeMemory <= '1';
			branch <= '0';
			ALUOp <= "00";
		elsif(OpCode = "000100") then -- branch
			destReg <= '0';
			ALUinput <= '0';
			fillReg <= '0';
			registerWrite <= '0';
			readMem <= '0';
			writeMemory <= '0';
			branch <= '1';
			ALUOp <= "01";
		else
			destReg <= '0';
			ALUinput <= '0';
			fillReg <= '0';
			registerWrite <= '0';
			readMem <= '0';
			writeMemory <= '0';
			branch <= '0';
			ALUOp <= "00";
		end if;
	end process;
end architecture ; -- arch



