property reset is
assume:
	 reset_sequence;
prove:
	 at t: idle_1;
	 --at t: fromMaster = resize(4294967295,32);
	 at t: master0_in_notify = false;
	 at t: master0_out_notify = false;
	 at t: master1_in_notify = false;
	 at t: master1_out_notify = false;
	 at t: master2_in_notify = false;
	 at t: master2_out_notify = false;
	 at t: master3_in_notify = false;
	 at t: master3_out_notify = false;
	 at t: slave0_in_notify = false;
	 at t: slave0_out_notify = false;
	 at t: not(slave_in0_notify);
	 at t: not(slave_in1_notify);
	 at t: not(slave_in2_notify);

	 at t: not(slave_out0_notify);
	 at t: not(slave_out1_notify);
	 at t: not(slave_out2_notify);
end property;


/*
master3_to_slave0_simple is one of the properties generated from the sequential model. 
It describes a transmission (read+write) from master 3 to slave 0. 
*/

property master3_to_slave0_simple is
dependencies: no_reset, no_split_retry,slave0,master_3,only_slave_0;
for timepoints:
	t_cs_1 = t,
	t_master3_in_2 = t+1,
	t_master3_in_2_wait = t_master3_in_2,
	t_slave0_out_3 = t_master3_in_2_wait+3,
	t_slave0_out_3_wait = t_slave0_out_3+0 .. max_wait waits_for complete slave_out0_sync,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+0 .. max_wait waits_for complete slave_in0_sync,
	t_master3_out_5 = t_slave0_in_4_wait+3,
	t_master3_out_5_wait = t_master3_out_5+0 .. max_wait  waits_for complete master3_out_sync,
	t_end = t_master3_out_5_wait+1;
freeze:
--	fromMaster_at_t_master3_in_2_wait = fromMaster@t_master3_in_2_wait,
--	fromMaster_at_t_slave0_out_3 = fromMaster@t_slave0_out_3,
--	fromMaster_at_t_slave0_in_4_wait = fromMaster@t_slave0_in_4_wait,
--	fromMaster_at_t_master3_out_5 = fromMaster@t_master3_out_5;
	master3_in_sig_haddr_at_t_master3_in_2_wait = master3_in_sig_haddr@t_master3_in_2_wait,
	master3_in_sig_hsize_at_t_master3_in_2_wait = master3_in_sig_hsize@t_master3_in_2_wait,
	master3_in_sig_hwdata_at_t_master3_in_2_wait = master3_in_sig_hwdata@t_master3_in_2_wait,
	master3_in_sig_hwrite_at_t_master3_in_2_wait = master3_in_sig_hwrite@t_master3_in_2_wait,

	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait;

assume:

	at t_cs_1: idle_1;
	at t_cs_1: master3_in_sync;
	--at t_master3_in_2: master3_in_sync; 
	--at t_slave0_out_3: slave0_out_sync;
	--at t_slave0_in_4: slave0_in_sync;
	--at t_slave0_in_4: (fromMaster = resize(3,32));
	--at t_master3_out_5: master3_out_sync;
prove:
	--at t_slave0_out_3: fromMaster = fromMaster_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_haddr = master3_in_sig_haddr_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master3_in_sig_hsize_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master3_in_sig_hwdata_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master3_in_sig_hwrite_at_t_master3_in_2_wait;
	--at t_slave0_in_4: fromMaster = fromMaster_at_t_slave0_out_3;
	--at t_master3_out_5: fromMaster = fromMaster_at_t_slave0_in_4_wait;
	at t_master3_out_5: master3_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master3_out_5: master3_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;
	--at t_end: fromMaster = fromMaster_at_t_master3_out_5;
	
	--NOTIFY--- (Manual for now) 
	at t: not(master3_in_notify); --Idea add a wait state? 
	at t+1: master3_in_notify;
	during[t+2,t_end-1]: not(master3_in_notify);
	
	during[t+2,t_slave0_out_3]: not(master3_in_notify) ;

	during[t,t_slave0_out_3-1]: not(slave0_out_notify);
	during[t_slave0_out_3,t_slave0_out_3_wait]: (slave0_out_notify);

	during[t,t_slave0_in_4-1]: not(slave0_in_notify);
	during[t_slave0_in_4,t_slave0_in_4_wait]: (slave0_in_notify);
	
	during[t,t_master3_out_5-1]: not(master3_out_notify);
	during[t_master3_out_5,t_master3_out_5_wait]: (master3_out_notify);

	at t+1: not(master0_out_notify);
	at t+1: not(master1_out_notify);
	at t+1: not(master2_out_notify);
right_hook: t+1;
end property;


property master2_to_slave0_simple is
dependencies: no_reset, no_split_retry,slave0,master_2, only_slave_0;
for timepoints:
	t_cs_1 = t,
	t_master2_in_9 = t+1,
	t_master2_in_9_wait = t_master2_in_9,
	t_slave0_out_3 = t_master2_in_9_wait+3,
	t_slave0_out_3_wait = t_slave0_out_3+0 .. max_wait waits_for complete slave_out0_sync,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+0 .. max_wait waits_for complete slave_in0_sync,
	t_master2_out_6 = t_slave0_in_4_wait+3,
	t_master2_out_6_wait = t_master2_out_6+0 .. max_wait  waits_for complete master2_out_sync,
	t_end = t_master2_out_6_wait+1;
freeze:
	--fromMaster_at_t_master2_in_9_wait = fromMaster@t_master2_in_9_wait,
	master2_in_sig_haddr_at_t_master2_in_9_wait = master2_in_sig_haddr@t_master2_in_9_wait,
	master2_in_sig_hsize_at_t_master2_in_9_wait = master2_in_sig_hsize@t_master2_in_9_wait,
	master2_in_sig_hwdata_at_t_master2_in_9_wait = master2_in_sig_hwdata@t_master2_in_9_wait,
	master2_in_sig_hwrite_at_t_master2_in_9_wait = master2_in_sig_hwrite@t_master2_in_9_wait,
	--fromMaster_at_t_slave0_out_3 = fromMaster@t_slave0_out_3,
	--fromMaster_at_t_slave0_in_4_wait = fromMaster@t_slave0_in_4_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait;
	--fromMaster_at_t_master2_out_6 = fromMaster@t_master2_out_6;
assume:
	
	at t_cs_1: idle_1;
	at t_cs_1: not(master3_in_sync); 
	at t_cs_1: master2_in_sync;
	--at t_master2_in_9: master2_in_sync;
	--at t_slave0_out_3: slave0_out_sync;
	--at t_slave0_in_4: slave0_in_sync;
	--at t_slave0_in_4: (fromMaster = resize(2,32));
	--at t_master2_out_6: master2_out_sync;
