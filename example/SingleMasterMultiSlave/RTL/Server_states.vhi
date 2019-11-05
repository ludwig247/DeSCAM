-- @lang=vhi @ts=8

-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro bus_in_notify :  boolean  := end macro;
--macro bus_in_sync   :  boolean  := end macro;
--macro bus_out_notify :  boolean  := end macro;
--macro bus_out_sync   :  boolean  := end macro;
--macro sample_timer_notify :  boolean  := end macro;
--macro sample_timer_sync   :  boolean  := end macro;
--macro uP_in_notify :  boolean  := end macro;
--macro uP_in_sync   :  boolean  := end macro;
--macro uP_report_out_notify :  boolean  := end macro;
--macro uP_report_out_sync   :  boolean  := end macro;


-- DP SIGNALS --
macro bus_in_ack_sig : ack_t := bus_in.ack end macro;
macro bus_in_data_sig : int := bus_in.data end macro;
macro bus_out_addr_sig : int := bus_out.addr end macro;
macro bus_out_data_sig : int := bus_out.data end macro;
macro bus_out_trans_type_sig : trans_t := bus_out.trans_type end macro;
macro heat_power_sig : bool :=  heat_power end macro;
macro mix_power_sig : bool := mix_power end macro;
macro uP_in_Kd_Heat_sig : int := uP_in.Kd_Heat end macro;
macro uP_in_Kd_Mix_sig : int := uP_in.Kd_Mix end macro;
macro uP_in_Ki_Heat_sig : int := uP_in.Ki_Heat end macro;
macro uP_in_Ki_Mix_sig : int := uP_in.Ki_Mix end macro;
macro uP_in_Kp_Heat_sig : int := uP_in.Kp_Heat end macro;
macro uP_in_Kp_Mix_sig : int := uP_in.Kp_Mix end macro;
macro uP_in_max_temp_diff_sig : int := uP_in.max_temp_diff end macro;
macro uP_in_sample_time_sig : int := uP_in.sample_time end macro;
macro uP_in_target_temp_sig : int := uP_in.target_temp end macro;
macro uP_report_out_sig : err_id_t := uP_report_out end macro;


--CONSTRAINTS--
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro err_id : err_id_t := err_id_signal end macro;
macro heat_Kd : int := heat_signal.Kd end macro;
macro heat_Ki : int := heat_signal.Ki end macro;
macro heat_Kp : int := heat_signal.Kp end macro;
macro heat_power_on : bool := heat_signal.power_on end macro;
macro heat_sample_time : int := heat_signal.sample_time end macro;
macro heat_sample_value : int := heat_signal.sample_value end macro;
macro heat_setpoint : int := heat_signal.setpoint end macro;
macro mix_Kd : int := mix_signal.Kd end macro;
macro mix_Ki : int := mix_signal.Ki end macro;
macro mix_Kp : int := mix_signal.Kp end macro;
macro mix_power_on : bool := mix_signal.power_on end macro;
macro mix_sample_time : int := mix_signal.sample_time end macro;
macro mix_sample_value : int := mix_signal.sample_value end macro;
macro mix_setpoint : int := mix_signal.setpoint end macro;
macro nb_result : bool := nb_result_signal end macro;
macro req_addr : int := req_signal.addr end macro;
macro req_data : int := req_signal.data end macro;
macro req_trans_type : trans_t := req_signal.trans_type end macro;
macro resp_ack : ack_t := resp_signal.ack end macro;
macro resp_data : int := resp_signal.data end macro;
macro resp_bot_ack : ack_t := resp_bot_signal.ack end macro;
macro resp_bot_data : int := resp_bot_signal.data end macro;
macro resp_top_ack : ack_t := resp_top_signal.ack  end macro;
macro resp_top_data : int :=  resp_top_signal.data end macro;
macro temp_bot_data : int := temp_bot_signal.data end macro;
macro temp_bot_data_stable : bool := temp_bot_signal.data_stable end macro;
macro temp_top_data : int := temp_top_signal.data end macro;
macro temp_top_data_stable : bool := temp_top_signal.data_stable end macro;
macro uP_Kd_Heat : int := uP_signal.Kd_Heat end macro;
macro uP_Kd_Mix : int := up_signal.Kd_Mix end macro;
macro uP_Ki_Heat : int := uP_signal.Ki_Heat end macro;
macro uP_Ki_Mix : int := uP_signal.Ki_Mix end macro;
macro uP_Kp_Heat : int := uP_signal.Kp_Heat end macro;
macro uP_Kp_Mix : int := uP_signal.Kp_Mix end macro;
macro uP_max_temp_diff : int := uP_signal.max_temp_diff end macro;
macro uP_sample_time : int := uP_signal.sample_time end macro;
macro uP_target_temp : int := uP_signal.target_temp end macro;

