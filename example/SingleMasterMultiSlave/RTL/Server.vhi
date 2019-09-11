property reset is
for timepoints:
	t_end = t;
assume:
	 reset_sequence;
prove:
	 at t_end: INIT_11;
	 at t_end: err_id = NO_ERR;
	 at t_end: heat_Kd = 0;
	 at t_end: heat_Ki = 0;
	 at t_end: heat_Kp = 0;
	 at t_end: heat_power_on = false;
	 at t_end: heat_sample_time = 0;
	 at t_end: heat_sample_value = 0;
	 at t_end: heat_setpoint = 0;
	 at t_end: mix_Kd = 0;
	 at t_end: mix_Ki = 0;
	 at t_end: mix_Kp = 0;
	 at t_end: mix_power_on = false;
	 at t_end: mix_sample_time = 0;
	 at t_end: mix_sample_value = 0;
	 at t_end: mix_setpoint = 0;
	 at t_end: nb_result = false;
	 at t_end: req_addr = 0;
	 at t_end: req_data = 0;
	 at t_end: req_trans_type = SINGLE_READ;
	 at t_end: resp_ack = ERR;
	 at t_end: resp_data = 0;
	 at t_end: resp_bot_ack = ERR;
	 at t_end: resp_bot_data = 0;
	 at t_end: resp_top_ack = ERR;
	 at t_end: resp_top_data = 0;
	 at t_end: temp_bot_data = 0;
	 at t_end: temp_bot_data_stable = false;
	 at t_end: temp_top_data = 0;
	 at t_end: temp_top_data_stable = false;
	 at t_end: uP_Kd_Heat = 0;
	 at t_end: uP_Kd_Mix = 0;
	 at t_end: uP_Ki_Heat = 0;
	 at t_end: uP_Ki_Mix = 0;
	 at t_end: uP_Kp_Heat = 0;
	 at t_end: uP_Kp_Mix = 0;
	 at t_end: uP_max_temp_diff = 0;
	 at t_end: uP_sample_time = 0;
	 at t_end: uP_target_temp = 0;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: heat_power_sig = true;
	 at t_end: bus_out_addr_sig = 0;
	 at t_end: bus_out_data_sig = 0;
	 at t_end: bus_out_trans_type_sig = SINGLE_READ;
	 at t_end: mix_power_sig = false;
	 at t_end: uP_report_out_sig = ERR_MIX;
end property;


property wait_CONFIG_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: CONFIG_0;
	 at t: (bus_out_sync = false);
prove:
	 at t_end: CONFIG_0;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property CONFIG_0_write_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: CONFIG_0;
	 at t: (bus_out_sync = true);
prove:
	 at t_end: CONFIG_1;
	 during[t+1, t_end-1]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_in_notify = true;
end property;

property CONFIG_1_read_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	uP_target_temp_at_t = uP_target_temp@t,
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: CONFIG_1;
	 at t: (req_addr = 1);
	 at t: (bus_in_sync = true);
prove:
	 at t_end: CONFIG_0;
	 at t_end: req_addr = 2;
	 at t_end: req_data = uP_target_temp_at_t;
	 at t_end: resp_ack = bus_in_sig_ack_at_t;
	 at t_end: resp_data = bus_in_sig_data_at_t;
	 at t_end: uP_target_temp = uP_target_temp_at_t;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property CONFIG_1_read_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	uP_Kp_Heat_at_t = uP_Kp_Heat@t,
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: CONFIG_1;
	 at t: (req_addr = 2);
	 at t: (bus_in_sync = true);
prove:
	 at t_end: CONFIG_0;
	 at t_end: req_addr = 3;
	 at t_end: req_data = uP_Kp_Heat_at_t;
	 at t_end: resp_ack = bus_in_sig_ack_at_t;
	 at t_end: resp_data = bus_in_sig_data_at_t;
	 at t_end: uP_Kp_Heat = uP_Kp_Heat_at_t;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property CONFIG_1_read_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	uP_Ki_Heat_at_t = uP_Ki_Heat@t,
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: CONFIG_1;
	 at t: (req_addr = 3);
	 at t: (bus_in_sync = true);
