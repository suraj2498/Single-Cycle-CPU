library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

package csc343Fall2019 is

----N BIT COMPARATOR COMPONENT-------
  component nBitComparator
    generic(nthBit: Integer:= 4);
    port(a,b: in std_logic_vector(nthBit-1 downto 0);
        immediate, signedOrUnsigned: in std_logic:= '0'; -- Default is not immediate and unsigned
        Eq, notEq: out std_logic);
  end component;
  
----N BIT FULL ADDER COMPONENT-------

  component nBitFullAdder -- nBitadder entity declaration
  generic (nBits: Integer := 32);
  port (input1, input2: in std_logic_vector(nBits-1 downto 0);
        addOrSub, immediate, signedUnsignedSwitch: in std_logic := '0'; -- default is addition unsigned not immediate
        sum: out std_logic_vector(nBits-1 downto 0);
        carry: out std_logic;
        overflow_flag, zero_flag, negative_flag: out std_logic := '0';
        sevenSegmentOutput: out std_logic_vector(7*(nBits/2)-1 downto 0);
        sevenSegmentOutputSign: out std_logic_vector(6 downto 0):= (others => '1'));
end component;

----N BIT SLT COMPONENT-------

  component setLessThan 
  generic(nBits: Integer := 4);
  port(input1, input2: in std_logic_vector(nBits-1 downto 0);
       SLT: in std_logic:= '0'; --sltu is default
       output:out std_logic);
  end component;

----N BIT AND-------

  component nBitAnd 
  generic (n: Integer := 4);
  port(a,b: in std_logic_vector(n-1 downto 0);
     output: out std_logic_vector(n-1 downto 0)); 
  end component;

----N BIT NOT-------

  component nBitNot
  generic (n: Integer := 4);
  port(a: in std_logic_vector(n-1 downto 0);
     output: out std_logic_vector(n-1 downto 0));
  end component;

----N BIT OR-------

  component nBitOr
  generic (n: Integer := 4);
  port(a,b: in std_logic_vector(n-1 downto 0);
     output: out std_logic_vector(n-1 downto 0));
  end component;

----N BIT XOR-------

  component nBitXor 
  generic (n: Integer := 4);
  port(a,b: in std_logic_vector(n-1 downto 0);
     output: out std_logic_vector(n-1 downto 0));
  end component;

----N BIT SLL-------

  component shiftLogicalLeft
  generic (n: Integer:= 4);
  port(a: in std_logic_vector(n-1 downto 0);
     shiftButton, resetButton: in std_logic := '1';
     output: out std_logic_vector(n-1 downto 0));
  end component;

----N BIT SLR-------

  component shiftLogicalRight
  generic (n: Integer:= 4);
  port(a: in std_logic_vector(n-1 downto 0);
     shiftButton, resetButton: in std_logic := '1';
     output: out std_logic_vector(n-1 downto 0));
  end component;  

----N BIT SLA-------

  component shiftArithmeticLeft
  generic (n: Integer:= 4);
  port(a: in std_logic_vector(n-1 downto 0);
     shiftButton, resetButton: in std_logic := '1';
     output: out std_logic_vector(n-1 downto 0));
  end component;

----N BIT SRA-------

  component shiftArithmeticRight
  generic (n: Integer:= 4);
  port(a: in std_logic_vector(n-1 downto 0);
     shiftButton, resetButton: in std_logic := '1';
     output: out std_logic_vector(n-1 downto 0));
  end component;

-------FUNCTION DECLARATION----------

  function VERIFY_EQUAL_VECTOR(inputVector: in std_logic_vector; nthBit: in Integer)
  return std_logic;
  
-------FUNCTION DECLARATION----------

  function SIGN_EXTEND(signal inputVector: in std_logic_vector; 
                       signedOrUnsigned: in std_logic;
                       nthBit: Integer) 
  return std_logic_vector;

-------FUNCTION DECLARATION----------

  function invertVector(signal inputVector: in std_logic_vector; nBits: Integer) -- returns inverted form of input
    return std_logic_vector;  
  
-------FUNCTION DECLARATION-----------

  function isZero (signal inputVector: in std_logic_vector; n: Integer) 
  return std_logic;

-------FUNCTION DECLARATION-----------
  
  function shiftRightLogical (inputVector: in std_logic_vector; shiftTotal: in Integer; n: in Integer) 
  return std_logic_vector;

-------FUNCTION DECLARATION-----------
  function shiftRightArithmetic (inputVector: in std_logic_vector; shiftTotal: in Integer; n: in Integer) 
  return std_logic_vector;

-------FUNCTION DECLARATION-----------
  
  function shiftLeftLogical (inputVector: in std_logic_vector; shiftTotal: in Integer; n: in Integer) 
  return std_logic_vector;

-------FUNCTION DECLARATION-----------

  function sevenSegmentDecoder(signal input: in std_logic_vector; signal signUnsignSwitch: in std_logic)
  return std_logic_vector;

