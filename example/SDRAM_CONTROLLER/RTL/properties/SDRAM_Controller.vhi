-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: idle_1;
	 at t: acc_rw = false;
	 at t: data_in_req_address_in = resize(0,32);
	 at t: data_in_req_burst_single = false;
	 at t: data_in_req_read_req = false;
	 at t: data_in_req_write_req = false;
	 at t: response_idle_last_row = resize(0,32);
	 at t: data_in_notify = true;
	 at t: data_int_notify = false;
	 at t: data_out_burst_read_notify = false;
	 at t: data_out_burst_write_notify = false;
	 at t: data_out_idle_notify = false;
	 at t: data_out_single_read_notify = false;
	 at t: data_out_single_write_notify = false;
end property;


property PRECHARGE_2_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	acc_rw_at_t = acc_rw@t,
	precharge_read_sig_address_in_at_t = precharge_read_sig_address_in@t,
	precharge_read_sig_burst_single_at_t = precharge_read_sig_burst_single@t,
	precharge_read_sig_read_req_at_t = precharge_read_sig_read_req@t,
	precharge_read_sig_write_req_at_t = precharge_read_sig_write_req@t,
	response_idle_last_row_at_t = response_idle_last_row@t;
assume:
	at t: PRECHARGE_2;
prove:
	at t_end: idle_1;
	at t_end: acc_rw = acc_rw_at_t;
	at t_end: data_in_req_address_in = precharge_read_sig_address_in_at_t;
	at t_end: data_in_req_burst_single = precharge_read_sig_burst_single_at_t;
	at t_end: data_in_req_read_req = precharge_read_sig_read_req_at_t;
	at t_end: data_in_req_write_req = precharge_read_sig_write_req_at_t;
	at t_end: response_idle_last_row = response_idle_last_row_at_t;
	during[t+1, t_end-1]: data_in_notify = false;
	at t_end: data_in_notify = true;
	during[t+1, t_end]: data_int_notify = false;
	during[t+1, t_end]: data_out_burst_read_notify = false;
	during[t+1, t_end]: data_out_burst_write_notify = false;
	during[t+1, t_end]: data_out_idle_notify = false;
	during[t+1, t_end]: data_out_single_read_notify = false;
	during[t+1, t_end]: data_out_single_write_notify = false;
end property;


property activate_3_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+4;
freeze:
	data_in_req_address_in_at_t = data_in_req_address_in@t,
	data_in_req_burst_single_at_t = data_in_req_burst_single@t,
	data_in_req_read_req_at_t = data_in_req_read_req@t,
	data_in_req_write_req_at_t = data_in_req_write_req@t,
	response_idle_last_row_at_t = response_idle_last_row@t,
	sdram_data_in_sig_at_t = sdram_data_in_sig@t;
assume:
	at t: activate_3;
	at t: (((data_in_req_read_req and not(acc_rw)) and not(data_in_req_burst_single)) and ((shift_right((data_in_req_address_in and resize(16777215,32)),resize(12,32))) = response_idle_last_row));
prove:
	at t_end: single_read_4;
	at t_end: acc_rw = data_in_req_write_req_at_t;
	at t_end: data_in_req_address_in = data_in_req_address_in_at_t;
	at t_end: data_in_req_burst_single = data_in_req_burst_single_at_t;
	at t_end: data_in_req_read_req = data_in_req_read_req_at_t;
	at t_end: data_in_req_write_req = data_in_req_write_req_at_t;
	at t_end: data_out_single_read_sig_address = (data_in_req_address_in_at_t and 4095);
	at t_end: data_out_single_read_sig_data_out = sdram_data_in_sig_at_t;
	at t_end: data_out_single_read_sig_ready = false;
	at t_end: data_out_single_read_sig_sdram_status = true;
	at t_end: response_idle_last_row = response_idle_last_row_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end]: data_int_notify = false;
	during[t+1, t_end]: data_out_burst_read_notify = false;
	during[t+1, t_end]: data_out_burst_write_notify = false;
	during[t+1, t_end]: data_out_idle_notify = false;
	during[t+1, t_end-1]: data_out_single_read_notify = false;
	at t_end: data_out_single_read_notify = true;
	during[t+1, t_end]: data_out_single_write_notify = false;
end property;


property activate_3_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	CPU_data_in_sig_at_t = CPU_data_in_sig@t,
	acc_rw_at_t = acc_rw@t,
	data_in_req_address_in_at_t = data_in_req_address_in@t,
	data_in_req_burst_single_at_t = data_in_req_burst_single@t,
	data_in_req_read_req_at_t = data_in_req_read_req@t,
	data_in_req_write_req_at_t = data_in_req_write_req@t,
	response_idle_last_row_at_t = response_idle_last_row@t;