prove:
	 at t_end: CONFIG_0;
	 at t_end: req_addr = 4;
	 at t_end: req_data = uP_Ki_Heat_at_t;
	 at t_end: resp_ack = bus_in_sig_ack_at_t;
	 at t_end: resp_data = bus_in_sig_data_at_t;
	 at t_end: uP_Ki_Heat = uP_Ki_Heat_at_t;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property CONFIG_1_read_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	uP_Kd_Heat_at_t = uP_Kd_Heat@t,
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: CONFIG_1;
	 at t: (req_addr = 4);
	 at t: (bus_in_sync = true);
prove:
	 at t_end: CONFIG_0;
	 at t_end: req_addr = 5;
	 at t_end: req_data = uP_Kd_Heat_at_t;
	 at t_end: resp_ack = bus_in_sig_ack_at_t;
	 at t_end: resp_data = bus_in_sig_data_at_t;
	 at t_end: uP_Kd_Heat = uP_Kd_Heat_at_t;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property CONFIG_1_read_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	uP_sample_time_at_t = uP_sample_time@t,
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: CONFIG_1;
	 at t: (req_addr = 5);
	 at t: (bus_in_sync = true);
prove:
	 at t_end: CONFIG_0;
	 at t_end: req_addr = 9;
	 at t_end: req_data = uP_sample_time_at_t;
	 at t_end: resp_ack = bus_in_sig_ack_at_t;
	 at t_end: resp_data = bus_in_sig_data_at_t;
	 at t_end: uP_sample_time = uP_sample_time_at_t;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property CONFIG_1_read_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	uP_target_temp_at_t = uP_target_temp@t,
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: CONFIG_1;
	 at t: (req_addr = 9);
	 at t: (bus_in_sync = true);
prove:
	 at t_end: CONFIG_0;
	 at t_end: req_addr = 10;
	 at t_end: req_data = uP_target_temp_at_t;
	 at t_end: resp_ack = bus_in_sig_ack_at_t;
	 at t_end: resp_data = bus_in_sig_data_at_t;
	 at t_end: uP_target_temp = uP_target_temp_at_t;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property CONFIG_1_read_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	uP_Kp_Mix_at_t = uP_Kp_Mix@t,
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: CONFIG_1;
	 at t: (req_addr = 10);
	 at t: (bus_in_sync = true);
prove:
	 at t_end: CONFIG_0;
	 at t_end: req_addr = 11;
	 at t_end: req_data = uP_Kp_Mix_at_t;
	 at t_end: resp_ack = bus_in_sig_ack_at_t;
	 at t_end: resp_data = bus_in_sig_data_at_t;
	 at t_end: uP_Kp_Mix = uP_Kp_Mix_at_t;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property CONFIG_1_read_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	uP_Ki_Mix_at_t = uP_Ki_Mix@t,
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: CONFIG_1;
	 at t: (req_addr = 11);
	 at t: (bus_in_sync = true);
prove:
	 at t_end: CONFIG_0;
	 at t_end: req_addr = 12;
	 at t_end: req_data = uP_Ki_Mix_at_t;
	 at t_end: resp_ack = bus_in_sig_ack_at_t;
	 at t_end: resp_data = bus_in_sig_data_at_t;
	 at t_end: uP_Ki_Mix = uP_Ki_Mix_at_t;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property CONFIG_1_read_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	uP_Kd_Mix_at_t = uP_Kd_Mix@t,
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: CONFIG_1;
	 at t: (req_addr = 12);
	 at t: (bus_in_sync = true);