prove:
	--at t_master2_in_9: fromMaster = 2;
	--at t_slave0_out_3: fromMaster = fromMaster_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_haddr = master2_in_sig_haddr_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master2_in_sig_hsize_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master2_in_sig_hwdata_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master2_in_sig_hwrite_at_t_master2_in_9_wait;
	--at t_slave0_in_4: fromMaster = fromMaster_at_t_slave0_out_3;
	--at t_master2_out_6: fromMaster = fromMaster_at_t_slave0_in_4_wait;
	at t_master2_out_6: master2_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master2_out_6: master2_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;
	--at t_end: fromMaster = fromMaster_at_t_master2_out_6;

	--NOTIFY---
	at t: not(master2_in_notify);	
	at t+1: master2_in_notify;
	at t+2: not(master2_in_notify);


	during[t,t_slave0_out_3-1]: not(slave0_out_notify);
	during[t_slave0_out_3,t_slave0_out_3_wait]: (slave0_out_notify);

	during[t,t_slave0_in_4-1]: not(slave0_in_notify);
	during[t_slave0_in_4,t_slave0_in_4_wait]: (slave0_in_notify);
	
	during[t,t_master2_out_6-1]: not(master2_out_notify);
	during[t_master2_out_6,t_master2_out_6_wait]: (master2_out_notify);

	at t+1: not(master0_out_notify);
	at t+1: not(master1_out_notify);
	at t+1: not(master3_out_notify);
right_hook: t+1;
end property;

property master1_to_slave0_simple is
dependencies: no_reset, no_split_retry, slave0,master_3,master_0,master_1,master_2,only_slave_0;
for timepoints:
	t_cs_1 = t,
	t_master1_in_10 = t+1,
	t_master1_in_10_wait = t_master1_in_10,
	t_slave0_out_3 = t_master1_in_10_wait+3,
	t_slave0_out_3_wait = t_slave0_out_3+0 .. max_wait waits_for complete slave_out0_sync,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+0 .. max_wait waits_for complete slave_in0_sync,
	t_master1_out_7 = t_slave0_in_4_wait+3,
	t_master1_out_7_wait = t_master1_out_7+0 .. max_wait  waits_for complete master1_out_sync,
	t_end = t_master1_out_7_wait+1;
freeze:
	--fromMaster_at_t_master1_in_10_wait = fromMaster@t_master1_in_10_wait,
	master1_in_sig_haddr_at_t_master1_in_10_wait = master1_in_sig_haddr@t_master1_in_10_wait,
	master1_in_sig_hsize_at_t_master1_in_10_wait = master1_in_sig_hsize@t_master1_in_10_wait,
	master1_in_sig_hwdata_at_t_master1_in_10_wait = master1_in_sig_hwdata@t_master1_in_10_wait,
	master1_in_sig_hwrite_at_t_master1_in_10_wait = master1_in_sig_hwrite@t_master1_in_10_wait,
	--fromMaster_at_t_slave0_out_3 = fromMaster@t_slave0_out_3,
	--fromMaster_at_t_slave0_in_4_wait = fromMaster@t_slave0_in_4_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait;
	--fromMaster_at_t_master1_out_7 = fromMaster@t_master1_out_7;
assume:
	at t_cs_1: idle_1;
	at t_cs_1: not(master3_in_sync);
	at t_cs_1: not(master2_in_sync);
	at t_cs_1: master1_in_sync;
	--at t_master1_in_10: master1_in_sync;
	--at t_slave0_out_3: at t_cs_1: idle_1;slave0_out_sync;
	--at t_slave0_in_4: slave0_in_sync;
	--at t_slave0_in_4: (fromMaster = resize(1,32));
	--at t_master1_out_7: master1_out_sync;
prove:
	--at t_master1_in_10: fromMaster = 1;
	--at t_slave0_out_3: fromMaster = fromMaster_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_haddr = master1_in_sig_haddr_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master1_in_sig_hsize_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master1_in_sig_hwdata_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master1_in_sig_hwrite_at_t_master1_in_10_wait;
	--at t_slave0_in_4: fromMaster = fromMaster_at_t_slave0_out_3;
	--at t_master1_out_7: fromMaster = fromMaster_at_t_slave0_in_4_wait;
	at t_master1_out_7: master1_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master1_out_7: master1_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;
	--at t_end: fromMaster = fromMaster_at_t_master1_out_7;

	--NOTIFY---
	at t: not(master1_in_notify);
	at t+1: master1_in_notify;
	at t+2: not(master1_in_notify);

	during[t,t_slave0_out_3-1]: not(slave0_out_notify);
	during[t_slave0_out_3,t_slave0_out_3_wait]: (slave0_out_notify);

	during[t,t_slave0_in_4-1]: not(slave0_in_notify);
	during[t_slave0_in_4,t_slave0_in_4_wait]: (slave0_in_notify);
	
	during[t,t_master1_out_7-1]: not(master1_out_notify);
	during[t_master1_out_7,t_master1_out_7_wait]: (master1_out_notify);
	
	at t+1: not(master0_out_notify);
	at t+1: not(master2_out_notify);
	at t+1: not(master3_out_notify);
	
right_hook: t+1;
end property;

property master0_to_slave0_simple is
dependencies: no_reset, no_split_retry, slave0,master_3,master_0,master_1,master_2, no_starvation, only_slave_0;
for timepoints:
	t_cs_1 = t,
	t_master0_in_11 = t+1,
	t_master0_in_11_wait = t_master0_in_11,
	t_slave0_out_3 = t_master0_in_11_wait+3,
	t_slave0_out_3_wait = t_slave0_out_3+0 .. max_wait waits_for complete slave_out0_sync,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+0 .. max_wait waits_for complete slave_in0_sync,
	t_master0_out_8 = t_slave0_in_4_wait+3,
	t_master0_out_8_wait = t_master0_out_8+0 .. max_wait  waits_for complete master0_out_sync,
	t_end = t_master0_out_8_wait+1;
freeze:
	--fromMaster_at_t_master0_in_11_wait = fromMaster@t_master0_in_11_wait,
	master0_in_sig_haddr_at_t_master0_in_11_wait = master0_in_sig_haddr@t_master0_in_11_wait,
	master0_in_sig_hsize_at_t_master0_in_11_wait = master0_in_sig_hsize@t_master0_in_11_wait,
	master0_in_sig_hwdata_at_t_master0_in_11_wait = master0_in_sig_hwdata@t_master0_in_11_wait,
	master0_in_sig_hwrite_at_t_master0_in_11_wait = master0_in_sig_hwrite@t_master0_in_11_wait,
	--fromMaster_at_t_slave0_out_3 = fromMaster@t_slave0_out_3,
	--fromMaster_at_t_slave0_in_4_wait = fromMaster@t_slave0_in_4_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait;
	--fromMaster_at_t_master0_out_8 = fromMaster@t_master0_out_8;
assume:
	--at t_cs_1: master_in0.haddr = 0; -- only check for slave0;
	at t_cs_1: idle_1;
	at t_cs_1: not(master3_in_sync);
	at t_cs_1: not(master2_in_sync);
	at t_cs_1: not(master1_in_sync);
	at t_cs_1: master0_in_sync;
	--at t_master0_in_11: master0_in_sync;
	--at t_slave0_out_3: slave0_out_sync;
	--at t_slave0_in_4: slave0_in_sync;
	--at t_slave0_in_4: (fromMaster = resize(0,32));
	--at t_master0_out_8: master0_out_sync;
