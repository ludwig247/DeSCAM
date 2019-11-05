library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

package RX_functions is

function frame_check(trigg: in boolean) return unsigned;
function parity_check(control: in unsigned ; counter : in unsigned ; trigg : in boolean) return unsigned;


end package RX_functions;

package body RX_functions is

function frame_check(trigg: in boolean) return unsigned is
begin
  
   if(trigg = true) then
     return to_unsigned(0,32);
    else
     return to_unsigned(128,32);
   end if;

end function frame_check;

function parity_check(control: in unsigned ; counter : in unsigned ; trigg : in boolean) return unsigned is
begin

  if((trigg =  true) and ((counter mod to_unsigned(2,32)) /= to_unsigned(0,32)) and (control = to_unsigned(2,32))) then
    return to_unsigned(0,32);
  elsif((trigg =  false) and ((counter mod to_unsigned(2,32)) = to_unsigned(0,32)) and (control = to_unsigned(2,32))) then
    return to_unsigned(0,32);
  elsif((trigg =  false) and ((counter mod to_unsigned(2,32)) /= to_unsigned(0,32)) and (control = to_unsigned(1,32))) then
    return to_unsigned(0,32);
  elsif((trigg =  true) and ((counter mod to_unsigned(2,32)) = to_unsigned(0,32)) and (control = to_unsigned(1,32))) then
   return to_unsigned(0,32);
  else
   return to_unsigned(64,32);
  end if;  
  

end function parity_check;

end package body RX_functions;