prove:
	 at t_end: CONFIG_0;
	 at t_end: req_addr = 13;
	 at t_end: req_data = uP_Kd_Mix_at_t;
	 at t_end: resp_ack = bus_in_sig_ack_at_t;
	 at t_end: resp_data = bus_in_sig_data_at_t;
	 at t_end: uP_Kd_Mix = uP_Kd_Mix_at_t;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property wait_CONFIG_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: CONFIG_1;
	 at t: (bus_in_sync = false);
prove:
	 at t_end: CONFIG_1;
	 during[t+1, t_end-1]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_in_notify = true;
end property;

property CONFIG_1_read_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: CONFIG_1;
	 at t: not((req_addr = 1));
	 at t: not((req_addr = 2));
	 at t: not((req_addr = 3));
	 at t: not((req_addr = 4));
	 at t: not((req_addr = 5));
	 at t: not((req_addr = 9));
	 at t: not((req_addr = 10));
	 at t: not((req_addr = 11));
	 at t: not((req_addr = 12));
	 at t: (bus_in_sync = true);
prove:
	 at t_end: GET_TEMP_5;
	 at t_end: req_addr = 16;
	 at t_end: req_trans_type = SINGLE_READ;
	 at t_end: resp_ack = bus_in_sig_ack_at_t;
	 at t_end: resp_data = bus_in_sig_data_at_t;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property ERROR_2_write_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: ERROR_2;
prove:
	 at t_end: ERROR_3;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: mix_power_sig = false;
end property;

property ERROR_3_write_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: ERROR_3;
prove:
	 at t_end: ERROR_4;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end-1]: uP_report_out_notify = false;
	 at t_end: uP_report_out_notify = true;
	 at t_end: uP_report_out_sig = err_id;
end property;

property ERROR_4_write_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: ERROR_4;
	 at t: (uP_report_out_sync = true);
prove:
	 at t_end: ERROR_2;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: heat_power_sig = false;
end property;

property wait_ERROR_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: ERROR_4;
	 at t: (uP_report_out_sync = false);
prove:
	 at t_end: ERROR_4;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end-1]: uP_report_out_notify = false;
	 at t_end: uP_report_out_notify = true;
	 at t_end: uP_report_out_sig = err_id;
end property;

property wait_GET_TEMP_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: GET_TEMP_5;
	 at t: (bus_out_sync = false);
prove:
	 at t_end: GET_TEMP_5;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property GET_TEMP_5_write_14 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: GET_TEMP_5;
	 at t: (bus_out_sync = true);
prove:
	 at t_end: GET_TEMP_6;
	 during[t+1, t_end-1]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_in_notify = true;
end property;

property wait_GET_TEMP_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: GET_TEMP_6;
	 at t: (bus_in_sync = false);
prove:
	 at t_end: GET_TEMP_6;
	 during[t+1, t_end-1]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_in_notify = true;
end property;

property GET_TEMP_6_read_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	resp_top_ack_at_t = resp_top_ack@t,
	resp_top_data_at_t = resp_top_data@t,
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: GET_TEMP_6;
	 at t: (bus_in_sync = true);
prove:
	 at t_end: GET_TEMP_7;
	 at t_end: req_addr = 24;
	 at t_end: resp_top_ack = bus_in_sig_ack_at_t;
	 at t_end: resp_top_data = bus_in_sig_data_at_t;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property wait_GET_TEMP_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: GET_TEMP_7;
	 at t: (bus_out_sync = false);
prove:
	 at t_end: GET_TEMP_7;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property GET_TEMP_7_write_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: GET_TEMP_7;
	 at t: (bus_out_sync = true);
prove:
	 at t_end: GET_TEMP_8;
	 during[t+1, t_end-1]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_in_notify = true;
end property;

property GET_TEMP_8_read_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	err_id_at_t = err_id@t,
	resp_bot_ack_at_t = resp_bot_ack@t,
	resp_bot_data_at_t = resp_bot_data@t,
	resp_top_ack_at_t = resp_top_ack@t,
	resp_top_data_at_t = resp_top_data@t,
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: GET_TEMP_8;
	 at t: (((((not((resp_top_ack = OK)) or not((bus_in_ack_sig = OK))) or not((resp_top_data <= 50))) or not((0 <= resp_top_data))) or not((bus_in_data_sig <= 50))) or not((0 <= bus_in_data_sig)));
	 at t: (bus_in_sync = true);
