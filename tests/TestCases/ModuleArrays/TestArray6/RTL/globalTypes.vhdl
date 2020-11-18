library ieee;
use IEEE.numeric_std.all;
use work.top_level_types.all;

package top_level_types is
subtype bool is Boolean;
type unsigned_4 is array(3 downto 0) of unsigned (31 downto 0);
end package top_level_types;