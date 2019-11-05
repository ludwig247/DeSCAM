library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

package TX_functions is

function parity_bit(control: in unsigned ; counter: in unsigned) return unsigned;



end package TX_functions;

package body TX_functions is

function parity_bit(control: in unsigned ; counter: in unsigned) return unsigned is
begin
  
   if(((counter mod to_unsigned(2,32)) /= to_unsigned(0,32)) and (control = to_unsigned(2,32))) then
    return to_unsigned(1,32);
   elsif(((counter mod to_unsigned(2,32)) = to_unsigned(0,32)) and (control = to_unsigned(1,32))) then
    return to_unsigned(1,32);
   else
    return to_unsigned(0,32);
   end if;

end function parity_bit;



end package body TX_functions;