prove:
	 at t_end: ERROR_2;
	 at t_end: err_id = ERR_TEMP;
	 at t_end: resp_bot_ack = bus_in_sig_ack_at_t;
	 at t_end: resp_bot_data = bus_in_sig_data_at_t;
	 at t_end: resp_top_ack = resp_top_ack_at_t;
	 at t_end: resp_top_data = resp_top_data_at_t;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: heat_power_sig = false;
end property;

property GET_TEMP_8_read_18 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	err_id_at_t = err_id@t,
	resp_bot_ack_at_t = resp_bot_ack@t,
	resp_bot_data_at_t = resp_bot_data@t,
	resp_top_ack_at_t = resp_top_ack@t,
	resp_top_data_at_t = resp_top_data@t,
	uP_max_temp_diff_at_t = uP_max_temp_diff@t,
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: GET_TEMP_8;
	 at t: (resp_top_ack = OK);
	 at t: (bus_in_ack_sig = OK);
	 at t: (not(((resp_top_data + (-1 * bus_in_data_sig)) <= uP_max_temp_diff)) or not(((bus_in_data_sig + (-1 * resp_top_data)) <= uP_max_temp_diff)));
	 at t: (resp_top_data >= 0);
	 at t: (resp_top_data <= 50);
	 at t: (bus_in_data_sig >= 0);
	 at t: (bus_in_data_sig <= 50);
	 at t: (bus_in_sync = true);
prove:
	 at t_end: ERROR_2;
	 at t_end: err_id = ERR_MIX;
	 at t_end: resp_bot_ack = bus_in_sig_ack_at_t;
	 at t_end: resp_bot_data = bus_in_sig_data_at_t;
	 at t_end: resp_top_ack = resp_top_ack_at_t;
	 at t_end: resp_top_data = resp_top_data_at_t;
	 at t_end: uP_max_temp_diff = uP_max_temp_diff_at_t;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: heat_power_sig = false;
end property;

property wait_GET_TEMP_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: GET_TEMP_8;
	 at t: (bus_in_sync = false);
prove:
	 at t_end: GET_TEMP_8;
	 during[t+1, t_end-1]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_in_notify = true;
end property;

property GET_TEMP_8_read_19 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_bot_ack_at_t = resp_bot_ack@t,
	resp_bot_data_at_t = resp_bot_data@t,
	resp_top_ack_at_t = resp_top_ack@t,
	resp_top_data_at_t = resp_top_data@t,
	uP_max_temp_diff_at_t = uP_max_temp_diff@t,
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: GET_TEMP_8;
	 at t: (resp_top_ack = OK);
	 at t: (bus_in_ack_sig = OK);
	 at t: ((resp_top_data + (-1 * bus_in_data_sig)) <= uP_max_temp_diff);
	 at t: ((bus_in_data_sig + (-1 * resp_top_data)) <= uP_max_temp_diff);
	 at t: (resp_top_data >= 0);
	 at t: (resp_top_data <= 50);
	 at t: (bus_in_data_sig >= 0);
	 at t: (bus_in_data_sig <= 50);
	 at t: (bus_in_sync = true);
prove:
	 at t_end: SET_MIX_16;
	 at t_end: req_addr = 8;
	 at t_end: req_data = ((resp_top_data_at_t + bus_in_sig_data_at_t) div 2);
	 at t_end: req_trans_type = SINGLE_WRITE;
	 at t_end: resp_bot_ack = bus_in_sig_ack_at_t;
	 at t_end: resp_bot_data = bus_in_sig_data_at_t;
	 at t_end: resp_top_ack = resp_top_ack_at_t;
	 at t_end: resp_top_data = resp_top_data_at_t;
	 at t_end: uP_max_temp_diff = uP_max_temp_diff_at_t;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property wait_IDLE_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: IDLE_9;
	 at t: (sample_timer_sync = false);
