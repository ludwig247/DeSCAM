library ieee;
use IEEE.numeric_std.all;
use work.top_level_types.all;

package top_level_types is
subtype bool is Boolean;
type global_enum is (A, B);
type global_enum_class is (M, N);
type global_compound_type is record
	b: bool;
	w: unsigned (31 downto 0);
end record;
type int_5 is array(4 downto 0) of signed(31 downto 0);
end package top_level_types;