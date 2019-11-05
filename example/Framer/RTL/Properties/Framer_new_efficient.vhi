-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro data_word_sync   :  boolean  := true end macro; -- ensured by system that there is always a new value
macro frame_pulse_notify :  boolean  :=  next(framer_comp/frame_pulse,2) end macro;


-- DP SIGNALS --
macro data_word_sig_isMarker: bool := (MarkerPosition /= 8); end macro;
macro data_word_sig_markerAlignment : int :=
    if prev(reset_n)=0 then
        8;
      elsif prev(reset_n,2)=0 then
        if prev(data_in)&data_in = FRAMEMARK_C then 0;
        else 8;
        end if;
      else
        if (prev(data_in,2)&prev(data_in)&data_in)(15 downto 0) = FRAMEMARK_C then 0;
        elsif (prev(data_in,2)&prev(data_in)&data_in)(16 downto 1) = FRAMEMARK_C then 1;
        elsif (prev(data_in,2)&prev(data_in)&data_in)(17 downto 2) = FRAMEMARK_C then 2;
        elsif (prev(data_in,2)&prev(data_in)&data_in)(18 downto 3) = FRAMEMARK_C then 3;
        elsif (prev(data_in,2)&prev(data_in)&data_in)(19 downto 4) = FRAMEMARK_C then 4;
        elsif (prev(data_in,2)&prev(data_in)&data_in)(20 downto 5) = FRAMEMARK_C then 5;
        elsif (prev(data_in,2)&prev(data_in)&data_in)(21 downto 6) = FRAMEMARK_C then 6;
        elsif (prev(data_in,2)&prev(data_in)&data_in)(22 downto 7) = FRAMEMARK_C then 7;
        else 8;
        end if;
      end if;
end macro;
macro frame_pulse_sig : bool := next(framer_comp/frame_pulse,2) end macro;
macro lof_sig : bool := framer_comp/lof end macro;
macro oof_sig : bool := not next(framer_comp/synchronized,2) end macro;


-- CONSTRAINTS --
macro rst: boolean:= not(framer_comp/reset_n) end macro;
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro FRM_PULSE_POS : int := 0; end macro;
macro WORDS_IN_FRAME : int := 64; end macro;
macro align : unsigned := next(framer_comp/prev_alignment,2); end macro;
macro frm_cnt : unsigned :=
        if(  next(framer_comp/frame_cnt_int,2) = 0 ) then 61;
        elsif (  next(framer_comp/frame_cnt_int,2) = 1 ) then 62;
        elsif (  next(framer_comp/frame_cnt_int,2) = 2 ) then 63;
        elsif (  next(framer_comp/frame_cnt_int,2) = 3 ) then 0;
        else unsigned( next(framer_comp/frame_cnt_int,2) - 3 );
        end if;
end macro;
macro nextphase : Phases :=
	if(state_23) then SEARCH;
	elsif (state_35) then FIND_SYNC;
	elsif (state_50) then SYNC;
	elsif (state_64) then MISS;
	else INITIALISE;
	end if;
end macro;


-- STATES --
macro state_23 : boolean :=
    next(framer_comp/prev_miss,2) and not next(synchronized,2) and
    if prev(MarkerIn) and not (prev(reset_n)=0) then
        prev(MarkerPosition) /= prev(Align);
    end if and
    if prev(reset_n,2)=0 then
        framer_comp/data_buffer(22 downto 8) = 0
    end if;
end macro;
macro state_35 : boolean :=
    not next(framer_comp/prev_miss,2) and not next(synchronized) and
    not next(synchronized) and
    not next(framer_comp/prev_miss,2) and
    (not next(framer_comp/sync_hit) or not next(synchronized,2));
end macro;
macro state_50 : boolean :=
 not next(framer_comp/prev_miss,2) and next(synchronized,2);
end macro;
macro state_64 : boolean :=
next(framer_comp/prev_miss,2) and synchronized and next(synchronized,2);
end macro;

