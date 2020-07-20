library ieee;
use IEEE.numeric_std.all;
use work.top_level_types.all;

package top_level_types is
subtype bool is Boolean;
subtype int is signed(31 downto 0);
type phases is (IDLE, RUN);
type int_3 is array(2 downto 0) of int;
end package top_level_types;