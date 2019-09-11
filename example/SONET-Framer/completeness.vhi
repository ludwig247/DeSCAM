

completeness myOSA is

inputs: 
    reset_dp,
    data_in,
    data_master,
    select_master,
    ffrmmo; --internal mode, set through uP interface

determination_requirements:

    determined(data_out);
    determined(frm_out);
    determined(frm_out_pulse);
    determined(e_lof_pulse);   
    determined(sdh_oof);


--datapath variables
  determined(curr_align);

  if (PROVESYNC_S or PROVESYNC_TMP_S) then
    determined(last_alignfound); --only needed in PROVESYNC_S and PROVESYNC_TMP_S
  end if;
    

  if (PROVESYNC_TMP_S) then
    determined(expect_at); --only needed in PROVESYNC_TMP_S
  end if;

  if (SYNC_S or SYNC_TMP_S) then
    determined(miss_cnt); --actually just needed in SYNC_S and SYNC_TMP_S
  end if;

reset_property: reset;

property_graph:
toF   := reset, framesearch_wait, provesync_miss, sync_lost;
fromF := framesearch_wait, framesearch_found_nonffrmmo, framesearch_found_ffrmmo;

toPtmp   := framesearch_found_nonffrmmo, framesearch_found_ffrmmo, incr_provesync_tmp;
fromPtmp := incr_provesync_tmp, to_provesync;

toP   := to_provesync;
fromP := provesync_miss, provesync_hit;

toStmp   := provesync_hit, incr_sync_tmp, sync_hit, sync_miss;
fromStmp := incr_sync_tmp, to_sync;

toS   := to_sync;
fromS := sync_hit, sync_miss, sync_lost;

toF -> fromF;
toPtmp -> fromPtmp;
toP -> fromP;
toStmp -> fromStmp;
toS -> fromS;

end completeness;
