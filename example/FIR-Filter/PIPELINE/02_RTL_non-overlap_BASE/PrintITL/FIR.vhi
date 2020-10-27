-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: data_in_1;
	 at t: acc = resize(0,32);
	 at t: coef(0) = resize(1,32);
	 at t: coef(1) = resize(1,32);
	 at t: coef(2) = resize(1,32);
	 at t: shiftreg(0) = resize(0,32);
	 at t: shiftreg(1) = resize(0,32);
	 at t: shiftreg(2) = resize(0,32);
	 at t: data_in_notify = true;
	 at t: data_out_notify = false;
end property;

------------------------------------ BASE PROPERTY------------------------------------------------

property cycle_0 is
dependencies: no_reset, data_in_restr;
for timepoints:
	t_data_in_1 = t,
	t_data_in_1_wait = t_data_in_1+0..5 waits_for data_in_sync,
	t_C1_2 = t_data_in_1_wait+1,
	t_C2_3 = t_C1_2+1,
	t_C3_4 = t_C2_3+1,
	t_data_out_5 = t_C3_4+1,
	t_data_out_5_wait = t_data_out_5+0..5 waits_for data_out_sync,
	t_end = t_data_out_5_wait + 1;

freeze:
	coef_0_at_t_data_in_1_wait = coef(0)@t_data_in_1_wait,
	coef_1_at_t_data_in_1_wait = coef(1)@t_data_in_1_wait,
	coef_2_at_t_data_in_1_wait = coef(2)@t_data_in_1_wait,
	data_in_sig_at_t_data_in_1_wait = data_in_sig@t_data_in_1_wait,
	shiftreg_0_at_t_data_in_1_wait = shiftreg(0)@t_data_in_1_wait,
	shiftreg_1_at_t_data_in_1_wait = shiftreg(1)@t_data_in_1_wait,
	acc_at_t_C1_2 = acc@t_C1_2,
	coef_0_at_t_C1_2 = coef(0)@t_C1_2,
	coef_1_at_t_C1_2 = coef(1)@t_C1_2,
	coef_2_at_t_C1_2 = coef(2)@t_C1_2,
	shiftreg_0_at_t_C1_2 = shiftreg(0)@t_C1_2,
	shiftreg_1_at_t_C1_2 = shiftreg(1)@t_C1_2,
	shiftreg_2_at_t_C1_2 = shiftreg(2)@t_C1_2,
	acc_at_t_C2_3 = acc@t_C2_3,
	coef_0_at_t_C2_3 = coef(0)@t_C2_3,
	coef_1_at_t_C2_3 = coef(1)@t_C2_3,
	coef_2_at_t_C2_3 = coef(2)@t_C2_3,
	shiftreg_0_at_t_C2_3 = shiftreg(0)@t_C2_3,
	shiftreg_1_at_t_C2_3 = shiftreg(1)@t_C2_3,
	shiftreg_2_at_t_C2_3 = shiftreg(2)@t_C2_3,
	acc_at_t_C3_4 = acc@t_C3_4,
	coef_0_at_t_C3_4 = coef(0)@t_C3_4,
	coef_1_at_t_C3_4 = coef(1)@t_C3_4,
	shiftreg_0_at_t_C3_4 = shiftreg(0)@t_C3_4,
	shiftreg_1_at_t_C3_4 = shiftreg(1)@t_C3_4,
	shiftreg_2_at_t_C3_4 = shiftreg(2)@t_C3_4,
	acc_at_t_data_out_5 = acc@t_data_out_5,
	coef_0_at_t_data_out_5 = coef(0)@t_data_out_5,
	coef_1_at_t_data_out_5 = coef(1)@t_data_out_5,
	coef_2_at_t_data_out_5 = coef(2)@t_data_out_5,
	shiftreg_0_at_t_data_out_5 = shiftreg(0)@t_data_out_5,
	shiftreg_1_at_t_data_out_5 = shiftreg(1)@t_data_out_5,
	shiftreg_2_at_t_data_out_5 = shiftreg(2)@t_data_out_5;
assume:
	
	at t_data_in_1: data_in_1;
	at t_data_in_1: data_in_sync;
	at t_data_out_5: data_out_sync;

