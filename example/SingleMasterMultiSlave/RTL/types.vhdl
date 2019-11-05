package SCAM_Model_types is

subtype bool is Boolean;
subtype int is Integer;

type PID_Actuator_SECTIONS is (checking,compute,reading);
type ack_t is (ERR,OK,RTY);
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

type Temp_detector_SECTIONS is (CHECK,MEASURE,UPDATE);
type sensor_t is record
	data: int;
	data_stable: bool;
end record;

type Buffer_SECTIONS is (run);
type Bus_SECTIONS is (run);
type Server_SECTIONS is (CONFIG,ERROR,GET_TEMP,IDLE,INIT,SET_HEAT,SET_MIX);
type err_id_t is (ERR_MIX,ERR_TEMP,ERR_TEMP_BOT,ERR_TEMP_TOP,ERR_UNKNOWN,NO_ERR);
type act_t is record
	Kd: int;
	Ki: int;
	Kp: int;
	power_on: bool;
	sample_time: int;
	sample_value: int;
	setpoint: int;
end record;

type config_t is record
	Kd_Heat: int;
	Kd_Mix: int;
	Ki_Heat: int;
	Ki_Mix: int;
	Kp_Heat: int;
	Kp_Mix: int;
	max_temp_diff: int;
	sample_time: int;
	target_temp: int;
end record;



end package SCAM_Model_types;

