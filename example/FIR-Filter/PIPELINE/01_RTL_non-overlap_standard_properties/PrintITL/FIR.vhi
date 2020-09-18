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


property C1_2_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	acc_at_t = acc@t,
	coef_0_at_t = coef(0)@t,
	coef_1_at_t = coef(1)@t,
	coef_2_at_t = coef(2)@t,
	shiftreg_0_at_t = shiftreg(0)@t,
	shiftreg_1_at_t = shiftreg(1)@t,
	shiftreg_2_at_t = shiftreg(2)@t;
assume:
	at t: C1_2;
prove:
	at t_end: C2_3;
	at t_end: acc = (acc_at_t + (coef_2_at_t * shiftreg_2_at_t)(31 downto 0))(31 downto 0);
	at t_end: coef(0) = coef_0_at_t;
	at t_end: coef(1) = coef_1_at_t;
	at t_end: coef(2) = coef_2_at_t;
	at t_end: shiftreg(0) = shiftreg_0_at_t;
	at t_end: shiftreg(1) = shiftreg_1_at_t;
	at t_end: shiftreg(2) = shiftreg_2_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end]: data_out_notify = false;
end property;


property C2_3_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	acc_at_t = acc@t,
	coef_0_at_t = coef(0)@t,
	coef_1_at_t = coef(1)@t,
	coef_2_at_t = coef(2)@t,
	shiftreg_0_at_t = shiftreg(0)@t,
	shiftreg_1_at_t = shiftreg(1)@t,
	shiftreg_2_at_t = shiftreg(2)@t;
assume:
	at t: C2_3;
prove:
	at t_end: C3_4;
	at t_end: acc = (acc_at_t + (coef_1_at_t * shiftreg_1_at_t)(31 downto 0))(31 downto 0);
	at t_end: coef(0) = coef_0_at_t;
	at t_end: coef(1) = coef_1_at_t;
	at t_end: coef(2) = coef_2_at_t;
	at t_end: shiftreg(0) = shiftreg_0_at_t;
	at t_end: shiftreg(1) = shiftreg_1_at_t;
	at t_end: shiftreg(2) = shiftreg_2_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end]: data_out_notify = false;
end property;


property C3_4_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	acc_at_t = acc@t,
	coef_0_at_t = coef(0)@t,
	coef_1_at_t = coef(1)@t,
	shiftreg_0_at_t = shiftreg(0)@t,
	shiftreg_1_at_t = shiftreg(1)@t,
	shiftreg_2_at_t = shiftreg(2)@t;
assume:
	at t: C3_4;
	--------
	at t-3: data_in < resize(4,32) and data_in >= resize(0,32);
	--------
prove:
	at t_end: data_out_5;
	at t_end: acc = (acc_at_t + (coef_0_at_t * shiftreg_0_at_t)(31 downto 0))(31 downto 0);
	at t_end: coef(0) = (acc_at_t + (coef_0_at_t * shiftreg_0_at_t)(31 downto 0))(31 downto 0);
	at t_end: coef(1) = coef_0_at_t;
	at t_end: coef(2) = coef_1_at_t;
	at t_end: data_out_sig = (acc_at_t + (coef_0_at_t * shiftreg_0_at_t)(31 downto 0))(31 downto 0);
	at t_end: shiftreg(0) = shiftreg_0_at_t;
	at t_end: shiftreg(1) = shiftreg_1_at_t;
	at t_end: shiftreg(2) = shiftreg_2_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
end property;


property data_in_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	coef_0_at_t = coef(0)@t,
	coef_1_at_t = coef(1)@t,
	coef_2_at_t = coef(2)@t,
	data_in_sig_at_t = data_in_sig@t,
	shiftreg_0_at_t = shiftreg(0)@t,
	shiftreg_1_at_t = shiftreg(1)@t;
assume:
	at t: data_in_1;
	at t: data_in_sync;
prove:
	at t_end: C1_2;
	at t_end: acc = 0;
	at t_end: coef(0) = coef_0_at_t;
	at t_end: coef(1) = coef_1_at_t;
	at t_end: coef(2) = coef_2_at_t;
	at t_end: shiftreg(0) = data_in_sig_at_t;
	at t_end: shiftreg(1) = shiftreg_0_at_t;
	at t_end: shiftreg(2) = shiftreg_1_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end]: data_out_notify = false;
end property;


property data_out_5_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	acc_at_t = acc@t,
	coef_0_at_t = coef(0)@t,
	coef_1_at_t = coef(1)@t,
	coef_2_at_t = coef(2)@t,
	shiftreg_0_at_t = shiftreg(0)@t,
	shiftreg_1_at_t = shiftreg(1)@t,
	shiftreg_2_at_t = shiftreg(2)@t;
assume:
	at t: data_out_5;
	at t: data_out_sync;
prove:
	at t_end: data_in_1;
	at t_end: acc = acc_at_t;
	at t_end: coef(0) = coef_0_at_t;
	at t_end: coef(1) = coef_1_at_t;
	at t_end: coef(2) = coef_2_at_t;
	at t_end: shiftreg(0) = shiftreg_0_at_t;
	at t_end: shiftreg(1) = shiftreg_1_at_t;
	at t_end: shiftreg(2) = shiftreg_2_at_t;
	during[t+1, t_end-1]: data_in_notify = false;
	at t_end: data_in_notify = true;
	during[t+1, t_end]: data_out_notify = false;
end property;


property wait_data_in_1 is
dependencies: no_reset;
freeze:
	acc_at_t = acc@t,
	coef_0_at_t = coef(0)@t,
	coef_1_at_t = coef(1)@t,
	coef_2_at_t = coef(2)@t,
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
	acc_at_t = acc@t,
	coef_0_at_t = coef(0)@t,
	coef_1_at_t = coef(1)@t,
	coef_2_at_t = coef(2)@t,
	data_out_sig_at_t = data_out_sig@t,
	shiftreg_0_at_t = shiftreg(0)@t,
	shiftreg_1_at_t = shiftreg(1)@t,
	shiftreg_2_at_t = shiftreg(2)@t;
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


