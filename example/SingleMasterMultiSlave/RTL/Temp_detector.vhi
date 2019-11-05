-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
--macro sample_event_notify :  boolean  := end macro; 
--macro sample_event_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro adc_in_sig : int := adc_in end macro; 
macro temp_out_sig : int := temp_out end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro adc_value : int := adc_value_signal end macro;
macro avg_temp : int := avg_temp_signal end macro;
macro avg_temp_last : int :=  avg_temp_last_signal end macro;
macro measured_sum_ok : int := measured_sum_ok_signal end macro;
macro sample_cnt : int := sample_cnt_signal end macro;
macro sample_cnt_ok : int := sample_cnt_ok_signal end macro;

--INVARIANT MACRO--
macro invariant : boolean := 
	measured_sum_ok <= sample_cnt_ok * 40 and measured_sum_ok >= 0 and --16*40
	sample_cnt_ok <= sample_cnt and sample_cnt_ok >= 0 and 
	sample_cnt >= 0 and sample_cnt <= 16 and 
	avg_temp >= 0 and avg_temp <= 640 and 
	avg_temp_last >= 0 and avg_temp_last <= 640; 

end macro;

-- STATES -- 
macro CHECK_0 : boolean := section = CHECK and invariant  end macro;
macro MEASURE_1 : boolean := section = MEASURE and invariant end macro;
macro UPDATE_2 : boolean := section = UPDATE and invariant end macro;

--Operations -- 


property reset is
for timepoints:
	t_end = t;
assume: 
	 reset_sequence;
prove:
	 at t_end: UPDATE_2;
	 at t_end: adc_value = 0;
	 at t_end: avg_temp = 20;
	 at t_end: avg_temp_last = 20;
	 at t_end: measured_sum_ok = 0;
	 at t_end: sample_cnt = 0;
	 at t_end: sample_cnt_ok = 0;
	 during[t+1, t_end]: sample_event_notify = false;
	 at t_end: temp_out_sig = avg_temp;
end property;

property CHECK_0_read_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	adc_value_at_t = adc_value@t,
	avg_temp_last_at_t = avg_temp_last@t,
	sample_cnt_at_t = sample_cnt@t,
	adc_in_sig_at_t = adc_in_sig@t;
assume: 
	 at t: CHECK_0;
	 at t: not((((not((adc_in_sig <= 0)) and not((40 <= adc_in_sig))) and not((10 <= (avg_temp_last + (-1 * adc_in_sig))))) and not((10 <= (adc_in_sig + (-1 * avg_temp_last))))));
	 at t: not((sample_cnt = 15));
prove:
	 at t_end: MEASURE_1;
	 at t_end: adc_value = adc_in_sig_at_t;
	 at t_end: avg_temp_last = avg_temp_last_at_t;
	 at t_end: sample_cnt = (1 + sample_cnt_at_t);
	 during[t+1, t_end-1]: sample_event_notify = false;
	 at t_end: sample_event_notify = true;
end property;

property CHECK_0_read_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	adc_value_at_t = adc_value@t,
	avg_temp_last_at_t = avg_temp_last@t,
	measured_sum_ok_at_t = measured_sum_ok@t,
	sample_cnt_at_t = sample_cnt@t,
	sample_cnt_ok_at_t = sample_cnt_ok@t,
	adc_in_sig_at_t = adc_in_sig@t;
assume: 
	 at t: CHECK_0;
	 at t: not((sample_cnt = 15));
	 at t: (adc_in_sig >= 1);
	 at t: (adc_in_sig <= 39);
	 at t: ((avg_temp_last + (-1 * adc_in_sig)) <= 9);
	 at t: ((adc_in_sig + (-1 * avg_temp_last)) <= 9);
prove:
	 at t_end: MEASURE_1;
	 at t_end: adc_value = adc_in_sig_at_t;
	 at t_end: avg_temp_last = avg_temp_last_at_t;
	 at t_end: measured_sum_ok = (measured_sum_ok_at_t + adc_in_sig_at_t);
	 at t_end: sample_cnt = (1 + sample_cnt_at_t);
	 at t_end: sample_cnt_ok = (1 + sample_cnt_ok_at_t);
	 during[t+1, t_end-1]: sample_event_notify = false;
	 at t_end: sample_event_notify = true;
end property;

property CHECK_0_read_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	adc_value_at_t = adc_value@t,
	avg_temp_at_t = avg_temp@t,
	avg_temp_last_at_t = avg_temp_last@t,
	measured_sum_ok_at_t = measured_sum_ok@t,
	sample_cnt_at_t = sample_cnt@t,
	sample_cnt_ok_at_t = sample_cnt_ok@t,
	adc_in_sig_at_t = adc_in_sig@t;
assume: 
	 at t: CHECK_0;
	 at t: not((((not((adc_in_sig <= 0)) and not((40 <= adc_in_sig))) and not((10 <= (avg_temp_last + (-1 * adc_in_sig))))) and not((10 <= (adc_in_sig + (-1 * avg_temp_last))))));
	 at t: (sample_cnt = 15);
	 at t: (sample_cnt_ok <= 10);
