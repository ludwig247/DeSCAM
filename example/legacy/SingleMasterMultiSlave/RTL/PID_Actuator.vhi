-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
--macro bus_req_notify :  boolean  := end macro; 
--macro bus_req_sync   :  boolean  := end macro; 
--macro bus_resp_notify :  boolean  := end macro; 
--macro bus_resp_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro bus_req_addr_sig : int := bus_req.addr end macro; 
macro bus_req_data_sig : int := bus_req.data end macro; 
macro bus_req_trans_type_sig : trans_t := bus_req.trans_type end macro; 
macro bus_resp_ack_sig : ack_t := bus_resp.ack end macro; 
macro bus_resp_data_sig : int := bus_resp.data end macro; 
macro dac_sig : int :=  dac end macro; 
macro power_sig : bool := power end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 

-- VISIBLE REGISTERS --
macro Kd : int := Kd_signal end macro; 
macro Ki : int := Ki_signal end macro; 
macro Kp : int := Kp_signal end macro; 
macro deriv : int := deriv_signal end macro; 
macro device_power : bool := device_power_signal end macro; 
macro error_m : int := error_signal end macro; 
macro integral : int := integral_signal end macro; 
macro prev_err : int := prev_err_signal end macro; 
macro req_addr : int := req_signal.addr end macro; 
macro req_data : int := req_signal.data end macro; 
macro req_trans_type : trans_t := req_signal.trans_type end macro; 
macro resp_ack : ack_t := resp_signal.ack end macro; 
macro resp_data : int := resp_signal.data end macro; 
macro sample : int := sample_signal end macro; 
macro sample_time : int := sample_time_signal end macro; 
macro setpoint : int := setpoint_signal end macro; 
macro setup_correct:bool:= setup_correct_signal end macro;


-- INVAR -- 
macro invar : boolean := 		
		prev_err_signal >= -10 and prev_err_signal <= 10 and
		integral_signal >= -65535 and integral_signal <= 65535;
end macro;

--Operations -- 
macro checking_0 : boolean := section = checking and wait_signal =  0  and invar end macro;
macro checking_1 : boolean := section = checking and wait_signal = 1 and invar end macro;
macro compute_2 : boolean := section = compute and wait_signal = 1 and invar end macro;
macro reading_3 : boolean := section = reading and bus_req_notify = 1 and bus_resp_notify = 0 and invar end macro;
macro reading_4 : boolean := section = reading and bus_req_notify = 0 and bus_resp_notify = 1 and invar end macro;

property reset is
for timepoints:
	t_end = t;
assume: 
	 reset_sequence;
prove:
	 at t_end: reading_3;
	 at t_end: Kd = 0;
	 at t_end: Ki = 0;
	 at t_end: Kp = 0;
	 at t_end: deriv = 0;
	 at t_end: device_power = false;
	 at t_end: error_m = 0;
	 at t_end: integral = 0;
	 at t_end: prev_err = 0;
	 at t_end: req_addr = 0;
	 at t_end: req_data = 0;
	 at t_end: req_trans_type = SINGLE_READ;
	 at t_end: resp_ack = ERR;
	 at t_end: resp_data = 0;
	 at t_end: sample = 20;
	 at t_end: sample_time = 10;
	 at t_end: setpoint = 20;
	 at t_end: setup_correct = false;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
end property;

property checking_0_read_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	Kd_at_t = Kd@t,
	Ki_at_t = Ki@t,
	Kp_at_t = Kp@t,
	device_power_at_t = device_power@t,
	sample_at_t = sample@t,
	sample_time_at_t = sample_time@t,
	setpoint_at_t = setpoint@t,
	setup_correct_at_t = setup_correct@t,
	power_sig_at_t = power_sig@t;
