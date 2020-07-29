-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro fromMemoryPort_sync : boolean := end macro;
macro toMemoryPort_sync : boolean := end macro;
macro fromMemoryPort_notify : boolean := end macro;
macro toMemoryPort_notify : boolean := end macro;
macro toRegsPort_notify : boolean := end macro;


-- DP SIGNALS --
macro fromMemoryPort_sig : unsigned := end macro;
macro fromRegsPort_sig : unsigned := end macro;
macro toMemoryPort_sig : unsigned := end macro;
macro toRegsPort_sig : unsigned := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro memoryAccess : unsigned := end macro;
macro regfileWrite : unsigned := end macro;


-- STATES --
macro SEC_IF_1 : boolean := true end macro;
macro SEC_IF_2 : boolean := true end macro;
macro SEC_ME_3 : boolean := true end macro;
macro SEC_ME_4 : boolean := true end macro;
macro SEC_ME_5 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: SEC_IF_1;
	 at t: memoryAccess = resize(0,32);
	 at t: regfileWrite = resize(0,32);
	 at t: toMemoryPort_sig = resize(0,32);
	 at t: fromMemoryPort_notify = false;
	 at t: toMemoryPort_notify = true;
	 at t: toRegsPort_notify = false;
end property;


property SEC_IF_1_write_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: SEC_IF_1;
	at t: toMemoryPort_sync;
prove:
	at t_end: SEC_IF_2;
	at t_end: memoryAccess = memoryAccess_at_t;
	at t_end: regfileWrite = regfileWrite_at_t;
	during[t+1, t_end-1]: fromMemoryPort_notify = false;
	at t_end: fromMemoryPort_notify = true;
	during[t+1, t_end]: toMemoryPort_notify = false;
	during[t+1, t_end]: toRegsPort_notify = false;
end property;


property SEC_IF_2_read_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: SEC_IF_2;
	at t: ((fromMemoryPort_sig and resize(127,32)) = resize(3,32));
	at t: fromMemoryPort_sync;
prove:
	at t_end: SEC_ME_3;
	at t_end: memoryAccess = memoryAccess_at_t;
	at t_end: regfileWrite = regfileWrite_at_t;
	at t_end: toMemoryPort_sig = memoryAccess_at_t;
	during[t+1, t_end]: fromMemoryPort_notify = false;
	during[t+1, t_end-1]: toMemoryPort_notify = false;
	at t_end: toMemoryPort_notify = true;
	during[t+1, t_end]: toRegsPort_notify = false;
end property;


property SEC_IF_2_read_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: SEC_IF_2;
	at t: not(((fromMemoryPort_sig and resize(127,32)) = resize(3,32)));
	at t: ((fromMemoryPort_sig and resize(127,32)) = resize(35,32));
	at t: fromMemoryPort_sync;
prove:
	at t_end: SEC_ME_5;
	at t_end: memoryAccess = memoryAccess_at_t;
	at t_end: regfileWrite = regfileWrite_at_t;
	at t_end: toMemoryPort_sig = memoryAccess_at_t;
	during[t+1, t_end]: fromMemoryPort_notify = false;
	during[t+1, t_end-1]: toMemoryPort_notify = false;
	at t_end: toMemoryPort_notify = true;
	during[t+1, t_end]: toRegsPort_notify = false;
end property;


property SEC_IF_2_read_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: SEC_IF_2;
	at t: not(((fromMemoryPort_sig and resize(127,32)) = resize(3,32)));
	at t: not(((fromMemoryPort_sig and resize(127,32)) = resize(35,32)));
	at t: fromMemoryPort_sync;
prove:
	at t_end: SEC_IF_1;
	at t_end: memoryAccess = memoryAccess_at_t;
	at t_end: regfileWrite = regfileWrite_at_t;
	at t_end: toMemoryPort_sig = memoryAccess_at_t;
	at t_end: toRegsPort_sig = regfileWrite_at_t;
	during[t+1, t_end]: fromMemoryPort_notify = false;
	during[t+1, t_end-1]: toMemoryPort_notify = false;
	at t_end: toMemoryPort_notify = true;
	during[t+1, t_end-1]: toRegsPort_notify = false;
	at t_end: toRegsPort_notify = true;
end property;


property SEC_ME_3_write_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: SEC_ME_3;
	at t: toMemoryPort_sync;
