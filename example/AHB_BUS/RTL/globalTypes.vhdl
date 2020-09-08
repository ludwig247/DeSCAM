library ieee;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

package SCAM_Model_types is
subtype bool is Boolean;
constant SLAVE0_START : integer := 16#00000000#;
constant SLAVE0_END : integer := 16#00010000#;
constant SLAVE1_START : integer := 16#00010000#;
constant SLAVE1_END : integer := 16#00020000#;
type states is (MASTER_REQ, SLAVE_REQ, SLAVE_RESP, MASTER_RESP);
type bus_req_t is record
    haddr   : Unsigned(31 downto 0);
    hwdata  : Unsigned(31 downto 0);
end record;
constant req_init : bus_req_t := (haddr => (others => '0'), hwdata => (others => '0'));
type bus_resp_t is record
    hrdata  : Unsigned(31 downto 0);
    hresp   : Unsigned(31 downto 0);
end record;
constant resp_init : bus_resp_t := (hrdata => (others => '0'), hresp => (others => '0'));
end package SCAM_Model_types;
