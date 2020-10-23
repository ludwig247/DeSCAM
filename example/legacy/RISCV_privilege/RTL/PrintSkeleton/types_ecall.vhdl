package SCAM_Model_types is
subtype bool is Boolean;
subtype int is Integer;
type ECallHandler_SECTIONS is (idle,process,writing);
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
type RegfileECallType is record
	reg_file_10: unsigned;
	reg_file_11: unsigned;
	reg_file_12: unsigned;
	reg_file_17: unsigned;
end record;
type RegfileWriteType is record
	dst: unsigned;
	dstData: unsigned;
	exception: unsigned;
end record;
end package SCAM_Model_types;