assume:
	at t: activate_3;
	at t: not((((data_in_req_read_req and not(acc_rw)) and not(data_in_req_burst_single)) and ((shift_right((data_in_req_address_in and resize(16777215,32)),resize(12,32))) = response_idle_last_row)));
	at t: (((data_in_req_write_req and not(data_in_req_burst_single)) and ((shift_right((data_in_req_address_in and resize(16777215,32)),resize(12,32))) = response_idle_last_row)) or (acc_rw = true));
prove:
	at t_end: single_write_5;
	at t_end: acc_rw = acc_rw_at_t;
	at t_end: data_in_req_address_in = data_in_req_address_in_at_t;
	at t_end: data_in_req_burst_single = data_in_req_burst_single_at_t;
	at t_end: data_in_req_read_req = data_in_req_read_req_at_t;
	at t_end: data_in_req_write_req = data_in_req_write_req_at_t;
	at t_end: data_out_single_write_sig_address = (data_in_req_address_in_at_t and 4095);
	at t_end: data_out_single_write_sig_data_out = CPU_data_in_sig_at_t;
	at t_end: data_out_single_write_sig_ready = false;
	at t_end: data_out_single_write_sig_sdram_status = true;
	at t_end: response_idle_last_row = response_idle_last_row_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end]: data_int_notify = false;
	during[t+1, t_end]: data_out_burst_read_notify = false;
	during[t+1, t_end]: data_out_burst_write_notify = false;
	during[t+1, t_end]: data_out_idle_notify = false;
	during[t+1, t_end]: data_out_single_read_notify = false;
	during[t+1, t_end-1]: data_out_single_write_notify = false;
	at t_end: data_out_single_write_notify = true;
end property;


property activate_3_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+7;
freeze:
	acc_rw_at_t = acc_rw@t,
	data_in_req_address_in_at_t = data_in_req_address_in@t,
	data_in_req_burst_single_at_t = data_in_req_burst_single@t,
	data_in_req_read_req_at_t = data_in_req_read_req@t,
	data_in_req_write_req_at_t = data_in_req_write_req@t,
	response_idle_last_row_at_t = response_idle_last_row@t,
	sdram_data_in_burst_sig_data_1_at_t = sdram_data_in_burst_sig_data_1@t,
	sdram_data_in_burst_sig_data_2_at_t = sdram_data_in_burst_sig_data_2@t,
	sdram_data_in_burst_sig_data_3_at_t = sdram_data_in_burst_sig_data_3@t,
	sdram_data_in_burst_sig_data_4_at_t = sdram_data_in_burst_sig_data_4@t;
assume:
	at t: activate_3;
	at t: not((((data_in_req_read_req and not(acc_rw)) and not(data_in_req_burst_single)) and ((shift_right((data_in_req_address_in and resize(16777215,32)),resize(12,32))) = response_idle_last_row)));
	at t: not((((data_in_req_write_req and not(data_in_req_burst_single)) and ((shift_right((data_in_req_address_in and resize(16777215,32)),resize(12,32))) = response_idle_last_row)) or (acc_rw = true)));
	at t: (((data_in_req_read_req and not(data_in_req_write_req)) and data_in_req_burst_single) and ((shift_right((data_in_req_address_in and resize(16777215,32)),resize(12,32))) = response_idle_last_row));
prove:
	at t_end: burst_read_6;
	at t_end: acc_rw = acc_rw_at_t;
	at t_end: data_in_req_address_in = data_in_req_address_in_at_t;
	at t_end: data_in_req_burst_single = data_in_req_burst_single_at_t;
	at t_end: data_in_req_read_req = data_in_req_read_req_at_t;
	at t_end: data_in_req_write_req = data_in_req_write_req_at_t;
	at t_end: data_out_burst_read_sig_address = (data_in_req_address_in_at_t and 4095);
	at t_end: data_out_burst_read_sig_data_1 = sdram_data_in_burst_sig_data_1_at_t;
	at t_end: data_out_burst_read_sig_data_2 = sdram_data_in_burst_sig_data_2_at_t;
	at t_end: data_out_burst_read_sig_data_3 = sdram_data_in_burst_sig_data_3_at_t;
	at t_end: data_out_burst_read_sig_data_4 = sdram_data_in_burst_sig_data_4_at_t;
	at t_end: data_out_burst_read_sig_ready = false;
	at t_end: data_out_burst_read_sig_sdram_status = true;
	at t_end: response_idle_last_row = response_idle_last_row_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end]: data_int_notify = false;
	during[t+1, t_end-1]: data_out_burst_read_notify = false;
	at t_end: data_out_burst_read_notify = true;
	during[t+1, t_end]: data_out_burst_write_notify = false;
	during[t+1, t_end]: data_out_idle_notify = false;
	during[t+1, t_end]: data_out_single_read_notify = false;
	during[t+1, t_end]: data_out_single_write_notify = false;
end property;


