-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --


-- DP SIGNALS --
macro consumer_notify_sig : boolean := consumer_notify end macro;
macro consumer_sig_sig : signed := consumer end macro;
macro consumer_sync_sig : boolean := consumer_sync end macro;
macro producer_notify_sig : boolean := producer_notify end macro;
macro producer_sig_sig : signed := producer end macro;
macro producer_sync_sig : boolean := producer_sync end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro buffer : int_array := fifo end macro; --NOTE: changed int_3 to int_array
--macro head : signed := end macro;
--macro state : states := end macro;
--macro tail : signed := end macro;


-- STATES --
macro filled_2 : boolean := state = FILLED and (head < 3) and (tail < 3) and not(head = tail) end macro;
macro full_3 : boolean := state = FULL and (head < 3) and (tail < 3) and (head = tail) end macro;
macro empty_1 : boolean := state = EMPTY and (head < 3) and (tail < 3) and (tail < 3) and (head = tail) end macro;