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
macro max_miss_uP_sig : int := 1 end macro;
macro oof_sig : bool := not next(framer_comp/synchronized,2) end macro;


--CONSTRAINTS--
macro rst: boolean:= not(framer_comp/reset_n) end macro;
constraint no_reset := rst = '0'; end constraint;

-- VISIBLE REGISTERS --
macro align : unsigned := next(framer_comp/prev_alignment,2); end macro;
macro frm_cnt : unsigned :=
    if(  next(framer_comp/frame_cnt_int,2) = 0 ) then 61;
    elsif (  next(framer_comp/frame_cnt_int,2) = 1 ) then 62;
    elsif (  next(framer_comp/frame_cnt_int,2) = 2 ) then 63;
    elsif (  next(framer_comp/frame_cnt_int,2) = 3 ) then 0;
    else unsigned( next(framer_comp/frame_cnt_int,2) - 3 );
    end if;
end macro;
macro missCnt : int := -- not used in our implementation, trivial 1
	if(SYNC_6) then 0;
	else 1;
	end if;
 end macro; 

macro WORDS_IN_FRAME: int := 64; end macro;
macro FRM_PULSE_POS: int := 0; end macro;

-- STATES --
macro FIND_SYNC_0 : boolean :=
    not next(framer_comp/prev_miss,2) and not next(synchronized) and
    not next(synchronized) and
    not next(framer_comp/prev_miss,2) and
    (not next(framer_comp/sync_hit) or not next(synchronized,2));
end macro;
macro MISS_2 : boolean :=
next(framer_comp/prev_miss,2) and synchronized and next(synchronized,2);
end macro;

macro SEARCH_4 : boolean :=
    next(framer_comp/prev_miss,2) and not next(synchronized,2) and
    if prev(MarkerIn) and not (prev(reset_n)=0) then
        prev(MarkerPosition) /= prev(Align);
    end if and
    if prev(reset_n,2)=0 then
        framer_comp/data_buffer(22 downto 8) = 0
    end if;
end macro;

macro SYNC_6 : boolean :=
 not next(framer_comp/prev_miss,2) and next(synchronized,2);
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

--Operations --
property reset is
dependencies: no_reset;
assume:
	 reset_sequence;
prove:
	 at t: SEARCH_4;
	 at t: align = 0;
	 at t: frm_cnt = 63;
	 at t: missCnt = 1;
	 at t: oof_sig = true;
	 at t: frame_pulse_notify = false;
end property;

property FIND_SYNC_0_read_0 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: FIND_SYNC_0;
	 at t: not(data_word_sync);
prove:
	 at t+1: FIND_SYNC_0;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = frm_cnt_at_t;
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = false;
end property;

property FIND_SYNC_0_read_1 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: FIND_SYNC_0;
	 at t: data_word_sync;
	 at t: not((frm_cnt = FRM_PULSE_POS));
	 at t: not((((1 + frm_cnt) mod WORDS_IN_FRAME) = 0));
	 at t: data_word_sync;
prove:
	 at t+1: FIND_SYNC_0;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = false;
end property;

property FIND_SYNC_0_read_2 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: FIND_SYNC_0;
	 at t: data_word_sync;
	 at t: not((frm_cnt = FRM_PULSE_POS));
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
	 at t: not((data_word_sig_isMarker and (align = data_word_sig_markerAlignment)));
	 at t: data_word_sync;
prove:
	 at t+1: SEARCH_4;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = false;
end property;

property FIND_SYNC_0_read_3 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume: 
	 at t: FIND_SYNC_0;
	 at t: data_word_sync;
	 at t: not((frm_cnt = FRM_PULSE_POS));
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
	 at t: data_word_sig_isMarker;
	 at t: (align = data_word_sig_markerAlignment);
	 at t: data_word_sync;
prove:
	 at t+1: SYNC_6;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = false;
	 at t+1: frame_pulse_notify = false;
end property;

property FIND_SYNC_0_read_4 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: FIND_SYNC_0;
	 at t: data_word_sync;
	 at t: (frm_cnt = FRM_PULSE_POS);
	 at t: not((((1 + frm_cnt) mod WORDS_IN_FRAME) = 0));
	 at t: data_word_sync;
