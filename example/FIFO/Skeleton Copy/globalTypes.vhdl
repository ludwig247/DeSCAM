library ieee;
use IEEE.numeric_std.all;

package SCAM_Model_types is
subtype bool is Boolean;
subtype int is signed(31 downto 0);
type int_5 is array(4 downto 0) of int;
end package SCAM_Model_types;