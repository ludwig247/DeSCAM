library ieee;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;

package SCAM_Model_types is
subtype bool is Boolean;
subtype int is signed(31 downto 0);
type Mode is (READ, WRITE);
type global_enum is (A, B);
type global_enum_class is (M, N);
type CompoundType is record
	mode: Mode;
	x: int;
	y: bool;
end record;
type global_compound_type is record
	b: bool;
	w: unsigned (31 downto 0);
end record;
type int_2 is array(1 downto 0) of int;
type int_5 is array(4 downto 0) of int;
type record_t is record
	x: int;
	y: unsigned (31 downto 0);
end record;
type test_compound is record
	x: int;
	y: unsigned (31 downto 0);
end record;
end package SCAM_Model_types;