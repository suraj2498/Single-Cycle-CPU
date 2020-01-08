library ieee;
library kumar;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use kumar.csc343Fall2019.all;

entity SingleCycleCPU is
	port (
		man_clk: in std_logic := '0';
		board_clk, data_WE, btn, b_in: in std_logic := '0';
		instrWrite, data_mem_enable, readEn_data_mem: in std_logic := '0';
		userInput:in std_logic_vector(7 downto 0) := x"00";
		user_addr: in std_logic_vector(4 downto 0) := "00000";
		dataOutSel: in std_logic := '1';
		overflow_flag: out std_logic := '0';
		output: out std_logic_vector(55 downto 0)
	);
end entity;


architecture arch of SingleCycleCPU is

	component PCAdder is
		port (
			input: in std_logic_vector(31 downto 0);
			output: out std_logic_vector(31 downto 0)	
		);
	end component;

	component programCounter is
		port (
			input: in std_logic_vector(31 downto 0);
			clk: in std_logic;
			output: out std_logic_vector(31 downto 0)			
		);
	end component;

	component CPUController is
		port (
			OpCode: in std_logic_vector(5 downto 0);
			destReg, ALUinput, fillReg, registerWrite: out std_logic;
			readMem, writeMemory, branch: out std_logic;
			ALUOp: out std_logic_vector(1 downto 0)
		);
	end component;

	component registerFiles is
		port (
			dataIn: in std_logic_vector(31 downto 0);
			readAddr1: in std_LOGIC_VECTOR(4 downto 0);
			readAddr2: in std_logic_vector(4 downto 0);
			writeAddr: in std_LOGIC_VECTOR(4 downto 0);
			clock, writeEn: in std_logic;
			output1, output2: out std_logic_vector(31 downto 0)	
		);
	end component;

	component signExtend is
		port (
			input: in std_logic_vector(15 downto 0);
			output: out std_logic_vector(31 downto 0)
		);
	end component;

	component miniCU is
		port (
			opCode: in std_logic_vector(5 downto 0);
			a,b: in std_logic_vector(31 downto 0);
			output : out std_logic_vector(31 downto 0);
			carry, overflow_flag, negative_flag, zero_flag: out std_logic
		);
	end component;

	component dataMemory is
		port (
			input: in std_logic_vector(31 downto 0);
			clk: in std_logic;
			addr: in std_logic_vector(4 downto 0);
			writeEn, readEn: in std_logic;
			output: out std_logic_vector(31 downto 0)
		);
	end component;

	component two_one_mux is
		generic (
			inputWidth: Integer := 5
		);
		port (
			inputA, inputB: in std_logic_vector(inputWidth-1 downto 0);
			sel: in std_logic;
			output: out std_logic_vector(inputWidth-1 downto 0)
		);
	end component;

	component instructionMemory is
		port (
			input: in std_logic_vector(31 downto 0);
			clk: in std_logic;
			address: in std_logic_vector(4 downto 0);
			writeEn: in std_logic;
			output: out std_logic_vector(31 downto 0)
		);
	end component;

	component ALUController is
		port (
			input: in std_logic_vector(1 downto 0);
			func: in std_logic_vector(5 downto 0);
			output: out std_logic_vector(5 downto 0)			
		);
	end component;

	component sevenSegDecoder is
			generic(n: Integer := 32); --Total Number of Bits
			port(
				input: in std_logic_vector(n-1 downto 0);
			  	output: out std_logic_vector(55 downto 0)
			); -- Use Formula (7n/4)-1 to decide upper range
	end component;

	component leftShifter is
		port (
			input: in std_logic_vector(31 downto 0);
			output: out std_logic_vector(31 downto 0)			
		);
	end component;

	component full32BitInput is
		port (
			input: in std_logic_vector(7 downto 0);
			btn, Clk: in std_logic;
			output: out std_logic_vector(31 downto 0)
		);
	end component;

	component two_one_bit_mux is
		port (
			inputA, inputB,sel: in std_logic;
			output: out std_logic
		);
	end component;

	component Clock_Divider is
		port (
			clk: in std_logic;
			clock_out: out std_logic
		);
	end component;

	component debounce is
		port (
			inp: in std_logic;
			clk:	in std_logic;
			outp: out std_logic
		);
	end component;

	-- Value fed into PC Register and output value
	signal PC_In: std_logic_vector(31 downto 0) := x"00000000";
	signal PC_Out: std_logic_vector(31 downto 0) := x"00000000";

	-- PC + 4 Value
	signal PC_Plus_4: std_logic_vector(31 downto 0) :=x"00000000";

	-- value being output of instr mem
	signal instrOut: std_logic_vector(31 downto 0);

	signal address_line: std_logic_vector(4 downto 0);

	signal full_userInput: std_logic_vector(31 downto 0);

	-- signals used for register files
	--signal shamt_func: std_logic_vector(15 downto 0);
	signal data_mem_read: std_logic_vector(31 downto 0);
	signal r_vs_i_dest: std_logic_vector(4 downto 0);
	signal regOut1, regOut2: std_logic_vector(31 downto 0);

	--Signals used for CPU Controller
	signal destRegister: std_logic;
	signal branch: std_logic;
	signal memRead: std_logic;
	signal memToReg: std_logic;
	signal ALUOp: std_logic_vector(1 downto 0);
	signal memWrite: std_logic;
	signal ALUSrc: std_logic;
	signal regWrite: std_logic;

	--Signals used with sign extender
	signal sign_extended_field: std_logic_vector(31 downto 0);

	--Signals used with ALUController
	signal CUOp: std_logic_vector(5 downto 0);

	signal ALUOperand2: std_logic_vector(31 downto 0);

	--Signals used with miniCU
	signal mainALURes: std_logic_vector(31 downto 0);
	signal CU_ZF: std_logic;

	-- Signal for use with data memory
	signal data_read: std_logic_vector(31 downto 0);
	signal data_mem_input: std_logic_vector(31 downto 0);
	signal data_mem_addr: std_logic_vector(4 downto 0);
	signal data_mem_we: std_logic;
	signal readEn_data: std_logic;

	--Signals used with shifter
	signal branchOp2: std_logic_vector(31 downto 0);
	signal branchSum: std_logic_vector(31 downto 0);

	--Branch Signals
	signal branchSel: std_logic := '0';

	-- Seven Seg Input
	signal SSI: std_logic_vector(31 downto 0);

	signal slowClock: std_logic;
	signal clk: std_logic;

	begin

		cd1: Clock_Divider port map (
			clk => board_clk,
			clock_out => slowClock
		);

		deb: debounce port map (
			inp => man_clk,
			clk => slowClock,
			outp => clk
		);

		PC: programCounter port map (
				input => PC_In,
				clk => clk,
				output => PC_Out
		);

		PCAdd: PCAdder port map (
				input => PC_Out,
				output => PC_Plus_4
		);		

		mux0: two_one_mux generic map(
				inputWidth => 5
		)
		port map (
				inputA => PC_Out(6 downto 2),
				inputB => user_addr,
				sel => instrWrite,
				output => address_line
		);

		input8: full32BitInput port map (
				input => userInput,
				Clk => board_clk,
				btn => btn,
				output => full_userInput
		);

		instrMem: instructionMemory port map (
				input => full_userInput,
				clk => clk,
				address => address_line,
				writeEn => instrWrite,
				output => instrOut
		);

		regFiles: registerFiles port map (
				clock => clk,
				dataIn => data_mem_read,
				readAddr1 => instrOut(25 downto 21),
				readAddr2 => instrOut(20 downto 16),
				writeAddr => r_vs_i_dest,
				writeEn => regWrite,
				output1 => regOut1,
				output2 => regOut2
		);

		mux1: two_one_mux generic map(
				inputWidth => 5
			) port map (
				inputA => instrOut(20 downto 16),
				inputB => instrOut(15 downto 11),
				sel => destRegister,
				output => r_vs_i_dest
		);

		CPUCont: CPUController port map (
				OpCode => instrOut(31 downto 26),
				destReg => destRegister,
				branch => branch,
				readMem => memRead,
				fillReg => memToReg,
				ALUOp => ALUOp,
				writeMemory => memWrite,
				ALUinput => ALUSrc,
				registerWrite => regWrite
		);

		signExtender: signExtend port map (
				input => instrOut(15 downto 0),
				output => sign_extended_field
		);

		mux2: two_one_mux 
		generic map(
			inputWidth => 32
		)
		port map (
			inputA => regOut2,
			inputB => sign_extended_field,
			sel => ALUSrc,
			output => ALUOperand2
		);

		ALUCont: ALUController port map (
			input => ALUOp,
			func => instrOut(5 downto 0),
			output => CUOp	
		);

		mCU: miniCU port map (
			opCode => CUOp,
			a => regOut1,
			b => ALUOperand2,
			output => mainALURes,
			zero_flag => CU_ZF
		);

		dataMux0: two_one_mux generic map(
			inputWidth => 32
		)
		port map (
			inputA => regOut2,
			inputB => full_userInput,
			sel => data_WE,
			output => data_mem_input
		);

		dataMux1: two_one_mux generic map(
			inputWidth => 5
		)
		port map (
			inputA => mainALURes(4 downto 0),
			inputB => user_addr,
			sel => data_mem_enable,
			output => data_mem_addr
		);

		data_bitMux2: two_one_bit_mux port map (
			inputA => memWrite,
			inputB => data_mem_enable,
			sel => data_mem_enable,
			output => data_mem_we
		);

		data_bitMux3: two_one_bit_mux port map (
			inputA => memRead,
			inputB => readEn_data_mem,
			sel => data_mem_enable,
			output => readEn_data
		);

		dataMem: dataMemory port map (
			input => data_mem_input,
			addr => data_mem_addr,
			clk => clk,
			writeEn => data_mem_we,
			readEn => readEn_data,
			output => data_read
		);

		mux3: two_one_mux generic map(
			inputWidth => 32
		)
		port map (
			inputA => mainALURes,
			inputB => data_read,
			sel => memToReg,
			output => data_mem_read
		);

		leftshift: leftShifter port map (
			input => sign_extended_field,
			output => branchOp2
		);

		brAdder: nBitFullAdder port map (
			input1 => PC_Plus_4,
			input2 => branchOp2,
			addOrSub => '0',
			immediate => '0',
			signedUnsignedSwitch => '0',
			sum => branchSum
		);

		branchSel <= (branch and CU_ZF);
		mux4: two_one_mux generic map(
			inputWidth => 32
		)
		port map (
			inputA => PC_Plus_4,
			inputB => branchSum,
			sel => branchSel,
			output => PC_In
		);

		outputMux: two_one_mux generic map(
			inputWidth => 32
		) 
		port map (
			inputA => x"00000000",
			inputB => data_read,
			sel => dataOutSel,
			output => SSI
		);

		ssd: sevenSegDecoder generic map(
			n => 32
		)
		port map (
			input => SSI,
			output => output
		);
end architecture ; -- arch
