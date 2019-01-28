-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro b_in_notify :  boolean  := end macro;
--macro b_in_sync   :  boolean  := end macro;
--macro m_out_notify :  boolean  := end macro;

-- DP SIGNALS --
macro b_in_sig_data : signed :=
data_in & next(data_in,1) & next(data_in,2) & next(data_in,3)
& next(data_in,4) & next(data_in,5) & next(data_in,6) & next(data_in,7)
& next(data_in,8) & next(data_in,9) & next(data_in,10) & next(data_in,11)
& next(data_in,12) & next(data_in,13) & next(data_in,14) & next(data_in,15)
& next(data_in,16) & next(data_in,17) & next(data_in,18) & next(data_in,19)
& next(data_in,20) & next(data_in,21) & next(data_in,22) & next(data_in,23)
& next(data_in,24)& next(data_in,25)& next(data_in,26)& next(data_in,27)
& next(data_in,28)& next(data_in,29)& next(data_in,30) & next(data_in,31)
end macro;

macro b_in_sig_status : status_t := 
	if(prev(rst,1)) then 
		frame_detected( signed(0) )
	elsif(prev(rst,2)) then
		frame_detected( 0 & 0 & 0 & prev(data_in,1) )
	elsif(prev(rst,3)) then
		frame_detected( 0 & 0 & prev(data_in,2) & prev(data_in,1) )
	elsif(prev(rst,4)) then
		frame_detected( 0 & prev(data_in,3) & prev(data_in,2) & prev(data_in,1) )
	else
		frame_detected( prev(data_in,4) & prev(data_in,3) & prev(data_in,2) & prev(data_in,1) )
	end if;
end macro;

macro frame_detected(value: signed):status_t :=
	if(value = -1) then 
		in_frame
	else 
		oof_frame
	end if;
end macro; 

macro m_out_sig : int := m_out end macro;
macro s_out_sig : bool := s_out end macro;

--CONSTRAINTS--
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro cnt : int := cnt_signal end macro;
macro msg_data : int := msg_signal.data end macro;
macro msg_status : status_t := msg_signal.status end macro;


-- STATES --
macro frame_data_0 : boolean := section=frame_data and buffer_cnt = 0 end macro;
macro frame_start_2 : boolean := section=frame_start end macro;
macro idle_3 : boolean := section=idle  and buffer_cnt = 0 end macro;

--Operations --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: idle_3;
	 at t: cnt = 0;
	 at t: msg_data = 0;
	 at t: msg_status = in_frame;
	 at t: s_out_sig = false;
	 at t: b_in_notify = true;
	 at t: m_out_notify = false;
end property;

property frame_data_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+32;
freeze:
	b_in_sig_data_at_t = b_in_sig_data@t,
	b_in_sig_status_at_t = b_in_sig_status@t,
	cnt_at_t = cnt@t,
	s_out_sig_at_t = s_out_sig@t;
assume:
	 at t: frame_data_0;
	 at t: b_in_sync;
	 at t: b_in_sync;
prove:
	 at t_end: frame_data_0;
	 at t_end: cnt = cnt_at_t;
	 at t_end: msg_data = b_in_sig_data_at_t;
	 at t_end: msg_status = b_in_sig_status_at_t;
	 at t_end: s_out_sig = s_out_sig_at_t;
	 during[t+1, t_end-1]: b_in_notify = false;
	 at t_end: b_in_notify = true;
	 during[t+1, t_end]: m_out_notify = false;
end property;

property frame_data_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	msg_data_at_t = msg_data@t,
	msg_status_at_t = msg_status@t,
	s_out_sig_at_t = s_out_sig@t;
assume:
	 at t: frame_data_0;
	 at t: not((cnt = 0));
	 at t: not(b_in_sync);
prove:
	 at t_end: frame_data_0;
	 at t_end: cnt = (-1 + cnt_at_t);
	 at t_end: m_out_sig = msg_data_at_t;
	 at t_end: msg_data = msg_data_at_t;
	 at t_end: msg_status = msg_status_at_t;
	 at t_end: s_out_sig = s_out_sig_at_t;
	 during[t+1, t_end-1]: b_in_notify = false;
	 at t_end: b_in_notify = true;
	 during[t+1, t_end-1]: m_out_notify = false;
	 at t_end: m_out_notify = true;
end property;

property frame_data_0_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	msg_data_at_t = msg_data@t,
	msg_status_at_t = msg_status@t;