-- STATES --16
macro CONFIG_0 : boolean := 
	section = CONFIG and 
	bus_out_notify = '1' and 
	bus_in_notify = '0';
end macro;
macro CONFIG_1 : boolean :=
	section = CONFIG and 
	bus_out_notify = '0' and 
	bus_in_notify = '1';
 end macro;
macro ERROR_2 : boolean := 
	section = ERROR and 
	uP_report_out_notify = '0' and
	help = 0;
	
end macro;
macro ERROR_3 : boolean := 
	section = ERROR and 
	help = 1 and 
	uP_report_out_notify = '0';
end macro;
macro ERROR_4 : boolean := 
	section = ERROR and
	uP_report_out_notify = '1' and
	heat_power = false and 
	mix_power = false;
end macro;
macro GET_TEMP_5 : boolean := 
	section = GET_TEMP and 
	bus_out_notify_tmp = '1' and 
	bus_in_notify_tmp = '0' and 
	req_signal.addr = 16;
end macro;
macro GET_TEMP_6 : boolean :=
	section = GET_TEMP and
	bus_out_notify_tmp = '0' and 
	bus_in_notify_tmp = '1' and 
	req_signal.addr = 16 ;
end macro;
macro GET_TEMP_7 : boolean :=
	section = GET_TEMP and 
	bus_out_notify_tmp = '1' and 
	bus_in_notify_tmp = '0' and 
	req_signal.addr = 24;  
end macro;
macro GET_TEMP_8 : boolean := 
	section = GET_TEMP and
	bus_out_notify_tmp = '0' and 
	bus_in_notify_tmp = '1' and 
	req_signal.addr = 24 ;
 end macro;
macro IDLE_9 : boolean := 
	section = IDLE and
	uP_in_notify_tmp <= '0' and 
	sample_timer_notify_tmp = '1'
end macro;
macro IDLE_10 : boolean := 
	section = IDLE and
	uP_in_notify_tmp <= '1' and 
	sample_timer_notify_tmp = '0';
end macro;
macro INIT_11 : boolean := 
	section = INIT and 
	heat_power_sig = true and 
	mix_power_sig = false and
	uP_in_notify = '0';
end macro;
macro INIT_12 : boolean := 
	section = INIT and 
	heat_power_sig = true and 
	mix_power_sig = true and 
	uP_in_notify = '0';
end macro;
macro INIT_13 : boolean :=
	section = INIT and 
	heat_power_sig = true and 
	mix_power_sig = true and 
	uP_in_notify = '1';
end macro;
macro SET_HEAT_14 : boolean := 
	section = SET_HEAT and
	bus_in_notify_tmp = '0';
 end macro;
macro SET_HEAT_15 : boolean := 	
	section = SET_HEAT and
	bus_in_notify_tmp = '1'; 
end macro;
macro SET_MIX_16 : boolean := 
	section=SET_MIX and
	bus_in_notify_tmp = '0';
end macro;
macro SET_MIX_17 : boolean := 
	section=SET_MIX and
	bus_in_notify_tmp = '1';
 end macro;