assume: 
	 at t: checking_0;
	 at t: not((((((((((((((power_sig and setup_correct) and not((sample_time <= 1))) and not((1000 <= sample_time))) and not((Kp <= 0))) and not((10 <= Kp))) and not((Ki <= 0))) and not((10 <= Ki))) and not((Kd <= 0))) and not((10 <= Kd))) and not((setpoint <= 0))) and not((100 <= setpoint))) and not((10 <= (setpoint + (-1 * sample))))) and not((10 <= (sample + (-1 * setpoint))))));
prove:
	 at t_end: checking_1;
	 at t_end: Kd = Kd_at_t;
	 at t_end: Ki = Ki_at_t;
	 at t_end: Kp = Kp_at_t;
	 at t_end: device_power = power_sig_at_t;
	 at t_end: sample = sample_at_t;
	 at t_end: sample_time = sample_time_at_t;
	 at t_end: setpoint = setpoint_at_t;
	 at t_end: setup_correct = ((((((((((((setup_correct_at_t and not((sample_time_at_t <= 1))) and not((1000 <= sample_time_at_t))) and not((Kp_at_t <= 0))) and not((10 <= Kp_at_t))) and not((Ki_at_t <= 0))) and not((10 <= Ki_at_t))) and not((Kd_at_t <= 0))) and not((10 <= Kd_at_t))) and not((setpoint_at_t <= 0))) and not((100 <= setpoint_at_t))) and not((10 <= (setpoint_at_t + (-1 * sample_at_t))))) and not((10 <= (sample_at_t + (-1 * setpoint_at_t)))));
	 during[t+1, t_end]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: dac_sig = 0;
end property;

property checking_0_read_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+4;
freeze:
	Kd_at_t = Kd@t,
	Ki_at_t = Ki@t,
	Kp_at_t = Kp@t,
	deriv_at_t = deriv@t,
	device_power_at_t = device_power@t,
	error_at_t = error_m@t,
	integral_at_t = integral@t,
	prev_err_at_t = prev_err@t,
	sample_at_t = sample@t,
	sample_time_at_t = sample_time@t,
	setpoint_at_t = setpoint@t,
	setup_correct_at_t = setup_correct@t,
	power_sig_at_t = power_sig@t;
assume: 
	 at t: checking_0;
	 at t: power_sig;
	 at t: setup_correct;
	 at t: ((integral + (sample_time * (setpoint + (-1 * sample)))) >= -65535);
	 at t: ((integral + (sample_time * (setpoint + (-1 * sample)))) <= 65535);
	 at t: (sample_time >= 2);
	 at t: (sample_time <= 999);
	 at t: (Kp >= 1);
	 at t: (Kp <= 9);
	 at t: (Ki >= 1);
	 at t: (Ki <= 9);
	 at t: (Kd >= 1);
	 at t: (Kd <= 9);
	 at t: (setpoint >= 1);
	 at t: (setpoint <= 99);
	 at t: ((setpoint + (-1 * sample)) <= 9);
	 at t: ((sample + (-1 * setpoint)) <= 9);
prove:
	 at t_end: compute_2;
	 at t_end: Kd = Kd_at_t;
	 at t_end: Ki = Ki_at_t;
	 at t_end: Kp = Kp_at_t;
	 at t_end: deriv = (((setpoint_at_t + (-1 * sample_at_t)) + (-1 * prev_err_at_t)) div sample_time_at_t);
	 at t_end: device_power = power_sig_at_t;
	 at t_end: error_m = (setpoint_at_t + (-1 * sample_at_t));
	 at t_end: integral = (integral_at_t + (sample_time_at_t * (setpoint_at_t + (-1 * sample_at_t))));
	 at t_end: prev_err = (setpoint_at_t + (-1 * sample_at_t));
	 at t_end: sample = sample_at_t;
	 at t_end: sample_time = sample_time_at_t;
	 at t_end: setpoint = setpoint_at_t;
	 at t_end: setup_correct = ((((((((((((setup_correct_at_t and not((sample_time_at_t <= 1))) and not((1000 <= sample_time_at_t))) and not((Kp_at_t <= 0))) and not((10 <= Kp_at_t))) and not((Ki_at_t <= 0))) and not((10 <= Ki_at_t))) and not((Kd_at_t <= 0))) and not((10 <= Kd_at_t))) and not((setpoint_at_t <= 0))) and not((100 <= setpoint_at_t))) and not((10 <= (setpoint_at_t + (-1 * sample_at_t))))) and not((10 <= (sample_at_t + (-1 * setpoint_at_t)))));
	 during[t+1, t_end]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: dac_sig = (((Kp * error_m) + (Ki * integral)) + (Kd * deriv));
