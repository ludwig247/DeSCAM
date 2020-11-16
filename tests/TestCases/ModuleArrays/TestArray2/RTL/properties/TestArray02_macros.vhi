-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro b_in_sync : boolean := b_in_sync_d end macro;
macro b_out_sync : boolean := b_out_sync_d end macro;
macro b_in_notify : boolean := b_in_notify_d end  macro;
macro b_out_notify : boolean := b_out_notify_d end  macro;


-- DP SIGNALS --
macro b_in_sig : signed := b_in end macro;
macro b_out_sig : signed := b_out end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;
constraint b_in_range := b_in >= 0 and b_in < 5; end constraint;


-- VISIBLE REGISTERS --
macro myArray : int_5 := myArray_signal end macro;


-- STATES --
macro state_1 : boolean := (currentstate = IDLE) end macro;
macro state_2 : boolean := (currentstate = WRITEVALUE) end macro;


