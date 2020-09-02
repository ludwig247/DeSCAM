-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: data_in_1;
	 at t: p1_acc_IN = resize(0,32);
	 at t: p1_coef = resize(1,32);
	 at t: p1_shiftreg(0) = resize(0,32);
	 at t: p1_shiftreg(1) = resize(0,32);
	 at t: p1_shiftreg(2) = resize(0,32);
	 at t: p1_data_in_notify = true;
	 at t: p1_data_out_notify = false;
end property;

------------------------------------ BASE PROPERTY------------------------------------------------

property cycle_0 is
dependencies: no_reset, data_in_restr, sync_in, liveness_in, liveness_out;
for timepoints:
	t_data_in_1 = t,
	t_data_in_1_wait = t_data_in_1+0..max_wait waits_for complete p1_data_in_sync,
	t_C1_2 = t_data_in_1_wait+1..max_wait waits_for complete p1_data_in_sync,
	t_C2_3 = t_C1_2+1..max_wait waits_for complete p1_data_in_sync,
	t_C3_4 = t_C2_3+1..max_wait waits_for complete p1_data_in_sync,
	t_data_out_5 = t_C3_4+1..max_wait waits_for complete p1_data_in_sync,
	t_data_out_5_wait = t_data_out_5+0..max_wait waits_for complete p1_data_in_sync;
freeze:
	data_in_sig_at_t_data_in_1_wait = p1_data_in_sig@t_data_in_1_wait,
	shiftreg_0_at_t_data_in_1_wait = p1_shiftreg(0)@t_data_in_1_wait,
	shiftreg_1_at_t_data_in_1_wait = p1_shiftreg(1)@t_data_in_1_wait,
	coef_at_t_C1_2 = p1_coef@t_C1_2,
	shiftreg_2_at_t_C1_2 = p1_shiftreg(2)@t_C1_2,
	coef_at_t_C2_3 = p1_coef@t_C2_3,
	shiftreg_2_at_t_C2_3 = p1_shiftreg(2)@t_C2_3,
	coef_at_t_C3_4 = p1_coef@t_C3_4,
	shiftreg_2_at_t_C3_4 = p1_shiftreg(2)@t_C3_4,
	data_in_sig_at_t_data_out_5 = p1_data_in_sig@t_data_out_5,
	shiftreg_0_at_t_data_out_5 = p1_shiftreg(0)@t_data_out_5,
	shiftreg_1_at_t_data_out_5 = p1_shiftreg(1)@t_data_out_5,
	shiftreg_2_at_t_data_out_5 = p1_shiftreg(2)@t_data_out_5;
assume:
	
	at t_data_in_1: data_in_1;

prove:
	at t: p1_data_in_notify; 
	at t_C1_2: p1_acc_IN = 0;
	at t_C1_2: p1_shiftreg(0) = data_in_sig_at_t_data_in_1_wait;
	at t_C1_2: p1_shiftreg(1) = shiftreg_0_at_t_data_in_1_wait;
	at t_C1_2: p1_shiftreg(2) = shiftreg_1_at_t_data_in_1_wait;
	at t_data_out_5: p1_coef = ((coef_at_t_C1_2 * shiftreg_2_at_t_C1_2)(31 downto 0) + (coef_at_t_C2_3 * shiftreg_2_at_t_C2_3)(31 downto 0) + (coef_at_t_C3_4 * shiftreg_2_at_t_C3_4)(31 downto 0))(31 downto 0);
	at t_data_out_5: p1_data_out_sig = ((coef_at_t_C1_2 * shiftreg_2_at_t_C1_2)(31 downto 0) + (coef_at_t_C2_3 * shiftreg_2_at_t_C2_3)(31 downto 0) + (coef_at_t_C3_4 * shiftreg_2_at_t_C3_4)(31 downto 0))(31 downto 0);
	at t_data_out_5: p1_data_out_notify;
end property;


-------------------------------- RELAXED PROPERTY --------------------------------------------

property CS2QED_FIR is
dependencies: no_reset, data_in_restr, sync_in, liveness_in, liveness_out;
for timepoints: 
	-- base instance
	t_data_in_1_i1 = t,
	t_data_in_1_wait_i1 = t_data_in_1_i1+0..max_wait waits_for complete p1_data_in_sync,
	t_C1_2_i1 = t_data_in_1_wait_i1+1..max_wait waits_for complete p1_data_in_sync,
	t_C2_3_i1 = t_C1_2_i1+1..max_wait waits_for complete p1_data_in_sync,
	t_C3_4_i1 = t_C2_3_i1+1..max_wait waits_for complete p1_data_in_sync,
	t_data_out_5_i1 = t_C3_4_i1+1..max_wait waits_for complete p1_data_in_sync,
	t_data_out_5_wait_i1 = t_data_out_5_i1+0..max_wait waits_for complete p1_data_in_sync,
	t_end_i1 = t_data_out_5_wait_i1 + 1..max_wait waits_for complete p1_data_in_sync,

	-- relaxed instance
	t_data_in_1_i2 = t,
	t_data_in_1_wait_i2 = t_data_in_1_i2+0..max_wait waits_for complete p2_data_in_sync,
	t_C1_2_i2 = t_data_in_1_wait_i2+1..max_wait waits_for complete p2_data_in_sync,
	t_C2_3_i2 = t_C1_2_i2+1..max_wait waits_for complete p2_data_in_sync,
	t_C3_4_i2 = t_C2_3_i2+1..max_wait waits_for complete p2_data_in_sync,
	t_data_out_5_i2 = t_C3_4_i2+1..max_wait waits_for complete p2_data_in_sync,
	t_data_out_5_wait_i2 = t_data_out_5_i2+0..max_wait waits_for complete p2_data_in_sync,
	t_end_i2 = t_data_out_5_wait_i2 + 1..max_wait waits_for complete p2_data_in_sync;