property activate_3_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+4;
freeze:
	CPU_data_in_burst_sig_data_1_at_t = CPU_data_in_burst_sig_data_1@t,
	CPU_data_in_burst_sig_data_2_at_t = CPU_data_in_burst_sig_data_2@t,
	CPU_data_in_burst_sig_data_3_at_t = CPU_data_in_burst_sig_data_3@t,
	CPU_data_in_burst_sig_data_4_at_t = CPU_data_in_burst_sig_data_4@t,
	acc_rw_at_t = acc_rw@t,
	data_in_req_address_in_at_t = data_in_req_address_in@t,
	data_in_req_burst_single_at_t = data_in_req_burst_single@t,
	data_in_req_read_req_at_t = data_in_req_read_req@t,
	data_in_req_write_req_at_t = data_in_req_write_req@t,
	response_idle_last_row_at_t = response_idle_last_row@t;
assume:
	at t: activate_3;
	at t: not((((data_in_req_read_req and not(acc_rw)) and not(data_in_req_burst_single)) and ((shift_right((data_in_req_address_in and resize(16777215,32)),resize(12,32))) = response_idle_last_row)));
	at t: not((((data_in_req_write_req and not(data_in_req_burst_single)) and ((shift_right((data_in_req_address_in and resize(16777215,32)),resize(12,32))) = response_idle_last_row)) or (acc_rw = true)));
	at t: not((((data_in_req_read_req and not(data_in_req_write_req)) and data_in_req_burst_single) and ((shift_right((data_in_req_address_in and resize(16777215,32)),resize(12,32))) = response_idle_last_row)));
	at t: (((not(data_in_req_read_req) and data_in_req_write_req) and data_in_req_burst_single) and ((shift_right((data_in_req_address_in and resize(16777215,32)),resize(12,32))) = response_idle_last_row));
prove:
	at t_end: burst_write_7;
	at t_end: acc_rw = acc_rw_at_t;
	at t_end: data_in_req_address_in = data_in_req_address_in_at_t;
	at t_end: data_in_req_burst_single = data_in_req_burst_single_at_t;
	at t_end: data_in_req_read_req = data_in_req_read_req_at_t;
	at t_end: data_in_req_write_req = data_in_req_write_req_at_t;
	at t_end: data_out_burst_write_sig_address = (data_in_req_address_in_at_t and 4095);
	at t_end: data_out_burst_write_sig_data_1 = CPU_data_in_burst_sig_data_1_at_t;
	at t_end: data_out_burst_write_sig_data_2 = CPU_data_in_burst_sig_data_2_at_t;
	at t_end: data_out_burst_write_sig_data_3 = CPU_data_in_burst_sig_data_3_at_t;
	at t_end: data_out_burst_write_sig_data_4 = CPU_data_in_burst_sig_data_4_at_t;
	at t_end: data_out_burst_write_sig_ready = false;
	at t_end: data_out_burst_write_sig_sdram_status = true;
	at t_end: response_idle_last_row = response_idle_last_row_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end]: data_int_notify = false;
	during[t+1, t_end]: data_out_burst_read_notify = false;
	during[t+1, t_end-1]: data_out_burst_write_notify = false;
	at t_end: data_out_burst_write_notify = true;
	during[t+1, t_end]: data_out_idle_notify = false;
	during[t+1, t_end]: data_out_single_read_notify = false;
	during[t+1, t_end]: data_out_single_write_notify = false;
end property;


property activate_3_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	acc_rw_at_t = acc_rw@t,
	data_in_req_address_in_at_t = data_in_req_address_in@t,
	data_in_req_burst_single_at_t = data_in_req_burst_single@t,
	data_in_req_read_req_at_t = data_in_req_read_req@t,
	data_in_req_write_req_at_t = data_in_req_write_req@t,
	response_idle_last_row_at_t = response_idle_last_row@t;
assume:
	at t: activate_3;
	at t: not((((data_in_req_read_req and not(acc_rw)) and not(data_in_req_burst_single)) and ((shift_right((data_in_req_address_in and resize(16777215,32)),resize(12,32))) = response_idle_last_row)));
	at t: not((((data_in_req_write_req and not(data_in_req_burst_single)) and ((shift_right((data_in_req_address_in and resize(16777215,32)),resize(12,32))) = response_idle_last_row)) or (acc_rw = true)));
	at t: not((((data_in_req_read_req and not(data_in_req_write_req)) and data_in_req_burst_single) and ((shift_right((data_in_req_address_in and resize(16777215,32)),resize(12,32))) = response_idle_last_row)));
	at t: not((((not(data_in_req_read_req) and data_in_req_write_req) and data_in_req_burst_single) and ((shift_right((data_in_req_address_in and resize(16777215,32)),resize(12,32))) = response_idle_last_row)));