-------FUNCTION DECLARATION-----------

  function sevenSegmentDecoderToHex(input: in std_logic_vector)
  return std_logic_vector;

end package csc343Fall2019;



package body csc343Fall2019 is
      
   ---- FUNCTION IMPLEMENTATION ----
 
  function VERIFY_EQUAL_VECTOR(inputVector: in std_logic_vector; nthBit: in Integer)
  return std_logic is
  variable placeHolder: std_logic;
    begin
      for i in 0 to nthBit-1 loop                  
        placeHolder := inputVector(i);
        if(placeHolder = '0') then
          exit;
        end if;
      end loop;
    return placeHolder;
  end function;
  
    ---- FUNCTION IMPLEMENTATION ----
  
  function SIGN_EXTEND(signal inputVector: in std_logic_vector; 
                       signedOrUnsigned: in std_logic;
                       nthBit: in Integer) 
  return std_logic_vector is
  variable returnVector: std_logic_vector((nthBit/2)-1 downto 0);
  variable immediateVector : std_logic_vector((nthBit/2)-1 downto 0);
  variable isSigned: std_logic;
  variable extendBit: std_logic;
    begin 
      if(signedOrUnsigned = '0') then
        extendBit:= '0';
      else
        isSigned := inputVector((nthBit/2)-1); --acquires the signed bit either '0' or '1'
        extendBit := isSigned;
      end if;
      for i in 0 to (nthBit/2)-1 loop
        returnVector(i) := extendBit;
        immediateVector(i) := inputVector(i); -- gets the first half od the full sized operand
      end loop;
    return returnVector & immediateVector; -- returns the concatenated vectors
  end function;

  ---- FUNCTION IMPLEMENTATION ----

  function invertVector(signal inputVector: in std_logic_vector; nBits: Integer) -- returns inverted form of input
    return std_logic_vector is
    variable tempVector: std_logic_vector((inputVector'length)-1 downto 0);
    begin
      for i in 0 to nBits-1 loop
        tempVector(i) := not(inputVector(i));
      end loop;
    return tempVector;
  end function;

  ---- FUNCTION IMPLEMENTATION ----

  function isZero (signal inputVector: in std_logic_vector; n: Integer) 
  return std_logic is
  variable returnVariable: std_logic;
  begin
    for i in 0 to n-1 loop
      returnVariable := inputVector(i);
      if(returnVariable = '1') then
        exit;
      end if;
    end loop;
    return (not returnVariable);
  end isZero;

  ---- FUNCTION IMPLEMENTATION ----

  function shiftRightLogical (inputVector: in std_logic_vector; shiftTotal: in Integer; n: in Integer) 
  return std_logic_vector is
  variable tempVector: std_logic_vector(n-1 downto 0);
    begin
      tempVector := inputVector;
      if(shiftTotal = 0) then
        return tempVector;
      else
        if(shiftTotal < inputVector'length) then
        for j in 0 to ((inputVector'length) - 1) loop
          if ((j+shiftTotal)<inputVector'length) then
            tempVector(j) := tempVector(j+shiftTotal);
          else
            tempVector(j) := '0';
          end if;
        end loop;
        else
          tempVector := (others => '0');
        end if;
      end if;
      return tempVector;
  end shiftRightLogical;


  function shiftRightArithmetic (inputVector: in std_logic_vector; shiftTotal: in Integer; n: in Integer) 
  return std_logic_vector is
  variable tempVector: std_logic_vector(n-1 downto 0);
  variable MSB: std_logic := inputVector(n-1);
    begin
      tempVector := inputVector;
      if(shiftTotal = 0) then
        return tempVector;
      else
        if(shiftTotal < inputVector'length) then
        for j in 0 to ((inputVector'length) - 1) loop
          if ((j+shiftTotal)<inputVector'length) then
            tempVector(j) := tempVector(j+shiftTotal);
          else
            tempVector(j) := MSB;
          end if;
        end loop;
        else
          tempVector := (others => '0');
        end if;
      end if;
      return tempVector;
  end shiftRightArithmetic;

  ----FUNCTION DECLARATION----

  function shiftLeftLogical (inputVector: in std_logic_vector; shiftTotal: in Integer; n: in Integer) 
  return std_logic_vector is
  variable tempVector: std_logic_vector(n-1 downto 0);
  begin
  tempVector := inputVector;
    if(shiftTotal = 0) then
      return tempVector;
    else
      if(shiftTotal < inputVector'length) then
        for j in ((inputVector'length) - 1) downto 0 loop
          if ((j+shiftTotal)<inputVector'length) then
            tempVector(j+shiftTotal) := tempVector(j);
            tempVector(j) := '0';
          else
            tempVector(j) := '0';
          end if;
        end loop;
        else
          tempVector := (others => '0');
        end if;
      end if;
      return tempVector;
  end shiftLeftLogical;

  ----FUNCTION DECLARATION----

  function sevenSegmentDecoder(signal input: in std_logic_vector; signal signUnsignSwitch: std_logic)
  return std_logic_vector is
  variable output: std_logic_vector(13 downto 0);
  begin

    -- format of output--> disp MSB -> [0000000] disp LSB -> [0000000] second disp will read higher 7 and first disp will read lower 7
    
    if(signUnsignSwitch = '0') then
      if (input = "0000") then 
        output := "0000001" & "0000001"; -- 00
      elsif (input = "0001") then
        output :=  "0000001" & "1001111"; -- 01
      elsif (input = "0010") then
        output := "0000001" & "0010010"; -- 02 
      elsif (input = "0011") then
        output :=  "0000001" & "0000110"; -- 3 0000110
      elsif (input = "0100") then
        output :=  "0000001" & "1001100"; -- 4 1001100
      elsif (input = "0101") then
        output :=  "0000001" & "0100100"; -- 5 0100100
      elsif (input = "0110") then
        output := "0000001" & "0100000"; -- 6 0100000
      elsif (input = "0111") then
        output := "0000001" & "0001111"; -- 7 0001111
      elsif (input = "1000") then
        output := "0000001" & "0000000"; -- 8 0000000
      elsif (input = "1001") then
        output := "0000001" & "0000100"; -- 9 0000100
      elsif (input = "1010") then
        output := "1001111" & "0000001"; -- 10 0001000
      elsif (input = "1011") then
        output := "1001111" & "1001111"; -- 11 1100000
      elsif (input = "1100") then
        output := "1001111" & "0010010"; -- 12 0110001
      elsif (input = "1101") then
        output := "1001111" & "0000110"; -- 13 1000010
      elsif (input = "1110") then
        output := "1001111" & "1001100"; -- 14 0110000
      elsif (input = "1111") then
        output := "1001111" & "0100100"; -- 15 0111000
      end if;
    else
      if (input = "0000") then 
        output := "0000001" & "0000001"; -- +00
      elsif (input = "0001") then
        output := "0000001" & "1001111"; -- +01
      elsif (input = "0010") then
        output := "0000001" & "0010010"; -- +02 
      elsif (input = "0011") then
        output := "0000001" & "0000110"; -- +03 0000110
      elsif (input = "0100") then
        output := "0000001" & "1001100"; -- +04 1001100
      elsif (input = "0101") then
        output := "0000001" & "0100100"; -- +05 0100100
      elsif (input = "0110") then
        output := "0000001" & "0100000"; -- +06 0100000
      elsif (input = "0111") then
        output := "0000001" & "0001111"; -- +07 0001111
      elsif (input = "1000") then
        output := "0000001" & "0000000"; -- -08 0000000
      elsif (input = "1001") then
        output := "0000001" & "0001111"; -- -07 0000100
      elsif (input = "1010") then
        output := "0000001" & "0100000"; -- -06 0001000
      elsif (input = "1011") then
        output := "0000001" & "0100100"; -- -05 1100000
      elsif (input = "1100") then
        output := "0000001" & "1001100"; -- -04 0110001
      elsif (input = "1101") then
        output := "0000001" & "0000110"; -- -03 1000010
      elsif (input = "1110") then
        output := "0000001" & "0010010"; -- -02 0110000
      elsif (input = "1111") then
        output := "0000001" & "1001111"; -- -01 0111000
      end if;
    end if;
    return output;        
  end sevenSegmentDecoder;

  function sevenSegmentDecoderToHex(input: in std_logic_vector)
  return std_logic_vector is
  variable inputVector: std_logic_vector(input'length-1 downto 0) := input;
  variable output: std_logic_vector(6 downto 0);
  begin
      if(inputVector = "0000") then
        output := not "1111110";
      elsif(inputVector = "0001") then
        output := not "0110000";
      elsif(inputVector = "0010") then 
        output := not "1101101";
      elsif(inputVector = "0011") then
        output := not "1111001";
      elsif(inputVector = "0100") then
        output := not "0110011";
      elsif(inputVector = "0101") then
        output := not "1011011";
      elsif(inputVector = "0110") then
        output := not "1011111";
      elsif(inputVector = "0111") then
        output := not "1110000"; 
      elsif(inputVector = "1000") then
        output := not "1111111";
      elsif(inputVector = "1001") then
        output := not "1110011";
      elsif(inputVector = "1010") then
        output := not "1110111";
      elsif(inputVector = "1011") then
        output := not "0011111";
      elsif(inputVector = "1100") then
        output := not "1001110";
      elsif(inputVector = "1101") then
        output := not "0111101";
      elsif(inputVector = "1110") then 
        output := not "1001111";
      elsif(inputvector = "1111") then
        output := not "1000111";
		  else
		    output := not "0000000";
      end if;
    return output;
  end sevenSegmentDecoderToHex;

end package body csc343Fall2019;

