-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro alu_out_notify : boolean := true end  macro;
macro reg_out_notify : boolean := true end  macro;


-- DP SIGNALS --
macro alu_in_sig : signed :=resize(0,32) end macro;
macro alu_out_sig : signed :=resize(0,32) end macro;
macro reg_in_sig : signed :=resize(0,32) end macro;
macro reg_out_sig : signed :=resize(0,32) end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --


-- STATES --
macro state_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: alu_out_sig = (resize(5,32) + reg_in_sig)(31 downto 0);
	 at t: alu_out_notify = true;
	 at t: reg_out_notify = false;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	alu_in_sig_at_t = alu_in_sig@t;
assume:
	at t: state_1;
prove:
	at t_end: state_2;
	at t_end: reg_out_sig = alu_in_sig_at_t;
	during[t+1, t_end]: alu_out_notify = false;
	during[t+1, t_end-1]: reg_out_notify = false;
	at t_end: reg_out_notify = true;
end property;


property state_2_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	reg_in_sig_at_t = reg_in_sig@t;
assume:
	at t: state_2;
prove:
	at t_end: state_1;
	at t_end: alu_out_sig = (5 + reg_in_sig_at_t)(31 downto 0);
	during[t+1, t_end-1]: alu_out_notify = false;
	at t_end: alu_out_notify = true;
	during[t+1, t_end]: reg_out_notify = false;
end property;