assume:
	 at t: frame_data_0;
	 at t: (cnt = 0);
	 at t: not(b_in_sync);
prove:
	 at t_end: idle_3;
	 at t_end: cnt = (-1 + cnt_at_t);
	 at t_end: m_out_sig = msg_data_at_t;
	 at t_end: msg_data = msg_data_at_t;
	 at t_end: msg_status = msg_status_at_t;
	 at t_end: s_out_sig = false;
	 during[t+1, t_end-1]: b_in_notify = false;
	 at t_end: b_in_notify = true;
	 during[t+1, t_end-1]: m_out_notify = false;
	 at t_end: m_out_notify = true;
end property;

property frame_start_2_write_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msg_data_at_t = msg_data@t,
	msg_status_at_t = msg_status@t,
	s_out_sig_at_t = s_out_sig@t;
assume:
	 at t: frame_start_2;
	 at t: (cnt = 1);
prove:
	 at t_end: frame_data_0;
	 at t_end: cnt = 15;
	 at t_end: msg_data = msg_data_at_t;
	 at t_end: msg_status = msg_status_at_t;
	 at t_end: s_out_sig = s_out_sig_at_t;
	 during[t+1, t_end-1]: b_in_notify = false;
	 at t_end: b_in_notify = true;
	 during[t+1, t_end]: m_out_notify = false;
end property;

property frame_start_2_write_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	msg_data_at_t = msg_data@t,
	msg_status_at_t = msg_status@t,
	s_out_sig_at_t = s_out_sig@t;
assume:
	 at t: frame_start_2;
	 at t: not((cnt = 1));
prove:
	 at t_end: frame_start_2;
	 at t_end: cnt = (-1 + cnt_at_t);
	 at t_end: m_out_sig = (-1 + cnt_at_t);
	 at t_end: msg_data = msg_data_at_t;
	 at t_end: msg_status = msg_status_at_t;
	 at t_end: s_out_sig = s_out_sig_at_t;
	 during[t+1, t_end]: b_in_notify = false;
	 during[t+1, t_end-1]: m_out_notify = false;
	 at t_end: m_out_notify = true;
end property;

property idle_3_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+32;
freeze:
	b_in_sig_data_at_t = b_in_sig_data@t,
	b_in_sig_status_at_t = b_in_sig_status@t;
assume:
	 at t: idle_3;
	 at t: (b_in_sig_status = in_frame);
	 at t: b_in_sync;
prove:
	 at t_end: frame_start_2;
	 at t_end: cnt = 3;
	 at t_end: m_out_sig = 3;
	 at t_end: msg_data = b_in_sig_data_at_t;
	 at t_end: msg_status = b_in_sig_status_at_t;
	 at t_end: s_out_sig = true;
	 during[t+1, t_end]: b_in_notify = false;
	 during[t+1, t_end-1]: m_out_notify = false;
	 at t_end: m_out_notify = true;
end property;

property idle_3_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+32;
freeze:
	b_in_sig_data_at_t = b_in_sig_data@t,
	b_in_sig_status_at_t = b_in_sig_status@t,
	cnt_at_t = cnt@t;
assume:
	 at t: idle_3;
	 at t: not((b_in_sig_status = in_frame));
	 at t: b_in_sync;
prove:
	 at t_end: idle_3;
	 at t_end: cnt = cnt_at_t;
	 at t_end: msg_data = b_in_sig_data_at_t;
	 at t_end: msg_status = b_in_sig_status_at_t;
	 at t_end: s_out_sig = false;
	 during[t+1, t_end-1]: b_in_notify = false;
	 at t_end: b_in_notify = true;
	 during[t+1, t_end]: m_out_notify = false;
end property;

property wait_idle_3 is
dependencies: no_reset;
freeze:
	cnt_at_t = cnt@t,
	msg_data_at_t = msg_data@t,
	msg_status_at_t = msg_status@t,
	s_out_sig_at_t = s_out_sig@t;
assume:
	 at t: idle_3;
	 at t: not(b_in_sync);
prove:
	 at t+1: idle_3;
	 at t+1: cnt = cnt_at_t;
	 at t+1: msg_data = msg_data_at_t;
	 at t+1: msg_status = msg_status_at_t;
	 at t+1: s_out_sig = s_out_sig_at_t;
	 at t+1: b_in_notify = true;
	 at t+1: m_out_notify = false;
end property;