prove:
	at t_end: PRECHARGE_2;
	at t_end: acc_rw = acc_rw_at_t;
	at t_end: data_in_req_address_in = data_in_req_address_in_at_t;
	at t_end: data_in_req_burst_single = data_in_req_burst_single_at_t;
	at t_end: data_in_req_read_req = data_in_req_read_req_at_t;
	at t_end: data_in_req_write_req = data_in_req_write_req_at_t;
	at t_end: response_idle_last_row = response_idle_last_row_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end]: data_int_notify = false;
	during[t+1, t_end]: data_out_burst_read_notify = false;
	during[t+1, t_end]: data_out_burst_write_notify = false;
	during[t+1, t_end]: data_out_idle_notify = false;
	during[t+1, t_end]: data_out_single_read_notify = false;
	during[t+1, t_end]: data_out_single_write_notify = false;
end property;


property burst_read_6_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+2;
freeze:
	acc_rw_at_t = acc_rw@t,
	precharge_read_sig_address_in_at_t = precharge_read_sig_address_in@t,
	precharge_read_sig_burst_single_at_t = precharge_read_sig_burst_single@t,
	precharge_read_sig_read_req_at_t = precharge_read_sig_read_req@t,
	precharge_read_sig_write_req_at_t = precharge_read_sig_write_req@t,
	response_idle_last_row_at_t = response_idle_last_row@t;
assume:
	at t: burst_read_6;
	at t: (((shift_right((data_in_end_burst_read_op_sig_address_in and resize(16777215,32)),resize(12,32))) /= response_idle_last_row) or (not(data_in_end_burst_read_op_sig_read_req) and not(data_in_end_burst_read_op_sig_write_req)));
prove:
	at t_end: PRECHARGE_2;
	at t_end: acc_rw = acc_rw_at_t;
	at t_end: data_in_req_address_in = precharge_read_sig_address_in_at_t;
	at t_end: data_in_req_burst_single = precharge_read_sig_burst_single_at_t;
	at t_end: data_in_req_read_req = precharge_read_sig_read_req_at_t;
	at t_end: data_in_req_write_req = precharge_read_sig_write_req_at_t;
	at t_end: response_idle_last_row = response_idle_last_row_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end]: data_int_notify = false;
	during[t+1, t_end]: data_out_burst_read_notify = false;
	during[t+1, t_end]: data_out_burst_write_notify = false;
	during[t+1, t_end]: data_out_idle_notify = false;
	during[t+1, t_end]: data_out_single_read_notify = false;
	during[t+1, t_end]: data_out_single_write_notify = false;
end property;


property burst_read_6_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	acc_rw_at_t = acc_rw@t,
	data_in_end_burst_read_op_sig_address_in_at_t = data_in_end_burst_read_op_sig_address_in@t,
	data_in_end_burst_read_op_sig_burst_single_at_t = data_in_end_burst_read_op_sig_burst_single@t,
	data_in_end_burst_read_op_sig_read_req_at_t = data_in_end_burst_read_op_sig_read_req@t,
	data_in_end_burst_read_op_sig_write_req_at_t = data_in_end_burst_read_op_sig_write_req@t,
	response_idle_last_row_at_t = response_idle_last_row@t;
assume:
	at t: burst_read_6;
	at t: not((((shift_right((data_in_end_burst_read_op_sig_address_in and resize(16777215,32)),resize(12,32))) /= response_idle_last_row) or (not(data_in_end_burst_read_op_sig_read_req) and not(data_in_end_burst_read_op_sig_write_req))));
prove:
	at t_end: activate_3;
	at t_end: acc_rw = acc_rw_at_t;
	at t_end: data_in_req_address_in = data_in_end_burst_read_op_sig_address_in_at_t;
	at t_end: data_in_req_burst_single = data_in_end_burst_read_op_sig_burst_single_at_t;
	at t_end: data_in_req_read_req = data_in_end_burst_read_op_sig_read_req_at_t;
	at t_end: data_in_req_write_req = data_in_end_burst_read_op_sig_write_req_at_t;
	at t_end: data_int_sig_address = (data_in_end_burst_read_op_sig_address_in_at_t and 4095);
	at t_end: data_int_sig_ready = false;
	at t_end: data_int_sig_sdram_status = true;
	at t_end: response_idle_last_row = response_idle_last_row_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end-1]: data_int_notify = false;
	at t_end: data_int_notify = true;
	during[t+1, t_end]: data_out_burst_read_notify = false;
	during[t+1, t_end]: data_out_burst_write_notify = false;
	during[t+1, t_end]: data_out_idle_notify = false;
	during[t+1, t_end]: data_out_single_read_notify = false;
	during[t+1, t_end]: data_out_single_write_notify = false;
end property;


