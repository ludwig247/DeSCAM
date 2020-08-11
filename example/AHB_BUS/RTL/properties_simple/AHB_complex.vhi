
property master3_to_slave0 is
dependencies: no_reset, no_split_retry,slave0,master_3,master_0,master_1,master_2;
for timepoints:
	t_cs_1 = t,
	t_master3_in_2 = t+1,
	t_master3_in_2_wait = t_master3_in_2,
	-- 	An assumption on the internal state of the master(buffer) had to be made in order to no know that the raised notify results from the transmission under verification
	t_slave0_out_3 = t_master3_in_2_wait+3 .. (7*max_wait)+1 waits_for complete slave0_out_notify and mst3/section = data_phase, 
	t_slave0_out_3_wait = t_slave0_out_3+0 .. max_wait waits_for complete slave_out0_sync,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+0 .. max_wait waits_for complete slave_in0_sync,
	t_master3_out_5 = t_slave0_in_4_wait+3,
	t_master3_out_5_wait = t_master3_out_5+0 .. max_wait  waits_for complete master3_out_sync,
	t_end = t_master3_out_5_wait+1;
freeze:
	master3_in_sig_haddr_at_t_master3_in_2_wait = master3_in_sig_haddr@t_master3_in_2_wait,
	master3_in_sig_hsize_at_t_master3_in_2_wait = master3_in_sig_hsize@t_master3_in_2_wait,
	master3_in_sig_hwdata_at_t_master3_in_2_wait = master3_in_sig_hwdata@t_master3_in_2_wait,
	master3_in_sig_hwrite_at_t_master3_in_2_wait = master3_in_sig_hwrite@t_master3_in_2_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait;
assume:
	at t_cs_1: master_in3.haddr = 0; -- only transmit to slave0; manual constraint
	--at t_cs_1: idle_1; 
	--Instead of assumging all masters idle we assume that only the master related to the transmission is idle
	--at t_cs_1: master_in3_notify;  --master3 idle 
	at t_cs_1: next(master3_in_notify);  -- manual 
	at t_cs_1: master3_in_sync;
prove:
	at t_slave0_out_3: slave0_out_sig_haddr = master3_in_sig_haddr_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master3_in_sig_hsize_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master3_in_sig_hwdata_at_t_master3_in_2_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master3_in_sig_hwrite_at_t_master3_in_2_wait;
	at t_master3_out_5: master3_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master3_out_5: master3_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;

	--NOTIFY---
	at t: not(master3_in_notify);
	at t+1: master3_in_notify;
	during[t+2,t_slave0_out_3]: not(master3_in_notify);
	
	--	Prove on the notify had to be simplified, because the others masters may use the slave	
	--	before it is TuV turn. 
	--during[t,t_slave0_out_3-1]: not(slave0_out_notify);
	during[t_slave0_out_3,t_slave0_out_3_wait]: (slave0_out_notify);

	--during[t,t_slave0_in_4-1]: not(slave0_in_notify);
	during[t_slave0_in_4,t_slave0_in_4_wait]: (slave0_in_notify);
	
	during[t,t_master3_out_5-1]: not(master3_out_notify);
	during[t_master3_out_5,t_master3_out_5_wait]: (master3_out_notify);
	
	/* Determination Test: 
		Every output has to be determined at each timepoint. 
		In my case, this is only known for the outputs related to that operation (e.g. master1 communicates with slave0). 
		For the other concurrent operations this is unknown (e.g. maste2 communicates with slave 2). 
		We would need to prove a value for each timepoint for all the non-used ports. 

		Of course, one could introduce determination domains, this would only reduce the time frame needed for the prove. 
		The information what other operations are doing in the pipeline is missing, regardless.
		
		Onespin Manual suggest to use local_determination_requirements in case a determination requirments depends on a timepoint and on a property, 
		which is the case here. 
		This should not be used for outputs, because these should be globally defined. 

		--MISSING FOR DETERMINATION---
		--at t+1: not(master2_in_notify);
		--at t+1: not(master1_in_notify);
		--at t+1: not(master0_in_notify); 

		--during[t,t_master3_out_5_wait]: not(master2_out_notify);
		--during[t,t_master3_out_5_wait]: not(master1_out_notify);
		--during[t,t_master3_out_5_wait]: not(master0_out_notify);

		--during[t,t_master3_out_5_wait]: not(slave2_out_notify);
		--during[t,t_master3_out_5_wait]: not(slave1_out_notify);
		--during[t,t_master3_out_5_wait]: not(slave0_out_notify);

		--during[t,t_master3_out_5_wait]: not(slave2_in_notify);
		--during[t,t_master3_out_5_wait]: not(slave1_in_notify);
		--during[t,t_master3_out_5_wait]: not(slave0_in_notify);

	Succesor-Test: 
		We assume that we start from some idle state. 
		Idle is defined as a state in which each master is ready for communication. 
		However, we can't prove that we return to idle, because other operation may still be going on in the pipeline. 
		It does not matter how we choose the right hook here. 
		--MISSING FOR SUCCESOR:
		--t_end: idle_1 
		or
		--t_right_hook: idle_1

	Case-Split: 
		I think case split is an obvious problem. 
		Is this solved with the CS2QED setup? 
	*/

