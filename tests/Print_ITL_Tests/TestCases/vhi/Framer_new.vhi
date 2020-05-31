-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro data_word_sync : boolean := true end macro;
macro frame_pulse_notify : boolean := true end  macro;


-- DP SIGNALS --
--macro data_word_sig : marker_t :={false, resize(0,32)} end macro;
macro data_word_sig_isMarker : boolean :=false end macro;
macro data_word_sig_markerAlignment : signed :=resize(0,32) end macro;
macro frame_pulse_sig : boolean :=false end macro;
macro lof_sig : boolean :=false end macro;
macro oof_sig : boolean :=false end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro FRM_PULSE_POS : signed :=resize(0,32) end macro;
macro WORDS_IN_FRAME : signed :=resize(0,32) end macro;
macro align : signed :=resize(0,32) end macro;
macro frm_cnt : signed :=resize(0,32) end macro;
macro nextphase : Phases :=INITIALISE end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;
macro state_3 : boolean := true end macro;
macro state_4 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: FRM_PULSE_POS = resize(0,32);
	 at t: WORDS_IN_FRAME = resize(64,32);
	 at t: align = resize(0,32);
	 at t: frm_cnt = resize(63,32);
	 at t: nextphase = SEARCH;
	 at t: oof_sig = true;
	 at t: frame_pulse_notify = false;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	data_word_sig_markerAlignment_at_t = data_word_sig_markerAlignment@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_1;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: data_word_sig_isMarker;
prove:
	at t_end: state_2;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = data_word_sig_markerAlignment_at_t;
	at t_end: frame_pulse_sig = true;
	at t_end: frm_cnt = 0;
	at t_end: nextphase = FIND_SYNC;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = true;
end property;


property state_1_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_1;
	at t: not(data_word_sync);
	at t: (nextphase = SEARCH);
prove:
	at t_end: state_1;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frm_cnt = frm_cnt_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_1_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_1;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: not(data_word_sig_isMarker);
	at t: (nextphase = SEARCH);
prove:
	at t_end: state_1;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frame_pulse_sig = true;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = nextphase_at_t;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = true;
end property;


property state_1_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	data_word_sig_markerAlignment_at_t = data_word_sig_markerAlignment@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_1;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: data_word_sig_isMarker;
prove:
	at t_end: state_2;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = data_word_sig_markerAlignment_at_t;
	at t_end: frm_cnt = 0;
	at t_end: nextphase = FIND_SYNC;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_1_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_1;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: not(data_word_sig_isMarker);
	at t: (nextphase = SEARCH);
prove:
	at t_end: state_1;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = nextphase_at_t;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_2_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_2;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: not((data_word_sig_isMarker and (align = data_word_sig_markerAlignment)));
prove:
	at t_end: state_1;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frame_pulse_sig = true;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = SEARCH;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = true;
end property;


property state_2_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume:
	at t: state_2;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: data_word_sig_isMarker;
	at t: (align = data_word_sig_markerAlignment);
prove:
	at t_end: state_3;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frame_pulse_sig = true;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = SYNC;
	at t_end: oof_sig = false;
	at t+1: frame_pulse_notify = true;
end property;


property state_2_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_2;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: not((((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32)));
	at t: (nextphase = FIND_SYNC);
prove:
	at t_end: state_2;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frame_pulse_sig = true;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = nextphase_at_t;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = true;
end property;


property state_2_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_2;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: not((data_word_sig_isMarker and (align = data_word_sig_markerAlignment)));
prove:
	at t_end: state_1;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = SEARCH;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_2_19 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume:
	at t: state_2;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: data_word_sig_isMarker;
	at t: (align = data_word_sig_markerAlignment);
prove:
	at t_end: state_3;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = SYNC;
	at t_end: oof_sig = false;
	at t+1: frame_pulse_notify = false;
end property;


property state_2_21 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_2;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: not((((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32)));
	at t: (nextphase = FIND_SYNC);
prove:
	at t_end: state_2;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = nextphase_at_t;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_2_24 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_2;
	at t: not(data_word_sync);
	at t: (nextphase = FIND_SYNC);
prove:
	at t_end: state_2;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frm_cnt = frm_cnt_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_3_25 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_3;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: not((data_word_sig_isMarker and (align = data_word_sig_markerAlignment)));
prove:
	at t_end: state_4;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frame_pulse_sig = true;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = MISS;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = true;
end property;


property state_3_27 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_3;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: data_word_sig_isMarker;
	at t: (align = data_word_sig_markerAlignment);
prove:
	at t_end: state_3;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frame_pulse_sig = true;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = SYNC;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = true;
end property;


property state_3_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_3;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: not((((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32)));
	at t: (nextphase = SYNC);
prove:
	at t_end: state_3;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frame_pulse_sig = true;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = nextphase_at_t;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = true;
end property;


property state_3_31 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_3;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: not((data_word_sig_isMarker and (align = data_word_sig_markerAlignment)));
prove:
	at t_end: state_4;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = MISS;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_3_33 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_3;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: data_word_sig_isMarker;
	at t: (align = data_word_sig_markerAlignment);
prove:
	at t_end: state_3;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = SYNC;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_3_35 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_3;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: not((((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32)));
	at t: (nextphase = SYNC);
prove:
	at t_end: state_3;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = nextphase_at_t;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_3_38 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_3;
	at t: not(data_word_sync);
	at t: (nextphase = SYNC);
prove:
	at t_end: state_3;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frm_cnt = frm_cnt_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_4_39 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume:
	at t: state_4;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: not((data_word_sig_isMarker and (align = data_word_sig_markerAlignment)));
prove:
	at t_end: state_1;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frame_pulse_sig = true;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = SEARCH;
	at t_end: oof_sig = true;
	at t+1: frame_pulse_notify = true;
end property;


property state_4_41 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_4;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: data_word_sig_isMarker;
	at t: (align = data_word_sig_markerAlignment);
prove:
	at t_end: state_3;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frame_pulse_sig = true;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = SYNC;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = true;
end property;


property state_4_43 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_4;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: not((((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32)));
	at t: (nextphase = MISS);
prove:
	at t_end: state_4;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frame_pulse_sig = true;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = nextphase_at_t;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = true;
end property;


property state_4_45 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume:
	at t: state_4;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: not((data_word_sig_isMarker and (align = data_word_sig_markerAlignment)));
prove:
	at t_end: state_1;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = SEARCH;
	at t_end: oof_sig = true;
	at t+1: frame_pulse_notify = false;
end property;


property state_4_47 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_4;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: data_word_sig_isMarker;
	at t: (align = data_word_sig_markerAlignment);
prove:
	at t_end: state_3;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = SYNC;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_4_49 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_4;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: not((((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32)));
	at t: (nextphase = MISS);
prove:
	at t_end: state_4;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frm_cnt = ((1 + frm_cnt_at_t)(31 downto 0) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t_end: nextphase = nextphase_at_t;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_4_52 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_4;
	at t: not(data_word_sync);
	at t: (nextphase = MISS);
prove:
	at t_end: state_4;
	at t_end: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t_end: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t_end: align = align_at_t;
	at t_end: frm_cnt = frm_cnt_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