prove:
	--at t_master0_in_11: fromMaster = 0;
	--at t_slave0_out_3: fromMaster = fromMaster_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_haddr = master0_in_sig_haddr_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master0_in_sig_hsize_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master0_in_sig_hwdata_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master0_in_sig_hwrite_at_t_master0_in_11_wait;
	--at t_slave0_in_4: fromMaster = fromMaster_at_t_slave0_out_3;
	--at t_master0_out_8: fromMaster = fromMaster_at_t_slave0_in_4_wait;
	at t_master0_out_8: master0_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master0_out_8: master0_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;
	--at t_end: fromMaster = fromMaster_at_t_master0_out_8;

	--NOTIFY---

	at t+1: (master0_in_notify);
	at t+2: not(master0_in_notify);
	

	during[t,t_slave0_out_3-1]: not(slave0_out_notify);
	during[t_slave0_out_3,t_slave0_out_3_wait]: (slave0_out_notify);

	during[t,t_slave0_in_4-1]: not(slave0_in_notify);
	during[t_slave0_in_4,t_slave0_in_4_wait]: (slave0_in_notify);
	
	during[t,t_master0_out_8-1]: not(master0_out_notify);
	during[t_master0_out_8,t_master0_out_8_wait]: (master0_out_notify);

	at t+1: not(master1_out_notify);
	at t+1: not(master2_out_notify);
	at t+1: not(master3_out_notify);
	at t+1: not(slave0_in_notify);
	at t+1: not(slave0_out_notify);

	
right_hook: t+1;
end property;

property wait is
dependencies: no_reset;
for timepoints:
	t_cs_1 = t,
	t_end = t+1;
assume:
	at t_cs_1: idle_1;
	at t_cs_1: not(master3_in_sync);
	at t_cs_1: not(master2_in_sync);
	at t_cs_1: not(master1_in_sync);
	at t_cs_1: not(master0_in_sync);
prove:
	at t_end: idle_1;

	at t+1: not(master0_in_notify);
	at t+1: not(master1_in_notify);
	at t+1: not(master2_in_notify);
	at t+1: not(master3_in_notify);	

	at t+1: not(master0_out_notify);
	at t+1: not(master1_out_notify);
	at t+1: not(master2_out_notify);
	at t+1: not(master3_out_notify);
	
	at t+1: not(slave0_in_notify);
	at t+1: not(slave0_out_notify);
	
end property;