prove:
	 at t+1: FIND_SYNC_0;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frame_pulse_sig = true;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = true;
end property;

property FIND_SYNC_0_read_5 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: FIND_SYNC_0;
	 at t: data_word_sync;
	 at t: (frm_cnt = FRM_PULSE_POS);
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
	 at t: not((data_word_sig_isMarker and (align = data_word_sig_markerAlignment)));
	 at t: data_word_sync;
prove:
	 at t+1: SEARCH_4;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frame_pulse_sig = true;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = true;
end property;

property FIND_SYNC_0_read_6 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume: 
	 at t: FIND_SYNC_0;
	 at t: data_word_sync;
	 at t: (frm_cnt = FRM_PULSE_POS);
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
	 at t: data_word_sig_isMarker;
	 at t: (align = data_word_sig_markerAlignment);
	 at t: data_word_sync;
prove:
	 at t+1: SYNC_6;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frame_pulse_sig = true;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = false;
	 at t+1: frame_pulse_notify = true;
end property;

property MISS_2_read_7 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: MISS_2;
	 at t: not(data_word_sync);
prove:
	 at t+1: MISS_2;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = frm_cnt_at_t;
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = false;
end property;

property MISS_2_read_8 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: MISS_2;
	 at t: data_word_sync;
	 at t: not((frm_cnt = FRM_PULSE_POS));
	 at t: not((((1 + frm_cnt) mod WORDS_IN_FRAME) = 0));
	 at t: data_word_sync;
prove:
	 at t+1: MISS_2;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = false;
end property;

property MISS_2_read_9 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume: 
	 at t: MISS_2;
	 at t: data_word_sync;
	 at t: not((frm_cnt = FRM_PULSE_POS));
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
	 at t: not((data_word_sig_isMarker and (align = data_word_sig_markerAlignment)));
	 at t: data_word_sync;
prove:
	 at t+1: SEARCH_4;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = true;
	 at t+1: frame_pulse_notify = false;
end property;

property MISS_2_read_10 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: MISS_2;
	 at t: data_word_sync;
	 at t: not((frm_cnt = FRM_PULSE_POS));
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
	 at t: data_word_sig_isMarker;
	 at t: (align = data_word_sig_markerAlignment);
	 at t: data_word_sync;
prove:
	 at t+1: SYNC_6;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = false;
end property;

property MISS_2_read_11 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: MISS_2;
	 at t: data_word_sync;
	 at t: (frm_cnt = FRM_PULSE_POS);
	 at t: not((((1 + frm_cnt) mod WORDS_IN_FRAME) = 0));
	 at t: data_word_sync;
prove:
	 at t+1: MISS_2;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frame_pulse_sig = true;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = true;
end property;

property MISS_2_read_12 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume: 
	 at t: MISS_2;
	 at t: data_word_sync;
	 at t: (frm_cnt = FRM_PULSE_POS);
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
	 at t: not((data_word_sig_isMarker and (align = data_word_sig_markerAlignment)));
	 at t: data_word_sync;
prove:
	 at t+1: SEARCH_4;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frame_pulse_sig = true;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = true;
	 at t+1: frame_pulse_notify = true;
end property;

property MISS_2_read_13 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: MISS_2;
	 at t: data_word_sync;
	 at t: (frm_cnt = FRM_PULSE_POS);
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
	 at t: data_word_sig_isMarker;
	 at t: (align = data_word_sig_markerAlignment);
	 at t: data_word_sync;
prove:
	 at t+1: SYNC_6;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frame_pulse_sig = true;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = true;
end property;

property SEARCH_4_read_14 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	data_word_sig_markerAlignment_at_t = data_word_sig_markerAlignment@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: SEARCH_4;
	 at t: data_word_sync;
	 at t: not((frm_cnt = FRM_PULSE_POS));
	 at t: data_word_sig_isMarker;
	 at t: data_word_sync;
prove:
	 at t+1: FIND_SYNC_0;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = data_word_sig_markerAlignment_at_t;
	 at t+1: frm_cnt = 0;
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = false;
end property;

property SEARCH_4_read_15 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: SEARCH_4;
	 at t: not(data_word_sync);
prove:
	 at t+1: SEARCH_4;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = frm_cnt_at_t;
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = false;
end property;

