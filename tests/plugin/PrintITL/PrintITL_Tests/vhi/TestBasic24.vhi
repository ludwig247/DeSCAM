-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro b_out_sync : boolean := true end macro;
macro alu_out_notify : boolean := true end  macro;
macro b_out_notify : boolean := true end  macro;
macro reg_out_notify : boolean := true end  macro;


-- DP SIGNALS --
macro alu_in_sig : signed :=resize(0,32) end macro;
macro alu_out_sig : signed :=resize(0,32) end macro;
macro b_out_sig : signed :=resize(0,32) end macro;
macro reg_in_sig : signed :=resize(0,32) end macro;
macro reg_out_sig : signed :=resize(0,32) end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro var1 : signed :=resize(0,32) end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: b_out_sig = resize(5,32);
	 at t: var1 = resize(5,32);
	 at t: alu_out_notify = false;
	 at t: b_out_notify = true;
	 at t: reg_out_notify = false;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	reg_in_sig_at_t = reg_in_sig@t,
	var1_at_t = var1@t;
assume:
	at t: state_1;
	at t: b_out_sync;
prove:
	at t_end: state_2;
	at t_end: alu_out_sig = (5 + reg_in_sig_at_t)(31 downto 0);
	at t_end: var1 = var1_at_t;
	during[t+1, t_end-1]: alu_out_notify = false;
	at t_end: alu_out_notify = true;
	during[t+1, t_end]: b_out_notify = false;
	during[t+1, t_end]: reg_out_notify = false;
end property;


property state_2_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	alu_in_sig_at_t = alu_in_sig@t,
	var1_at_t = var1@t;
assume:
	at t: state_2;
prove:
	at t_end: state_1;
	at t_end: b_out_sig = var1_at_t;
	at t_end: reg_out_sig = alu_in_sig_at_t;
	at t_end: var1 = var1_at_t;
	during[t+1, t_end]: alu_out_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
	during[t+1, t_end-1]: reg_out_notify = false;
	at t_end: reg_out_notify = true;
end property;


property wait_state_1 is
dependencies: no_reset;
freeze:
	b_out_sig_at_t = b_out_sig@t,
	var1_at_t = var1@t;
assume:
	at t: state_1;
	at t: not(b_out_sync);
prove:
	at t+1: state_1;
	at t+1: b_out_sig = b_out_sig_at_t;
	at t+1: var1 = var1_at_t;
	at t+1: alu_out_notify = false;
	at t+1: b_out_notify = true;
	at t+1: reg_out_notify = false;
end property;


