library ieee;
use IEEE.numeric_std.all;
--use work.top_level_types.all;

package top_level_types is
subtype bool is Boolean;
subtype fixed_def is unsigned(16 downto 0);
end package top_level_types;