right_hook: t+1;
end property;


property master2_to_slave0 is
dependencies: no_reset, no_split_retry,slave0,master_3,master_0,master_1,master_2;
for timepoints:
	t_cs_1 = t,
	t_master2_in_9 = t+1,
	t_master2_in_9_wait = t_master2_in_9,
	t_slave0_out_3 = t_master2_in_9_wait+3 .. (10*max_wait)+1 waits_for complete slave0_out_notify and mst2/section = data_phase,
	t_slave0_out_3_wait = t_slave0_out_3+0 .. max_wait waits_for slave_out0_sync,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+0 .. max_wait waits_for slave_in0_sync,
	t_master2_out_6 = t_slave0_in_4_wait+3,
	t_master2_out_6_wait = t_master2_out_6+0 .. max_wait  waits_for master2_out_sync,
	t_end = t_master2_out_6_wait+1;
freeze:
	master2_in_sig_haddr_at_t_master2_in_9_wait = master2_in_sig_haddr@t_master2_in_9_wait,
	master2_in_sig_hsize_at_t_master2_in_9_wait = master2_in_sig_hsize@t_master2_in_9_wait,
	master2_in_sig_hwdata_at_t_master2_in_9_wait = master2_in_sig_hwdata@t_master2_in_9_wait,
	master2_in_sig_hwrite_at_t_master2_in_9_wait = master2_in_sig_hwrite@t_master2_in_9_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait;
assume:
	at t_cs_1: master_in2.haddr = 0; -- only check for slave0;
	--at t_cs_1: idle_1;
	at t_cs_1: master_in2_notify;  -- manual
	at t_cs_1: not(master3_in_sync);
	at t_cs_1: master2_in_sync;
	at t_cs_1: not(master2_out_notify); --invariant
prove:
	at t_slave0_out_3: slave0_out_sig_haddr = master2_in_sig_haddr_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master2_in_sig_hsize_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master2_in_sig_hwdata_at_t_master2_in_9_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master2_in_sig_hwrite_at_t_master2_in_9_wait;
	at t_master2_out_6: master2_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master2_out_6: master2_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;

	--NOTIFY---
	at t: not(master2_in_notify);	
	at t+1: master2_in_notify;
	during[t+2,t_end-1]: not(master2_in_notify);
	
	--during[t,t_slave0_out_3-1]: not(slave0_out_notify);
	during[t_slave0_out_3,t_slave0_out_3_wait]: (slave0_out_notify);

	--during[t,t_slave0_in_4-1]: not(slave0_in_notify);
	during[t_slave0_in_4,t_slave0_in_4_wait]: (slave0_in_notify);
	
	during[t,t_master2_out_6-1]: not(master2_out_notify);
	during[t_master2_out_6,t_master2_out_6_wait]: (master2_out_notify);

	--COMPLETENESS--
	--during[t_master2_in_9_wait,t_slave0_out_3]: not(mst2/section = data_phase);
	--at t_slave0_out_3: (mst2/section = data_phase);
right_hook: t+1;
end property;

property master1_to_slave0 is
dependencies: no_reset, no_split_retry, slave0,master_3,master_0,master_1,master_2;
for timepoints:
	t_cs_1 = t,
	t_master1_in_10 = t+1,
	t_master1_in_10_wait = t_master1_in_10,
	t_slave0_out_3 = t_master1_in_10_wait+3 .. 40 waits_for complete slave0_out_notify and mst1/section = data_phase, 
	t_slave0_out_3_wait = t_slave0_out_3+0 .. max_wait waits_for slave_out0_sync,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+0 .. max_wait waits_for slave_in0_sync,
	t_master1_out_7 = t_slave0_in_4_wait+3,
	t_master1_out_7_wait = t_master1_out_7+0 .. max_wait  waits_for master1_out_sync,
	t_end = t_master1_out_7_wait+1;
freeze:
	master1_in_sig_haddr_at_t_master1_in_10_wait = master1_in_sig_haddr@t_master1_in_10_wait,
	master1_in_sig_hsize_at_t_master1_in_10_wait = master1_in_sig_hsize@t_master1_in_10_wait,
	master1_in_sig_hwdata_at_t_master1_in_10_wait = master1_in_sig_hwdata@t_master1_in_10_wait,
	master1_in_sig_hwrite_at_t_master1_in_10_wait = master1_in_sig_hwrite@t_master1_in_10_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait;