property burst_write_7_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+2;
freeze:
	acc_rw_at_t = acc_rw@t,
	precharge_read_sig_address_in_at_t = precharge_read_sig_address_in@t,
	precharge_read_sig_burst_single_at_t = precharge_read_sig_burst_single@t,
	precharge_read_sig_read_req_at_t = precharge_read_sig_read_req@t,
	precharge_read_sig_write_req_at_t = precharge_read_sig_write_req@t,
	response_idle_last_row_at_t = response_idle_last_row@t;
assume:
	at t: burst_write_7;
	at t: (((shift_right((data_in_end_burst_write_op_sig_address_in and resize(16777215,32)),resize(12,32))) /= response_idle_last_row) or (not(data_in_end_burst_write_op_sig_read_req) and not(data_in_end_burst_write_op_sig_write_req)));
prove:
	at t_end: PRECHARGE_2;
	at t_end: acc_rw = acc_rw_at_t;
	at t_end: data_in_req_address_in = precharge_read_sig_address_in_at_t;
	at t_end: data_in_req_burst_single = precharge_read_sig_burst_single_at_t;
	at t_end: data_in_req_read_req = precharge_read_sig_read_req_at_t;
	at t_end: data_in_req_write_req = precharge_read_sig_write_req_at_t;
	at t_end: response_idle_last_row = response_idle_last_row_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end]: data_int_notify = false;
	during[t+1, t_end]: data_out_burst_read_notify = false;
	during[t+1, t_end]: data_out_burst_write_notify = false;
	during[t+1, t_end]: data_out_idle_notify = false;
	during[t+1, t_end]: data_out_single_read_notify = false;
	during[t+1, t_end]: data_out_single_write_notify = false;
end property;


property burst_write_7_18 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	acc_rw_at_t = acc_rw@t,
	data_in_end_burst_write_op_sig_address_in_at_t = data_in_end_burst_write_op_sig_address_in@t,
	data_in_end_burst_write_op_sig_burst_single_at_t = data_in_end_burst_write_op_sig_burst_single@t,
	data_in_end_burst_write_op_sig_read_req_at_t = data_in_end_burst_write_op_sig_read_req@t,
	data_in_end_burst_write_op_sig_write_req_at_t = data_in_end_burst_write_op_sig_write_req@t,
	response_idle_last_row_at_t = response_idle_last_row@t;
assume:
	at t: burst_write_7;
	at t: not((((shift_right((data_in_end_burst_write_op_sig_address_in and resize(16777215,32)),resize(12,32))) /= response_idle_last_row) or (not(data_in_end_burst_write_op_sig_read_req) and not(data_in_end_burst_write_op_sig_write_req))));
prove:
	at t_end: activate_3;
	at t_end: acc_rw = acc_rw_at_t;
	at t_end: data_in_req_address_in = data_in_end_burst_write_op_sig_address_in_at_t;
	at t_end: data_in_req_burst_single = data_in_end_burst_write_op_sig_burst_single_at_t;
	at t_end: data_in_req_read_req = data_in_end_burst_write_op_sig_read_req_at_t;
	at t_end: data_in_req_write_req = data_in_end_burst_write_op_sig_write_req_at_t;
	at t_end: data_int_sig_address = (data_in_end_burst_write_op_sig_address_in_at_t and 4095);
	at t_end: data_int_sig_ready = false;
	at t_end: data_int_sig_sdram_status = true;
	at t_end: response_idle_last_row = response_idle_last_row_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end-1]: data_int_notify = false;
	at t_end: data_int_notify = true;
	during[t+1, t_end]: data_out_burst_read_notify = false;
	during[t+1, t_end]: data_out_burst_write_notify = false;
	during[t+1, t_end]: data_out_idle_notify = false;
	during[t+1, t_end]: data_out_single_read_notify = false;
	during[t+1, t_end]: data_out_single_write_notify = false;
end property;


property idle_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+2;
freeze:
	acc_rw_at_t = acc_rw@t,
	data_in_sig_address_in_at_t = data_in_sig_address_in@t,
	data_in_sig_burst_single_at_t = data_in_sig_burst_single@t,
	data_in_sig_read_req_at_t = data_in_sig_read_req@t,
	data_in_sig_write_req_at_t = data_in_sig_write_req@t;
assume:
	at t: idle_1;
	at t: data_in_sync;
	at t: not((not(data_in_sig_read_req) and not(data_in_sig_write_req)));
