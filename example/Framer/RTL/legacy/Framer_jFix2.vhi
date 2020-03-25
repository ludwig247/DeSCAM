--Version without handshake for data_word, instead one data_word per clock cycle. This is possible when all properties are done in a single cycle.
--missCnt is optimized (determined only when needed, i.e., determined in MISS)

--TODO:
-- +  1-cycle communication (synchronized on every clock edge, and sharing clock with comm.partner)
-- +  parallelization of communication. Do an analyzis of which messages can be sent / read in parallel
-- +  Wait operations must be of length 1, while the length of other operations is t+1 which is freely chosen, current property generation sets both to t+1
-- +  Too many freeze variables are created
-- +  would be nice if #defines / consts were not replaced, the symbolic values, e.g., WORDS_IN_FRAME and FRM_PULSE_POS was left symbolic in the property file
-- +  if we want a psudo-lang, I suggest removing the entire section and us @t directly
-- +  analyzes for minimal determination: For example, missCnt is only used in state MISS, and does therefore only need to be determined there. Since all (non-loop) operations ending in MISS sets missCnt to a constant it is enough to prove the value for all operations ending in MISS (also the loop operations)
--    must be proven at t+1 for SYNC_read_20, and at t+1 for all MISS_* operations


--here, the data_word will be implemented as a 1-cycle no-wait port... a data word is sent in each cycle
-- --> this module must use the clock of the data word (or a faster one? and then check?):
--        Solution: the data_word is implemented as a nb_read, the questions that remains what happens in case sync is low ? Sync macro may be set to true or designer has to provide some special properties?
-- --> must read data_word in every cycle... hmm too strict. Instead, all operations must be 1 cycle long.
--       This ensures that message are only lost if they are ignorable. However, at the abstract level a message must then be read and thrown away, we can replace that now by reading only when needed... it continues on its own..
--       It boils down to simply reading the signal when needed.. just like for shareds, however, we cannot model it at the abstract level using a shared since we need the events and the synchronization there.


--DEFINES
macro rst: boolean:= not(framer_comp/reset_n) end macro;
macro WORDS_IN_FRAME : integer := 64 end macro;
macro FRM_PULSE_POS : integer := 0 end macro;
macro max_miss_uP_sig : integer := 1 end macro;

-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro frame_pulse_notify :  boolean  := next(framer_comp/frame_pulse,2) end macro;

-- DP SIGNALS --
macro FRAMEMARK_C : unsigned :=
  framer_comp/FRAMEMARK_C;
end macro;


macro data_word_isMarker_sig : boolean :=
  (MarkerPosition /= 8);
end macro;

macro data_word_markerAlignment_sig : unsigned :=
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


macro lof_sig : boolean := framer_comp/lof end macro;
macro oof_sig : boolean := not next(framer_comp/synchronized,2) end macro;


--CONSTRAINTS--
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro align : unsigned := next(framer_comp/prev_alignment,2); end macro;
--macro frm_cnt : unsigned := next(framer_comp/frame_cnt_int,2)  end macro;

macro frm_cnt : unsigned :=

if    (  next(framer_comp/frame_cnt_int,2) = 0 ) then 61;
elsif (  next(framer_comp/frame_cnt_int,2) = 1 ) then 62;
elsif (  next(framer_comp/frame_cnt_int,2) = 2 ) then 63;
elsif (  next(framer_comp/frame_cnt_int,2) = 3 ) then 0;
else
  unsigned( next(framer_comp/frame_cnt_int,2) - 3 );
end if;

end macro;


--macro frm_cnt : unsigned := if (framer_comp/frame_cnt_int=0) then unsigned(WORDS_IN_FRAME-2); elsif (framer_comp/frame_cnt_int=1) then unsigned(WORDS_IN_FRAME-1); else unsigned(framer_comp/frame_cnt_int-2); end if; end macro;
macro missCnt : unsigned := 1  end macro; -- not used in our implementation, trivial 1

-- HELPERS
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

-- STATES --
macro SEARCH : boolean :=
  next(framer_comp/prev_miss,2) and not next(synchronized,2) and
  if prev(MarkerIn) and not (prev(reset_n)=0) then
    prev(MarkerPosition) /= prev(Align);
  end if and
  if prev(reset_n,2)=0 then
    framer_comp/data_buffer(22 downto 8) = 0
  end if;
end macro;

macro FIND_SYNC: boolean :=
  not next(framer_comp/prev_miss,2) and not next(synchronized) and
  not next(synchronized) and
  not next(framer_comp/prev_miss,2) and
  (not next(framer_comp/sync_hit) or not next(synchronized,2));
end macro;

macro SYNC : boolean :=
  not next(framer_comp/prev_miss,2) and next(synchronized,2);
end macro;

macro MISS : boolean :=
  next(framer_comp/prev_miss,2) and synchronized and next(synchronized,2);

end macro;

--Operations --

--TODO: in general, also the reset actually need the no_reset constraint (to ensure that reset only happens when assumed and not also later)
property reset is
dependencies: no_reset;
assume:
	 reset_sequence;
prove:
	 at t: SEARCH;
	 at t: align = 0;
	 at t: frm_cnt = 63; --in original it is set to 0, a small missmatch, but doesnt really change any "real" functionality since after reset  we do not not where we are anyways
	 at t: oof_sig = true;
	 at t: frame_pulse_notify = false;
