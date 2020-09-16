package SCAM_Model_types is
subtype bool is Boolean;
subtype int is Integer;
type SlaveAgent_SECTIONS is (DONE,IDLE,READ,WRITE);
type MasterAgent_SECTIONS is (DONE,IDLE,READ,WAITING,WRITE);
type MasterDummy_SECTIONS is (run);
type SlaveDummy_SECTIONS is (run);
type ack_t is (ERR,OK);
type Bus_SECTIONS is (run);
type trans_t is (SINGLE_READ,SINGLE_WRITE);
type bus_req_t is record
	addr: int;
	data: int;
	trans_type: trans_t;
end record;
type bus_resp_t is record
	ack: ack_t;
	data: int;
end record;
type master_signals is record
	addr: int;
	cyc: bool;
	data: int;
	stb: bool;
	we: bool;
end record;
type slave_signals is record
	ack: bool;
	data: int;
	err: bool;
end record;

type Interconnect_SECTIONS is (DONE,IDLE,START,TRANSMITTING);

constant master_signals_default : master_signals :=
	( 0, 		-- addr
	  false,	-- cyc
	  0,		-- data
	  false, 	-- stb
	  false		-- we
	  );
constant slave_signals_default: slave_signals :=
	(false,0,false);

end package SCAM_Model_types;



