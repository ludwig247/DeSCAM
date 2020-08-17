library ieee;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

package SCAM_Model_types is
subtype bool is Boolean;
type int_array is array(31 downto 0) of signed(31 downto 0);
end package SCAM_Model_types;