end property;

property checking_0_read_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+4;
freeze:
	Kd_at_t = Kd@t,
	Ki_at_t = Ki@t,
	Kp_at_t = Kp@t,
	deriv_at_t = deriv@t,
	device_power_at_t = device_power@t,
	error_at_t = error_m@t,
	integral_at_t = integral@t,
	prev_err_at_t = prev_err@t,
	sample_at_t = sample@t,
	sample_time_at_t = sample_time@t,
	setpoint_at_t = setpoint@t,
	setup_correct_at_t = setup_correct@t,
	power_sig_at_t = power_sig@t;
assume: 
	 at t: checking_0;
	 at t: power_sig;
	 at t: setup_correct;
	 at t: ((integral + (sample_time * (setpoint + (-1 * sample)))) >= 65536);
	 at t: (sample_time >= 2);
	 at t: (sample_time <= 999);
	 at t: (Kp >= 1);
	 at t: (Kp <= 9);
	 at t: (Ki >= 1);
	 at t: (Ki <= 9);
	 at t: (Kd >= 1);
	 at t: (Kd <= 9);
	 at t: (setpoint >= 1);
	 at t: (setpoint <= 99);
	 at t: ((setpoint + (-1 * sample)) <= 9);
	 at t: ((sample + (-1 * setpoint)) <= 9);
prove:
	 at t_end: compute_2;
	 at t_end: Kd = Kd_at_t;
	 at t_end: Ki = Ki_at_t;
	 at t_end: Kp = Kp_at_t;
	 at t_end: deriv = (((setpoint_at_t + (-1 * sample_at_t)) + (-1 * prev_err_at_t)) div sample_time_at_t);
	 at t_end: device_power = power_sig_at_t;
	 at t_end: error_m = (setpoint_at_t + (-1 * sample_at_t));
	 at t_end: integral = 65535;
	 at t_end: prev_err = (setpoint_at_t + (-1 * sample_at_t));
	 at t_end: sample = sample_at_t;
	 at t_end: sample_time = sample_time_at_t;
	 at t_end: setpoint = setpoint_at_t;
	 at t_end: setup_correct = ((((((((((((setup_correct_at_t and not((sample_time_at_t <= 1))) and not((1000 <= sample_time_at_t))) and not((Kp_at_t <= 0))) and not((10 <= Kp_at_t))) and not((Ki_at_t <= 0))) and not((10 <= Ki_at_t))) and not((Kd_at_t <= 0))) and not((10 <= Kd_at_t))) and not((setpoint_at_t <= 0))) and not((100 <= setpoint_at_t))) and not((10 <= (setpoint_at_t + (-1 * sample_at_t))))) and not((10 <= (sample_at_t + (-1 * setpoint_at_t)))));
	 during[t+1, t_end]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: dac_sig = (((Kp * error_m) + (Ki * integral)) + (Kd * deriv));
end property;

property checking_0_read_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+4;
freeze:
	Kd_at_t = Kd@t,
	Ki_at_t = Ki@t,
	Kp_at_t = Kp@t,
	deriv_at_t = deriv@t,
	device_power_at_t = device_power@t,
	error_at_t = error_m@t,
	integral_at_t = integral@t,
	prev_err_at_t = prev_err@t,
	sample_at_t = sample@t,
	sample_time_at_t = sample_time@t,
	setpoint_at_t = setpoint@t,
	setup_correct_at_t = setup_correct@t,
	power_sig_at_t = power_sig@t;
