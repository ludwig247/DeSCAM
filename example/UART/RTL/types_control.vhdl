library ieee;
use IEEE.numeric_std.all;

package SCAM_Model_types is
subtype bool is Boolean;
subtype int is integer;
type Control_SECTIONS is (RUN);
type ME_AccessType is (ME_RD,ME_WR,ME_X);
type ME_MaskType is (MT_B,MT_BU,MT_H,MT_HU,MT_W,MT_X);
type reg_action is (NA,TX_WR);
type CUtoME_IF is record
	addrIn: unsigned(31 downto 0);
	dataIn: unsigned(31 downto 0);
	mask: ME_MaskType;
	req: ME_AccessType;
end record;
type reg_files is record
	CR_reg: unsigned(31 downto 0);
	DR_reg: unsigned(31 downto 0);
	SR_reg: unsigned(31 downto 0);
end record;
type rx_data is record
	DR_reg: unsigned(31 downto 0);
	SR_reg: unsigned(31 downto 0);
end record;
type tx_data is record
	r_act: reg_action;
	tx_reg: unsigned(31 downto 0);
end record;
end package SCAM_Model_types;
