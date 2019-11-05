library ieee;
use IEEE.numeric_std.all;

package SCAM_Model_types is
subtype bool is Boolean;
subtype int is signed(31 downto 0);
type ME_AccessType is (ME_RD,ME_WR,ME_X);
type ME_MaskType is (MT_B,MT_BU,MT_H,MT_HU,MT_W,MT_X);
type Tranceiver_SECTIONS is (initialize,run0, run4);
type CUtoME_IF is record
	addrIn: unsigned(31 downto 0);
	dataIn: unsigned(31 downto 0);
	mask: ME_MaskType;
	req: ME_AccessType;
end record;
type reg_files is record
	CR1: unsigned(31 downto 0);
	CR2: unsigned(31 downto 0);
	CR3: unsigned(31 downto 0);
	RX: unsigned(31 downto 0);
	SR1: unsigned(31 downto 0);
	SR2: unsigned(31 downto 0);
	SR3: unsigned(31 downto 0);
	TX: unsigned(31 downto 0);
end record;
end package SCAM_Model_types;