property SEARCH_4_read_16 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: SEARCH_4;
	 at t: data_word_sync;
	 at t: not((frm_cnt = FRM_PULSE_POS));
	 at t: not(data_word_sig_isMarker);
	 at t: data_word_sync;
prove:
	 at t+1: SEARCH_4;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = false;
end property;

property SEARCH_4_read_17 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	data_word_sig_markerAlignment_at_t = data_word_sig_markerAlignment@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: SEARCH_4;
	 at t: data_word_sync;
	 at t: (frm_cnt = FRM_PULSE_POS);
	 at t: data_word_sig_isMarker;
	 at t: data_word_sync;
prove:
	 at t+1: FIND_SYNC_0;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = data_word_sig_markerAlignment_at_t;
	 at t+1: frame_pulse_sig = true;
	 at t+1: frm_cnt = 0;
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = true;
end property;

property SEARCH_4_read_18 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: SEARCH_4;
	 at t: data_word_sync;
	 at t: (frm_cnt = FRM_PULSE_POS);
	 at t: not(data_word_sig_isMarker);
	 at t: data_word_sync;
prove:
	 at t+1: SEARCH_4;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frame_pulse_sig = true;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = true;
end property;

property SYNC_6_read_19 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: SYNC_6;
	 at t: data_word_sync;
	 at t: not((frm_cnt = FRM_PULSE_POS));
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
	 at t: not((data_word_sig_isMarker and (align = data_word_sig_markerAlignment)));
	 at t: data_word_sync;
prove:
	 at t+1: MISS_2;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = false;
end property;

property SYNC_6_read_20 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: SYNC_6;
	 at t: not(data_word_sync);
prove:
	 at t+1: SYNC_6;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = frm_cnt_at_t;
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = false;
end property;

property SYNC_6_read_21 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: SYNC_6;
	 at t: data_word_sync;
	 at t: not((frm_cnt = FRM_PULSE_POS));
	 at t: not((((1 + frm_cnt) mod WORDS_IN_FRAME) = 0));
	 at t: data_word_sync;
prove:
	 at t+1: SYNC_6;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = false;
end property;

property SYNC_6_read_22 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: SYNC_6;
	 at t: data_word_sync;
	 at t: not((frm_cnt = FRM_PULSE_POS));
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
	 at t: data_word_sig_isMarker;
	 at t: (align = data_word_sig_markerAlignment);
	 at t: data_word_sync;
prove:
	 at t+1: SYNC_6;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = false;
end property;

property SYNC_6_read_23 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: SYNC_6;
	 at t: data_word_sync;
	 at t: (frm_cnt = FRM_PULSE_POS);
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
	 at t: not((data_word_sig_isMarker and (align = data_word_sig_markerAlignment)));
	 at t: data_word_sync;
prove:
	 at t+1: MISS_2;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frame_pulse_sig = true;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = true;
end property;

property SYNC_6_read_24 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: SYNC_6;
	 at t: data_word_sync;
	 at t: (frm_cnt = FRM_PULSE_POS);
	 at t: not((((1 + frm_cnt) mod WORDS_IN_FRAME) = 0));
	 at t: data_word_sync;
prove:
	 at t+1: SYNC_6;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frame_pulse_sig = true;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = true;
end property;

property SYNC_6_read_25 is
dependencies: no_reset;
freeze:
	FRM_PULSE_POS_at_t = FRM_PULSE_POS@t,
	WORDS_IN_FRAME_at_t = WORDS_IN_FRAME@t,
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume: 
	 at t: SYNC_6;
	 at t: data_word_sync;
	 at t: (frm_cnt = FRM_PULSE_POS);
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
	 at t: data_word_sig_isMarker;
	 at t: (align = data_word_sig_markerAlignment);
	 at t: data_word_sync;
prove:
	 at t+1: SYNC_6;
	 at t+1: FRM_PULSE_POS = FRM_PULSE_POS_at_t;
	 at t+1: WORDS_IN_FRAME = WORDS_IN_FRAME_at_t;
	 at t+1: align = align_at_t;
	 at t+1: frame_pulse_sig = true;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME_at_t);
	 at t+1: oof_sig = oof_sig_at_t;
	 at t+1: frame_pulse_notify = true;
end property;