-- HELPER --
macro FRAMEMARK_C : unsigned :=  framer_comp/FRAMEMARK_C; end macro;
macro MarkerPosition : unsigned := --abstract input for marker position

  if prev(reset_n)=0 then
    8;
  elsif prev(reset_n,2)=0 then
    if prev(data_in)&data_in = framer_comp/FRAMEMARK_C then 0;
    else 8;
    end if;
  else
    if (prev(data_in,2)&prev(data_in)&data_in)(15 downto 0) = framer_comp/FRAMEMARK_C then 0;
    elsif (prev(data_in,2)&prev(data_in)&data_in)(16 downto 1) = framer_comp/FRAMEMARK_C then 1;
    elsif (prev(data_in,2)&prev(data_in)&data_in)(17 downto 2) = framer_comp/FRAMEMARK_C then 2;
    elsif (prev(data_in,2)&prev(data_in)&data_in)(18 downto 3) = framer_comp/FRAMEMARK_C then 3;
    elsif (prev(data_in,2)&prev(data_in)&data_in)(19 downto 4) = framer_comp/FRAMEMARK_C then 4;
    elsif (prev(data_in,2)&prev(data_in)&data_in)(20 downto 5) = framer_comp/FRAMEMARK_C then 5;
    elsif (prev(data_in,2)&prev(data_in)&data_in)(21 downto 6) = framer_comp/FRAMEMARK_C then 6;
    elsif (prev(data_in,2)&prev(data_in)&data_in)(22 downto 7) = framer_comp/FRAMEMARK_C then 7;
    else 8;
    end if;
  end if;
end macro;
macro MarkerIn : bit := --abstract input for marker
  if MarkerPosition = 8 then
    '0';
  else
    '1';
  end if;
end macro;


-- OPERATIONS --
property reset is
dependencies: no_reset;
assume:
	 reset_sequence;
prove:
	 at t: state_23;
	 at t: FRM_PULSE_POS = resize(0,32);
	 at t: WORDS_IN_FRAME = resize(64,32);
	 at t: align = resize(0,32);
	 at t: frm_cnt = resize(63,32);
	 at t: nextphase = SEARCH;
	 at t: oof_sig = true;
	 at t: frame_pulse_notify = false;
end property;


property state_23_1 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	data_word_sig_markerAlignment_at_t = data_word_sig_markerAlignment@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_23;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: data_word_sig_isMarker;
prove:
	at t+1: state_35;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = data_word_sig_markerAlignment_at_t;
	at t+1: frame_pulse_sig = true;
	at t+1: frm_cnt = 0;
	at t+1: nextphase = FIND_SYNC;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = true;
end property;


property state_23_3 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_23;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: not(data_word_sig_isMarker);
	at t: (nextphase = SEARCH);
prove:
	at t+1: state_23;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frame_pulse_sig = true;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = nextphase_at_t;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = true;
end property;


property state_23_5 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	data_word_sig_markerAlignment_at_t = data_word_sig_markerAlignment@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_23;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: data_word_sig_isMarker;
prove:
	at t+1: state_35;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = data_word_sig_markerAlignment_at_t;
	at t+1: frm_cnt = 0;
	at t+1: nextphase = FIND_SYNC;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_23_7 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_23;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: not(data_word_sig_isMarker);
	at t: (nextphase = SEARCH);
prove:
	at t+1: state_23;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = nextphase_at_t;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_23_10 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_23;
	at t: not(data_word_sync);
	at t: (nextphase = SEARCH);
prove:
	at t+1: state_23;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frm_cnt = frm_cnt_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_35_11 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_35;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: not((data_word_sig_isMarker and (align = data_word_sig_markerAlignment)));
prove:
	at t+1: state_23;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frame_pulse_sig = true;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = SEARCH;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = true;
end property;


property state_35_13 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume:
	at t: state_35;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: data_word_sig_isMarker;
	at t: (align = data_word_sig_markerAlignment);
prove:
	at t+1: state_50;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frame_pulse_sig = true;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = SYNC;
	at t+1: oof_sig = false;
	at t+1: frame_pulse_notify = true;
end property;


