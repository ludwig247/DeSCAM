package SCAM_Model_types is
subtype bool is Boolean;
subtype int is Integer;
type LR_SC is (LR,NONE,SC);
type ME_AccessType is (ME_RD,ME_WR,ME_X);
type ME_MaskType is (MT_B,MT_BU,MT_H,MT_HU,MT_W,MT_X);
type MMU_SECTIONS is (MEMORY_OP,PMA,PTE_DECODE,PTE_FETCH,REQUEST,RESPONSE);
type MMUaccessType is (FETCH,LOAD,STORE);
type CUtoME_IF is record
	addrIn: unsigned;
	dataIn: unsigned;
	mask: ME_MaskType;
	req: ME_AccessType;
end record;
type MEtoCU_IF is record
	loadedData: unsigned;
end record;
type MMU_in is record
	accesstype: MMUaccessType;
	data: unsigned;
	exception_in: unsigned;
	lrsc: LR_SC;
	mask: ME_MaskType;
	mstatus: unsigned;
	prv: unsigned;
	reset_lrsc: unsigned;
	satp: unsigned;
	v_addr: unsigned;
end record;
type MMU_return is record
	data: unsigned;
	exception: unsigned;
	sc_success: unsigned;
end record;
end package SCAM_Model_types;