assume: 
	 at t: checking_0;
	 at t: power_sig;
	 at t: setup_correct;
	 at t: ((integral + (sample_time * (setpoint + (-1 * sample)))) <= -65536);
	 at t: (sample_time >= 2);
	 at t: (sample_time <= 999);
	 at t: (Kp >= 1);
	 at t: (Kp <= 9);
	 at t: (Ki >= 1);
	 at t: (Ki <= 9);
	 at t: (Kd >= 1);
	 at t: (Kd <= 9);
	 at t: (setpoint >= 1);
	 at t: (setpoint <= 99);
	 at t: ((setpoint + (-1 * sample)) <= 9);
	 at t: ((sample + (-1 * setpoint)) <= 9);
prove:
	 at t_end: compute_2;
	 at t_end: Kd = Kd_at_t;
	 at t_end: Ki = Ki_at_t;
	 at t_end: Kp = Kp_at_t;
	 at t_end: deriv = (((setpoint_at_t + (-1 * sample_at_t)) + (-1 * prev_err_at_t)) div sample_time_at_t);
	 at t_end: device_power = power_sig_at_t;
	 at t_end: error_m = (setpoint_at_t + (-1 * sample_at_t));
	 at t_end: integral = -65535;
	 at t_end: prev_err = (setpoint_at_t + (-1 * sample_at_t));
	 at t_end: sample = sample_at_t;
	 at t_end: sample_time = sample_time_at_t;
	 at t_end: setpoint = setpoint_at_t;
	 at t_end: setup_correct = ((((((((((((setup_correct_at_t and not((sample_time_at_t <= 1))) and not((1000 <= sample_time_at_t))) and not((Kp_at_t <= 0))) and not((10 <= Kp_at_t))) and not((Ki_at_t <= 0))) and not((10 <= Ki_at_t))) and not((Kd_at_t <= 0))) and not((10 <= Kd_at_t))) and not((setpoint_at_t <= 0))) and not((100 <= setpoint_at_t))) and not((10 <= (setpoint_at_t + (-1 * sample_at_t))))) and not((10 <= (sample_at_t + (-1 * setpoint_at_t)))));
	 during[t+1, t_end]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: dac_sig = (((Kp * error_m) + (Ki * integral)) + (Kd * deriv));
end property;

property checking_1_write_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: checking_1;
prove:
	 at t_end: reading_3;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
end property;

property compute_2_write_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: compute_2;
prove:
	 at t_end: reading_3;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
end property;

property wait_reading_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	bus_req_sig_addr_at_t = bus_req_addr_sig@t,
	bus_req_sig_data_at_t = bus_req_data_sig@t,
	bus_req_sig_trans_type_at_t = bus_req_trans_type_sig@t;
assume: 
	 at t: reading_3;
	 at t: (bus_req_sync = false);
prove:
	 at t_end: reading_3;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
end property;

property reading_3_read_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	sample_at_t = sample@t,
	bus_req_sig_addr_at_t = bus_req_addr_sig@t,
	bus_req_sig_data_at_t = bus_req_data_sig@t,
	bus_req_sig_trans_type_at_t = bus_req_trans_type_sig@t;
assume: 
	 at t: reading_3;
	 at t: (bus_req_addr_sig = 0);
	 at t: (bus_req_sync = true);