property state_35_15 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_35;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: not((((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32)));
	at t: (nextphase = FIND_SYNC);
prove:
	at t+1: state_35;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frame_pulse_sig = true;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = nextphase_at_t;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = true;
end property;


property state_35_17 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_35;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: not((data_word_sig_isMarker and (align = data_word_sig_markerAlignment)));
prove:
	at t+1: state_23;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = SEARCH;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_35_19 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume:
	at t: state_35;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: data_word_sig_isMarker;
	at t: (align = data_word_sig_markerAlignment);
prove:
	at t+1: state_50;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = SYNC;
	at t+1: oof_sig = false;
	at t+1: frame_pulse_notify = false;
end property;


property state_35_21 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_35;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: not((((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32)));
	at t: (nextphase = FIND_SYNC);
prove:
	at t+1: state_35;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = nextphase_at_t;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_35_24 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_35;
	at t: not(data_word_sync);
	at t: (nextphase = FIND_SYNC);
prove:
	at t+1: state_35;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frm_cnt = frm_cnt_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_50_25 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_50;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: not((data_word_sig_isMarker and (align = data_word_sig_markerAlignment)));
prove:
	at t+1: state_64;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frame_pulse_sig = true;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = MISS;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = true;
end property;


property state_50_27 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_50;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: data_word_sig_isMarker;
	at t: (align = data_word_sig_markerAlignment);
prove:
	at t+1: state_50;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frame_pulse_sig = true;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = SYNC;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = true;
end property;


property state_50_29 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_50;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: not((((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32)));
	at t: (nextphase = SYNC);
prove:
	at t+1: state_50;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frame_pulse_sig = true;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = nextphase_at_t;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = true;
end property;


property state_50_31 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_50;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: not((data_word_sig_isMarker and (align = data_word_sig_markerAlignment)));
prove:
	at t+1: state_64;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = MISS;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_50_33 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_50;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: data_word_sig_isMarker;
	at t: (align = data_word_sig_markerAlignment);
prove:
	at t+1: state_50;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = SYNC;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_50_35 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_50;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: not((((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32)));
	at t: (nextphase = SYNC);
prove:
	at t+1: state_50;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = nextphase_at_t;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_50_38 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_50;
	at t: not(data_word_sync);
	at t: (nextphase = SYNC);
prove:
	at t+1: state_50;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frm_cnt = frm_cnt_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_64_39 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume:
	at t: state_64;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: not((data_word_sig_isMarker and (align = data_word_sig_markerAlignment)));
prove:
	at t+1: state_23;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frame_pulse_sig = true;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = SEARCH;
	at t+1: oof_sig = true;
	at t+1: frame_pulse_notify = true;
end property;


property state_64_41 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_64;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: data_word_sig_isMarker;
	at t: (align = data_word_sig_markerAlignment);
prove:
	at t+1: state_50;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frame_pulse_sig = true;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = SYNC;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = true;
end property;


property state_64_43 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_64;
	at t: data_word_sync;
	at t: (frm_cnt = FRM_PULSE_POS);
	at t: not((((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32)));
	at t: (nextphase = MISS);
prove:
	at t+1: state_64;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frame_pulse_sig = true;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = nextphase_at_t;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = true;
end property;


property state_64_45 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume:
	at t: state_64;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: not((data_word_sig_isMarker and (align = data_word_sig_markerAlignment)));
prove:
	at t+1: state_23;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = SEARCH;
	at t+1: oof_sig = true;
	at t+1: frame_pulse_notify = false;
end property;


property state_64_47 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_64;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: (((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32));
	at t: data_word_sig_isMarker;
	at t: (align = data_word_sig_markerAlignment);
prove:
	at t+1: state_50;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = SYNC;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_64_49 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_64;
	at t: data_word_sync;
	at t: not((frm_cnt = FRM_PULSE_POS));
	at t: not((((resize(1,32) + frm_cnt)(31 downto 0) mod WORDS_IN_FRAME)(31 downto 0) = resize(0,32)));
	at t: (nextphase = MISS);
prove:
	at t+1: state_64;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t)(31 downto 0);
	at t+1: nextphase = nextphase_at_t;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


property state_64_52 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	nextphase_at_t = nextphase@t,
	oof_sig_at_t = oof_sig@t;
assume:
	at t: state_64;
	at t: not(data_word_sync);
	at t: (nextphase = MISS);
prove:
	at t+1: state_64;
	at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	at t+1: align = align_at_t;
	at t+1: frm_cnt = frm_cnt_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: oof_sig = oof_sig_at_t;
	at t+1: frame_pulse_notify = false;
end property;


