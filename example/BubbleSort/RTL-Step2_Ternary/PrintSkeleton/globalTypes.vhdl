library ieee;
use IEEE.numeric_std.all;
--use work.top_level_types.all;

package top_level_types is
subtype bool is Boolean;
subtype int is signed(31 downto 0);
type phases is (IDLE, RUN);
type int_128 is array(127 downto 0) of signed(31 downto 0);
end package top_level_types;