prove:
	at t_end: SEC_ME_4;
	at t_end: memoryAccess = memoryAccess_at_t;
	at t_end: regfileWrite = regfileWrite_at_t;
	during[t+1, t_end-1]: fromMemoryPort_notify = false;
	at t_end: fromMemoryPort_notify = true;
	during[t+1, t_end]: toMemoryPort_notify = false;
	during[t+1, t_end]: toRegsPort_notify = false;
end property;


property SEC_ME_4_read_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: SEC_ME_4;
	at t: fromMemoryPort_sync;
prove:
	at t_end: SEC_IF_1;
	at t_end: memoryAccess = memoryAccess_at_t;
	at t_end: regfileWrite = regfileWrite_at_t;
	at t_end: toMemoryPort_sig = memoryAccess_at_t;
	at t_end: toRegsPort_sig = regfileWrite_at_t;
	during[t+1, t_end]: fromMemoryPort_notify = false;
	during[t+1, t_end-1]: toMemoryPort_notify = false;
	at t_end: toMemoryPort_notify = true;
	during[t+1, t_end-1]: toRegsPort_notify = false;
	at t_end: toRegsPort_notify = true;
end property;


property SEC_ME_5_write_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: SEC_ME_5;
	at t: toMemoryPort_sync;
prove:
	at t_end: SEC_IF_1;
	at t_end: memoryAccess = memoryAccess_at_t;
	at t_end: regfileWrite = regfileWrite_at_t;
	at t_end: toMemoryPort_sig = memoryAccess_at_t;
	at t_end: toRegsPort_sig = regfileWrite_at_t;
	during[t+1, t_end]: fromMemoryPort_notify = false;
	during[t+1, t_end-1]: toMemoryPort_notify = false;
	at t_end: toMemoryPort_notify = true;
	during[t+1, t_end-1]: toRegsPort_notify = false;
	at t_end: toRegsPort_notify = true;
end property;


property wait_SEC_IF_1 is
dependencies: no_reset;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: SEC_IF_1;
	at t: not(toMemoryPort_sync);
prove:
	at t+1: SEC_IF_1;
	at t+1: memoryAccess = memoryAccess_at_t;
	at t+1: regfileWrite = regfileWrite_at_t;
	at t+1: toMemoryPort_sig = memoryAccess_at_t;
	at t+1: fromMemoryPort_notify = false;
	at t+1: toMemoryPort_notify = true;
	at t+1: toRegsPort_notify = false;
end property;


property wait_SEC_IF_2 is
dependencies: no_reset;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: SEC_IF_2;
	at t: not(fromMemoryPort_sync);
prove:
	at t+1: SEC_IF_2;
	at t+1: memoryAccess = memoryAccess_at_t;
	at t+1: regfileWrite = regfileWrite_at_t;
	at t+1: fromMemoryPort_notify = true;
	at t+1: toMemoryPort_notify = false;
	at t+1: toRegsPort_notify = false;
end property;


property wait_SEC_ME_3 is
dependencies: no_reset;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: SEC_ME_3;
	at t: not(toMemoryPort_sync);
prove:
	at t+1: SEC_ME_3;
	at t+1: memoryAccess = memoryAccess_at_t;
	at t+1: regfileWrite = regfileWrite_at_t;
	at t+1: toMemoryPort_sig = memoryAccess_at_t;
	at t+1: fromMemoryPort_notify = false;
	at t+1: toMemoryPort_notify = true;
	at t+1: toRegsPort_notify = false;
end property;


property wait_SEC_ME_4 is
dependencies: no_reset;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: SEC_ME_4;
	at t: not(fromMemoryPort_sync);
prove:
	at t+1: SEC_ME_4;
	at t+1: memoryAccess = memoryAccess_at_t;
	at t+1: regfileWrite = regfileWrite_at_t;
	at t+1: fromMemoryPort_notify = true;
	at t+1: toMemoryPort_notify = false;
	at t+1: toRegsPort_notify = false;
end property;


property wait_SEC_ME_5 is
dependencies: no_reset;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: SEC_ME_5;
	at t: not(toMemoryPort_sync);
prove:
	at t+1: SEC_ME_5;
	at t+1: memoryAccess = memoryAccess_at_t;
	at t+1: regfileWrite = regfileWrite_at_t;
	at t+1: toMemoryPort_sig = memoryAccess_at_t;
	at t+1: fromMemoryPort_notify = false;
	at t+1: toMemoryPort_notify = true;
	at t+1: toRegsPort_notify = false;
end property;