prove:
	 at t_end: reading_4;
	 at t_end: req_addr = bus_req_sig_addr_at_t;
	 at t_end: req_data = bus_req_sig_data_at_t;
	 at t_end: req_trans_type = bus_req_sig_trans_type_at_t;
	 at t_end: resp_ack = OK;
	 at t_end: sample = bus_req_sig_data_at_t;
	 during[t+1, t_end]: bus_req_notify = false;
	 during[t+1, t_end-1]: bus_resp_notify = false;
	 at t_end: bus_resp_notify = true;
	 at t_end: bus_resp_ack_sig = resp_ack;
	 at t_end: bus_resp_data_sig = resp_data;
end property;

property reading_3_read_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	sample_time_at_t = sample_time@t,
	bus_req_sig_addr_at_t = bus_req_addr_sig@t,
	bus_req_sig_data_at_t = bus_req_data_sig@t,
	bus_req_sig_trans_type_at_t = bus_req_trans_type_sig@t;
assume: 
	 at t: reading_3;
	 at t: (bus_req_addr_sig = 1);
	 at t: (bus_req_sync = true);
prove:
	 at t_end: reading_4;
	 at t_end: req_addr = bus_req_sig_addr_at_t;
	 at t_end: req_data = bus_req_sig_data_at_t;
	 at t_end: req_trans_type = bus_req_sig_trans_type_at_t;
	 at t_end: resp_ack = OK;
	 at t_end: sample_time = bus_req_sig_data_at_t;
	 during[t+1, t_end]: bus_req_notify = false;
	 during[t+1, t_end-1]: bus_resp_notify = false;
	 at t_end: bus_resp_notify = true;
	 at t_end: bus_resp_ack_sig = resp_ack;
	 at t_end: bus_resp_data_sig = resp_data;
end property;

property reading_3_read_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	setpoint_at_t = setpoint@t,
	bus_req_sig_addr_at_t = bus_req_addr_sig@t,
	bus_req_sig_data_at_t = bus_req_data_sig@t,
	bus_req_sig_trans_type_at_t = bus_req_trans_type_sig@t;
assume: 
	 at t: reading_3;
	 at t: (bus_req_addr_sig = 2);
	 at t: (bus_req_sync = true);
prove:
	 at t_end: reading_4;
	 at t_end: req_addr = bus_req_sig_addr_at_t;
	 at t_end: req_data = bus_req_sig_data_at_t;
	 at t_end: req_trans_type = bus_req_sig_trans_type_at_t;
	 at t_end: resp_ack = OK;
	 at t_end: setpoint = bus_req_sig_data_at_t;
	 during[t+1, t_end]: bus_req_notify = false;
	 during[t+1, t_end-1]: bus_resp_notify = false;
	 at t_end: bus_resp_notify = true;
	 at t_end: bus_resp_ack_sig = resp_ack;
	 at t_end: bus_resp_data_sig = resp_data;
end property;

property reading_3_read_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	Kp_at_t = Kp@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	bus_req_sig_addr_at_t = bus_req_addr_sig@t,
	bus_req_sig_data_at_t = bus_req_data_sig@t,
	bus_req_sig_trans_type_at_t = bus_req_trans_type_sig@t;
assume: 
	 at t: reading_3;
	 at t: (bus_req_addr_sig = 3);
	 at t: (bus_req_sync = true);
prove:
	 at t_end: reading_4;
	 at t_end: Kp = bus_req_sig_data_at_t;
	 at t_end: req_addr = bus_req_sig_addr_at_t;
	 at t_end: req_data = bus_req_sig_data_at_t;
	 at t_end: req_trans_type = bus_req_sig_trans_type_at_t;
	 at t_end: resp_ack = OK;
	 during[t+1, t_end]: bus_req_notify = false;
	 during[t+1, t_end-1]: bus_resp_notify = false;
	 at t_end: bus_resp_notify = true;
	 at t_end: bus_resp_ack_sig = resp_ack;
	 at t_end: bus_resp_data_sig = resp_data;
end property;

property reading_3_read_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	Ki_at_t = Ki@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	bus_req_sig_addr_at_t = bus_req_addr_sig@t,
	bus_req_sig_data_at_t = bus_req_data_sig@t,
	bus_req_sig_trans_type_at_t = bus_req_trans_type_sig@t;