end property;

property SEARCH_hit is
dependencies: no_reset;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	data_word_sig_markerAlignment_at_t = data_word_markerAlignment_sig@t;
assume:
	 at t: SEARCH;
	 at t: data_word_isMarker_sig;
prove:
	 at t+1: FIND_SYNC;
	 at t+1: align = data_word_sig_markerAlignment_at_t;
	 at t+1: frm_cnt = 0;
	 at t+1: frame_pulse_notify = (frm_cnt_at_t = FRM_PULSE_POS); ---ORIG IS FALSE, change in ESL
end property;

property SEARCH_miss is
dependencies: no_reset;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume:
	 at t: SEARCH;
	 at t: not(data_word_isMarker_sig);
prove:
	 at t+1: SEARCH;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME);
	 at t+1: frame_pulse_notify = (frm_cnt_at_t = FRM_PULSE_POS);
end property;


property FIND_SYNC_wait is
dependencies: no_reset;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume:
	 at t: FIND_SYNC;
	 at t: not( ((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
prove:
	 at t+1: FIND_SYNC;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME);
	 at t+1: frame_pulse_notify = (frm_cnt_at_t = FRM_PULSE_POS);
end property;

property FIND_SYNC_miss is
dependencies: no_reset;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume:
	 at t: FIND_SYNC;
	 at t: not((data_word_isMarker_sig and (align = data_word_markerAlignment_sig)));
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
prove:
	 at t+1: SEARCH;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME);
	 at t+1: frame_pulse_notify = (frm_cnt_at_t = FRM_PULSE_POS);
end property;

property FIND_SYNC_hit is
dependencies: no_reset;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	 at t: FIND_SYNC;
	 at t: data_word_isMarker_sig;
	 at t: (align = data_word_markerAlignment_sig);
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
prove:
	 at t+1: SYNC;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME);
	 at t+1: oof_sig = false;
	 at t+1: frame_pulse_notify = (frm_cnt_at_t = FRM_PULSE_POS);
end property;

property SYNC_wait is
dependencies: no_reset;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume:
	 at t: SYNC;
	 at t: not( ((1 + frm_cnt) mod WORDS_IN_FRAME) = 0 );
prove:
	 at t+1: SYNC;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME);
	 at t+1: frame_pulse_notify = (frm_cnt_at_t = FRM_PULSE_POS);
end property;

property SYNC_miss is
dependencies: no_reset;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume:
	 at t: SYNC;
	 at t: not((data_word_isMarker_sig and (align = data_word_markerAlignment_sig)));
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
prove:
	 at t+1: MISS;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME);
	 at t+1: missCnt = 1;
	 at t+1: frame_pulse_notify = (frm_cnt_at_t = FRM_PULSE_POS);
end property;

property SYNC_hit is
dependencies: no_reset;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume:
	 at t: SYNC;
	 at t: data_word_isMarker_sig;
	 at t: (align = data_word_markerAlignment_sig);
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
prove:
	 at t+1: SYNC;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME);
	 at t+1: frame_pulse_notify = (frm_cnt_at_t = FRM_PULSE_POS);
end property;

property MISS_wait is
dependencies: no_reset;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: MISS;
	 at t: not( ((1 + frm_cnt) mod WORDS_IN_FRAME) = 0 );
prove:
	 at t+1: MISS;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME);
	 at t+1: missCnt = missCnt_at_t;
	 at t+1: frame_pulse_notify = (frm_cnt_at_t = FRM_PULSE_POS);
end property;

property MISS_incrementMissCnt is
dependencies: no_reset;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	missCnt_at_t = missCnt@t;
assume:
	 at t: MISS;
	 at t: not((data_word_isMarker_sig and (align = data_word_markerAlignment_sig)));
	 at t: not((missCnt >= max_miss_uP_sig));
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
prove:
	 at t+1: MISS;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME);
	 at t+1: missCnt = (1 + missCnt_at_t);
	 at t+1: frame_pulse_notify = (frm_cnt_at_t = FRM_PULSE_POS);
end property;


property MISS_lostSync is
dependencies: no_reset;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t,
	oof_sig_at_t = oof_sig@t;
assume:
	 at t: MISS;
	 at t: not((data_word_isMarker_sig and (align = data_word_markerAlignment_sig)));
	 at t: (missCnt >= max_miss_uP_sig);
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
prove:
	 at t+1: SEARCH;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME);
	 at t+1: oof_sig = true;
	 at t+1: frame_pulse_notify = (frm_cnt_at_t = FRM_PULSE_POS);
end property;

property MISS_hit is
dependencies: no_reset;
freeze:
	align_at_t = align@t,
	frm_cnt_at_t = frm_cnt@t;
assume:
	 at t: MISS;
	 at t: data_word_isMarker_sig;
	 at t: (align = data_word_markerAlignment_sig);
	 at t: (((1 + frm_cnt) mod WORDS_IN_FRAME) = 0);
prove:
	 at t+1: SYNC;
	 at t+1: align = align_at_t;
	 at t+1: frm_cnt = ((1 + frm_cnt_at_t) mod WORDS_IN_FRAME);
	 at t+1: frame_pulse_notify = (frm_cnt_at_t = FRM_PULSE_POS);
end property;
