-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro data_in_sync : boolean := data_in_sync end macro;
--macro data_out_sync : boolean := data_out_sync end macro;
--macro data_in_notify : boolean := data_in_notify end  macro;
--macro data_out_notify : boolean := data_out_notify end  macro;


-- DP SIGNALS --
macro data_in_sig : signed := data_in end macro;
macro data_out_sig : signed := data_out end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;
constraint data_in_restr := ((data_in < resize(2,32)) and (data_in >= resize(0,32))); end constraint;


-- VISIBLE REGISTERS --
macro acc : signed := acc_signal end macro;
macro coef : int_3 := coef_signal end macro;
macro data_algorithm : signed := data_algorithm_signal end macro;
macro shiftreg : int_3 := shiftreg_signal end macro;


-- STATES --
macro data_in_1 : boolean := ((data_in_notify = true)
		and (data_out_notify = false)
		and (phase_algorithm_signal = IDLE))
		and coef(0) = 1  
		and coef(1) = 1 
		and coef(2) = 1
		and shiftreg(0) = 0
		and shiftreg(1) = 0
		and shiftreg(2) = 0
		and data_algorithm = 0
		and acc = 0 end macro;
macro C1_2 : boolean := ((data_in_notify = false)
		and (data_out_notify = false)
		and (phase_algorithm_signal = RUN_C1)) end macro;
macro C2_3 : boolean := ((data_in_notify = false)
		and (data_out_notify = false)
		and (phase_algorithm_signal = RUN_C2)) end macro;
macro C3_4 : boolean := ((data_in_notify = false)
		and (data_out_notify = false)
		and (phase_algorithm_signal = RUN_C3)) end macro;
macro data_out_5 : boolean := ((data_in_notify = false)
		and (data_out_notify = true)
		and (phase_algorithm_signal = RUN_OUT)) end macro;


