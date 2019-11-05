library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

package SCAM_Model_types is
subtype bool is Boolean;
subtype int is Integer;
type Memory_manager_SECTIONS is (RUN1, RUN2);
type ME_AccessType is (ME_RD,ME_WR,ME_X);
type ME_MaskType is (MT_B,MT_BU,MT_H,MT_HU,MT_W,MT_X);
type reg_action is (NA,TX_WR);

type CUtoME_IF is record
	addrIn: unsigned(31 downto 0);
	dataIn: unsigned(31 downto 0);
	mask: ME_MaskType;
	req: ME_AccessType;
end record;
type MEtoCU_IF is record
	loadedData: unsigned(31 downto 0);
end record;
type reg_files is record
	CR_reg: unsigned(31 downto 0);
	DR_reg: unsigned(31 downto 0);
	SR_reg: unsigned(31 downto 0);
end record;

end package SCAM_Model_types;