prove:
	 at t_end: UPDATE_2;
	 at t_end: adc_value = adc_in_sig_at_t;
	 at t_end: avg_temp = avg_temp_last_at_t;
	 at t_end: avg_temp_last = avg_temp_last_at_t;
	 at t_end: measured_sum_ok = 0;
	 at t_end: sample_cnt = 0;
	 at t_end: sample_cnt_ok = 0;
	 during[t+1, t_end]: sample_event_notify = false;
	 at t_end: temp_out_sig = avg_temp;
end property;

property CHECK_0_read_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	adc_value_at_t = adc_value@t,
	avg_temp_at_t = avg_temp@t,
	avg_temp_last_at_t = avg_temp_last@t,
	measured_sum_ok_at_t = measured_sum_ok@t,
	sample_cnt_at_t = sample_cnt@t,
	sample_cnt_ok_at_t = sample_cnt_ok@t,
	adc_in_sig_at_t = adc_in_sig@t;
assume: 
	 at t: CHECK_0;
	 at t: not((((not((adc_in_sig <= 0)) and not((40 <= adc_in_sig))) and not((10 <= (avg_temp_last + (-1 * adc_in_sig))))) and not((10 <= (adc_in_sig + (-1 * avg_temp_last))))));
	 at t: (sample_cnt = 15);
	 at t: (sample_cnt_ok >= 11);
prove:
	 at t_end: UPDATE_2;
	 at t_end: adc_value = adc_in_sig_at_t;
	 at t_end: avg_temp = (measured_sum_ok_at_t div sample_cnt_ok_at_t);
	 at t_end: avg_temp_last = (measured_sum_ok_at_t div sample_cnt_ok_at_t);
	 at t_end: measured_sum_ok = 0;
	 at t_end: sample_cnt = 0;
	 at t_end: sample_cnt_ok = 0;
	 during[t+1, t_end]: sample_event_notify = false;
	 at t_end: temp_out_sig = avg_temp;
end property;

property CHECK_0_read_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	adc_value_at_t = adc_value@t,
	avg_temp_at_t = avg_temp@t,
	avg_temp_last_at_t = avg_temp_last@t,
	measured_sum_ok_at_t = measured_sum_ok@t,
	sample_cnt_at_t = sample_cnt@t,
	sample_cnt_ok_at_t = sample_cnt_ok@t,
	adc_in_sig_at_t = adc_in_sig@t;
assume: 
	 at t: CHECK_0;
	 at t: (adc_in_sig >= 1);
	 at t: (adc_in_sig <= 39);
	 at t: ((avg_temp_last + (-1 * adc_in_sig)) <= 9);
	 at t: ((adc_in_sig + (-1 * avg_temp_last)) <= 9);
	 at t: (sample_cnt = 15);
	 at t: (sample_cnt_ok <= 9);
prove:
	 at t_end: UPDATE_2;
	 at t_end: adc_value = adc_in_sig_at_t;
	 at t_end: avg_temp = avg_temp_last_at_t;
	 at t_end: avg_temp_last = avg_temp_last_at_t;
	 at t_end: measured_sum_ok = 0;
	 at t_end: sample_cnt = 0;
	 at t_end: sample_cnt_ok = 0;
	 during[t+1, t_end]: sample_event_notify = false;
	 at t_end: temp_out_sig = avg_temp;
end property;

property CHECK_0_read_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	adc_value_at_t = adc_value@t,
	avg_temp_at_t = avg_temp@t,
	avg_temp_last_at_t = avg_temp_last@t,
	measured_sum_ok_at_t = measured_sum_ok@t,
	sample_cnt_at_t = sample_cnt@t,
	sample_cnt_ok_at_t = sample_cnt_ok@t,
	adc_in_sig_at_t = adc_in_sig@t;
assume: 
	 at t: CHECK_0;
	 at t: (adc_in_sig >= 1);
	 at t: (adc_in_sig <= 39);
	 at t: ((avg_temp_last + (-1 * adc_in_sig)) <= 9);
	 at t: ((adc_in_sig + (-1 * avg_temp_last)) <= 9);
	 at t: (sample_cnt = 15);
	 at t: (sample_cnt_ok >= 10);
prove:
	 at t_end: UPDATE_2;
	 at t_end: adc_value = adc_in_sig_at_t;
	 at t_end: avg_temp = ((measured_sum_ok_at_t + adc_in_sig_at_t) div (1 + sample_cnt_ok_at_t));
	 at t_end: avg_temp_last = ((measured_sum_ok_at_t + adc_in_sig_at_t) div (1 + sample_cnt_ok_at_t));
	 at t_end: measured_sum_ok = 0;
	 at t_end: sample_cnt = 0;
	 at t_end: sample_cnt_ok = 0;
	 during[t+1, t_end]: sample_event_notify = false;
	 at t_end: temp_out_sig = avg_temp;
end property;

property MEASURE_1_read_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: MEASURE_1;
	 at t: (sample_event_sync = true);
prove:
	 at t_end: CHECK_0;
	 during[t+1, t_end]: sample_event_notify = false;
end property;

property wait_MEASURE_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: MEASURE_1;
	 at t: (sample_event_sync = false);
prove:
	 at t_end: MEASURE_1;
	 during[t+1, t_end-1]: sample_event_notify = false;
	 at t_end: sample_event_notify = true;
end property;

property UPDATE_2_write_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume: 
	 at t: UPDATE_2;
prove:
	 at t_end: MEASURE_1;
	 during[t+1, t_end-1]: sample_event_notify = false;
	 at t_end: sample_event_notify = true;
end property;
