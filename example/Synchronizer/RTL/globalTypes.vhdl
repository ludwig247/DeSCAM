library ieee;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

package SCAM_Model_types is
subtype bool is Boolean;
constant NUMBER_OF_SENDERS : integer := 3;
type int_array is array(NUMBER_OF_SENDERS-1 downto 0) of signed(31 downto 0);
type bool_array is array(NUMBER_OF_SENDERS-1 downto 0) of bool;
end package SCAM_Model_types;
