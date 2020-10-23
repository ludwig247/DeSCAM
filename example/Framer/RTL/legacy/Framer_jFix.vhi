//Version with handshake for data_word, and with missCnt unoptimized (determined for all sections altough it is only needed determined in MISS)

//TODO:
// +  1-cycle communication (synchronized on every clock edge, and sharing clock with comm.partner)
// +  parallelization of communication. Do an analyzis of which messages can be sent / read in parallel
// +  Wait operations must be of length 1, while the length of other operations is t_end which is freely chosen, current property generation sets both to t+1
// +  Too many freeze variables are created
// +  would be nice if #defines / consts were not replaced, the symbolic values, e.g., WORDS_IN_FRAME and FRM_PULSE_POS was left symbolic in the property file
// +  if we want a psudo-lang, I suggest removing the entire section and us @t directly
// +  analyzes for minimal determination: For example, missCnt is only used in state MISS, and does therefore only need to be determined there. Since all (non-loop) operations ending in MISS sets missCnt to a constant it is enough to prove the value for all operations ending in MISS (also the loop operations)
//    must be proven at t_end for SYNC_read_20, and at t_end for all MISS_* operations


//here, the data_word will be implemented as a 1-cycle no-wait port... a data word is sent in each cycle
// --> this module must use the clock of the data word (or a faster one? and then check?)
// --> must read data_word in every cycle... hmm too strict. Instead, all operations must be 1 cycle long. This ensures that message are only lost if they are ignorable.
       However, at the abstract level a message must then be read and thrown away, we can replace that now by reading only when needed... it continues on its own.. It boils down to simply reading the signal when needed.. just like for shareds, however, we cannot model it at the abstract level using a shared since we need the events and the synchronization there.


--DEFINES
macro WORDS_IN_FRAME : int := 10 end macro;
macro FRM_PULSE_POS : int := 10 end macro;

-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro data_word_notify :  boolean  := end macro;
macro data_word_sync   :  boolean  := end macro;
macro frame_pulse_notify :  boolean  := end macro;

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
macro frm_cnt : int := end macro;
macro missCnt : int := end macro;


-- STATES --
macro FIND_SYNC : boolean := section=FIND_SYNC end macro;
macro MISS : boolean := section=MISS end macro;
macro SEARCH : boolean := section=SEARCH end macro;
macro SYNC : boolean := section=SYNC end macro;


--Operations --


property reset is
for timepoints:
	t_end = t+1;
assume:
	 reset_sequence;
prove:
	 at t_end: SEARCH;
	 at t_end: align = 0;
	 at t_end: frm_cnt = 0;
	 at t_end: missCnt = 0;
	 at t_end: oof_sig = true;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;



property wait_SEARCH is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: SEARCH;
	 at t: (data_word_sync = false);
prove:
	 at t_end: SEARCH;
	 at t_end: align = align_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property SEARCH_read_16 is
dependencies: no_reset;
for timepoints:
	t_end = /*please fill in*/;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	missCnt_at_t = missCnt@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: SEARCH;
	 at t: data_word_isMarker_sig;
	 at t: (data_word_sync = true);
prove:
	 at t_end: FIND_SYNC;
	 at t_end: align = data_word_sig_markerAlignment_at_t;
	 at t_end: frm_cnt = 0;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end]: frame_pulse_notify = false;
	 at t_end: data_word_notify = true;
end property;

property SEARCH_read_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: SEARCH;
	 at t: not(data_word_isMarker_sig);
	 at t: (data_word_sync = true);
prove:
	 at t_end: SEARCH;
	 at t_end: align = align_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) % WORDS_IN_FRAME);
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = (frm_cnt_at_t == FRM_PULSE_POS);
	 at t_end: data_word_notify = true;
end property;





property wait_FIND_SYNC is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: FIND_SYNC;
	 at t: (data_word_sync = false);
prove:
	 at t_end: FIND_SYNC;
	 at t_end: align = align_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = (frm_cnt_at_t == FRM_PULSE_POS);
	 at t_end: data_word_notify = true;
end property;

property FIND_SYNC_read_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: FIND_SYNC;
	 at t: not( ((1 + frm_cnt) % WORDS_IN_FRAME) = 0);
	 at t: (data_word_sync = true);
prove:
	 at t_end: FIND_SYNC;
	 at t_end: align = align_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) % WORDS_IN_FRAME);
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = (frm_cnt_at_t == FRM_PULSE_POS);
	 at t_end: data_word_notify = true;
end property;

property FIND_SYNC_read_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: FIND_SYNC;
	 at t: not((data_word_isMarker_sig and (align = data_word_markerAlignment_sig)));
	 at t: (((1 + frm_cnt) % WORDS_IN_FRAME) = 0);
	 at t: (data_word_sync = true);
prove:
	 at t_end: SEARCH;
	 at t_end: align = align_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) % WORDS_IN_FRAME);
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = (frm_cnt_at_t == FRM_PULSE_POS);
	 at t_end: data_word_notify = true;
end property;