prove:
	at t_end: activate_3;
	at t_end: acc_rw = acc_rw_at_t;
	at t_end: data_in_req_address_in = data_in_sig_address_in_at_t;
	at t_end: data_in_req_burst_single = data_in_sig_burst_single_at_t;
	at t_end: data_in_req_read_req = data_in_sig_read_req_at_t;
	at t_end: data_in_req_write_req = data_in_sig_write_req_at_t;
	at t_end: data_int_sig_address = (data_in_sig_address_in_at_t and 4095);
	at t_end: data_int_sig_ready = false;
	at t_end: data_int_sig_sdram_status = true;
	at t_end: data_out_idle_sig_address = (shift_right((data_in_sig_address_in_at_t and 16777215),12));
	at t_end: response_idle_last_row = (shift_right((data_in_sig_address_in_at_t and 16777215),12));
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end-1]: data_int_notify = false;
	at t_end: data_int_notify = true;
	during[t+1, t_end]: data_out_burst_read_notify = false;
	during[t+1, t_end]: data_out_burst_write_notify = false;
	during[t+1, t_end-1]: data_out_idle_notify = false;
	at t_end: data_out_idle_notify = true;
	during[t+1, t_end]: data_out_single_read_notify = false;
	during[t+1, t_end]: data_out_single_write_notify = false;
end property;


property idle_1_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	acc_rw_at_t = acc_rw@t,
	data_in_sig_address_in_at_t = data_in_sig_address_in@t,
	data_in_sig_burst_single_at_t = data_in_sig_burst_single@t,
	data_in_sig_read_req_at_t = data_in_sig_read_req@t,
	data_in_sig_write_req_at_t = data_in_sig_write_req@t,
	response_idle_last_row_at_t = response_idle_last_row@t;
assume:
	at t: idle_1;
	at t: data_in_sync;
	at t: not(data_in_sig_read_req);
	at t: not(data_in_sig_write_req);
prove:
	at t_end: idle_1;
	at t_end: acc_rw = acc_rw_at_t;
	at t_end: data_in_req_address_in = data_in_sig_address_in_at_t;
	at t_end: data_in_req_burst_single = data_in_sig_burst_single_at_t;
	at t_end: data_in_req_read_req = data_in_sig_read_req_at_t;
	at t_end: data_in_req_write_req = data_in_sig_write_req_at_t;
	at t_end: response_idle_last_row = response_idle_last_row_at_t;
	during[t+1, t_end-1]: data_in_notify = false;
	at t_end: data_in_notify = true;
	during[t+1, t_end]: data_int_notify = false;
	during[t+1, t_end]: data_out_burst_read_notify = false;
	during[t+1, t_end]: data_out_burst_write_notify = false;
	during[t+1, t_end]: data_out_idle_notify = false;
	during[t+1, t_end]: data_out_single_read_notify = false;
	during[t+1, t_end]: data_out_single_write_notify = false;
end property;


property single_read_4_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	acc_rw_at_t = acc_rw@t,
	data_in_req_address_in_at_t = data_in_req_address_in@t,
	data_in_req_burst_single_at_t = data_in_req_burst_single@t,
	data_in_req_read_req_at_t = data_in_req_read_req@t,
	data_in_req_write_req_at_t = data_in_req_write_req@t,
	response_idle_last_row_at_t = response_idle_last_row@t;
assume:
	at t: single_read_4;
	at t: acc_rw;
	at t: not((((shift_right((data_in_req_address_in and resize(16777215,32)),resize(12,32))) /= response_idle_last_row) or (not(data_in_req_read_req) and not(data_in_req_write_req))));
prove:
	at t_end: activate_3;
	at t_end: acc_rw = acc_rw_at_t;
	at t_end: data_in_req_address_in = data_in_req_address_in_at_t;
	at t_end: data_in_req_burst_single = data_in_req_burst_single_at_t;
	at t_end: data_in_req_read_req = data_in_req_read_req_at_t;
	at t_end: data_in_req_write_req = data_in_req_write_req_at_t;
	at t_end: data_int_sig_address = (data_in_req_address_in_at_t and 4095);
	at t_end: data_int_sig_ready = false;
	at t_end: data_int_sig_sdram_status = true;
	at t_end: response_idle_last_row = response_idle_last_row_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end-1]: data_int_notify = false;
	at t_end: data_int_notify = true;
	during[t+1, t_end]: data_out_burst_read_notify = false;
	during[t+1, t_end]: data_out_burst_write_notify = false;
	during[t+1, t_end]: data_out_idle_notify = false;
	during[t+1, t_end]: data_out_single_read_notify = false;
	during[t+1, t_end]: data_out_single_write_notify = false;
end property;


property single_read_4_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+2;
freeze:
	acc_rw_at_t = acc_rw@t,
	precharge_read_sig_address_in_at_t = precharge_read_sig_address_in@t,
	precharge_read_sig_burst_single_at_t = precharge_read_sig_burst_single@t,
	precharge_read_sig_read_req_at_t = precharge_read_sig_read_req@t,
	precharge_read_sig_write_req_at_t = precharge_read_sig_write_req@t,
	response_idle_last_row_at_t = response_idle_last_row@t;
assume:
	at t: single_read_4;
	at t: not(acc_rw);
	at t: (((shift_right((data_in_end_read_op_sig_address_in and resize(16777215,32)),resize(12,32))) /= response_idle_last_row) or (not(data_in_end_read_op_sig_read_req) and not(data_in_end_read_op_sig_write_req)));
