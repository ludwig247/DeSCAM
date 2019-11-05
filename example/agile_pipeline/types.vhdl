library ieee;
use IEEE.numeric_std.all;

package SCAM_Model_types is
subtype bool is Boolean;
subtype int is signed(31 downto 0);
type Pipeline_SECTIONS is (run);
type states is (Aw,A,Bw,B);
end package SCAM_Model_types;