freeze:	
	shiftreg_2_at_t_C1_2_i1 = p1_shiftreg(2)@t_C1_2_i1,
	shiftreg_2_at_t_C2_3_i1 = p1_shiftreg(2)@t_C2_3_i1,
	shiftreg_2_at_t_C3_4_i1 = p1_shiftreg(2)@t_C3_4_i1,

	shiftreg_2_at_t_C1_2_i2 = p2_shiftreg(2)@t_C1_2_i2,
	shiftreg_2_at_t_C2_3_i2 = p2_shiftreg(2)@t_C2_3_i2,
	shiftreg_2_at_t_C3_4_i2 = p2_shiftreg(2)@t_C3_4_i2,

	coef_at_t_C1_2_i1 = p1_coef@t_C1_2_i1,
	coef_at_t_C2_3_i1 = p1_coef@t_C2_3_i1,

	coef_at_t_C1_2_i2 = p2_coef@t_C1_2_i2,
	coef_at_t_C2_3_i2 = p2_coef@t_C2_3_i2,

	coef_at_t_C3_4_i1 = p1_coef@t_C3_4_i1,
	coef_at_t_data_out_5_i1 = p1_coef@t_data_out_5_i1,

	data_out_at_t_data_out_5_i1 = p1_data_out_sig@t_data_out_5_i1;
	
assume:
	-- constrained pipeline after reset state
	at t: data_in_1;

	-- input identical
	at t: p1_data_in_sig = p2_data_in_sig;

	-- acc-signal identical
	at t_C3_4_i2: ((coef_at_t_C1_2_i2 * shiftreg_2_at_t_C1_2_i2)(31 downto 0) + (coef_at_t_C2_3_i2 * shiftreg_2_at_t_C2_3_i2)(31 downto 0))(31 downto 0) = ((coef_at_t_C1_2_i1 * shiftreg_2_at_t_C1_2_i1)(31 downto 0) + (coef_at_t_C2_3_i1 * shiftreg_2_at_t_C2_3_i1)(31 downto 0))(31 downto 0);

	-- coef identical in stage 4 (C3)
	at t_C3_4_i2: p2_coef = coef_at_t_C3_4_i1;

prove:	

	-- coef
	-- shifted values + new value must be identical in both pipelines
	at t_data_out_5_i2: p2_coef = coef_at_t_data_out_5_i1;

	-- output
	at t_data_out_5_i2: p2_data_out_sig = data_out_at_t_data_out_5_i1;

end property;


property wait_data_in_1 is
dependencies: no_reset;
freeze:
	coef_at_t = p1_coef@t,
	acc_at_t = p1_acc_IN@t,
	shiftreg_0_at_t = p1_shiftreg(0)@t,
	shiftreg_1_at_t = p1_shiftreg(1)@t,
	shiftreg_2_at_t = p1_shiftreg(2)@t;
assume:
	at t: p1_data_in_notify;
	at t: not(p1_data_in_sync);
prove:
	at t+1: p1_coef = coef_at_t;
	at t+1: p1_shiftreg(0) = shiftreg_0_at_t;
	at t+1: p1_shiftreg(1) = shiftreg_1_at_t;
	at t+1: p1_shiftreg(2) = shiftreg_2_at_t;
	at t+1: p1_data_in_notify = true;
end property;


property wait_data_out_5 is
dependencies: no_reset;
freeze:
	coef_at_t = p1_coef@t,
	acc_at_t = p1_acc_C3@t,
	shiftreg_0_at_t = p1_shiftreg(0)@t,
	shiftreg_1_at_t = p1_shiftreg(1)@t,
	shiftreg_2_at_t = p1_shiftreg(2)@t,
	data_out_sig_at_t = p1_data_out_sig@t;
assume:
	at t: p1_data_out_notify;
	at t: not(p1_data_out_sync);
prove:
	at t+1: p1_coef = coef_at_t;
	at t+1: p1_data_out_sig = data_out_sig_at_t;
	at t+1: p1_shiftreg(0) = shiftreg_0_at_t;
	at t+1: p1_shiftreg(1) = shiftreg_1_at_t;
	at t+1: p1_shiftreg(2) = shiftreg_2_at_t;
	at t+1: p1_data_out_notify = true;
end property;


