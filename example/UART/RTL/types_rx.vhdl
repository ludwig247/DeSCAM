library ieee;
use IEEE.numeric_std.all;

package SCAM_Model_types is
subtype bool is Boolean;
subtype int is integer;
type RX_SECTIONS is (IDLE,RECEIVE,SCAN, SCAN2 ,STOP1, STOP2);
type reg_action is (NA,TX_WR);
type rx_data is record
	DR_reg: unsigned(31 downto 0);
	SR_reg: unsigned(31 downto 0);
end record;
end package SCAM_Model_types;
