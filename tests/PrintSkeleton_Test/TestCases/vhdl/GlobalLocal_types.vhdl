library ieee;
use IEEE.numeric_std.all;

package GlobalLocal_types is
type GlobalLocal_SECTIONS is (run);
type local_enum is (X, Y);
type local_enum_class is (D, E);
type local_compound_type is record
	fest: global_enum;
	x: int;
	y: bool;
end record;
end package GlobalLocal_types;
