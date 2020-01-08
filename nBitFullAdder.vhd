library ieee;
library kumar;
use ieee.std_logic_1164.all;
use kumar.csc343Fall2019.all;
--use ieee.numeric_std.all;

entity nBitFullAdder is -- nBitadder entity declaration
  generic (nBits: Integer := 32);
  port (input1, input2: in std_logic_vector(nBits-1 downto 0);
        addOrSub, immediate, signedUnsignedSwitch: in std_logic := '0'; -- default is addition unsigned not immediate
        sum: out std_logic_vector(nBits-1 downto 0);
        carry: out std_logic;
        overflow_flag, zero_flag, negative_flag: out std_logic := '0';
        sevenSegmentOutput: out std_logic_vector(7*(nBits/2)-1 downto 0);
        sevenSegmentOutputSign: out std_logic_vector(6 downto 0):= (others => '1'));
end nBitFullAdder;

architecture nBitArch of nBitFullAdder is
  component OneBitFullAdder -- using one bit full adder
      port(a,b,cin: in std_logic;
      sum,carry: out std_logic);
  end component;
  
  signal addCarryOutVector: std_logic_vector(nBits downto 0); --hold values of carry for addition
  signal subCarryOutVector: std_logic_vector(nBits downto 0); -- holds value of carry for sub
  signal immediateOperand: std_logic_vector(nBits-1 downto 0);
  signal invertedImmediateOperand: std_logic_vector(nBits-1 downto 0);
  signal invertedInput2: std_logic_vector(nBits-1 downto 0); -- holds inverted version of second operand
  signal sumVector: std_logic_vector(nBits-1 downto 0); -- holds the result of op1 + op2
  signal differenceVector: std_logic_vector(nBits-1 downto 0); -- holds diff op op1 - op2
  signal immediateSumVector: std_logic_vector(nBits-1 downto 0);
  signal immediateDifferenceVector: std_logic_vector(nBits-1 downto 0);
  signal addCarryOutVectorImmediate: std_logic_vector(nBits downto 0); 
  signal subCarryOutVectorImmediate: std_logic_vector(nBits downto 0); 
    
  begin
    invertedInput2 <= (not input2);
    immediateOperand <= SIGN_EXTEND(input2, signedUnsignedSwitch, nBits);
    invertedImmediateOperand <= (not immediateOperand);

    addCarryOutVector(0) <= '0';  -- initial carry for both subtractor and adder is 0
    subCarryOutVector(0) <= '1';  -- the carry in acts as adding one for 2's complemeted version of the input
    addCarryOutVectorImmediate(0) <= '0';
    subCarryOutVectorImmediate(0) <= '1';
    
    FULL_ADDER_GENERATE: -- generates both sum and difference for specified input
    for i in 0 to nBits-1 generate
        nAdders: oneBitFullAdder port map(a => input1(i), b => input2(i), cin => addCarryOutVector(i),
                                     sum => sumVector(i), 
                                     carry => addCarryOutVector(i+1));  
      
        nsubs: oneBitFullAdder port map(a => input1(i), b => invertedInput2(i), cin => subCarryOutVector(i),
                                   sum => differenceVector(i), 
                                   carry => subCarryOutVector(i+1));  

        nAddI: oneBitFullAdder port map(a => input1(i), b => immediateOperand(i), cin => addCarryOutVectorImmediate(i),
                                   sum => immediateSumvector(i), 
                                   carry => addCarryOutVectorImmediate(i+1));

        nSubI: oneBitFullAdder port map(a => input1(i), b => invertedImmediateOperand(i), cin => subCarryOutVectorImmediate(i),
                                   sum => immediateDifferenceVector(i), 
                                   carry => subCarryOutVectorImmediate(i+1));
    end generate FULL_ADDER_GENERATE;


    process(sumVector, differenceVector, addOrSub, addCarryOutVector, subCarryOutVector, immediateDifferenceVector, immediateSumvector,
    		addCarryOutVectorImmediate, subCarryOutVectorImmediate, immediate, immediateOperand, input1, input2, signedUnsignedSwitch)
      begin

      	  if(immediate = '0') then 
            if(addOrSub = '0') then  --UnImmediate Addition
              sum <= sumVector;
              --sevenSegmentOutput <= sevenSegmentDecoder(sumVector(nBits-1 downto nbits-4), signedUnsignedSwitch);

	          if (isZero(SumVector, nBits)) = '1' then
              sevenSegmentOutputSign <= "1111111";
            else 
              if(signedUnsignedSwitch = '1') then
                if(SumVector(nBits-1) = '0') then
                  sevenSegmentOutputSign <= "1001110";
                else
                  sevenSegmentOutputSign <= "1111110";
                end if;
              else
                sevenSegmentOutputSign <= "1111111";
              end if;
            end if;
            else -- Unimmediate Subtraction
              sum <= differenceVector;
          
              
              if(isZero(differenceVector,nBits-1) = '1') then
                sevenSegmentOutputSign <= "1111111";
              else
                if(signedUnsignedSwitch = '1') then
                  if(differenceVector(nBits-1) = '0') then
                    sevenSegmentOutputSign <= "1001110";
                  else
                    sevenSegmentOutputSign <= "1111110";
                  end if;
                else
                  sevenSegmentOutputSign <= "1111111";
                end if;
              end if;
            end if;
          else
            if(addOrSub = '0') then -- immediate addition
              sum <= immediateSumvector;
              --sevenSegmentOutput <= sevenSegmentDecoder(immediateSumvector(nBits-1 downto nbits-4),signedUnsignedSwitch);
              
              if(isZero(immediateSumvector, nBits)) = '1' then
                sevenSegmentOutputSign <= "1111111";
              else
                if(signedUnsignedSwitch = '1') then
                  if(immediateSumvector(nBits-1) = '0') then
                    sevenSegmentOutputSign <= "1001110";
                  else
                    sevenSegmentOutputSign <= "1111110";
                  end if;
                else
                  sevenSegmentOutputSign <= "1111111";
                end if;
              end if;
            else -- immediate subtraction
              sum <= immediateDifferenceVector;
              --sevenSegmentOutput <= sevenSegmentDecoder(immediateDifferenceVector(nBits-1 downto nBits-4),signedUnsignedSwitch);

              if(isZero(immediateDifferenceVector, nBits) = '1') then
                sevenSegmentOutputSign <= "1111111";
              else
                if(signedUnsignedSwitch = '1') then
                  if(immediateDifferenceVector(nBits-1) = '0') then
                    sevenSegmentOutputSign <= "1001110";
                  else
                    sevenSegmentOutputSign <= "1111110";
                  end if;
                else
                  sevenSegmentOutputSign <= "1111111";
                end if;
              end if;
          end if;
      end if;
