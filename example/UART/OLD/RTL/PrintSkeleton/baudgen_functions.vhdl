library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;


package baudgen_functions is

function calc_prescaler(baud_ctrl: in unsigned ; Clock: in unsigned) return unsigned;
function trigging(counter: in unsigned ; prescaler: in unsigned) return unsigned;
function count(counter: in unsigned ; prescaler: in unsigned) return unsigned;

end package baudgen_functions;

package body baudgen_functions is

function calc_prescaler(baud_ctrl: in unsigned ; Clock: in unsigned) return unsigned is
begin

if(baud_ctrl = to_unsigned(0,32)) then
  return (Clock / to_unsigned(9600, 32));
elsif(baud_ctrl = to_unsigned(1,32)) then
  return (Clock / to_unsigned(57600, 32));
elsif(baud_ctrl = to_unsigned(2,32)) then
return (Clock / to_unsigned(115200, 32));
else
return (Clock / to_unsigned(256000, 32));
end if;

end function calc_prescaler;

function trigging(counter: in unsigned ; prescaler: in unsigned) return unsigned is
begin

if(counter = prescaler) then
 return to_unsigned(1,32);
 else
 return to_unsigned(0,32);
 end if;


end function trigging;


function count(counter: in unsigned ; prescaler: in unsigned) return unsigned is
begin

if(counter = prescaler) then
 return to_unsigned(0,32);
else 
return counter + to_unsigned(1, 32);
end if;

end function count;


end package body baudgen_functions;
