library ieee;
use ieee.std_logic_1164.all;

entity OneBitFullAdder is
  port(a,b, cin: in std_logic;
      sum, carry: out std_logic);
end OneBitFullAdder;

architecture arch of OneBitFullAdder is
  begin
 sum <= a xor b xor cin ;
 carry <= (a and b) or (cin and a) or (cin and b) ;

end arch;





