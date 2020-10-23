-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro data_word_notify :  boolean  := end macro;
macro data_word_sync   :  boolean  := end macro;
macro frame_pulse_notify :  boolean  := end macro;
macro frame_pulse_sync   :  boolean  := end macro;

-- DP SIGNALS --
macro data_word_isMarker_sig : bool := end macro;
macro data_word_markerAlignment_sig : int := end macro;
macro lof_sig : bool := end macro;
macro max_miss_uP_sig : int := end macro;
macro oof_sig : bool := end macro;


--CONSTRAINTS--
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro align : int := end macro;
macro data_word_tmp_isMarker : bool := end macro;
macro data_word_tmp_markerAlignment : int := end macro;
macro frm_cnt : int := end macro;
macro max_miss_uP_tmp : int := end macro;
macro missCnt : int := end macro;


-- STATES --
macro FIND_SYNC_0 : boolean := section=FIND_SYNC end macro;
macro FIND_SYNC_1 : boolean := section=FIND_SYNC end macro;
macro MISS_2 : boolean := section=MISS end macro;
macro MISS_3 : boolean := section=MISS end macro;
macro SEARCH_4 : boolean := section=SEARCH end macro;
macro SEARCH_5 : boolean := section=SEARCH end macro;
macro SYNC_6 : boolean := section=SYNC end macro;
macro SYNC_7 : boolean := section=SYNC end macro;


--Operations --


property reset is
for timepoints:
	t_end = t;
assume:
	 reset_sequence;
prove:
	 at t_end: SEARCH_4;
	 at t_end: align = 0;
	 at t_end: data_word_tmp_isMarker = false;
	 at t_end: data_word_tmp_markerAlignment = 0;
	 at t_end: frm_cnt = 0;
	 at t_end: max_miss_uP_tmp = 0;
	 at t_end: missCnt = 0;
	 at t_end: oof_sig = true;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property wait_FIND_SYNC_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: FIND_SYNC_0;
	 at t: (data_word_sync = false);
prove:
	 at t_end: FIND_SYNC_0;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property FIND_SYNC_0_read_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: FIND_SYNC_0;
	 at t: not((((1 + frm_cnt) / 10) = 10));
	 at t: not((((1 + frm_cnt) / 10) = 0));
	 at t: (data_word_sync = true);
prove:
	 at t_end: FIND_SYNC_0;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_sig_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_sig_markerAlignment_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) / 10);
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property FIND_SYNC_0_read_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: FIND_SYNC_0;
	 at t: (((1 + frm_cnt) / 10) = 10);
	 at t: (data_word_sync = true);
prove:
	 at t_end: FIND_SYNC_1;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_sig_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_sig_markerAlignment_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) / 10);
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = true;
end property;

property FIND_SYNC_0_read_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: FIND_SYNC_0;
	 at t: not((data_word_isMarker_sig and (align = data_word_markerAlignment_sig)));
	 at t: (((1 + frm_cnt) / 10) = 0);
	 at t: (data_word_sync = true);
prove:
	 at t_end: SEARCH_4;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_sig_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_sig_markerAlignment_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) / 10);
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property FIND_SYNC_0_read_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	oof_sig_at_t = oof_sig@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: FIND_SYNC_0;
	 at t: data_word_isMarker_sig;
	 at t: (align = data_word_markerAlignment_sig);
	 at t: (((1 + frm_cnt) / 10) = 0);
	 at t: (data_word_sync = true);
prove:
	 at t_end: SYNC_6;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_sig_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_sig_markerAlignment_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) / 10);
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = 0;
	 at t_end: oof_sig = false;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property FIND_SYNC_1_read_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: FIND_SYNC_1;
	 at t: not((frm_cnt = 0));
	 at t: (frame_pulse_sync = true);
prove:
	 at t_end: FIND_SYNC_0;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property wait_FIND_SYNC_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: FIND_SYNC_1;
	 at t: (frame_pulse_sync = false);
prove:
	 at t_end: FIND_SYNC_1;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = true;
end property;

property FIND_SYNC_1_read_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: FIND_SYNC_1;
	 at t: not((data_word_tmp_isMarker and (align = data_word_tmp_markerAlignment)));
	 at t: (frm_cnt = 0);
	 at t: (frame_pulse_sync = true);
