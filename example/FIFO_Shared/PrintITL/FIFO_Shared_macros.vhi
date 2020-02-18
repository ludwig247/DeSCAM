-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --


-- DP SIGNALS --
macro consumer_notify_sig : boolean := end macro;
macro consumer_sig_sig : signed := end macro;
macro consumer_sync_sig : boolean := end macro;
macro producer_notify_sig : boolean := end macro;
macro producer_sig_sig : signed := end macro;
macro producer_sync_sig : boolean := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro buffer : int_3 := end macro;
macro head : signed := end macro;
macro state : states := end macro;
macro tail : signed := end macro;


-- STATES --
macro empty_1 : boolean := true end macro;
macro filled_2 : boolean := true end macro;
macro full_3 : boolean := true end macro;