assume:
	at t_cs_1: master_in1.haddr = 0; -- only check for slave0;
	--at t_cs_1: idle_1;
	at t_cs_1: master_in1_notify; -- manual
	at t_cs_1: not(master3_in_sync);
	at t_cs_1: not(master2_in_sync);
	at t_cs_1: master1_in_sync;
	--at t_cs_1: not(master1_out_notify); -- invariant
	
prove:
	at t_slave0_out_3: slave0_out_sig_haddr = master1_in_sig_haddr_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master1_in_sig_hsize_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master1_in_sig_hwdata_at_t_master1_in_10_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master1_in_sig_hwrite_at_t_master1_in_10_wait;
	at t_master1_out_7: master1_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master1_out_7: master1_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;

	--NOTIFY---
	at t: not(master1_in_notify);
	at t+1: master1_in_notify;
	at t+2: not(master1_in_notify);
	
	--during[t,t_slave0_out_3-1]: not(slave0_out_notify);
	during[t_slave0_out_3,t_slave0_out_3_wait]: (slave0_out_notify);

	--during[t,t_slave0_in_4-1]: not(slave0_in_notify);
	during[t_slave0_in_4,t_slave0_in_4_wait]: (slave0_in_notify);
	
	during[t,t_master1_out_7-1]: not(master1_out_notify);
	during[t_master1_out_7,t_master1_out_7_wait]: (master1_out_notify);
right_hook: t+1;
end property;



property master0_to_slave0 is
dependencies: no_reset, no_split_retry,only_slave_0,  no_starvation;
for timepoints:
	t_cs_1 = t,
	t_master0_in_11 = t+1,
	t_master0_in_11_wait = t_master0_in_11,
	t_slave0_out_3 = t_master0_in_11_wait+3 .. 50+(7*max_wait)+1 waits_for complete slave0_out_notify and mst0/section = data_phase,
	t_slave0_out_3_wait = t_slave0_out_3+0 .. max_wait waits_for slave_out0_sync,
	t_slave0_in_4 = t_slave0_out_3_wait+1,
	t_slave0_in_4_wait = t_slave0_in_4+0 .. max_wait waits_for slave_in0_sync,
	t_master0_out_8 = t_slave0_in_4_wait+3,
	t_master0_out_8_wait = t_master0_out_8+0 .. max_wait  waits_for master0_out_sync,
	t_end = t_master0_out_8_wait+1;
freeze:
	master0_in_sig_haddr_at_t_master0_in_11_wait = master0_in_sig_haddr@t_master0_in_11_wait,
	master0_in_sig_hsize_at_t_master0_in_11_wait = master0_in_sig_hsize@t_master0_in_11_wait,
	master0_in_sig_hwdata_at_t_master0_in_11_wait = master0_in_sig_hwdata@t_master0_in_11_wait,
	master0_in_sig_hwrite_at_t_master0_in_11_wait = master0_in_sig_hwrite@t_master0_in_11_wait,
	slave0_in_sig_hrdata_at_t_slave0_in_4_wait = slave0_in_sig_hrdata@t_slave0_in_4_wait,
	slave0_in_sig_hresp_at_t_slave0_in_4_wait = slave0_in_sig_hresp@t_slave0_in_4_wait;
assume:
	at t_cs_1: master_in0.haddr = 0; -- only check for slave0;
	--at t_cs_1: idle_1;
	at t_cs_1: master_in0_notify; -- manual
	at t_cs_1: not(master3_in_sync);
	at t_cs_1: not(master2_in_sync);
	at t_cs_1: not(master1_in_sync);
	at t_cs_1: master0_in_sync;
prove:
	at t_slave0_out_3: slave0_out_sig_haddr = master0_in_sig_haddr_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_hsize = master0_in_sig_hsize_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_hwdata = master0_in_sig_hwdata_at_t_master0_in_11_wait;
	at t_slave0_out_3: slave0_out_sig_hwrite = master0_in_sig_hwrite_at_t_master0_in_11_wait;
	at t_master0_out_8: master0_out_sig_hrdata = slave0_in_sig_hrdata_at_t_slave0_in_4_wait;
	at t_master0_out_8: master0_out_sig_hresp = slave0_in_sig_hresp_at_t_slave0_in_4_wait;
	--NOTIFY---
	at t: not(master0_in_notify);
	at t+1: (master0_in_notify);
	at t+2: not(master0_in_notify);
	
	during[t_slave0_out_3,t_slave0_out_3_wait]: (slave0_out_notify);
	during[t_slave0_in_4,t_slave0_in_4_wait]: (slave0_in_notify);

	during[t,t_master0_out_8-1]: not(master0_out_notify);
	during[t_master0_out_8,t_master0_out_8_wait]: (master0_out_notify);
right_hook: t+1;
end property;
