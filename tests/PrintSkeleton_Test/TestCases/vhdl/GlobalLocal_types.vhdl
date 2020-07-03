library ieee;
use IEEE.numeric_std.all;
use work.top_level_types.all;

package GlobalLocal_types is
type local_enum is (X, Y);
type local_enum_class is (D, E);
type local_compound_type is record
	fest: global_enum;
	x: signed(31 downto 0);
	y: bool;
end record;
end package GlobalLocal_types;