----------------------------------------------------------------------------------------------------------------------------------------------

          carry <= (((not immediate) and (not addOrSub) and addCarryOutVector(nBits))) --Add Carry
          										OR
          		   (((not immediate) and (addOrSub) and subCarryOutVector(nBits))) --Subtract Carry
          		   								OR
          		   (((immediate) and (not addOrSub) and addCarryOutVectorImmediate(nBits))) -- Add Immediate carry
          		   								OR
          		   (((immediate) and (addOrSub) and subCarryOutVectorImmediate(nBits))); -- Subtract Immediate Carry

----------------------------------------------------------------------------------------------------------------------------------------------

          zero_flag <= (((not immediate) and (not addOrSub) and isZero(sumVector, nbits))) -- Add Zero Flag
          										OR
          			   (((not immediate) and (addOrSub) and isZero(differenceVector, nBits))) -- Subtract Zero Flag
          			   							OR
          			   (((immediate) and (not addOrSub) and isZero(immediateSumvector, nbits))) -- Add immediate Zero flag
          			   							OR
          			   (((immediate) and (addOrSub) and isZero(immediateDifferenceVector, nBits)));	-- Subtract immediate Zero flag

----------------------------------------------------------------------------------------------------------------------------------------------

          overflow_flag <= ((not immediate) and (not addOrSub) and addCarryOutVector(nBits)) -- Add Overflow Flag
          										OR
((not immediate) and (addOrSub) and ((input1(nBits-1) xor input2(nBits-1)) and (differenceVector(nBits-1) xnor input2(nBits-1)))) -- Sub Overflow Flag
          				   						OR
          				   ((immediate) and (not addOrSub) and addCarryOutVectorImmediate(nBits)) -- Add imm Overflow Flag
          				   						OR
((immediate) and (addOrSub) and ((input1(nBits-1) xor immediateOperand(nBits-1)) and (immediateDifferenceVector(nBits-1) xnor immediateOperand(nBits-1)))); -- Sub IMM OVF Flag 

----------------------------------------------------------------------------------------------------------------------------------------------

          negative_flag <= ((not immediate) and (not addOrSub) and sumVector(nBits-1) and (signedUnsignedSwitch) and (not isZero(SumVector, nBits))) -- Add Negative Flag
          										OR
          				   ((not immediate) and (addOrSub) and differenceVector(nBits-1) and (signedUnsignedSwitch) and (not isZero(differenceVector, nBits))) -- Subtract Negative Flag
          				   						OR
          				   ((immediate) and (not addOrSub) and immediateSumvector(nBits-1) and (signedUnsignedSwitch) and (not isZero(immediateSumvector, nBits))) -- Add Imm Negative Flag
          				   						OR
     ((immediate) and (addOrSub) and immediateDifferenceVector(nBits-1) and (signedUnsignedSwitch) and (not isZero(immediateDifferenceVector, nBits))); -- Subtract Imm Negative Flag
    end process;
end nBitArch;





 --sevenSegmentOutput <= sevenSegmentDecoder(differenceVector(nBits-1 downto nBits-4),signedUnsignedSwitch);