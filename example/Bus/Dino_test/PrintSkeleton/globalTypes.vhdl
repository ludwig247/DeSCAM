library ieee;
use IEEE.numeric_std.all;
use work.top_level_types.all;

package top_level_types is
subtype bool is Boolean;
subtype int is signed(31 downto 0);
type ack_t is (ERR, OK, RTY);
type trans_t is (SINGLE_READ, SINGLE_WRITE);
type bus_req_t is record
	addr: int;
	data: int;
	trans_type: trans_t;
end record;
type bus_resp_t is record
	ack: ack_t;
	data: int;
end record;
end package top_level_types;