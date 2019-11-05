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
macro state_12 : boolean := true end macro;
macro state_13 : boolean := true end macro;
macro state_17 : boolean := true end macro;
macro state_23 : boolean := true end macro;
macro state_24 : boolean := true end macro;
macro state_27 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_12;
	 at t: memoryAccess = resize(0,32);
	 at t: regfileWrite = resize(0,32);
	 at t: toMemoryPort_sig = resize(0,32);
	 at t: fromMemoryPort_notify = false;
	 at t: toMemoryPort_notify = true;
	 at t: toRegsPort_notify = false;
end property;


property state_12_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: state_12;
	at t: toMemoryPort_sync;
prove:
	at t_end: state_13;
	at t_end: memoryAccess = memoryAccess_at_t;
	at t_end: regfileWrite = regfileWrite_at_t;
	during[t+1, t_end-1]: fromMemoryPort_notify = false;
	at t_end: fromMemoryPort_notify = true;
	during[t+1, t_end]: toMemoryPort_notify = false;
	during[t+1, t_end]: toRegsPort_notify = false;
end property;


property state_13_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: state_13;
	at t: fromMemoryPort_sync;
prove:
	at t_end: state_17;
	at t_end: memoryAccess = memoryAccess_at_t;
	at t_end: regfileWrite = regfileWrite_at_t;
	during[t+1, t_end]: fromMemoryPort_notify = false;
	during[t+1, t_end]: toMemoryPort_notify = false;
	during[t+1, t_end]: toRegsPort_notify = false;
end property;


property state_17_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: state_17;
prove:
	at t_end: state_17;
	at t_end: memoryAccess = memoryAccess_at_t;
	at t_end: regfileWrite = regfileWrite_at_t;
	during[t+1, t_end]: fromMemoryPort_notify = false;
	during[t+1, t_end]: toMemoryPort_notify = false;
	during[t+1, t_end]: toRegsPort_notify = false;
end property;


property state_23_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: state_23;
	at t: toMemoryPort_sync;
prove:
	at t_end: state_24;
	at t_end: memoryAccess = memoryAccess_at_t;
	at t_end: regfileWrite = regfileWrite_at_t;
	during[t+1, t_end-1]: fromMemoryPort_notify = false;
	at t_end: fromMemoryPort_notify = true;
	during[t+1, t_end]: toMemoryPort_notify = false;
	during[t+1, t_end]: toRegsPort_notify = false;
end property;


property state_24_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: state_24;
	at t: fromMemoryPort_sync;
prove:
	at t_end: state_12;
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


property state_27_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: state_27;
	at t: toMemoryPort_sync;
prove:
	at t_end: state_12;
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


property wait_state_12 is
dependencies: no_reset;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: state_12;
	at t: not(toMemoryPort_sync);
prove:
	at t+1: state_12;
	at t+1: memoryAccess = memoryAccess_at_t;
	at t+1: regfileWrite = regfileWrite_at_t;
	at t+1: toMemoryPort_sig = memoryAccess_at_t;
	at t+1: fromMemoryPort_notify = false;
	at t+1: toMemoryPort_notify = true;
	at t+1: toRegsPort_notify = false;
end property;


property wait_state_13 is
dependencies: no_reset;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: state_13;
	at t: not(fromMemoryPort_sync);
prove:
	at t+1: state_13;
	at t+1: memoryAccess = memoryAccess_at_t;
	at t+1: regfileWrite = regfileWrite_at_t;
	at t+1: fromMemoryPort_notify = true;
	at t+1: toMemoryPort_notify = false;
	at t+1: toRegsPort_notify = false;
end property;


property wait_state_23 is
dependencies: no_reset;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: state_23;
	at t: not(toMemoryPort_sync);
prove:
	at t+1: state_23;
	at t+1: memoryAccess = memoryAccess_at_t;
	at t+1: regfileWrite = regfileWrite_at_t;
	at t+1: toMemoryPort_sig = memoryAccess_at_t;
	at t+1: fromMemoryPort_notify = false;
	at t+1: toMemoryPort_notify = true;
	at t+1: toRegsPort_notify = false;
end property;


property wait_state_24 is
dependencies: no_reset;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: state_24;
	at t: not(fromMemoryPort_sync);
prove:
	at t+1: state_24;
	at t+1: memoryAccess = memoryAccess_at_t;
	at t+1: regfileWrite = regfileWrite_at_t;
	at t+1: fromMemoryPort_notify = true;
	at t+1: toMemoryPort_notify = false;
	at t+1: toRegsPort_notify = false;
end property;


property wait_state_27 is
dependencies: no_reset;
freeze:
	memoryAccess_at_t = memoryAccess@t,
	regfileWrite_at_t = regfileWrite@t;
assume:
	at t: state_27;
	at t: not(toMemoryPort_sync);
prove:
	at t+1: state_27;
	at t+1: memoryAccess = memoryAccess_at_t;
	at t+1: regfileWrite = regfileWrite_at_t;
	at t+1: toMemoryPort_sig = memoryAccess_at_t;
	at t+1: fromMemoryPort_notify = false;
	at t+1: toMemoryPort_notify = true;
	at t+1: toRegsPort_notify = false;
end property;


