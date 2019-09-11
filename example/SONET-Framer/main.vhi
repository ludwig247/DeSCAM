
/*Constraints*/

constraint no_reset :=
  not reset_dp;
end constraint;



/*Assertions*/
assertion data_out_assertion :=
dependencies: no_reset;
  if (prev(reset_dp)=0) then
    data_out = alignedData(curr_align);
  else
    data_out = 0;
  end if;
end assertion;

assertion cnt_assertion :=
  if (reset_dp or prev(reset_dp)) then
    frm_out = 0;
  elsif (prev(oof_map/reset_frm_out)) then
    frm_out = 1;
  else
    cycle(frm_out)  = (prev(cycle(frm_out)) + 1) rem (max_cycle(sdh_rate)+1) and
    (column(frm_out) = if cycle(frm_out) /= 0 then prev(column(frm_out)); else (prev(column(frm_out))+1) rem 270; end if) and
    row(frm_out) = if cycle(frm_out) /= 0 or column(frm_out) /= 0 then prev(row(frm_out)); else (prev(row(frm_out))+1) rem 9; end if;
  end if;
end assertion;


/*Datapath variables*/
macro expect_at : unsigned := oof_map/expect_at; end macro;
macro curr_align : unsigned := oof_map/curr_align; end macro;
macro last_alignfound : unsigned := oof_map/last_alignfound; end macro;
macro miss_cnt : unsigned := oof_map/miss_cnt; end macro;


/*Conceptual STATES*/

macro FRAMESEARCH_S : boolean :=
  oof_map/mode = FRAMESEARCH;
end macro;

macro PROVESYNC_S : boolean :=
  oof_map/mode = PROVE_SYNC and
  frm_out = expect_at and
  oof_map/reset_frm_out = 0;
end macro;

macro PROVESYNC_TMP_S : boolean :=
  oof_map/mode = PROVE_SYNC and
  (frm_out /= expect_at or oof_map/reset_frm_out);
end macro;

macro SYNC_S : boolean :=
  oof_map/mode = SYNC and
  frm_out = expect_at and
  oof_map/reset_frm_out = 0 and
  expect_at = 0 and
  frm_out = 0 and
  last_alignfound = curr_align;
end macro;

macro SYNC_TMP_S : boolean :=
  oof_map/mode = SYNC and
  (frm_out /= expect_at or oof_map/reset_frm_out) and
  expect_at = 0 and
  last_alignfound = curr_align;
end macro;





/*input macros*/
macro alignfound_input_macro : numeric :=

  if (prev(reset_dp)) then
    -1;

  elsif (prev(reset_dp,2)) then --can be found in prev (but ignore earlier)
    search_substr(prev(dataInMuxed), c_framemarker, dp_sdh_msb(sdh_rate), 0);

  else --(prev(reset_dp,3)) then --can be found in prev & prevprev (but ignore earlier)
    search_substr((prev(dataInMuxed,2) & prev(dataInMuxed)), c_framemarker, dp_sdh_msb(sdh_rate)+31, 0);
/*
  elsif (prev(reset_dp,4)) then --can be found in prev & prevprev & prevprevprev (but ignore earlier)
    search_substr((prev(dataInMuxed,3) & prev(dataInMuxed,2) & prev(dataInMuxed)), c_framemarker, needed_frm_buffersize(sdh_rate) - 1, 0);

  else
    search_substr((prev(dataInMuxed,4) & prev(dataInMuxed,3) & prev(dataInMuxed,2) & prev(dataInMuxed)), c_framemarker, needed_frm_buffersize(sdh_rate) - 1, 0);
*/
  end if;

end macro;

macro markerfound_input_macro : bit :=
  if (alignfound_input_macro < 0) then
    0;
  else
    1;
  end if;
end macro;






/*helper macros*/

macro cycle (cnt : unsigned) : unsigned :=
  cnt(frm_sdh_msb(sdh_rate)-13 downto 0);
end macro;

macro column (cnt : unsigned) : unsigned :=
  cnt(frm_sdh_msb(sdh_rate)-4 downto frm_sdh_msb(sdh_rate)-12);
end macro;

macro row (cnt : unsigned) : unsigned :=
  cnt(frm_sdh_msb(sdh_rate) downto frm_sdh_msb(sdh_rate)-3);