prove:
	 at t_end: IDLE_9;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end-1]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: sample_timer_notify = true;
end property;

property IDLE_9_read_20 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: IDLE_9;
	 at t: (sample_timer_sync = true);
prove:
	 at t_end: IDLE_10;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end-1]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: uP_in_notify = true;
end property;

property IDLE_10_read_21 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	nb_result_at_t = nb_result@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	uP_Kd_Heat_at_t = uP_Kd_Heat@t,
	uP_Kd_Mix_at_t = uP_Kd_Mix@t,
	uP_Ki_Heat_at_t = uP_Ki_Heat@t,
	uP_Ki_Mix_at_t = uP_Ki_Mix@t,
	uP_Kp_Heat_at_t = uP_Kp_Heat@t,
	uP_Kp_Mix_at_t = uP_Kp_Mix@t,
	uP_max_temp_diff_at_t = uP_max_temp_diff@t,
	uP_sample_time_at_t = uP_sample_time@t,
	uP_target_temp_at_t = uP_target_temp@t,
	uP_in_sig_Kd_Heat_at_t = uP_in_Kd_Heat_sig@t,
	uP_in_sig_Kd_Mix_at_t = uP_in_Kd_Mix_sig@t,
	uP_in_sig_Ki_Heat_at_t = uP_in_Ki_Heat_sig@t,
	uP_in_sig_Ki_Mix_at_t = uP_in_Ki_Mix_sig@t,
	uP_in_sig_Kp_Heat_at_t = uP_in_Kp_Heat_sig@t,
	uP_in_sig_Kp_Mix_at_t = uP_in_Kp_Mix_sig@t,
	uP_in_sig_max_temp_diff_at_t = uP_in_max_temp_diff_sig@t,
	uP_in_sig_sample_time_at_t = uP_in_sample_time_sig@t,
	uP_in_sig_target_temp_at_t = uP_in_target_temp_sig@t;
assume: 
	 at t: IDLE_10;
	 at t: (uP_in_sync = true);
prove:
	 at t_end: CONFIG_0;
	 at t_end: nb_result = true;
	 at t_end: req_addr = 1;
	 at t_end: req_data = uP_in_sig_sample_time_at_t;
	 at t_end: req_trans_type = SINGLE_WRITE;
	 at t_end: uP_Kd_Heat = uP_in_sig_Kd_Heat_at_t;
	 at t_end: uP_Kd_Mix = uP_in_sig_Kd_Mix_at_t;
	 at t_end: uP_Ki_Heat = uP_in_sig_Ki_Heat_at_t;
	 at t_end: uP_Ki_Mix = uP_in_sig_Ki_Mix_at_t;
	 at t_end: uP_Kp_Heat = uP_in_sig_Kp_Heat_at_t;
	 at t_end: uP_Kp_Mix = uP_in_sig_Kp_Mix_at_t;
	 at t_end: uP_max_temp_diff = uP_in_sig_max_temp_diff_at_t;
	 at t_end: uP_sample_time = uP_in_sig_sample_time_at_t;
	 at t_end: uP_target_temp = uP_in_sig_target_temp_at_t;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property IDLE_10_read_22 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	nb_result_at_t = nb_result@t,
	req_addr_at_t = req_addr@t,
	req_trans_type_at_t = req_trans_type@t,
	uP_in_sig_Kd_Heat_at_t = uP_in_Kd_Heat_sig@t,
	uP_in_sig_Kd_Mix_at_t = uP_in_Kd_Mix_sig@t,
	uP_in_sig_Ki_Heat_at_t = uP_in_Ki_Heat_sig@t,
	uP_in_sig_Ki_Mix_at_t = uP_in_Ki_Mix_sig@t,
	uP_in_sig_Kp_Heat_at_t = uP_in_Kp_Heat_sig@t,
	uP_in_sig_Kp_Mix_at_t = uP_in_Kp_Mix_sig@t,
	uP_in_sig_max_temp_diff_at_t = uP_in_max_temp_diff_sig@t,
	uP_in_sig_sample_time_at_t = uP_in_sample_time_sig@t,
	uP_in_sig_target_temp_at_t = uP_in_target_temp_sig@t;