assume: 
	 at t: reading_3;
	 at t: (bus_req_addr_sig = 4);
	 at t: (bus_req_sync = true);
prove:
	 at t_end: reading_4;
	 at t_end: Ki = bus_req_sig_data_at_t;
	 at t_end: req_addr = bus_req_sig_addr_at_t;
	 at t_end: req_data = bus_req_sig_data_at_t;
	 at t_end: req_trans_type = bus_req_sig_trans_type_at_t;
	 at t_end: resp_ack = OK;
	 during[t+1, t_end]: bus_req_notify = false;
	 during[t+1, t_end-1]: bus_resp_notify = false;
	 at t_end: bus_resp_notify = true;
	 at t_end: bus_resp_ack_sig = resp_ack;
	 at t_end: bus_resp_data_sig = resp_data;
end property;

property reading_3_read_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	Kd_at_t = Kd@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	bus_req_sig_addr_at_t = bus_req_addr_sig@t,
	bus_req_sig_data_at_t = bus_req_data_sig@t,
	bus_req_sig_trans_type_at_t = bus_req_trans_type_sig@t;
assume: 
	 at t: reading_3;
	 at t: (bus_req_addr_sig = 5);
	 at t: (bus_req_sync = true);
prove:
	 at t_end: reading_4;
	 at t_end: Kd = bus_req_sig_data_at_t;
	 at t_end: req_addr = bus_req_sig_addr_at_t;
	 at t_end: req_data = bus_req_sig_data_at_t;
	 at t_end: req_trans_type = bus_req_sig_trans_type_at_t;
	 at t_end: resp_ack = OK;
	 during[t+1, t_end]: bus_req_notify = false;
	 during[t+1, t_end-1]: bus_resp_notify = false;
	 at t_end: bus_resp_notify = true;
	 at t_end: bus_resp_ack_sig = resp_ack;
	 at t_end: bus_resp_data_sig = resp_data;
end property;

property reading_3_read_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	bus_req_sig_addr_at_t = bus_req_addr_sig@t,
	bus_req_sig_data_at_t = bus_req_data_sig@t,
	bus_req_sig_trans_type_at_t = bus_req_trans_type_sig@t;
assume: 
	 at t: reading_3;
	 at t: not((bus_req_addr_sig = 0));
	 at t: not((bus_req_addr_sig = 1));
	 at t: not((bus_req_addr_sig = 2));
	 at t: not((bus_req_addr_sig = 3));
	 at t: not((bus_req_addr_sig = 4));
	 at t: not((bus_req_addr_sig = 5));
	 at t: (bus_req_sync = true);
prove:
	 at t_end: reading_4;
	 at t_end: req_addr = bus_req_sig_addr_at_t;
	 at t_end: req_data = bus_req_sig_data_at_t;
	 at t_end: req_trans_type = bus_req_sig_trans_type_at_t;
	 at t_end: resp_ack = ERR;
	 during[t+1, t_end]: bus_req_notify = false;
	 during[t+1, t_end-1]: bus_resp_notify = false;
	 at t_end: bus_resp_notify = true;
	 at t_end: bus_resp_ack_sig = resp_ack;
	 at t_end: bus_resp_data_sig = resp_data;
end property;

property reading_4_write_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: reading_4;
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: checking_0;
	 during[t+1, t_end]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
end property;

property wait_reading_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: reading_4;
	 at t: (bus_resp_sync = false);
prove:
	 at t_end: reading_4;
	 during[t+1, t_end]: bus_req_notify = false;
	 during[t+1, t_end-1]: bus_resp_notify = false;
	 at t_end: bus_resp_notify = true;
	 at t_end: bus_resp_ack_sig = resp_ack;
	 at t_end: bus_resp_data_sig = resp_data;
end property;