end macro;



macro dataMuxed(i : numeric) : unsigned :=
  if select_master(i) then
    data_master(((i+1)*8)-1 downto i*8);
  else
    data_in(((i+1)*8)-1 downto i*8);
  end if;
end macro;

macro dataInMuxed : unsigned :=
  if statically ( sdh_rate = sdh_rate_is(stm256_8)) then
    dataMuxed(31)&dataMuxed(30)&dataMuxed(29)&dataMuxed(28)&
    dataMuxed(27)&dataMuxed(26)&dataMuxed(25)&dataMuxed(24)&
    dataMuxed(23)&dataMuxed(22)&dataMuxed(21)&dataMuxed(20)&
    dataMuxed(19)&dataMuxed(18)&dataMuxed(17)&dataMuxed(16)&
    dataMuxed(15)&dataMuxed(14)&dataMuxed(13)&dataMuxed(12)&
    dataMuxed(11)&dataMuxed(10)&dataMuxed(9)&dataMuxed(8)&
    dataMuxed(7)&dataMuxed(6)&dataMuxed(5)&dataMuxed(4)&
    dataMuxed(3)&dataMuxed(2)&dataMuxed(1)&dataMuxed(0); 
  else --stm64_4
    dataMuxed(15)&dataMuxed(14)&dataMuxed(13)&dataMuxed(12)&
    dataMuxed(11)&dataMuxed(10)&dataMuxed(9)&dataMuxed(8)&
    dataMuxed(7)&dataMuxed(6)&dataMuxed(5)&dataMuxed(4)&
    dataMuxed(3)&dataMuxed(2)&dataMuxed(1)&dataMuxed(0);
  end if;
end macro;


