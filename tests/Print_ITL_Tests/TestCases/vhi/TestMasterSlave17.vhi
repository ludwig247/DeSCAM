-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --


-- DP SIGNALS --
macro s_out_1_sig : bus_req_t := end macro;
macro s_out_1_sig_addr : signed := end macro;
macro s_out_1_sig_data : signed := end macro;
macro s_out_1_sig_trans_type : trans_t := end macro;
macro s_out_2_sig : bus_req_t := end macro;
macro s_out_2_sig_addr : signed := end macro;
macro s_out_2_sig_data : signed := end macro;
macro s_out_2_sig_trans_type : trans_t := end macro;
macro s_out_3_sig : bus_req_t := end macro;
macro s_out_3_sig_addr : signed := end macro;
macro s_out_3_sig_data : signed := end macro;
macro s_out_3_sig_trans_type : trans_t := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro data1_data : signed := end macro;
macro data1_trans_type : trans_t := end macro;
macro data2_data : signed := end macro;
macro data2_trans_type : trans_t := end macro;
macro data3_data : signed := end macro;
macro data3_trans_type : trans_t := end macro;


-- STATES --
macro state_1 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: data1_data = resize(0,32);
	 at t: data1_trans_type = SINGLE_READ;
	 at t: data2_data = resize(0,32);
	 at t: data2_trans_type = SINGLE_READ;
	 at t: data3_data = resize(0,32);
	 at t: data3_trans_type = SINGLE_READ;
	 at t: s_out_1_sig_addr = resize(0,32);
	 at t: s_out_1_sig_data = resize(0,32);
	 at t: s_out_1_sig_trans_type = SINGLE_READ;
	 at t: s_out_2_sig_addr = resize(0,32);
	 at t: s_out_2_sig_data = resize(0,32);
	 at t: s_out_2_sig_trans_type = SINGLE_READ;
	 at t: s_out_3_sig_addr = resize(0,32);
	 at t: s_out_3_sig_data = resize(0,32);
	 at t: s_out_3_sig_trans_type = SINGLE_READ;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data1_data_at_t = data1_data@t,
	data1_trans_type_at_t = data1_trans_type@t,
	data2_data_at_t = data2_data@t,
	data2_trans_type_at_t = data2_trans_type@t,
	data3_data_at_t = data3_data@t,
	data3_trans_type_at_t = data3_trans_type@t;
assume:
	at t: state_1;
prove:
	at t_end: state_1;
	at t_end: data1_data = data1_data_at_t;
	at t_end: data1_trans_type = data1_trans_type_at_t;
	at t_end: data2_data = data2_data_at_t;
	at t_end: data2_trans_type = data2_trans_type_at_t;
	at t_end: data3_data = data3_data_at_t;
	at t_end: data3_trans_type = data3_trans_type_at_t;
	at t_end: s_out_1_sig_addr = 1;
	at t_end: s_out_1_sig_data = data1_data_at_t;
	at t_end: s_out_1_sig_trans_type = data1_trans_type_at_t;
	at t_end: s_out_2_sig_addr = 2;
	at t_end: s_out_2_sig_data = data2_data_at_t;
	at t_end: s_out_2_sig_trans_type = data2_trans_type_at_t;
	at t_end: s_out_3_sig_addr = 3;
	at t_end: s_out_3_sig_data = data3_data_at_t;
	at t_end: s_out_3_sig_trans_type = data3_trans_type_at_t;
end property;


