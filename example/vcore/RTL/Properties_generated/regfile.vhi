-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro toRegsPort_sync : boolean := wb_valid and wb_write_reg  end macro;


-- DP SIGNALS --
macro fromRegsPort_sig : array of unsigned := regfile end macro;
macro toRegsPort_sig_dest : unsigned := wb_dest_reg end macro;
macro toRegsPort_sig_value : unsigned := wb_result end macro;


-- CONSTRAINTS --
--constraint no_reset := reset_n = '1'; end constraint;


-- VISIBLE REGISTERS --
--macro regfile : array of unsigned := regfile end macro;


-- STATES --
macro state_1 : boolean := true end macro;

property state_1_1 is
dependencies: no_reset;
freeze:
	regfile_1_at_t = regfile(1)@t,
	regfile_2_at_t = regfile(2)@t,
	regfile_3_at_t = regfile(3)@t,
	regfile_4_at_t = regfile(4)@t,
	regfile_5_at_t = regfile(5)@t,
	regfile_6_at_t = regfile(6)@t,
	regfile_7_at_t = regfile(7)@t,
	toRegsPort_sig_value_at_t = toRegsPort_sig_value@t;
assume:
	at t: state_1;
	at t: toRegsPort_sync;
	at t: (toRegsPort_sig_dest = resize(0,32));
prove:
	at t+1: state_1;
	at t+1: fromRegsPort_sig(0) = toRegsPort_sig_value_at_t;
	at t+1: fromRegsPort_sig(1) = regfile_1_at_t;
	at t+1: fromRegsPort_sig(2) = regfile_2_at_t;
	at t+1: fromRegsPort_sig(3) = regfile_3_at_t;
	at t+1: fromRegsPort_sig(4) = regfile_4_at_t;
	at t+1: fromRegsPort_sig(5) = regfile_5_at_t;
	at t+1: fromRegsPort_sig(6) = regfile_6_at_t;
	at t+1: fromRegsPort_sig(7) = regfile_7_at_t;
	at t+1: regfile(0) = toRegsPort_sig_value_at_t;
	at t+1: regfile(1) = regfile_1_at_t;
	at t+1: regfile(2) = regfile_2_at_t;
	at t+1: regfile(3) = regfile_3_at_t;
	at t+1: regfile(4) = regfile_4_at_t;
	at t+1: regfile(5) = regfile_5_at_t;
	at t+1: regfile(6) = regfile_6_at_t;
	at t+1: regfile(7) = regfile_7_at_t;
end property;


property state_1_3 is
dependencies: no_reset;
freeze:
	regfile_0_at_t = regfile(0)@t,
	regfile_2_at_t = regfile(2)@t,
	regfile_3_at_t = regfile(3)@t,
	regfile_4_at_t = regfile(4)@t,
	regfile_5_at_t = regfile(5)@t,
	regfile_6_at_t = regfile(6)@t,
	regfile_7_at_t = regfile(7)@t,
	toRegsPort_sig_value_at_t = toRegsPort_sig_value@t;
assume:
	at t: state_1;
	at t: toRegsPort_sync;
	at t: (toRegsPort_sig_dest = resize(1,32));
prove:
	at t+1: state_1;
	at t+1: fromRegsPort_sig(0) = regfile_0_at_t;
	at t+1: fromRegsPort_sig(1) = toRegsPort_sig_value_at_t;
	at t+1: fromRegsPort_sig(2) = regfile_2_at_t;
	at t+1: fromRegsPort_sig(3) = regfile_3_at_t;
	at t+1: fromRegsPort_sig(4) = regfile_4_at_t;
	at t+1: fromRegsPort_sig(5) = regfile_5_at_t;
	at t+1: fromRegsPort_sig(6) = regfile_6_at_t;
	at t+1: fromRegsPort_sig(7) = regfile_7_at_t;
	at t+1: regfile(0) = regfile_0_at_t;
	at t+1: regfile(1) = toRegsPort_sig_value_at_t;
	at t+1: regfile(2) = regfile_2_at_t;
	at t+1: regfile(3) = regfile_3_at_t;
	at t+1: regfile(4) = regfile_4_at_t;
	at t+1: regfile(5) = regfile_5_at_t;
	at t+1: regfile(6) = regfile_6_at_t;
	at t+1: regfile(7) = regfile_7_at_t;
end property;


