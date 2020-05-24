library ieee;
use IEEE.numeric_std.all;
use work.top_level_types.all;

package top_level_types is
subtype bool is Boolean;
subtype int is signed(31 downto 0);
type trans_t is (SINGLE_READ, SINGLE_WRITE);
type bus_req_t is record
	addr: signed(31 downto 0);
	data: signed(31 downto 0);
	trans_type: trans_t;
end record;
end package top_level_types;