macro search_substr(bitString: bit_vector; findWhat: bit_vector; highest, lowest: numeric): numeric :=
#assert highest >= lowest;
#assert lowest >= 0;
#assert highest - findWhat'LENGTH >= 0;

  if findWhat = bitString(highest downto highest - (findWhat'LENGTH - 1)) then
    highest - (findWhat'LENGTH - 1);

  else
    if statically (highest-lowest = findWhat'LENGTH) then
      if findWhat = bitString(findWhat'LENGTH - 1 downto 0) then
        0;
      else
        -1;
      end if;
    else
      search_substr(bitString, findWhat, highest-1, lowest);
    end if;
  end if;
end macro;




/*Operations*/

property reset is
dependencies: no_reset;
assume: reset_sequence;
prove:
  at t: data_out = 0;
  at t: frm_out = 0;
  at t+1: frm_out = 1;
  at t: frm_out_pulse = 0;
  at t: e_lof_pulse = 0;
  at t: sdh_oof = 1;

  at t: curr_align = 0;
  at t: FRAMESEARCH_S;

right_hook: t;
end property;



property framesearch_wait is
dependencies: no_reset, data_out_assertion, cnt_assertion;
assume:
  at t: FRAMESEARCH_S;
  at t: not markerfound_input_macro;
prove:

  at t+1: cycle(next(frm_out))  = (cycle(frm_out) + 1) rem (max_cycle(sdh_rate)+1);
  at t+1: column(next(frm_out)) = if cycle(next(frm_out)) /= 0 then column(frm_out); else (column(frm_out)+1) rem 270; end if;
  at t+1: row(next(frm_out)) = if cycle(next(frm_out)) /= 0 or column(next(frm_out)) /= 0 then row(frm_out); else (row(frm_out)+1) rem 9; end if;

  at t+1: frm_out_pulse = if row(frm_out)=8 and column(frm_out)=269 and cycle(frm_out)=max_cycle(sdh_rate) then 1; else 0; end if;
  at t+1: e_lof_pulse = if row(frm_out)=0 and column(frm_out)=3 and cycle(frm_out)=0 then 1; else 0; end if;

  at t+1:  sdh_oof = 1;

  at t+1: data_out = alignedData(curr_align);

  at t+1: curr_align = prev(curr_align);
  at t+1: FRAMESEARCH_S;

left_hook:  t;
right_hook: t+1;
end property;


property framesearch_found_nonffrmmo is
dependencies: no_reset, data_out_assertion, cnt_assertion;
assume:
  at t: FRAMESEARCH_S;
  at t: not ffrmmo;
  at t: markerfound_input_macro;
prove:

  at t+1: cycle(next(frm_out))  = (cycle(frm_out) + 1) rem (max_cycle(sdh_rate)+1);
  at t+1: column(next(frm_out)) = if cycle(next(frm_out)) /= 0 then column(frm_out); else (column(frm_out)+1) rem 270; end if;
  at t+1: row(next(frm_out)) = if cycle(next(frm_out)) /= 0 or column(next(frm_out)) /= 0 then row(frm_out); else (row(frm_out)+1) rem 9; end if;

  at t+1: frm_out_pulse = if row(frm_out)=8 and column(frm_out)=269 and cycle(frm_out)=max_cycle(sdh_rate) then 1; else 0; end if;
  at t+1: e_lof_pulse = if row(frm_out)=0 and column(frm_out)=3 and cycle(frm_out)=0 then 1; else 0; end if;

  at t+1 :  sdh_oof = 1;

  at t+1: data_out = alignedData(curr_align);


  at t+1: expect_at = prev(frm_out);
  at t+1: last_alignfound = prev(alignfound_input_macro);
  at t+1: curr_align = prev(curr_align);

  at t+1: PROVESYNC_TMP_S;

left_hook:  t;
right_hook: t+1;
end property;


property framesearch_found_ffrmmo is
dependencies: no_reset, data_out_assertion;
assume:
  at t: FRAMESEARCH_S;
  at t: ffrmmo;
  at t: markerfound_input_macro;
prove:

  at t+1 : next(frm_out) = 1;
  at t+1: frm_out_pulse = if row(frm_out)=8 and column(frm_out)=269 and cycle(frm_out)=max_cycle(sdh_rate) then 1; else 0; end if;
  at t+1: e_lof_pulse = if row(frm_out)=0 and column(frm_out)=3 and cycle(frm_out)=0 then 1; else 0; end if;

  at t+1 :  sdh_oof = 1;

  at t+1: data_out = alignedData(curr_align);

  at t+1: expect_at = 0;
  at t+1: last_alignfound = prev(alignfound_input_macro);
  at t+1: curr_align = last_alignfound;

  at t+1: PROVESYNC_TMP_S;

left_hook:  t;
right_hook: t+1;
end property;


property incr_provesync_tmp is
dependencies: no_reset, data_out_assertion, cnt_assertion;
assume:
  at t: PROVESYNC_TMP_S;
  at t: next(frm_out) /= expect_at;
prove:

  at t+1: cycle(next(frm_out))  = (cycle(frm_out) + 1) rem (max_cycle(sdh_rate)+1);
  at t+1: column(next(frm_out)) = if cycle(next(frm_out)) /= 0 then column(frm_out); else (column(frm_out)+1) rem 270; end if;
  at t+1: row(next(frm_out)) = if cycle(next(frm_out)) /= 0 or column(next(frm_out)) /= 0 then row(frm_out); else (row(frm_out)+1) rem 9; end if;

  at t+1: frm_out_pulse = if row(frm_out)=8 and column(frm_out)=269 and cycle(frm_out)=max_cycle(sdh_rate) then 1; else 0; end if;
  at t+1: e_lof_pulse = if row(frm_out)=0 and column(frm_out)=3 and cycle(frm_out)=0 then 1; else 0; end if;

  at t+1 :  sdh_oof = 1;

  at t+1: data_out = alignedData(curr_align);

  at t+1: expect_at = prev(expect_at);
  at t+1: last_alignfound = prev(last_alignfound);
  at t+1: curr_align = prev(curr_align);

  at t+1: PROVESYNC_TMP_S;

left_hook:  t;
right_hook: t+1;
end property;


property to_provesync is
dependencies: no_reset, data_out_assertion, cnt_assertion;
assume:
  at t: PROVESYNC_TMP_S;
  at t: next(frm_out) = expect_at;
prove:

  at t+1: cycle(next(frm_out))  = (cycle(frm_out) + 1) rem (max_cycle(sdh_rate)+1);
  at t+1: column(next(frm_out)) = if cycle(next(frm_out)) /= 0 then column(frm_out); else (column(frm_out)+1) rem 270; end if;
  at t+1: row(next(frm_out)) = if cycle(next(frm_out)) /= 0 or column(next(frm_out)) /= 0 then row(frm_out); else (row(frm_out)+1) rem 9; end if;

  at t+1: frm_out_pulse = if row(frm_out)=8 and column(frm_out)=269 and cycle(frm_out)=max_cycle(sdh_rate) then 1; else 0; end if;
  at t+1: e_lof_pulse = if row(frm_out)=0 and column(frm_out)=3 and cycle(frm_out)=0 then 1; else 0; end if;

  at t+1 :  sdh_oof = 1;

  at t+1: data_out = alignedData(curr_align);

  at t+1: last_alignfound = prev(last_alignfound);
  at t+1: curr_align = prev(curr_align);

  at t+1: PROVESYNC_S;

left_hook:  t;
right_hook: t+1;
end property;


property provesync_miss is
dependencies: no_reset, data_out_assertion, cnt_assertion;
assume:
  at t: PROVESYNC_S;
  at t: (not markerfound_input_macro) or (alignfound_input_macro /= last_alignfound);
prove:

  at t+1: cycle(next(frm_out))  = (cycle(frm_out) + 1) rem (max_cycle(sdh_rate)+1);
  at t+1: column(next(frm_out)) = if cycle(next(frm_out)) /= 0 then column(frm_out); else (column(frm_out)+1) rem 270; end if;
  at t+1: row(next(frm_out)) = if cycle(next(frm_out)) /= 0 or column(next(frm_out)) /= 0 then row(frm_out); else (row(frm_out)+1) rem 9; end if;

  at t+1: frm_out_pulse = if row(frm_out)=8 and column(frm_out)=269 and cycle(frm_out)=max_cycle(sdh_rate) then 1; else 0; end if;
  at t+1: e_lof_pulse = if row(frm_out)=0 and column(frm_out)=3 and cycle(frm_out)=0 then 1; else 0; end if;

  at t+1 :  sdh_oof = 1;

  at t+1: data_out = alignedData(curr_align);

  at t+1: curr_align = prev(curr_align);
  at t+1: FRAMESEARCH_S;

left_hook:  t;
right_hook: t+1;
end property;

property provesync_hit is
dependencies: no_reset, data_out_assertion;
assume:
  at t: PROVESYNC_S;
  at t: markerfound_input_macro and (alignfound_input_macro = last_alignfound);
prove:

  at t+1: next(frm_out) = 1;

  at t+1: frm_out_pulse = if row(frm_out)=8 and column(frm_out)=269 and cycle(frm_out)=max_cycle(sdh_rate) then 1; else 0; end if;
  at t+1: e_lof_pulse = if row(frm_out)=0 and column(frm_out)=3 and cycle(frm_out)=0 then 1; else 0; end if;

  at t+1 :  sdh_oof = 0;

  at t+1: data_out = alignedData(curr_align);

  at t+1: curr_align = prev(last_alignfound);
  at t+1: miss_cnt = 0;
  at t+1: SYNC_TMP_S;

left_hook:  t;
right_hook: t+1;
end property;


property incr_sync_tmp is
dependencies: no_reset, data_out_assertion, cnt_assertion;
assume:
  at t: SYNC_TMP_S;
  at t: next(frm_out) /= expect_at;
prove:

  at t+1: cycle(next(frm_out))  = (cycle(frm_out) + 1) rem (max_cycle(sdh_rate)+1);
  at t+1: column(next(frm_out)) = if cycle(next(frm_out)) /= 0 then column(frm_out); else (column(frm_out)+1) rem 270; end if;
  at t+1: row(next(frm_out)) = if cycle(next(frm_out)) /= 0 or column(next(frm_out)) /= 0 then row(frm_out); else (row(frm_out)+1) rem 9; end if;

  at t+1: frm_out_pulse = if row(frm_out)=8 and column(frm_out)=269 and cycle(frm_out)=max_cycle(sdh_rate) then 1; else 0; end if;
  at t+1: e_lof_pulse = if row(frm_out)=0 and column(frm_out)=3 and cycle(frm_out)=0 then 1; else 0; end if;

  at t+1 :  sdh_oof = 0;

  at t+1: data_out = alignedData(curr_align);

  at t+1: curr_align = prev(curr_align);
  at t+1: miss_cnt = prev(miss_cnt);
  at t+1: SYNC_TMP_S;

left_hook:  t;
right_hook: t+1;
end property;

property to_sync is
dependencies: no_reset, data_out_assertion, cnt_assertion;
assume:
  at t: SYNC_TMP_S;
  at t: next(frm_out) = expect_at;
prove:

  at t+1: cycle(next(frm_out))  = (cycle(frm_out) + 1) rem (max_cycle(sdh_rate)+1);
  at t+1: column(next(frm_out)) = if cycle(next(frm_out)) /= 0 then column(frm_out); else (column(frm_out)+1) rem 270; end if;
  at t+1: row(next(frm_out)) = if cycle(next(frm_out)) /= 0 or column(next(frm_out)) /= 0 then row(frm_out); else (row(frm_out)+1) rem 9; end if;

  at t+1: frm_out_pulse = if row(frm_out)=8 and column(frm_out)=269 and cycle(frm_out)=max_cycle(sdh_rate) then 1; else 0; end if;
  at t+1: e_lof_pulse = if row(frm_out)=0 and column(frm_out)=3 and cycle(frm_out)=0 then 1; else 0; end if;

  at t+1 :  sdh_oof = 0;

  at t+1: data_out = alignedData(curr_align);

  at t+1: curr_align = prev(curr_align);
  at t+1: miss_cnt = prev(miss_cnt);
  at t+1: SYNC_S;

left_hook:  t;
right_hook: t+1;
end property;

property sync_hit is
dependencies: no_reset, data_out_assertion, cnt_assertion;
assume:
  at t: SYNC_S;
  at t: markerfound_input_macro and (alignfound_input_macro = last_alignfound);
prove:

at t+1: next(frm_out) = 2;
at t+1: frm_out_pulse = if row(frm_out)=8 and column(frm_out)=269 and cycle(frm_out)=max_cycle(sdh_rate) then 1; else 0; end if;
at t+1: e_lof_pulse = if row(frm_out)=0 and column(frm_out)=3 and cycle(frm_out)=0 then 1; else 0; end if;
at t+1 :  sdh_oof = 0;
at t+1: data_out = alignedData(curr_align);

at t+1: curr_align = prev(curr_align);
at t+1: miss_cnt = 0;
at t+1: SYNC_TMP_S;

left_hook:  t;
right_hook: t+1;
end property;

property sync_miss is
dependencies: no_reset, data_out_assertion, cnt_assertion;
assume:
  at t: SYNC_S;
  at t: miss_cnt < 4;
  at t: (not markerfound_input_macro) or (alignfound_input_macro /= last_alignfound);
prove:

  at t+1: next(frm_out) = 2;

  at t+1: frm_out_pulse = if row(frm_out)=8 and column(frm_out)=269 and cycle(frm_out)=max_cycle(sdh_rate) then 1; else 0; end if;
  at t+1: e_lof_pulse = if row(frm_out)=0 and column(frm_out)=3 and cycle(frm_out)=0 then 1; else 0; end if;

  at t+1 :  sdh_oof = 0;

  at t+1: data_out = alignedData(curr_align);

  at t+1: curr_align = prev(curr_align);
  at t+1: miss_cnt = prev(miss_cnt) + 1;
  at t+1: SYNC_TMP_S;

left_hook:  t;
right_hook: t+1;
end property;


property sync_lost is
dependencies: no_reset, data_out_assertion;
assume:
  at t: SYNC_S;
  at t: miss_cnt = 4;
  at t: (not markerfound_input_macro) or (alignfound_input_macro /= last_alignfound);
prove:

  at t+1: next(frm_out) = 2;

  at t+1: frm_out_pulse = if row(frm_out)=8 and column(frm_out)=269 and cycle(frm_out)=max_cycle(sdh_rate) then 1; else 0; end if;
  at t+1: e_lof_pulse = if row(frm_out)=0 and column(frm_out)=3 and cycle(frm_out)=0 then 1; else 0; end if;

  at t+1 :  sdh_oof = 1;

  at t+1: data_out = alignedData(curr_align);

  at t+1: curr_align = prev(curr_align);
  at t+1: FRAMESEARCH_S;

left_hook:  t;
right_hook: t+1;
end property;