property state_1_5 is
dependencies: no_reset;
freeze:
	regfile_0_at_t = regfile(0)@t,
	regfile_1_at_t = regfile(1)@t,
	regfile_3_at_t = regfile(3)@t,
	regfile_4_at_t = regfile(4)@t,
	regfile_5_at_t = regfile(5)@t,
	regfile_6_at_t = regfile(6)@t,
	regfile_7_at_t = regfile(7)@t,
	toRegsPort_sig_value_at_t = toRegsPort_sig_value@t;
assume:
	at t: state_1;
	at t: toRegsPort_sync;
	at t: (toRegsPort_sig_dest = resize(2,32));
prove:
	at t+1: state_1;
	at t+1: fromRegsPort_sig(0) = regfile_0_at_t;
	at t+1: fromRegsPort_sig(1) = regfile_1_at_t;
	at t+1: fromRegsPort_sig(2) = toRegsPort_sig_value_at_t;
	at t+1: fromRegsPort_sig(3) = regfile_3_at_t;
	at t+1: fromRegsPort_sig(4) = regfile_4_at_t;
	at t+1: fromRegsPort_sig(5) = regfile_5_at_t;
	at t+1: fromRegsPort_sig(6) = regfile_6_at_t;
	at t+1: fromRegsPort_sig(7) = regfile_7_at_t;
	at t+1: regfile(0) = regfile_0_at_t;
	at t+1: regfile(1) = regfile_1_at_t;
	at t+1: regfile(2) = toRegsPort_sig_value_at_t;
	at t+1: regfile(3) = regfile_3_at_t;
	at t+1: regfile(4) = regfile_4_at_t;
	at t+1: regfile(5) = regfile_5_at_t;
	at t+1: regfile(6) = regfile_6_at_t;
	at t+1: regfile(7) = regfile_7_at_t;
end property;


property state_1_7 is
dependencies: no_reset;
freeze:
	regfile_0_at_t = regfile(0)@t,
	regfile_1_at_t = regfile(1)@t,
	regfile_2_at_t = regfile(2)@t,
	regfile_4_at_t = regfile(4)@t,
	regfile_5_at_t = regfile(5)@t,
	regfile_6_at_t = regfile(6)@t,
	regfile_7_at_t = regfile(7)@t,
	toRegsPort_sig_value_at_t = toRegsPort_sig_value@t;
assume:
	at t: state_1;
	at t: toRegsPort_sync;
	at t: (toRegsPort_sig_dest = resize(3,32));
prove:
	at t+1: state_1;
	at t+1: fromRegsPort_sig(0) = regfile_0_at_t;
	at t+1: fromRegsPort_sig(1) = regfile_1_at_t;
	at t+1: fromRegsPort_sig(2) = regfile_2_at_t;
	at t+1: fromRegsPort_sig(3) = toRegsPort_sig_value_at_t;
	at t+1: fromRegsPort_sig(4) = regfile_4_at_t;
	at t+1: fromRegsPort_sig(5) = regfile_5_at_t;
	at t+1: fromRegsPort_sig(6) = regfile_6_at_t;
	at t+1: fromRegsPort_sig(7) = regfile_7_at_t;
	at t+1: regfile(0) = regfile_0_at_t;
	at t+1: regfile(1) = regfile_1_at_t;
	at t+1: regfile(2) = regfile_2_at_t;
	at t+1: regfile(3) = toRegsPort_sig_value_at_t;
	at t+1: regfile(4) = regfile_4_at_t;
	at t+1: regfile(5) = regfile_5_at_t;
	at t+1: regfile(6) = regfile_6_at_t;
	at t+1: regfile(7) = regfile_7_at_t;
end property;


property state_1_9 is
dependencies: no_reset;
freeze:
	regfile_0_at_t = regfile(0)@t,
	regfile_1_at_t = regfile(1)@t,
	regfile_2_at_t = regfile(2)@t,
	regfile_3_at_t = regfile(3)@t,
	regfile_5_at_t = regfile(5)@t,
	regfile_6_at_t = regfile(6)@t,
	regfile_7_at_t = regfile(7)@t,
	toRegsPort_sig_value_at_t = toRegsPort_sig_value@t;
assume:
	at t: state_1;
	at t: toRegsPort_sync;
	at t: (toRegsPort_sig_dest = resize(4,32));