prove:
	 at t_end: SEARCH_4;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property FIND_SYNC_1_read_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	 at t: FIND_SYNC_1;
	 at t: data_word_tmp_isMarker;
	 at t: (align = data_word_tmp_markerAlignment);
	 at t: (frm_cnt = 0);
	 at t: (frame_pulse_sync = true);
prove:
	 at t_end: SYNC_6;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = 0;
	 at t_end: oof_sig = false;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property wait_MISS_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: MISS_2;
	 at t: (data_word_sync = false);
prove:
	 at t_end: MISS_2;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property MISS_2_read_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: MISS_2;
	 at t: not((((1 + frm_cnt) / 10) = 10));
	 at t: not((((1 + frm_cnt) / 10) = 0));
	 at t: (data_word_sync = true);
prove:
	 at t_end: MISS_2;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_sig_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_sig_markerAlignment_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) / 10);
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property MISS_2_read_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: MISS_2;
	 at t: not((data_word_isMarker_sig and (align = data_word_markerAlignment_sig)));
	 at t: not((missCnt >= max_miss_uP_sig));
	 at t: (((1 + frm_cnt) / 10) = 0);
	 at t: (data_word_sync = true);
prove:
	 at t_end: MISS_2;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_sig_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_sig_markerAlignment_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) / 10);
	 at t_end: max_miss_uP_tmp = max_miss_uP_sig_at_t;
	 at t_end: missCnt = (1 + missCnt_at_t);
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property MISS_2_read_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: MISS_2;
	 at t: (((1 + frm_cnt) / 10) = 10);
	 at t: (data_word_sync = true);
prove:
	 at t_end: MISS_3;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_sig_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_sig_markerAlignment_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) / 10);
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = true;
end property;

property MISS_2_read_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	oof_sig_at_t = oof_sig@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: MISS_2;
	 at t: not((data_word_isMarker_sig and (align = data_word_markerAlignment_sig)));
	 at t: (missCnt >= max_miss_uP_sig);
	 at t: (((1 + frm_cnt) / 10) = 0);
	 at t: (data_word_sync = true);
prove:
	 at t_end: SEARCH_4;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_sig_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_sig_markerAlignment_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) / 10);
	 at t_end: max_miss_uP_tmp = max_miss_uP_sig_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 at t_end: oof_sig = true;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property MISS_2_read_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: MISS_2;
	 at t: data_word_isMarker_sig;
	 at t: (align = data_word_markerAlignment_sig);
	 at t: (((1 + frm_cnt) / 10) = 0);
	 at t: (data_word_sync = true);
prove:
	 at t_end: SYNC_6;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_sig_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_sig_markerAlignment_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) / 10);
	 at t_end: max_miss_uP_tmp = max_miss_uP_sig_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property MISS_3_read_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: MISS_3;
	 at t: not((frm_cnt = 0));
	 at t: (frame_pulse_sync = true);
prove:
	 at t_end: MISS_2;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property MISS_3_read_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: MISS_3;
	 at t: not((data_word_tmp_isMarker and (align = data_word_tmp_markerAlignment)));
	 at t: not((missCnt >= max_miss_uP_sig));
	 at t: (frm_cnt = 0);
	 at t: (frame_pulse_sync = true);
prove:
	 at t_end: MISS_2;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_sig_at_t;
	 at t_end: missCnt = (1 + missCnt_at_t);
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property wait_MISS_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: MISS_3;
	 at t: (frame_pulse_sync = false);
prove:
	 at t_end: MISS_3;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = true;
end property;

property MISS_3_read_14 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	 at t: MISS_3;
	 at t: not((data_word_tmp_isMarker and (align = data_word_tmp_markerAlignment)));
	 at t: (missCnt >= max_miss_uP_sig);
	 at t: (frm_cnt = 0);
	 at t: (frame_pulse_sync = true);
prove:
	 at t_end: SEARCH_4;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_sig_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 at t_end: oof_sig = true;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property MISS_3_read_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: MISS_3;
	 at t: data_word_tmp_isMarker;
	 at t: (align = data_word_tmp_markerAlignment);
	 at t: (frm_cnt = 0);
	 at t: (frame_pulse_sync = true);
prove:
	 at t_end: SYNC_6;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_sig_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property SEARCH_4_read_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: SEARCH_4;
	 at t: data_word_tmp_isMarker;
	 at t: (data_word_sync = true);
