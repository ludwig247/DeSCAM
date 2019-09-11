library ieee;
use IEEE.numeric_std.all;

package SCAM_Model_types is
subtype bool is Boolean;
subtype int is signed(31 downto 0);
type TestArray1_SECTIONS is (run);
type int_2 is array(1 downto 0) of int;
end package SCAM_Model_types;