/*
property cycle_6 is
dependencies: no_reset, no_split_retry, slave0, master_1;
for timepoints:
	t_cs_1 = t,
	t_master2_in_9 = t+1,
	t_master2_in_9_wait = t_master2_in_9+1,
	t_slave0_out_3 = t_master2_in_9_wait+1,
	t_slave0_out_3_wait = t_slave0_out_3+1,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+1,
	t_master1_out_7 = t_slave0_in_4_wait+1,
	t_master1_out_7_wait = t_master1_out_7+1,
	t_end = t_master1_out_7_wait+1;
freeze:
	fromMaster_at_t_master2_in_9_wait = fromMaster@t_master2_in_9_wait,
	master2_in_sig_haddr_at_t_master2_in_9_wait = master2_in_sig_haddr@t_master2_in_9_wait,
	master2_in_sig_hsize_at_t_master2_in_9_wait = master2_in_sig_hsize@t_master2_in_9_wait,
	master2_in_sig_hwdata_at_t_master2_in_9_wait = master2_in_sig_hwdata@t_master2_in_9_wait,
	master2_in_sig_hwrite_at_t_master2_in_9_wait = master2_in_sig_hwrite@t_master2_in_9_wait,
	fromMaster_at_t_slave0_out_3 = fromMaster@t_slave0_out_3,
	fromMaster_at_t_slave0_in_4_wait = fromMaster@t_slave0_in_4_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait,
	fromMaster_at_t_master1_out_7 = fromMaster@t_master1_out_7;
assume:
	at t_cs_1: idle_1;
	at t_cs_1: not(master3_in_sync);
	at t_cs_1: master2_in_sync;
	at t_master2_in_9: master2_in_sync;
	at t_slave0_out_3: slave0_out_sync;
	at t_slave0_in_4: slave0_in_sync;
	at t_slave0_in_4: (fromMaster = resize(1,32));
	at t_master1_out_7: master1_out_sync;
	at t: true = false;
prove:
	at t_master2_in_9: fromMaster = 2;
	at t_slave0_out_3: fromMaster = fromMaster_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_haddr = master2_in_sig_haddr_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master2_in_sig_hsize_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master2_in_sig_hwdata_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master2_in_sig_hwrite_at_t_master2_in_9_wait;
	at t_slave0_in_4: fromMaster = fromMaster_at_t_slave0_out_3;
	at t_master1_out_7: fromMaster = fromMaster_at_t_slave0_in_4_wait;
	at t_master1_out_7: master1_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master1_out_7: master1_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;
	at t_end: fromMaster = fromMaster_at_t_master1_out_7;
end property;


property cycle_7 is
dependencies: no_reset;
for timepoints:
	t_cs_1 = t,
	t_master2_in_9 = t+1,
	t_master2_in_9_wait = t_master2_in_9+1,
	t_slave0_out_3 = t_master2_in_9_wait+1,
	t_slave0_out_3_wait = t_slave0_out_3+1,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+1,
	t_master0_out_8 = t_slave0_in_4_wait+1,
	t_master0_out_8_wait = t_master0_out_8+1,
	t_end = t_master0_out_8_wait+1;
freeze:
	fromMaster_at_t_master2_in_9_wait = fromMaster@t_master2_in_9_wait,
	master2_in_sig_haddr_at_t_master2_in_9_wait = master2_in_sig_haddr@t_master2_in_9_wait,
	master2_in_sig_hsize_at_t_master2_in_9_wait = master2_in_sig_hsize@t_master2_in_9_wait,
	master2_in_sig_hwdata_at_t_master2_in_9_wait = master2_in_sig_hwdata@t_master2_in_9_wait,
	master2_in_sig_hwrite_at_t_master2_in_9_wait = master2_in_sig_hwrite@t_master2_in_9_wait,
	fromMaster_at_t_slave0_out_3 = fromMaster@t_slave0_out_3,
	fromMaster_at_t_slave0_in_4_wait = fromMaster@t_slave0_in_4_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait,
	fromMaster_at_t_master0_out_8 = fromMaster@t_master0_out_8;
assume:
	at t_cs_1: idle_1;
	at t_cs_1: not(master3_in_sync);
	at t_cs_1: master2_in_sync;
	at t_master2_in_9: master2_in_sync;
	at t_slave0_out_3: slave0_out_sync;
	at t_slave0_in_4: slave0_in_sync;
	at t_slave0_in_4: (fromMaster = resize(0,32));
	at t_master0_out_8: master0_out_sync;
	at t: true = false;
prove:
	at t_master2_in_9: fromMaster = 2;
	at t_slave0_out_3: fromMaster = fromMaster_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_haddr = master2_in_sig_haddr_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master2_in_sig_hsize_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master2_in_sig_hwdata_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master2_in_sig_hwrite_at_t_master2_in_9_wait;
	at t_slave0_in_4: fromMaster = fromMaster_at_t_slave0_out_3;
	at t_master0_out_8: fromMaster = fromMaster_at_t_slave0_in_4_wait;
	at t_master0_out_8: master0_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master0_out_8: master0_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;
	at t_end: fromMaster = fromMaster_at_t_master0_out_8;
end property;


property cycle_8 is
dependencies: no_reset, no_split_retry, slave0, master_1;
for timepoints:
	t_cs_1 = t,
	t_master1_in_10 = t+1,
	t_master1_in_10_wait = t_master1_in_10,
	t_slave0_out_3 = t_master1_in_10_wait+3,
	t_slave0_out_3_wait = t_slave0_out_3+0 .. max_wait waits_for slave_out0_sync,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+0 .. max_wait waits_for slave_in0_sync,
	t_master3_out_5 = t_slave0_in_4_wait+3,
	t_master3_out_5_wait = t_master3_out_5+0 .. max_wait  waits_for master1_out_sync,
	t_end = t_master3_out_5_wait+1;
freeze:
	fromMaster_at_t_master1_in_10_wait = fromMaster@t_master1_in_10_wait,
	master1_in_sig_haddr_at_t_master1_in_10_wait = master1_in_sig_haddr@t_master1_in_10_wait,
	master1_in_sig_hsize_at_t_master1_in_10_wait = master1_in_sig_hsize@t_master1_in_10_wait,
	master1_in_sig_hwdata_at_t_master1_in_10_wait = master1_in_sig_hwdata@t_master1_in_10_wait,
	master1_in_sig_hwrite_at_t_master1_in_10_wait = master1_in_sig_hwrite@t_master1_in_10_wait,
	fromMaster_at_t_slave0_out_3 = fromMaster@t_slave0_out_3,
	fromMaster_at_t_slave0_in_4_wait = fromMaster@t_slave0_in_4_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait,
	fromMaster_at_t_master3_out_5 = fromMaster@t_master3_out_5;
assume:
	at t_cs_1: master_in1.haddr = 0; -- only check for slave0;
	at t_cs_1: idle_1;
	at t_cs_1: not(master3_in_sync);
	at t_cs_1: not(master2_in_sync);
	at t_cs_1: master1_in_sync;
	--at t_master1_in_10: master1_in_sync;
	--at t_slave0_out_3: slave0_out_sync;
	--at t_slave0_in_4: slave0_in_sync;
	--at t_slave0_in_4: (fromMaster = resize(3,32));
	--at t_master3_out_5: master3_out_sync;
	at t: false = true;
prove:
	--at t_master1_in_10: fromMaster = 1;
	--at t_slave0_out_3: fromMaster = fromMaster_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_haddr = master1_in_sig_haddr_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master1_in_sig_hsize_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master1_in_sig_hwdata_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master1_in_sig_hwrite_at_t_master1_in_10_wait;
	--at t_slave0_in_4: fromMaster = fromMaster_at_t_slave0_out_3;
	--at t_master3_out_5: fromMaster = fromMaster_at_t_slave0_in_4_wait;
	at t_master3_out_5: master3_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master3_out_5: master3_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;
	--at t_end: fromMaster = fromMaster_at_t_master3_out_5;
end property;


property cycle_9 is
dependencies: no_reset;
for timepoints:
	t_cs_1 = t,
	t_master1_in_10 = t+1,
	t_master1_in_10_wait = t_master1_in_10+1,
	t_slave0_out_3 = t_master1_in_10_wait+1,
	t_slave0_out_3_wait = t_slave0_out_3+1,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+1,
	t_master2_out_6 = t_slave0_in_4_wait+1,
	t_master2_out_6_wait = t_master2_out_6+1,
	t_end = t_master2_out_6_wait+1;
freeze:
	fromMaster_at_t_master1_in_10_wait = fromMaster@t_master1_in_10_wait,
	master1_in_sig_haddr_at_t_master1_in_10_wait = master1_in_sig_haddr@t_master1_in_10_wait,
	master1_in_sig_hsize_at_t_master1_in_10_wait = master1_in_sig_hsize@t_master1_in_10_wait,
	master1_in_sig_hwdata_at_t_master1_in_10_wait = master1_in_sig_hwdata@t_master1_in_10_wait,
	master1_in_sig_hwrite_at_t_master1_in_10_wait = master1_in_sig_hwrite@t_master1_in_10_wait,
	fromMaster_at_t_slave0_out_3 = fromMaster@t_slave0_out_3,
	fromMaster_at_t_slave0_in_4_wait = fromMaster@t_slave0_in_4_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait,
	fromMaster_at_t_master2_out_6 = fromMaster@t_master2_out_6;
assume:
	at t_cs_1: idle_1;
	at t_cs_1: not(master3_in_sync);
	at t_cs_1: not(master2_in_sync);
	at t_cs_1: master1_in_sync;
	at t_master1_in_10: master1_in_sync;
	at t_slave0_out_3: slave0_out_sync;
	at t_slave0_in_4: slave0_in_sync;
	at t_slave0_in_4: (fromMaster = resize(2,32));
	at t_master2_out_6: master2_out_sync;
	at t: true = false;
prove:
	at t_master1_in_10: fromMaster = 1;
	at t_slave0_out_3: fromMaster = fromMaster_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_haddr = master1_in_sig_haddr_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master1_in_sig_hsize_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master1_in_sig_hwdata_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master1_in_sig_hwrite_at_t_master1_in_10_wait;
	at t_slave0_in_4: fromMaster = fromMaster_at_t_slave0_out_3;
	at t_master2_out_6: fromMaster = fromMaster_at_t_slave0_in_4_wait;
	at t_master2_out_6: master2_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master2_out_6: master2_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;
	at t_end: fromMaster = fromMaster_at_t_master2_out_6;
end property;


property wait_master0_in_11 is
dependencies: no_reset;
freeze:
	fromMaster_at_t = fromMaster@t;
assume:
	at t: master0_in_11;
	at t: not(master0_in_sync);
prove:
	at t+1: master0_in_11;
	at t+1: fromMaster = fromMaster_at_t;
	at t+1: master0_in_notify = true;
	at t+1: master0_out_notify = false;
	at t+1: master1_in_notify = false;
	at t+1: master1_out_notify = false;
	at t+1: master2_in_notify = false;
	at t+1: master2_out_notify = false;
	at t+1: master3_in_notify = false;
	at t+1: master3_out_notify = false;
	at t+1: slave0_in_notify = false;
	at t+1: slave0_out_notify = false;
end property;


property wait_master0_out_8 is
dependencies: no_reset;
freeze:
	fromMaster_at_t = fromMaster@t,
	master0_out_sig_at_t = master0_out_sig@t;
assume:
	at t: master0_out_8;
	at t: not(master0_out_sync);
prove:
	at t+1: master0_out_8;
	at t+1: fromMaster = fromMaster_at_t;
	at t+1: master0_out_sig = master0_out_sig_at_t;
	at t+1: master0_in_notify = false;
	at t+1: master0_out_notify = true;
	at t+1: master1_in_notify = false;
	at t+1: master1_out_notify = false;
	at t+1: master2_in_notify = false;
	at t+1: master2_out_notify = false;
	at t+1: master3_in_notify = false;
	at t+1: master3_out_notify = false;
	at t+1: slave0_in_notify = false;
	at t+1: slave0_out_notify = false;
end property;


property wait_master1_in_10 is
dependencies: no_reset;
freeze:
	fromMaster_at_t = fromMaster@t;
assume:
	at t: master1_in_10;
	at t: not(master1_in_sync);
prove:
	at t+1: master1_in_10;
	at t+1: fromMaster = fromMaster_at_t;
	at t+1: master0_in_notify = false;
	at t+1: master0_out_notify = false;
	at t+1: master1_in_notify = true;
	at t+1: master1_out_notify = false;
	at t+1: master2_in_notify = false;
	at t+1: master2_out_notify = false;
	at t+1: master3_in_notify = false;
	at t+1: master3_out_notify = false;
	at t+1: slave0_in_notify = false;
	at t+1: slave0_out_notify = false;
end property;


property wait_master1_out_7 is
dependencies: no_reset;
freeze:
	fromMaster_at_t = fromMaster@t,
	master1_out_sig_at_t = master1_out_sig@t;
assume:
	at t: master1_out_7;
	at t: not(master1_out_sync);
prove:
	at t+1: master1_out_7;
	at t+1: fromMaster = fromMaster_at_t;
	at t+1: master1_out_sig = master1_out_sig_at_t;
	at t+1: master0_in_notify = false;
	at t+1: master0_out_notify = false;
	at t+1: master1_in_notify = false;
	at t+1: master1_out_notify = true;
	at t+1: master2_in_notify = false;
	at t+1: master2_out_notify = false;
	at t+1: master3_in_notify = false;
	at t+1: master3_out_notify = false;
	at t+1: slave0_in_notify = false;
	at t+1: slave0_out_notify = false;
end property;


property wait_master2_in_9 is
dependencies: no_reset;
freeze:
	fromMaster_at_t = fromMaster@t;
assume:
	at t: master2_in_9;
	at t: not(master2_in_sync);
prove:
	at t+1: master2_in_9;
	at t+1: fromMaster = fromMaster_at_t;
	at t+1: master0_in_notify = false;
	at t+1: master0_out_notify = false;
	at t+1: master1_in_notify = false;
	at t+1: master1_out_notify = false;
	at t+1: master2_in_notify = true;
	at t+1: master2_out_notify = false;
	at t+1: master3_in_notify = false;
	at t+1: master3_out_notify = false;
	at t+1: slave0_in_notify = false;
	at t+1: slave0_out_notify = false;
end property;


property wait_master2_out_6 is
dependencies: no_reset;
freeze:
	fromMaster_at_t = fromMaster@t,
	master2_out_sig_at_t = master2_out_sig@t;
assume:
	at t: master2_out_6;
	at t: not(master2_out_sync);
prove:
	at t+1: master2_out_6;
	at t+1: fromMaster = fromMaster_at_t;
	at t+1: master2_out_sig = master2_out_sig_at_t;
	at t+1: master0_in_notify = false;
	at t+1: master0_out_notify = false;
	at t+1: master1_in_notify = false;
	at t+1: master1_out_notify = false;
	at t+1: master2_in_notify = false;
	at t+1: master2_out_notify = true;
	at t+1: master3_in_notify = false;
	at t+1: master3_out_notify = false;
	at t+1: slave0_in_notify = false;
	at t+1: slave0_out_notify = false;
end property;


property wait_master3_in_2 is
dependencies: no_reset;
freeze:
	fromMaster_at_t = fromMaster@t;
assume:
	at t: master3_in_2;
	at t: not(master3_in_sync);
prove:
	at t+1: master3_in_2;
	at t+1: fromMaster = fromMaster_at_t;
	at t+1: master0_in_notify = false;
	at t+1: master0_out_notify = false;
	at t+1: master1_in_notify = false;
	at t+1: master1_out_notify = false;
	at t+1: master2_in_notify = false;
	at t+1: master2_out_notify = false;
	at t+1: master3_in_notify = true;
	at t+1: master3_out_notify = false;
	at t+1: slave0_in_notify = false;
	at t+1: slave0_out_notify = false;
end property;


property wait_master3_out_5 is
dependencies: no_reset;
freeze:
	fromMaster_at_t = fromMaster@t,
	master3_out_sig_at_t = master3_out_sig@t;
assume:
	at t: master3_out_5;
	at t: not(master3_out_sync);
prove:
	at t+1: master3_out_5;
	at t+1: fromMaster = fromMaster_at_t;
	at t+1: master3_out_sig = master3_out_sig_at_t;
	at t+1: master0_in_notify = false;
	at t+1: master0_out_notify = false;
	at t+1: master1_in_notify = false;
	at t+1: master1_out_notify = false;
	at t+1: master2_in_notify = false;
	at t+1: master2_out_notify = false;
	at t+1: master3_in_notify = false;
	at t+1: master3_out_notify = true;
	at t+1: slave0_in_notify = false;
	at t+1: slave0_out_notify = false;
end property;


property wait_slave0_in_4 is
dependencies: no_reset;
freeze:
	fromMaster_at_t = fromMaster@t;
assume:
	at t: slave0_in_4;
	at t: not(slave0_in_sync);
prove:
	at t+1: slave0_in_4;
	at t+1: fromMaster = fromMaster_at_t;
	at t+1: master0_in_notify = false;
	at t+1: master0_out_notify = false;
	at t+1: master1_in_notify = false;
	at t+1: master1_out_notify = false;
	at t+1: master2_in_notify = false;
	at t+1: master2_out_notify = false;
	at t+1: master3_in_notify = false;
	at t+1: master3_out_notify = false;
	at t+1: slave0_in_notify = true;
	at t+1: slave0_out_notify = false;
end property;


property wait_slave0_out_3 is
dependencies: no_reset;
freeze:
	fromMaster_at_t = fromMaster@t,
	slave0_out_sig_at_t = slave0_out_sig@t;
assume:
	at t: slave0_out_3;
	at t: not(slave0_out_sync);
prove:
	at t+1: slave0_out_3;
	at t+1: fromMaster = fromMaster_at_t;
	at t+1: slave0_out_sig = slave0_out_sig_at_t;
	at t+1: master0_in_notify = false;
	at t+1: master0_out_notify = false;
	at t+1: master1_in_notify = false;
	at t+1: master1_out_notify = false;
	at t+1: master2_in_notify = false;
	at t+1: master2_out_notify = false;
	at t+1: master3_in_notify = false;
	at t+1: master3_out_notify = false;
	at t+1: slave0_in_notify = false;
	at t+1: slave0_out_notify = true;
end property;


property cycle_1 is
dependencies: no_reset;
for timepoints:
	t_cs_1 = t,
	t_master3_in_2 = t+1,
	t_master3_in_2_wait = t_master3_in_2+1,
	t_slave0_out_3 = t_master3_in_2_wait+1,
	t_slave0_out_3_wait = t_slave0_out_3+1,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+1,
	t_master2_out_6 = t_slave0_in_4_wait+1,
	t_master2_out_6_wait = t_master2_out_6+1,
	t_end = t_master2_out_6_wait+1;
freeze:
	fromMaster_at_t_master3_in_2_wait = fromMaster@t_master3_in_2_wait,
	master3_in_sig_haddr_at_t_master3_in_2_wait = master3_in_sig_haddr@t_master3_in_2_wait,
	master3_in_sig_hsize_at_t_master3_in_2_wait = master3_in_sig_hsize@t_master3_in_2_wait,
	master3_in_sig_hwdata_at_t_master3_in_2_wait = master3_in_sig_hwdata@t_master3_in_2_wait,
	master3_in_sig_hwrite_at_t_master3_in_2_wait = master3_in_sig_hwrite@t_master3_in_2_wait,
	fromMaster_at_t_slave0_out_3 = fromMaster@t_slave0_out_3,
	fromMaster_at_t_slave0_in_4_wait = fromMaster@t_slave0_in_4_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait,
	fromMaster_at_t_master2_out_6 = fromMaster@t_master2_out_6;
assume:
	at t_cs_1: idle_1;
	at t_cs_1: master3_in_sync;
	at t_master3_in_2: master3_in_sync;
	at t_slave0_out_3: slave0_out_sync;
	at t_slave0_in_4: slave0_in_sync;
	at t_slave0_in_4: (fromMaster = resize(2,32));
	at t_master2_out_6: master2_out_sync;
prove:
	at t_master3_in_2: fromMaster = 3;
	at t_slave0_out_3: fromMaster = fromMaster_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_haddr = master3_in_sig_haddr_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master3_in_sig_hsize_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master3_in_sig_hwdata_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master3_in_sig_hwrite_at_t_master3_in_2_wait;
	at t_slave0_in_4: fromMaster = fromMaster_at_t_slave0_out_3;
	at t_master2_out_6: fromMaster = fromMaster_at_t_slave0_in_4_wait;
	at t_master2_out_6: master2_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master2_out_6: master2_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;
	at t_end: fromMaster = fromMaster_at_t_master2_out_6;
end property;


property cycle_11 is
dependencies: no_reset;
for timepoints:
	t_cs_1 = t,
	t_master1_in_10 = t+1,
	t_master1_in_10_wait = t_master1_in_10+1,
	t_slave0_out_3 = t_master1_in_10_wait+1,
	t_slave0_out_3_wait = t_slave0_out_3+1,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+1,
	t_master0_out_8 = t_slave0_in_4_wait+1,
	t_master0_out_8_wait = t_master0_out_8+1,
	t_end = t_master0_out_8_wait+1;
freeze:
	fromMaster_at_t_master1_in_10_wait = fromMaster@t_master1_in_10_wait,
	master1_in_sig_haddr_at_t_master1_in_10_wait = master1_in_sig_haddr@t_master1_in_10_wait,
	master1_in_sig_hsize_at_t_master1_in_10_wait = master1_in_sig_hsize@t_master1_in_10_wait,
	master1_in_sig_hwdata_at_t_master1_in_10_wait = master1_in_sig_hwdata@t_master1_in_10_wait,
	master1_in_sig_hwrite_at_t_master1_in_10_wait = master1_in_sig_hwrite@t_master1_in_10_wait,
	fromMaster_at_t_slave0_out_3 = fromMaster@t_slave0_out_3,
	fromMaster_at_t_slave0_in_4_wait = fromMaster@t_slave0_in_4_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait,
	fromMaster_at_t_master0_out_8 = fromMaster@t_master0_out_8;
assume:
	at t_cs_1: idle_1;
	at t_cs_1: not(master3_in_sync);
	at t_cs_1: not(master2_in_sync);
	at t_cs_1: master1_in_sync;
	at t_master1_in_10: master1_in_sync;
	at t_slave0_out_3: slave0_out_sync;
	at t_slave0_in_4: slave0_in_sync;
	at t_slave0_in_4: (fromMaster = resize(0,32));
	at t_master0_out_8: master0_out_sync;
	at t: true = false;
prove:
	at t_master1_in_10: fromMaster = 1;
	at t_slave0_out_3: fromMaster = fromMaster_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_haddr = master1_in_sig_haddr_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master1_in_sig_hsize_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master1_in_sig_hwdata_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master1_in_sig_hwrite_at_t_master1_in_10_wait;
	at t_slave0_in_4: fromMaster = fromMaster_at_t_slave0_out_3;
	at t_master0_out_8: fromMaster = fromMaster_at_t_slave0_in_4_wait;
	at t_master0_out_8: master0_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master0_out_8: master0_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;
	at t_end: fromMaster = fromMaster_at_t_master0_out_8;
end property;


property cycle_12 is
dependencies: no_reset;
for timepoints:
	t_cs_1 = t,
	t_master0_in_11 = t+1,
	t_master0_in_11_wait = t_master0_in_11+1,
	t_slave0_out_3 = t_master0_in_11_wait+1,
	t_slave0_out_3_wait = t_slave0_out_3+1,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+1,
	t_master3_out_5 = t_slave0_in_4_wait+1,
	t_master3_out_5_wait = t_master3_out_5+1,
	t_end = t_master3_out_5_wait+1;
freeze:
	fromMaster_at_t_master0_in_11_wait = fromMaster@t_master0_in_11_wait,
	master0_in_sig_haddr_at_t_master0_in_11_wait = master0_in_sig_haddr@t_master0_in_11_wait,
	master0_in_sig_hsize_at_t_master0_in_11_wait = master0_in_sig_hsize@t_master0_in_11_wait,
	master0_in_sig_hwdata_at_t_master0_in_11_wait = master0_in_sig_hwdata@t_master0_in_11_wait,
	master0_in_sig_hwrite_at_t_master0_in_11_wait = master0_in_sig_hwrite@t_master0_in_11_wait,
	fromMaster_at_t_slave0_out_3 = fromMaster@t_slave0_out_3,
	fromMaster_at_t_slave0_in_4_wait = fromMaster@t_slave0_in_4_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait,
	fromMaster_at_t_master3_out_5 = fromMaster@t_master3_out_5;
assume:
	at t_cs_1: idle_1;
	at t_cs_1: not(master3_in_sync);
	at t_cs_1: not(master2_in_sync);
	at t_cs_1: not(master1_in_sync);
	at t_cs_1: master0_in_sync;
	at t_master0_in_11: master0_in_sync;
	at t_slave0_out_3: slave0_out_sync;
	at t_slave0_in_4: slave0_in_sync;
	at t_slave0_in_4: (fromMaster = resize(3,32));
	at t_master3_out_5: master3_out_sync;
	at t: true = false;
prove:
	at t_master0_in_11: fromMaster = 0;
	at t_slave0_out_3: fromMaster = fromMaster_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_haddr = master0_in_sig_haddr_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master0_in_sig_hsize_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master0_in_sig_hwdata_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master0_in_sig_hwrite_at_t_master0_in_11_wait;
	at t_slave0_in_4: fromMaster = fromMaster_at_t_slave0_out_3;
	at t_master3_out_5: fromMaster = fromMaster_at_t_slave0_in_4_wait;
	at t_master3_out_5: master3_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master3_out_5: master3_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;
	at t_end: fromMaster = fromMaster_at_t_master3_out_5;
end property;


property cycle_13 is
dependencies: no_reset;
for timepoints:
	t_cs_1 = t,
	t_master0_in_11 = t+1,
	t_master0_in_11_wait = t_master0_in_11+1,
	t_slave0_out_3 = t_master0_in_11_wait+1,
	t_slave0_out_3_wait = t_slave0_out_3+1,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+1,
	t_master2_out_6 = t_slave0_in_4_wait+1,
	t_master2_out_6_wait = t_master2_out_6+1,
	t_end = t_master2_out_6_wait+1;
freeze:
	fromMaster_at_t_master0_in_11_wait = fromMaster@t_master0_in_11_wait,
	master0_in_sig_haddr_at_t_master0_in_11_wait = master0_in_sig_haddr@t_master0_in_11_wait,
	master0_in_sig_hsize_at_t_master0_in_11_wait = master0_in_sig_hsize@t_master0_in_11_wait,
	master0_in_sig_hwdata_at_t_master0_in_11_wait = master0_in_sig_hwdata@t_master0_in_11_wait,
	master0_in_sig_hwrite_at_t_master0_in_11_wait = master0_in_sig_hwrite@t_master0_in_11_wait,
	fromMaster_at_t_slave0_out_3 = fromMaster@t_slave0_out_3,
	fromMaster_at_t_slave0_in_4_wait = fromMaster@t_slave0_in_4_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait,
	fromMaster_at_t_master2_out_6 = fromMaster@t_master2_out_6;
assume:
	at t_cs_1: idle_1;
	at t_cs_1: not(master3_in_sync);
	at t_cs_1: not(master2_in_sync);
	at t_cs_1: not(master1_in_sync);
	at t_cs_1: master0_in_sync;
	at t_master0_in_11: master0_in_sync;
	at t_slave0_out_3: slave0_out_sync;
	at t_slave0_in_4: slave0_in_sync;
	at t_slave0_in_4: (fromMaster = resize(2,32));
	at t_master2_out_6: master2_out_sync;
prove:
	at t_master0_in_11: fromMaster = 0;
	at t_slave0_out_3: fromMaster = fromMaster_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_haddr = master0_in_sig_haddr_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master0_in_sig_hsize_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master0_in_sig_hwdata_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master0_in_sig_hwrite_at_t_master0_in_11_wait;
	at t_slave0_in_4: fromMaster = fromMaster_at_t_slave0_out_3;
	at t_master2_out_6: fromMaster = fromMaster_at_t_slave0_in_4_wait;
	at t_master2_out_6: master2_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master2_out_6: master2_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;
	at t_end: fromMaster = fromMaster_at_t_master2_out_6;
end property;


property cycle_14 is
dependencies: no_reset;
for timepoints:
	t_cs_1 = t,
	t_master0_in_11 = t+1,
	t_master0_in_11_wait = t_master0_in_11+1,
	t_slave0_out_3 = t_master0_in_11_wait+1,
	t_slave0_out_3_wait = t_slave0_out_3+1,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+1,
	t_master1_out_7 = t_slave0_in_4_wait+1,
	t_master1_out_7_wait = t_master1_out_7+1,
	t_end = t_master1_out_7_wait+1;
freeze:
	fromMaster_at_t_master0_in_11_wait = fromMaster@t_master0_in_11_wait,
	master0_in_sig_haddr_at_t_master0_in_11_wait = master0_in_sig_haddr@t_master0_in_11_wait,
	master0_in_sig_hsize_at_t_master0_in_11_wait = master0_in_sig_hsize@t_master0_in_11_wait,
	master0_in_sig_hwdata_at_t_master0_in_11_wait = master0_in_sig_hwdata@t_master0_in_11_wait,
	master0_in_sig_hwrite_at_t_master0_in_11_wait = master0_in_sig_hwrite@t_master0_in_11_wait,
	fromMaster_at_t_slave0_out_3 = fromMaster@t_slave0_out_3,
	fromMaster_at_t_slave0_in_4_wait = fromMaster@t_slave0_in_4_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait,
	fromMaster_at_t_master1_out_7 = fromMaster@t_master1_out_7;
assume:
	at t_cs_1: idle_1;
	at t_cs_1: not(master3_in_sync);
	at t_cs_1: not(master2_in_sync);
	at t_cs_1: not(master1_in_sync);
	at t_cs_1: master0_in_sync;
	at t_master0_in_11: master0_in_sync;
	at t_slave0_out_3: slave0_out_sync;
	at t_slave0_in_4: slave0_in_sync;
	at t_slave0_in_4: (fromMaster = resize(1,32));
	at t_master1_out_7: master1_out_sync;
prove:
	at t_master0_in_11: fromMaster = 0;
	at t_slave0_out_3: fromMaster = fromMaster_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_haddr = master0_in_sig_haddr_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master0_in_sig_hsize_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master0_in_sig_hwdata_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master0_in_sig_hwrite_at_t_master0_in_11_wait;
	at t_slave0_in_4: fromMaster = fromMaster_at_t_slave0_out_3;
	at t_master1_out_7: fromMaster = fromMaster_at_t_slave0_in_4_wait;
	at t_master1_out_7: master1_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master1_out_7: master1_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;
	at t_end: fromMaster = fromMaster_at_t_master1_out_7;
end property;


property cycle_16 is
dependencies: no_reset;
for timepoints:
	t_cs_1 = t,
	t_end = t+1;
assume:
	at t_cs_1: idle_1;
	at t_cs_1: not(master3_in_sync);
	at t_cs_1: not(master2_in_sync);
	at t_cs_1: not(master1_in_sync);
	at t_cs_1: not(master0_in_sync);
prove:
	at t_end: idle_1;
end property;


property cycle_2 is
dependencies: no_reset;
for timepoints:
	t_cs_1 = t,
	t_master3_in_2 = t+1,
	t_master3_in_2_wait = t_master3_in_2+1,
	t_slave0_out_3 = t_master3_in_2_wait+1,
	t_slave0_out_3_wait = t_slave0_out_3+1,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+1,
	t_master1_out_7 = t_slave0_in_4_wait+1,
	t_master1_out_7_wait = t_master1_out_7+1,
	t_end = t_master1_out_7_wait+1;
freeze:
	fromMaster_at_t_master3_in_2_wait = fromMaster@t_master3_in_2_wait,
	master3_in_sig_haddr_at_t_master3_in_2_wait = master3_in_sig_haddr@t_master3_in_2_wait,
	master3_in_sig_hsize_at_t_master3_in_2_wait = master3_in_sig_hsize@t_master3_in_2_wait,
	master3_in_sig_hwdata_at_t_master3_in_2_wait = master3_in_sig_hwdata@t_master3_in_2_wait,
	master3_in_sig_hwrite_at_t_master3_in_2_wait = master3_in_sig_hwrite@t_master3_in_2_wait,
	fromMaster_at_t_slave0_out_3 = fromMaster@t_slave0_out_3,
	fromMaster_at_t_slave0_in_4_wait = fromMaster@t_slave0_in_4_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait,
	fromMaster_at_t_master1_out_7 = fromMaster@t_master1_out_7;
assume:
	at t_cs_1: idle_1;
	at t_cs_1: master3_in_sync;
	at t_master3_in_2: master3_in_sync;
	at t_slave0_out_3: slave0_out_sync;
	at t_slave0_in_4: slave0_in_sync;
	at t_slave0_in_4: (fromMaster = resize(1,32));
	at t_master1_out_7: master1_out_sync;
prove:
	at t_master3_in_2: fromMaster = 3;
	at t_slave0_out_3: fromMaster = fromMaster_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_haddr = master3_in_sig_haddr_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master3_in_sig_hsize_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master3_in_sig_hwdata_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master3_in_sig_hwrite_at_t_master3_in_2_wait;
	at t_slave0_in_4: fromMaster = fromMaster_at_t_slave0_out_3;
	at t_master1_out_7: fromMaster = fromMaster_at_t_slave0_in_4_wait;
	at t_master1_out_7: master1_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master1_out_7: master1_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;
	at t_end: fromMaster = fromMaster_at_t_master1_out_7;
end property;


property cycle_3 is
dependencies: no_reset;
for timepoints:
	t_cs_1 = t,
	t_master3_in_2 = t+1,
	t_master3_in_2_wait = t_master3_in_2+1,
	t_slave0_out_3 = t_master3_in_2_wait+1,
	t_slave0_out_3_wait = t_slave0_out_3+1,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+1,
	t_master0_out_8 = t_slave0_in_4_wait+1,
	t_master0_out_8_wait = t_master0_out_8+1,
	t_end = t_master0_out_8_wait+1;
freeze:
	fromMaster_at_t_master3_in_2_wait = fromMaster@t_master3_in_2_wait,
	master3_in_sig_haddr_at_t_master3_in_2_wait = master3_in_sig_haddr@t_master3_in_2_wait,
	master3_in_sig_hsize_at_t_master3_in_2_wait = master3_in_sig_hsize@t_master3_in_2_wait,
	master3_in_sig_hwdata_at_t_master3_in_2_wait = master3_in_sig_hwdata@t_master3_in_2_wait,
	master3_in_sig_hwrite_at_t_master3_in_2_wait = master3_in_sig_hwrite@t_master3_in_2_wait,
	fromMaster_at_t_slave0_out_3 = fromMaster@t_slave0_out_3,
	fromMaster_at_t_slave0_in_4_wait = fromMaster@t_slave0_in_4_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait,
	fromMaster_at_t_master0_out_8 = fromMaster@t_master0_out_8;
assume:
	at t_cs_1: idle_1;
	at t_cs_1: master3_in_sync;
	at t_master3_in_2: master3_in_sync;
	at t_slave0_out_3: slave0_out_sync;
	at t_slave0_in_4: slave0_in_sync;
	at t_slave0_in_4: (fromMaster = resize(0,32));
	at t_master0_out_8: master0_out_sync;

	at t: false = true;
prove:
	at t_master3_in_2: fromMaster = 3;
	at t_slave0_out_3: fromMaster = fromMaster_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_haddr = master3_in_sig_haddr_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master3_in_sig_hsize_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master3_in_sig_hwdata_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master3_in_sig_hwrite_at_t_master3_in_2_wait;
	at t_slave0_in_4: fromMaster = fromMaster_at_t_slave0_out_3;
	at t_master0_out_8: fromMaster = fromMaster_at_t_slave0_in_4_wait;
	at t_master0_out_8: master0_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master0_out_8: master0_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;
	at t_end: fromMaster = fromMaster_at_t_master0_out_8;
end property;


property cycle_4 is
dependencies: no_reset;
for timepoints:
	t_cs_1 = t,
	t_master2_in_9 = t+1,
	t_master2_in_9_wait = t_master2_in_9+1,
	t_slave0_out_3 = t_master2_in_9_wait+1,
	t_slave0_out_3_wait = t_slave0_out_3+1,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+1,
	t_master3_out_5 = t_slave0_in_4_wait+1,
	t_master3_out_5_wait = t_master3_out_5+1,
	t_end = t_master3_out_5_wait+1;

freeze:
	fromMaster_at_t_master2_in_9_wait = fromMaster@t_master2_in_9_wait,
	master2_in_sig_haddr_at_t_master2_in_9_wait = master2_in_sig_haddr@t_master2_in_9_wait,
	master2_in_sig_hsize_at_t_master2_in_9_wait = master2_in_sig_hsize@t_master2_in_9_wait,
	master2_in_sig_hwdata_at_t_master2_in_9_wait = master2_in_sig_hwdata@t_master2_in_9_wait,
	master2_in_sig_hwrite_at_t_master2_in_9_wait = master2_in_sig_hwrite@t_master2_in_9_wait,
	fromMaster_at_t_slave0_out_3 = fromMaster@t_slave0_out_3,
	fromMaster_at_t_slave0_in_4_wait = fromMaster@t_slave0_in_4_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait,
	fromMaster_at_t_master3_out_5 = fromMaster@t_master3_out_5;
assume:
	at t_cs_1: idle_1;
	at t_cs_1: not(master3_in_sync);
	at t_cs_1: master2_in_sync;
	at t_master2_in_9: master2_in_sync;
	at t_slave0_out_3: slave0_out_sync;
	at t_slave0_in_4: slave0_in_sync;
	at t_slave0_in_4: (fromMaster = resize(3,32));
	at t_master3_out_5: master3_out_sync;
	at t: false = true;
prove:
	at t_master2_in_9: fromMaster = 2;
	at t_slave0_out_3: fromMaster = fromMaster_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_haddr = master2_in_sig_haddr_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master2_in_sig_hsize_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master2_in_sig_hwdata_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master2_in_sig_hwrite_at_t_master2_in_9_wait;
	at t_slave0_in_4: fromMaster = fromMaster_at_t_slave0_out_3;
	at t_master3_out_5: fromMaster = fromMaster_at_t_slave0_in_4_wait;
	at t_master3_out_5: master3_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master3_out_5: master3_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;
	at t_end: fromMaster = fromMaster_at_t_master3_out_5;
end property; */