prove:
	at t_end: PRECHARGE_2;
	at t_end: acc_rw = acc_rw_at_t;
	at t_end: data_in_req_address_in = precharge_read_sig_address_in_at_t;
	at t_end: data_in_req_burst_single = precharge_read_sig_burst_single_at_t;
	at t_end: data_in_req_read_req = precharge_read_sig_read_req_at_t;
	at t_end: data_in_req_write_req = precharge_read_sig_write_req_at_t;
	at t_end: response_idle_last_row = response_idle_last_row_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end]: data_int_notify = false;
	during[t+1, t_end]: data_out_burst_read_notify = false;
	during[t+1, t_end]: data_out_burst_write_notify = false;
	during[t+1, t_end]: data_out_idle_notify = false;
	during[t+1, t_end]: data_out_single_read_notify = false;
	during[t+1, t_end]: data_out_single_write_notify = false;
end property;


property single_read_4_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	acc_rw_at_t = acc_rw@t,
	data_in_end_read_op_sig_address_in_at_t = data_in_end_read_op_sig_address_in@t,
	data_in_end_read_op_sig_burst_single_at_t = data_in_end_read_op_sig_burst_single@t,
	data_in_end_read_op_sig_read_req_at_t = data_in_end_read_op_sig_read_req@t,
	data_in_end_read_op_sig_write_req_at_t = data_in_end_read_op_sig_write_req@t,
	response_idle_last_row_at_t = response_idle_last_row@t;
assume:
	at t: single_read_4;
	at t: not(acc_rw);
	at t: not((((shift_right((data_in_end_read_op_sig_address_in and resize(16777215,32)),resize(12,32))) /= response_idle_last_row) or (not(data_in_end_read_op_sig_read_req) and not(data_in_end_read_op_sig_write_req))));
prove:
	at t_end: activate_3;
	at t_end: acc_rw = acc_rw_at_t;
	at t_end: data_in_req_address_in = data_in_end_read_op_sig_address_in_at_t;
	at t_end: data_in_req_burst_single = data_in_end_read_op_sig_burst_single_at_t;
	at t_end: data_in_req_read_req = data_in_end_read_op_sig_read_req_at_t;
	at t_end: data_in_req_write_req = data_in_end_read_op_sig_write_req_at_t;
	at t_end: data_int_sig_address = (data_in_end_read_op_sig_address_in_at_t and 4095);
	at t_end: data_int_sig_ready = false;
	at t_end: data_int_sig_sdram_status = true;
	at t_end: response_idle_last_row = response_idle_last_row_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end-1]: data_int_notify = false;
	at t_end: data_int_notify = true;
	during[t+1, t_end]: data_out_burst_read_notify = false;
	during[t+1, t_end]: data_out_burst_write_notify = false;
	during[t+1, t_end]: data_out_idle_notify = false;
	during[t+1, t_end]: data_out_single_read_notify = false;
	during[t+1, t_end]: data_out_single_write_notify = false;
end property;


property single_read_4_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+2;
freeze:
	acc_rw_at_t = acc_rw@t,
	precharge_read_sig_address_in_at_t = precharge_read_sig_address_in@t,
	precharge_read_sig_burst_single_at_t = precharge_read_sig_burst_single@t,
	precharge_read_sig_read_req_at_t = precharge_read_sig_read_req@t,
	precharge_read_sig_write_req_at_t = precharge_read_sig_write_req@t,
	response_idle_last_row_at_t = response_idle_last_row@t;
assume:
	at t: single_read_4;
	at t: acc_rw;
	at t: (((shift_right((data_in_req_address_in and resize(16777215,32)),resize(12,32))) /= response_idle_last_row) or (not(data_in_req_read_req) and not(data_in_req_write_req)));
prove:
	at t_end: PRECHARGE_2;
	at t_end: acc_rw = acc_rw_at_t;
	at t_end: data_in_req_address_in = precharge_read_sig_address_in_at_t;
	at t_end: data_in_req_burst_single = precharge_read_sig_burst_single_at_t;
	at t_end: data_in_req_read_req = precharge_read_sig_read_req_at_t;
	at t_end: data_in_req_write_req = precharge_read_sig_write_req_at_t;
	at t_end: response_idle_last_row = response_idle_last_row_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end]: data_int_notify = false;
	during[t+1, t_end]: data_out_burst_read_notify = false;
	during[t+1, t_end]: data_out_burst_write_notify = false;
	during[t+1, t_end]: data_out_idle_notify = false;
	during[t+1, t_end]: data_out_single_read_notify = false;
	during[t+1, t_end]: data_out_single_write_notify = false;
end property;


