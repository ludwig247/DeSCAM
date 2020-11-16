-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro b_in_sync : boolean := b_in_sync_d end macro;
macro b_out_sync : boolean := b_out_sync_d end macro;
macro b_in_notify : boolean := b_in_notify_d end  macro;
macro b_out_notify : boolean := b_out_notify_d end  macro;


-- DP SIGNALS --
macro b_in_sig : int_5 := b_in end macro;
macro b_in_sig_0 : signed := b_in(0) end macro;
macro b_in_sig_1 : signed := b_in(1) end macro;
macro b_in_sig_2 : signed := b_in(2) end macro;
macro b_in_sig_3 : signed := b_in(3) end macro;
macro b_in_sig_4 : signed := b_in(4) end macro;
macro b_out_sig : signed := b_out end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --


-- STATES --
macro state_1 : boolean := (currentstate = IDLE) end macro;
macro state_2 : boolean := (currentstate = WRITEVALUE) end macro;