property FIND_SYNC_read_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	missCnt_at_t = missCnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	 at t: FIND_SYNC;
	 at t: data_word_isMarker_sig;
	 at t: (align = data_word_markerAlignment_sig);
	 at t: (((1 + frm_cnt) % WORDS_IN_FRAME) = 0);
	 at t: (data_word_sync = true);
prove:
	 at t_end: SYNC;
	 at t_end: align = align_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) % WORDS_IN_FRAME);
	 at t_end: missCnt = 0;
	 at t_end: oof_sig = false;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = (frm_cnt_at_t == FRM_PULSE_POS);
	 at t_end: data_word_notify = true;
end property;




property wait_SYNC is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: SYNC;
	 at t: (data_word_sync = false);
prove:
	 at t_end: SYNC;
	 at t_end: align = align_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = (frm_cnt_at_t == FRM_PULSE_POS);
	 at t_end: data_word_notify = true;
end property;

property SYNC_read_21 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: SYNC;
	 at t: not( ((1 + frm_cnt) % WORDS_IN_FRAME) = 0 );
	 at t: (data_word_sync = true);
prove:
	 at t_end: SYNC;
	 at t_end: align = align_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) % WORDS_IN_FRAME);
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = (frm_cnt_at_t == FRM_PULSE_POS);
	 at t_end: data_word_notify = true;
end property;

property SYNC_read_20 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: SYNC;
	 at t: not((data_word_isMarker_sig and (align = data_word_markerAlignment_sig)));
	 at t: (((1 + frm_cnt) % WORDS_IN_FRAME) = 0);
	 at t: (data_word_sync = true);
prove:
	 at t_end: MISS;
	 at t_end: align = align_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) % WORDS_IN_FRAME);
	 at t_end: missCnt = 1;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = (frm_cnt_at_t == FRM_PULSE_POS);
	 at t_end: data_word_notify = true;
end property;

property SYNC_read_22 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: SYNC;
	 at t: data_word_isMarker_sig;
	 at t: (align = data_word_markerAlignment_sig);
	 at t: (((1 + frm_cnt) % WORDS_IN_FRAME) = 0);
	 at t: (data_word_sync = true);
prove:
	 at t_end: SYNC;
	 at t_end: align = align_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) % WORDS_IN_FRAME);
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = (frm_cnt_at_t == FRM_PULSE_POS);
	 at t_end: data_word_notify = true;
end property;





property wait_MISS is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: MISS;
	 at t: (data_word_sync = false);
prove:
	 at t_end: MISS;
	 at t_end: align = align_at_t;
	 at t_end: frm_cnt = frm_cnt_at_t;
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = (frm_cnt_at_t == FRM_PULSE_POS);
	 at t_end: data_word_notify = true;
end property;

property MISS_read_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: MISS;
	 at t: not( ((1 + frm_cnt) % WORDS_IN_FRAME) = 0 );
	 at t: (data_word_sync = true);
prove:
	 at t_end: MISS;
	 at t_end: align = align_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) % WORDS_IN_FRAME);
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = (frm_cnt_at_t == FRM_PULSE_POS);
	 at t_end: data_word_notify = true;
end property;

property MISS_read_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: MISS;
	 at t: not((data_word_isMarker_sig and (align = data_word_markerAlignment_sig)));
	 at t: not((missCnt >= max_miss_uP_sig));
	 at t: (((1 + frm_cnt) % WORDS_IN_FRAME) = 0);
	 at t: (data_word_sync = true);
prove:
	 at t_end: MISS;
	 at t_end: align = align_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) % WORDS_IN_FRAME);
	 at t_end: missCnt = (1 + missCnt_at_t);
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = (frm_cnt_at_t == FRM_PULSE_POS);
	 at t_end: data_word_notify = true;
end property;


property MISS_read_WORDS_IN_FRAME is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	missCnt_at_t = missCnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	 at t: MISS;
	 at t: not((data_word_isMarker_sig and (align = data_word_markerAlignment_sig)));
	 at t: (missCnt >= max_miss_uP_sig);
	 at t: (((1 + frm_cnt) % WORDS_IN_FRAME) = 0);
	 at t: (data_word_sync = true);
prove:
	 at t_end: SEARCH;
	 at t_end: align = align_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) % WORDS_IN_FRAME);
	 at t_end: missCnt = missCnt_at_t;
	 at t_end: oof_sig = true;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = (frm_cnt_at_t == FRM_PULSE_POS);
	 at t_end: data_word_notify = true;
end property;

property MISS_read_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: MISS;
	 at t: data_word_isMarker_sig;
	 at t: (align = data_word_markerAlignment_sig);
	 at t: (((1 + frm_cnt) % WORDS_IN_FRAME) = 0);
	 at t: (data_word_sync = true);
prove:
	 at t_end: SYNC;
	 at t_end: align = align_at_t;
	 at t_end: frm_cnt = ((1 + frm_cnt_at_t) % WORDS_IN_FRAME);
	 at t_end: missCnt = missCnt_at_t;
	 during[t+1, t_end-1]: data_word_notify = false;
	 during[t+1, t_end-1]: frame_pulse_notify = false;
	 at t_end: frame_pulse_notify = (frm_cnt_at_t == FRM_PULSE_POS);
	 at t_end: data_word_notify = true;
end property;
