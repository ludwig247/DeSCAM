-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro master_in_sync : boolean := end macro;
macro master_out_sync : boolean := end macro;
macro slave_in0_sync : boolean := end macro;
macro slave_in1_sync : boolean := end macro;
macro slave_in2_sync : boolean := end macro;
macro slave_in3_sync : boolean := end macro;
macro slave_out0_sync : boolean := end macro;
macro slave_out1_sync : boolean := end macro;
macro slave_out2_sync : boolean := end macro;
macro slave_out3_sync : boolean := end macro;
macro master_in_notify : boolean := end macro;
macro master_out_notify : boolean := end macro;
macro slave_in0_notify : boolean := end macro;
macro slave_in1_notify : boolean := end macro;
macro slave_in2_notify : boolean := end macro;
macro slave_in3_notify : boolean := end macro;
macro slave_out0_notify : boolean := end macro;
macro slave_out1_notify : boolean := end macro;
macro slave_out2_notify : boolean := end macro;
macro slave_out3_notify : boolean := end macro;


-- DP SIGNALS --
macro master_in_sig : bus_req_t := end macro;
macro master_in_sig_addr : signed := end macro;
macro master_in_sig_data : signed := end macro;
macro master_in_sig_trans_type : trans_t := end macro;
macro master_out_sig : bus_resp_t := end macro;
macro master_out_sig_ack : ack_t := end macro;
macro master_out_sig_data : signed := end macro;
macro slave_in0_sig : bus_resp_t := end macro;
macro slave_in0_sig_ack : ack_t := end macro;
macro slave_in0_sig_data : signed := end macro;
macro slave_in1_sig : bus_resp_t := end macro;
macro slave_in1_sig_ack : ack_t := end macro;
macro slave_in1_sig_data : signed := end macro;
macro slave_in2_sig : bus_resp_t := end macro;
macro slave_in2_sig_ack : ack_t := end macro;
macro slave_in2_sig_data : signed := end macro;
macro slave_in3_sig : bus_resp_t := end macro;
macro slave_in3_sig_ack : ack_t := end macro;
macro slave_in3_sig_data : signed := end macro;
macro slave_out0_sig : bus_req_t := end macro;
macro slave_out0_sig_addr : signed := end macro;
macro slave_out0_sig_data : signed := end macro;
macro slave_out0_sig_trans_type : trans_t := end macro;
macro slave_out1_sig : bus_req_t := end macro;
macro slave_out1_sig_addr : signed := end macro;
macro slave_out1_sig_data : signed := end macro;
macro slave_out1_sig_trans_type : trans_t := end macro;
macro slave_out2_sig : bus_req_t := end macro;
macro slave_out2_sig_addr : signed := end macro;
macro slave_out2_sig_data : signed := end macro;
macro slave_out2_sig_trans_type : trans_t := end macro;
macro slave_out3_sig : bus_req_t := end macro;
macro slave_out3_sig_addr : signed := end macro;
macro slave_out3_sig_data : signed := end macro;
macro slave_out3_sig_trans_type : trans_t := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro req_trans_type : trans_t := end macro;
macro resp_ack : ack_t := end macro;
macro resp_data : signed := end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;
macro state_3 : boolean := true end macro;
macro state_4 : boolean := true end macro;
macro state_5 : boolean := true end macro;
macro state_6 : boolean := true end macro;
macro state_7 : boolean := true end macro;
macro state_8 : boolean := true end macro;
macro state_9 : boolean := true end macro;
macro state_10 : boolean := true end macro;