prove:
	 at t_end: FIND_SYNC_0;
	 at t_end: align = data_word_sig_markerAlignment_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_sig_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_sig_markerAlignment_at_t;
	 at t_end: frm_cnt = 0;
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property wait_SEARCH_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: SEARCH_4;
	 at t: (data_word_sync = false);
prove:
	 at t_end: SEARCH_4;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property SEARCH_4_read_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: SEARCH_4;
	 at t: not(data_word_isMarker_sig);
	 at t: not((((1 + frm_cnt) / 10) = 10));
	 at t: (data_word_sync = true);
prove:
	 at t_end: SEARCH_4;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_sig_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_sig_markerAlignment_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) / 10);
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property SEARCH_4_read_18 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: SEARCH_4;
	 at t: not(data_word_isMarker_sig);
	 at t: (((1 + frm_cnt) / 10) = 10);
	 at t: (data_word_sync = true);
prove:
	 at t_end: SEARCH_5;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_sig_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_sig_markerAlignment_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) / 10);
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = true;
end property;

property SEARCH_5_read_19 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: SEARCH_5;
	 at t: (frame_pulse_sync = true);
prove:
	 at t_end: SEARCH_4;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property wait_SEARCH_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: SEARCH_5;
	 at t: (frame_pulse_sync = false);
prove:
	 at t_end: SEARCH_5;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = true;
end property;

property SYNC_6_read_20 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: SYNC_6;
	 at t: not((data_word_isMarker_sig and (align = data_word_markerAlignment_sig)));
	 at t: (((1 + frm_cnt) / 10) = 0);
	 at t: (data_word_sync = true);
prove:
	 at t_end: MISS_2;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_sig_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_sig_markerAlignment_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) / 10);
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = 1;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property wait_SYNC_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: SYNC_6;
	 at t: (data_word_sync = false);
prove:
	 at t_end: SYNC_6;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property SYNC_6_read_21 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: SYNC_6;
	 at t: not((((1 + frm_cnt) / 10) = 10));
	 at t: not((((1 + frm_cnt) / 10) = 0));
	 at t: (data_word_sync = true);
prove:
	 at t_end: SYNC_6;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_sig_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_sig_markerAlignment_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) / 10);
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property SYNC_6_read_22 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: SYNC_6;
	 at t: data_word_isMarker_sig;
	 at t: (align = data_word_markerAlignment_sig);
	 at t: (((1 + frm_cnt) / 10) = 0);
	 at t: (data_word_sync = true);
prove:
	 at t_end: SYNC_6;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_sig_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_sig_markerAlignment_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) / 10);
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property SYNC_6_read_23 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_isMarker_at_t = data_word_isMarker_sig@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: SYNC_6;
	 at t: (((1 + frm_cnt) / 10) = 10);
	 at t: (data_word_sync = true);
prove:
	 at t_end: SYNC_7;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_sig_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_sig_markerAlignment_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) / 10);
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = true;
end property;

property SYNC_7_read_24 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: SYNC_7;
	 at t: not((data_word_tmp_isMarker and (align = data_word_tmp_markerAlignment)));
	 at t: (frm_cnt = 0);
	 at t: (frame_pulse_sync = true);
prove:
	 at t_end: MISS_2;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = 1;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property SYNC_7_read_25 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: SYNC_7;
	 at t: not((frm_cnt = 0));
	 at t: (frame_pulse_sync = true);
prove:
	 at t_end: SYNC_6;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property SYNC_7_read_26 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: SYNC_7;
	 at t: data_word_tmp_isMarker;
	 at t: (align = data_word_tmp_markerAlignment);
	 at t: (frm_cnt = 0);
	 at t: (frame_pulse_sync = true);
prove:
	 at t_end: SYNC_6;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property wait_SYNC_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	data_word_tmp_isMarker_at_t = data_word_tmp_isMarker@t,
	data_word_tmp_markerAlignment_at_t = data_word_tmp_markerAlignment@t,
	frm_cnt_at_t = frm_cnt@t,
	max_miss_uP_tmp_at_t = max_miss_uP_tmp@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: SYNC_7;
	 at t: (frame_pulse_sync = false);
prove:
	 at t_end: SYNC_7;
	 at t_end: align = align_at_t;
	 at t_end: data_word_tmp_isMarker = data_word_tmp_isMarker_at_t;
	 at t_end: data_word_tmp_markerAlignment = data_word_tmp_markerAlignment_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: max_miss_uP_tmp = max_miss_uP_tmp_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = true;
end property;