prove:
	at t_C1_2: acc = 0;
	at t_C1_2: coef(0) = coef_0_at_t_data_in_1_wait;
	at t_C1_2: coef(1) = coef_1_at_t_data_in_1_wait;
	at t_C1_2: coef(2) = coef_2_at_t_data_in_1_wait;
	at t_C1_2: shiftreg(0) = data_in_sig_at_t_data_in_1_wait;
	at t_C1_2: shiftreg(1) = shiftreg_0_at_t_data_in_1_wait;
	at t_C1_2: shiftreg(2) = shiftreg_1_at_t_data_in_1_wait;
	at t_C2_3: acc = (acc_at_t_C1_2 + (coef_2_at_t_C1_2 * shiftreg_2_at_t_C1_2)(31 downto 0))(31 downto 0);
	at t_C2_3: coef(0) = coef_0_at_t_C1_2;
	at t_C2_3: coef(1) = coef_1_at_t_C1_2;
	at t_C2_3: coef(2) = coef_2_at_t_C1_2;
	at t_C2_3: shiftreg(0) = shiftreg_0_at_t_C1_2;
	at t_C2_3: shiftreg(1) = shiftreg_1_at_t_C1_2;
	at t_C2_3: shiftreg(2) = shiftreg_2_at_t_C1_2;
	at t_C3_4: acc = (acc_at_t_C2_3 + (coef_1_at_t_C2_3 * shiftreg_1_at_t_C2_3)(31 downto 0))(31 downto 0);
	at t_C3_4: coef(0) = coef_0_at_t_C2_3;
	at t_C3_4: coef(1) = coef_1_at_t_C2_3;
	at t_C3_4: coef(2) = coef_2_at_t_C2_3;
	at t_C3_4: shiftreg(0) = shiftreg_0_at_t_C2_3;
	at t_C3_4: shiftreg(1) = shiftreg_1_at_t_C2_3;
	at t_C3_4: shiftreg(2) = shiftreg_2_at_t_C2_3;
	at t_data_out_5: acc = (acc_at_t_C3_4 + (coef_0_at_t_C3_4 * shiftreg_0_at_t_C3_4)(31 downto 0))(31 downto 0);
	at t_data_out_5: coef(0) = (acc_at_t_C3_4 + (coef_0_at_t_C3_4 * shiftreg_0_at_t_C3_4)(31 downto 0))(31 downto 0);
	at t_data_out_5: coef(1) = coef_0_at_t_C3_4;
	at t_data_out_5: coef(2) = coef_1_at_t_C3_4;
	at t_data_out_5: data_out_sig = (acc_at_t_C3_4 + (coef_0_at_t_C3_4 * shiftreg_0_at_t_C3_4)(31 downto 0))(31 downto 0);
	at t_data_out_5: shiftreg(0) = shiftreg_0_at_t_C3_4;
	at t_data_out_5: shiftreg(1) = shiftreg_1_at_t_C3_4;
	at t_data_out_5: shiftreg(2) = shiftreg_2_at_t_C3_4;
	at t_end: acc = acc_at_t_data_out_5;
	at t_end: coef(0) = coef_0_at_t_data_out_5;
	at t_end: coef(1) = coef_1_at_t_data_out_5;
	at t_end: coef(2) = coef_2_at_t_data_out_5;
	at t_end: shiftreg(0) = shiftreg_0_at_t_data_out_5;
	at t_end: shiftreg(1) = shiftreg_1_at_t_data_out_5;
	at t_end: shiftreg(2) = shiftreg_2_at_t_data_out_5;
end property;


-------------------------------- RELAXED PROPERTY --------------------------------------------

property CS2QED_FIR is
dependencies: no_reset;
for timepoints: 
	-- base instance
	t_data_in_1_i1 = t,
	t_data_in_1_wait_i1 = t_data_in_1_i1+0..5 waits_for data_in_sync,
	t_C1_2_i1 = t_data_in_1_wait_i1+1,
	t_C2_3_i1 = t_C1_2_i1+1,
	t_C3_4_i1 = t_C2_3_i1+1,
	t_data_out_5_i1 = t_C3_4_i1+1,
	t_data_out_5_wait_i1 = t_data_out_5_i1+0..5 waits_for data_out_sync,
	t_end_i1 = t_data_out_5_wait_i1+1,

	-- relaxed instance
	t_data_in_1_i2 = t,
	t_data_in_1_wait_i2 = t_data_in_1_i2+0..5 waits_for data_in_sync,
	t_C1_2_i2 = t_data_in_1_wait_i2+1,
	t_C2_3_i2 = t_C1_2_i2+1,
	t_C3_4_i2 = t_C2_3_i2+1,
	t_data_out_5_i2 = t_C3_4_i2+1,
	t_data_out_5_wait_i2 = t_data_out_5_i2+0..5 waits_for data_out_sync,
	t_end_i2 = t_data_out_5_wait_i2+1;
assume:
	at t: data_in_1;

prove:
	at t+1: data_in_1;

end property;


property wait_data_in_1 is
dependencies: no_reset;
freeze:
	coef_2_at_t = coef(2)@t,
	coef_1_at_t = coef(1)@t,
	coef_0_at_t = coef(0)@t,
	acc_at_t = acc@t,
	shiftreg_0_at_t = shiftreg(0)@t,
	shiftreg_1_at_t = shiftreg(1)@t,
	shiftreg_2_at_t = shiftreg(2)@t;
assume:
	at t: data_in_1;
	at t: not(data_in_sync);
prove:
	at t+1: data_in_1;
	at t+1: acc = acc_at_t;
	at t+1: coef(0) = coef_0_at_t;
	at t+1: coef(1) = coef_1_at_t;
	at t+1: coef(2) = coef_2_at_t;
	at t+1: shiftreg(0) = shiftreg_0_at_t;
	at t+1: shiftreg(1) = shiftreg_1_at_t;
	at t+1: shiftreg(2) = shiftreg_2_at_t;
	at t+1: data_in_notify = true;
	at t+1: data_out_notify = false;
end property;


property wait_data_out_5 is
dependencies: no_reset;
freeze:
	coef_2_at_t = coef(2)@t,
	coef_1_at_t = coef(1)@t,
	coef_0_at_t = coef(0)@t,
	acc_at_t = acc@t,
	shiftreg_0_at_t = shiftreg(0)@t,
	shiftreg_1_at_t = shiftreg(1)@t,
	shiftreg_2_at_t = shiftreg(2)@t,
	data_out_sig_at_t = data_out_sig@t;
assume:
	at t: data_out_5;
	at t: not(data_out_sync);
prove:
	at t+1: data_out_5;
	at t+1: acc = acc_at_t;
	at t+1: coef(0) = coef_0_at_t;
	at t+1: coef(1) = coef_1_at_t;
	at t+1: coef(2) = coef_2_at_t;
	at t+1: data_out_sig = data_out_sig_at_t;
	at t+1: shiftreg(0) = shiftreg_0_at_t;
	at t+1: shiftreg(1) = shiftreg_1_at_t;
	at t+1: shiftreg(2) = shiftreg_2_at_t;
	at t+1: data_in_notify = false;
	at t+1: data_out_notify = true;
end property;