assume: 
	 at t: IDLE_10;
	 at t: (uP_in_sync = false);
prove:
	 at t_end: GET_TEMP_5;
	 at t_end: nb_result = false;
	 at t_end: req_addr = 16;
	 at t_end: req_trans_type = SINGLE_READ;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property INIT_11_write_23 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: INIT_11;
prove:
	 at t_end: INIT_12;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: mix_power_sig = true;
end property;

property INIT_12_write_24 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: INIT_12;
prove:
	 at t_end: INIT_13;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end-1]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: uP_in_notify = true;
end property;

property INIT_13_read_25 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	uP_Kd_Heat_at_t = uP_Kd_Heat@t,
	uP_Kd_Mix_at_t = uP_Kd_Mix@t,
	uP_Ki_Heat_at_t = uP_Ki_Heat@t,
	uP_Ki_Mix_at_t = uP_Ki_Mix@t,
	uP_Kp_Heat_at_t = uP_Kp_Heat@t,
	uP_Kp_Mix_at_t = uP_Kp_Mix@t,
	uP_max_temp_diff_at_t = uP_max_temp_diff@t,
	uP_sample_time_at_t = uP_sample_time@t,
	uP_target_temp_at_t = uP_target_temp@t,
	uP_in_sig_Kd_Heat_at_t = uP_in_Kd_Heat_sig@t,
	uP_in_sig_Kd_Mix_at_t = uP_in_Kd_Mix_sig@t,
	uP_in_sig_Ki_Heat_at_t = uP_in_Ki_Heat_sig@t,
	uP_in_sig_Ki_Mix_at_t = uP_in_Ki_Mix_sig@t,
	uP_in_sig_Kp_Heat_at_t = uP_in_Kp_Heat_sig@t,
	uP_in_sig_Kp_Mix_at_t = uP_in_Kp_Mix_sig@t,
	uP_in_sig_max_temp_diff_at_t = uP_in_max_temp_diff_sig@t,
	uP_in_sig_sample_time_at_t = uP_in_sample_time_sig@t,
	uP_in_sig_target_temp_at_t = uP_in_target_temp_sig@t;
assume: 
	 at t: INIT_13;
	 at t: (uP_in_sync = true);
prove:
	 at t_end: CONFIG_0;
	 at t_end: req_addr = 1;
	 at t_end: req_data = uP_in_sig_sample_time_at_t;
	 at t_end: req_trans_type = SINGLE_WRITE;
	 at t_end: uP_Kd_Heat = uP_in_sig_Kd_Heat_at_t;
	 at t_end: uP_Kd_Mix = uP_in_sig_Kd_Mix_at_t;
	 at t_end: uP_Ki_Heat = uP_in_sig_Ki_Heat_at_t;
	 at t_end: uP_Ki_Mix = uP_in_sig_Ki_Mix_at_t;
	 at t_end: uP_Kp_Heat = uP_in_sig_Kp_Heat_at_t;
	 at t_end: uP_Kp_Mix = uP_in_sig_Kp_Mix_at_t;
	 at t_end: uP_max_temp_diff = uP_in_sig_max_temp_diff_at_t;
	 at t_end: uP_sample_time = uP_in_sig_sample_time_at_t;
	 at t_end: uP_target_temp = uP_in_sig_target_temp_at_t;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property wait_INIT_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	uP_in_sig_Kd_Heat_at_t = uP_in_Kd_Heat_sig@t,
	uP_in_sig_Kd_Mix_at_t = uP_in_Kd_Mix_sig@t,
	uP_in_sig_Ki_Heat_at_t = uP_in_Ki_Heat_sig@t,
	uP_in_sig_Ki_Mix_at_t = uP_in_Ki_Mix_sig@t,
	uP_in_sig_Kp_Heat_at_t = uP_in_Kp_Heat_sig@t,
	uP_in_sig_Kp_Mix_at_t = uP_in_Kp_Mix_sig@t,
	uP_in_sig_max_temp_diff_at_t = uP_in_max_temp_diff_sig@t,
	uP_in_sig_sample_time_at_t = uP_in_sample_time_sig@t,
	uP_in_sig_target_temp_at_t = uP_in_target_temp_sig@t;