prove:
	at t+1: state_1;
	at t+1: fromRegsPort_sig(0) = regfile_0_at_t;
	at t+1: fromRegsPort_sig(1) = regfile_1_at_t;
	at t+1: fromRegsPort_sig(2) = regfile_2_at_t;
	at t+1: fromRegsPort_sig(3) = regfile_3_at_t;
	at t+1: fromRegsPort_sig(4) = toRegsPort_sig_value_at_t;
	at t+1: fromRegsPort_sig(5) = regfile_5_at_t;
	at t+1: fromRegsPort_sig(6) = regfile_6_at_t;
	at t+1: fromRegsPort_sig(7) = regfile_7_at_t;
	at t+1: regfile(0) = regfile_0_at_t;
	at t+1: regfile(1) = regfile_1_at_t;
	at t+1: regfile(2) = regfile_2_at_t;
	at t+1: regfile(3) = regfile_3_at_t;
	at t+1: regfile(4) = toRegsPort_sig_value_at_t;
	at t+1: regfile(5) = regfile_5_at_t;
	at t+1: regfile(6) = regfile_6_at_t;
	at t+1: regfile(7) = regfile_7_at_t;
end property;


property state_1_11 is
dependencies: no_reset;
freeze:
	regfile_0_at_t = regfile(0)@t,
	regfile_1_at_t = regfile(1)@t,
	regfile_2_at_t = regfile(2)@t,
	regfile_3_at_t = regfile(3)@t,
	regfile_4_at_t = regfile(4)@t,
	regfile_6_at_t = regfile(6)@t,
	regfile_7_at_t = regfile(7)@t,
	toRegsPort_sig_value_at_t = toRegsPort_sig_value@t;
assume:
	at t: state_1;
	at t: toRegsPort_sync;
	at t: (toRegsPort_sig_dest = resize(5,32));
prove:
	at t+1: state_1;
	at t+1: fromRegsPort_sig(0) = regfile_0_at_t;
	at t+1: fromRegsPort_sig(1) = regfile_1_at_t;
	at t+1: fromRegsPort_sig(2) = regfile_2_at_t;
	at t+1: fromRegsPort_sig(3) = regfile_3_at_t;
	at t+1: fromRegsPort_sig(4) = regfile_4_at_t;
	at t+1: fromRegsPort_sig(5) = toRegsPort_sig_value_at_t;
	at t+1: fromRegsPort_sig(6) = regfile_6_at_t;
	at t+1: fromRegsPort_sig(7) = regfile_7_at_t;
	at t+1: regfile(0) = regfile_0_at_t;
	at t+1: regfile(1) = regfile_1_at_t;
	at t+1: regfile(2) = regfile_2_at_t;
	at t+1: regfile(3) = regfile_3_at_t;
	at t+1: regfile(4) = regfile_4_at_t;
	at t+1: regfile(5) = toRegsPort_sig_value_at_t;
	at t+1: regfile(6) = regfile_6_at_t;
	at t+1: regfile(7) = regfile_7_at_t;
end property;


property state_1_13 is
dependencies: no_reset;
freeze:
	regfile_0_at_t = regfile(0)@t,
	regfile_1_at_t = regfile(1)@t,
	regfile_2_at_t = regfile(2)@t,
	regfile_3_at_t = regfile(3)@t,
	regfile_4_at_t = regfile(4)@t,
	regfile_5_at_t = regfile(5)@t,
	regfile_7_at_t = regfile(7)@t,
	toRegsPort_sig_value_at_t = toRegsPort_sig_value@t;
assume:
	at t: state_1;
	at t: toRegsPort_sync;
	at t: (toRegsPort_sig_dest = resize(6,32));
prove:
	at t+1: state_1;
	at t+1: fromRegsPort_sig(0) = regfile_0_at_t;
	at t+1: fromRegsPort_sig(1) = regfile_1_at_t;
	at t+1: fromRegsPort_sig(2) = regfile_2_at_t;
	at t+1: fromRegsPort_sig(3) = regfile_3_at_t;
	at t+1: fromRegsPort_sig(4) = regfile_4_at_t;
	at t+1: fromRegsPort_sig(5) = regfile_5_at_t;
	at t+1: fromRegsPort_sig(6) = toRegsPort_sig_value_at_t;
	at t+1: fromRegsPort_sig(7) = regfile_7_at_t;
	at t+1: regfile(0) = regfile_0_at_t;
	at t+1: regfile(1) = regfile_1_at_t;
	at t+1: regfile(2) = regfile_2_at_t;
	at t+1: regfile(3) = regfile_3_at_t;
	at t+1: regfile(4) = regfile_4_at_t;
	at t+1: regfile(5) = regfile_5_at_t;
	at t+1: regfile(6) = toRegsPort_sig_value_at_t;
	at t+1: regfile(7) = regfile_7_at_t;