property single_write_5_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+2;
freeze:
	precharge_read_sig_address_in_at_t = precharge_read_sig_address_in@t,
	precharge_read_sig_burst_single_at_t = precharge_read_sig_burst_single@t,
	precharge_read_sig_read_req_at_t = precharge_read_sig_read_req@t,
	precharge_read_sig_write_req_at_t = precharge_read_sig_write_req@t,
	response_idle_last_row_at_t = response_idle_last_row@t;
assume:
	at t: single_write_5;
	at t: (((shift_right((data_in_end_write_op_sig_address_in and resize(16777215,32)),resize(12,32))) /= response_idle_last_row) or (not(data_in_end_write_op_sig_read_req) and not(data_in_end_write_op_sig_write_req)));
prove:
	at t_end: PRECHARGE_2;
	at t_end: acc_rw = false;
	at t_end: data_in_req_address_in = precharge_read_sig_address_in_at_t;
	at t_end: data_in_req_burst_single = precharge_read_sig_burst_single_at_t;
	at t_end: data_in_req_read_req = precharge_read_sig_read_req_at_t;
	at t_end: data_in_req_write_req = precharge_read_sig_write_req_at_t;
	at t_end: response_idle_last_row = response_idle_last_row_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end]: data_int_notify = false;
	during[t+1, t_end]: data_out_burst_read_notify = false;
	during[t+1, t_end]: data_out_burst_write_notify = false;
	during[t+1, t_end]: data_out_idle_notify = false;
	during[t+1, t_end]: data_out_single_read_notify = false;
	during[t+1, t_end]: data_out_single_write_notify = false;
end property;


property single_write_5_14 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_end_write_op_sig_address_in_at_t = data_in_end_write_op_sig_address_in@t,
	data_in_end_write_op_sig_burst_single_at_t = data_in_end_write_op_sig_burst_single@t,
	data_in_end_write_op_sig_read_req_at_t = data_in_end_write_op_sig_read_req@t,
	data_in_end_write_op_sig_write_req_at_t = data_in_end_write_op_sig_write_req@t,
	response_idle_last_row_at_t = response_idle_last_row@t;
assume:
	at t: single_write_5;
	at t: not((((shift_right((data_in_end_write_op_sig_address_in and resize(16777215,32)),resize(12,32))) /= response_idle_last_row) or (not(data_in_end_write_op_sig_read_req) and not(data_in_end_write_op_sig_write_req))));
prove:
	at t_end: activate_3;
	at t_end: acc_rw = false;
	at t_end: data_in_req_address_in = data_in_end_write_op_sig_address_in_at_t;
	at t_end: data_in_req_burst_single = data_in_end_write_op_sig_burst_single_at_t;
	at t_end: data_in_req_read_req = data_in_end_write_op_sig_read_req_at_t;
	at t_end: data_in_req_write_req = data_in_end_write_op_sig_write_req_at_t;
	at t_end: data_int_sig_address = (data_in_end_write_op_sig_address_in_at_t and 4095);
	at t_end: data_int_sig_ready = false;
	at t_end: data_int_sig_sdram_status = true;
	at t_end: response_idle_last_row = response_idle_last_row_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end-1]: data_int_notify = false;
	at t_end: data_int_notify = true;
	during[t+1, t_end]: data_out_burst_read_notify = false;
	during[t+1, t_end]: data_out_burst_write_notify = false;
	during[t+1, t_end]: data_out_idle_notify = false;
	during[t+1, t_end]: data_out_single_read_notify = false;
	during[t+1, t_end]: data_out_single_write_notify = false;
end property;


property wait_idle_1 is
dependencies: no_reset;
freeze:
	acc_rw_at_t = acc_rw@t,
	data_in_req_address_in_at_t = data_in_req_address_in@t,
	data_in_req_burst_single_at_t = data_in_req_burst_single@t,
	data_in_req_read_req_at_t = data_in_req_read_req@t,
	data_in_req_write_req_at_t = data_in_req_write_req@t,
	response_idle_last_row_at_t = response_idle_last_row@t;
assume:
	at t: idle_1;
	at t: not(data_in_sync);
prove:
	at t+1: idle_1;
	at t+1: acc_rw = acc_rw_at_t;
	at t+1: data_in_req_address_in = data_in_req_address_in_at_t;
	at t+1: data_in_req_burst_single = data_in_req_burst_single_at_t;
	at t+1: data_in_req_read_req = data_in_req_read_req_at_t;
	at t+1: data_in_req_write_req = data_in_req_write_req_at_t;
	at t+1: response_idle_last_row = response_idle_last_row_at_t;
	at t+1: data_in_notify = true;
	at t+1: data_int_notify = false;
	at t+1: data_out_burst_read_notify = false;
	at t+1: data_out_burst_write_notify = false;
	at t+1: data_out_idle_notify = false;
	at t+1: data_out_single_read_notify = false;
	at t+1: data_out_single_write_notify = false;
end property;