assume: 
	 at t: INIT_13;
	 at t: (uP_in_sync = false);
prove:
	 at t_end: INIT_13;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end-1]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: uP_in_notify = true;
end property;

property wait_SET_HEAT_14 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: SET_HEAT_14;
	 at t: (bus_out_sync = false);
prove:
	 at t_end: SET_HEAT_14;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property SET_HEAT_14_write_26 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: SET_HEAT_14;
	 at t: (bus_out_sync = true);
prove:
	 at t_end: SET_HEAT_15;
	 during[t+1, t_end-1]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_in_notify = true;
end property;

property SET_HEAT_15_read_27 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: SET_HEAT_15;
	 at t: (bus_in_sync = true);
prove:
	 at t_end: IDLE_9;
	 at t_end: resp_ack = bus_in_sig_ack_at_t;
	 at t_end: resp_data = bus_in_sig_data_at_t;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end-1]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: sample_timer_notify = true;
end property;

property wait_SET_HEAT_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: SET_HEAT_15;
	 at t: (bus_in_sync = false);
prove:
	 at t_end: SET_HEAT_15;
	 during[t+1, t_end-1]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_in_notify = true;
end property;

property wait_SET_MIX_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: SET_MIX_16;
	 at t: (bus_out_sync = false);
prove:
	 at t_end: SET_MIX_16;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property SET_MIX_16_write_28 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: SET_MIX_16;
	 at t: (bus_out_sync = true);
prove:
	 at t_end: SET_MIX_17;
	 during[t+1, t_end-1]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_in_notify = true;
end property;

property SET_MIX_17_read_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	resp_bot_data_at_t = resp_bot_data@t,
	resp_top_data_at_t = resp_top_data@t,
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: SET_MIX_17;
	 at t: (bus_in_sync = true);
prove:
	 at t_end: SET_HEAT_14;
	 at t_end: req_addr = 0;
	 at t_end: req_data = ((resp_top_data_at_t + resp_bot_data_at_t) div 2);
	 at t_end: req_trans_type = SINGLE_WRITE;
	 at t_end: resp_ack = bus_in_sig_ack_at_t;
	 at t_end: resp_data = bus_in_sig_data_at_t;
	 at t_end: resp_bot_data = resp_bot_data_at_t;
	 at t_end: resp_top_data = resp_top_data_at_t;
	 during[t+1, t_end]: bus_in_notify = false;
	 during[t+1, t_end-1]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_out_notify = true;
	 at t_end: bus_out_addr_sig = req_addr;
	 at t_end: bus_out_data_sig = req_data;
	 at t_end: bus_out_trans_type_sig = req_trans_type;
end property;

property wait_SET_MIX_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	bus_in_sig_ack_at_t = bus_in_ack_sig@t,
	bus_in_sig_data_at_t = bus_in_data_sig@t;
assume: 
	 at t: SET_MIX_17;
	 at t: (bus_in_sync = false);
prove:
	 at t_end: SET_MIX_17;
	 during[t+1, t_end-1]: bus_in_notify = false;
	 during[t+1, t_end]: bus_out_notify = false;
	 during[t+1, t_end]: sample_timer_notify = false;
	 during[t+1, t_end]: uP_in_notify = false;
	 during[t+1, t_end]: uP_report_out_notify = false;
	 at t_end: bus_in_notify = true;
end property;