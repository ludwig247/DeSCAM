-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro b_in_sync : boolean := b_in_sync_d end macro;
macro b_out_sync : boolean := b_out_sync_d end macro;
macro b_in_notify : boolean := b_in_notify_d end  macro;
macro b_out_notify : boolean := b_out_notify_d end  macro;


-- DP SIGNALS --
macro b_in_sig : signed := b_in_d end macro;
macro b_out_sig : int_2 := b_out_d end macro;
macro b_out_sig_0 : signed := b_out_d(0) end macro;
macro b_out_sig_1 : signed := b_out_d(1) end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro myArray : int_2 := myArray_signal_d end macro;


-- STATES --
macro state_1 : boolean := (currentstate = IDLE) end macro;
macro state_2 : boolean := (currentstate = WRITEVALUE) end macro;


