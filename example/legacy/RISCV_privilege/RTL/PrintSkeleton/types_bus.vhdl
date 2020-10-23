package SCAM_Model_types is
subtype bool is Boolean;
subtype int is Integer;
type CoreBus_SECTIONS is (run);
type ME_AccessType is (ME_RD,ME_WR,ME_X);
type ME_MaskType is (MT_B,MT_BU,MT_H,MT_HU,MT_W,MT_X);
type CUtoME_IF is record
	addrIn: unsigned;
	dataIn: unsigned;
	mask: ME_MaskType;
	req: ME_AccessType;
end record;
type MEtoCU_IF is record
	loadedData: unsigned;
end record;
end package SCAM_Model_types;
