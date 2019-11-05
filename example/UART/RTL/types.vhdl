library ieee;
use IEEE.numeric_std.all;

package SCAM_Model_types is
subtype bool is Boolean;
subtype int is integer;
type TX_SECTIONS is (IDLE1, IDLE2 ,SEND,START ,STOP);
type reg_action is (NA,TX_WR);
type tx_data is record
	tx_reg: unsigned(31 downto 0);
	r_act: reg_action;
end record;
end package SCAM_Model_types;
