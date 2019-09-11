package SCAM_Model_types is
subtype bool is Boolean;
subtype int is Integer;
type FPI_Master_SECTIONS is (ADDR,BTR_CONT,DATA,DATA_ADDR,IDLE,WAIT_BEFORE_RETRY);
type requesteQ_SECTIONS is (EMPTY,NON_EMPTY,STARTUP);
type ack_t is (ERR,OK,RTY);
type opc_t is (BTR2_OPC,BTR4_OPC,BTR8_OPC,NOP_OPC,READ_OPC,RMW_OPC,WRITE_OPC);
type req_status_t is (ADDR_STATUS,DATA_STAUS,EMPTY_STATUS,REQ_STATUS);
type update_t is (NXT_BTR_Q,NXT_GRANT_Q,NXT_PHASE_Q,RTY_Q);
type req_t is record
	abort: bool;
	addr: int;
	data: int;
	opc: opc_t;
end record;
type result_t is record
	data: int;
	err: bool;
end record;
end package SCAM_Model_types;