end property;


property state_1_15 is
dependencies: no_reset;
freeze:
	regfile_0_at_t = regfile(0)@t,
	regfile_1_at_t = regfile(1)@t,
	regfile_2_at_t = regfile(2)@t,
	regfile_3_at_t = regfile(3)@t,
	regfile_4_at_t = regfile(4)@t,
	regfile_5_at_t = regfile(5)@t,
	regfile_6_at_t = regfile(6)@t,
	toRegsPort_sig_value_at_t = toRegsPort_sig_value@t;
assume:
	at t: state_1;
	at t: toRegsPort_sync;
	at t: not((toRegsPort_sig_dest = resize(0,32)));
	at t: not((toRegsPort_sig_dest = resize(1,32)));
	at t: not((toRegsPort_sig_dest = resize(2,32)));
	at t: not((toRegsPort_sig_dest = resize(3,32)));
	at t: not((toRegsPort_sig_dest = resize(4,32)));
	at t: not((toRegsPort_sig_dest = resize(5,32)));
	at t: not((toRegsPort_sig_dest = resize(6,32)));
prove:
	at t+1: state_1;
	at t+1: fromRegsPort_sig(0) = regfile_0_at_t;
	at t+1: fromRegsPort_sig(1) = regfile_1_at_t;
	at t+1: fromRegsPort_sig(2) = regfile_2_at_t;
	at t+1: fromRegsPort_sig(3) = regfile_3_at_t;
	at t+1: fromRegsPort_sig(4) = regfile_4_at_t;
	at t+1: fromRegsPort_sig(5) = regfile_5_at_t;
	at t+1: fromRegsPort_sig(6) = regfile_6_at_t;
	at t+1: fromRegsPort_sig(7) = toRegsPort_sig_value_at_t;
	at t+1: regfile(0) = regfile_0_at_t;
	at t+1: regfile(1) = regfile_1_at_t;
	at t+1: regfile(2) = regfile_2_at_t;
	at t+1: regfile(3) = regfile_3_at_t;
	at t+1: regfile(4) = regfile_4_at_t;
	at t+1: regfile(5) = regfile_5_at_t;
	at t+1: regfile(6) = regfile_6_at_t;
	at t+1: regfile(7) = toRegsPort_sig_value_at_t;
end property;


property state_1_18 is
dependencies: no_reset;
freeze:
	regfile_0_at_t = regfile(0)@t,
	regfile_1_at_t = regfile(1)@t,
	regfile_2_at_t = regfile(2)@t,
	regfile_3_at_t = regfile(3)@t,
	regfile_4_at_t = regfile(4)@t,
	regfile_5_at_t = regfile(5)@t,
	regfile_6_at_t = regfile(6)@t,
	regfile_7_at_t = regfile(7)@t;
assume:
	at t: state_1;
	at t: not(toRegsPort_sync);
prove:
	at t+1: state_1;
	at t+1: fromRegsPort_sig(0) = regfile_0_at_t;
	at t+1: fromRegsPort_sig(1) = regfile_1_at_t;
	at t+1: fromRegsPort_sig(2) = regfile_2_at_t;
	at t+1: fromRegsPort_sig(3) = regfile_3_at_t;
	at t+1: fromRegsPort_sig(4) = regfile_4_at_t;
	at t+1: fromRegsPort_sig(5) = regfile_5_at_t;
	at t+1: fromRegsPort_sig(6) = regfile_6_at_t;
	at t+1: fromRegsPort_sig(7) = regfile_7_at_t;
	at t+1: regfile(0) = regfile_0_at_t;
	at t+1: regfile(1) = regfile_1_at_t;
	at t+1: regfile(2) = regfile_2_at_t;
	at t+1: regfile(3) = regfile_3_at_t;
	at t+1: regfile(4) = regfile_4_at_t;
	at t+1: regfile(5) = regfile_5_at_t;
	at t+1: regfile(6) = regfile_6_at_t;
	at t+1: regfile(7) = regfile_7_at_t;
end property;