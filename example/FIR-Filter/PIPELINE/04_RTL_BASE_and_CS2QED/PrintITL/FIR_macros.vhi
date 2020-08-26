-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro p1_data_in_sync : boolean := p1_inst/data_in_sync  end macro;
macro p1_data_out_sync : boolean := p1_inst/data_out_sync  end macro;
macro p1_data_in_notify : boolean := p1_inst/data_in_notify end  macro;
macro p1_data_out_notify : boolean := p1_inst/data_out_notify  end  macro;

macro p2_data_in_sync : boolean := p2_inst/data_in_sync  end macro;
macro p2_data_out_sync : boolean := p2_inst/data_out_sync end macro;
macro p2_data_in_notify : boolean := p2_inst/data_in_notify end  macro;
macro p2_data_out_notify : boolean := p2_inst/data_out_notify end  macro;

-- DP SIGNALS --
macro p1_data_in_sig : signed := p1_inst/data_in end macro;
macro p1_data_out_sig : signed := p1_inst/data_out end macro;

macro p2_data_in_sig : signed := p2_inst/data_in end macro;
macro p2_data_out_sig : signed := p2_inst/data_out end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;
constraint data_in_restr := ((p1_data_in_sig < resize(8,32)) and (p1_data_in_sig >= resize(0,32))); end constraint;


-- VISIBLE REGISTERS --
macro p1_acc_IN : signed := p1_inst/acc_signal_IN end macro;
macro p1_acc_C1 : signed := p1_inst/acc_signal_C1 end macro;
macro p1_acc_C2 : signed := p1_inst/acc_signal_C2 end macro;
macro p1_acc_C3 : signed := p1_inst/acc_signal_C3 end macro;
macro p1_coef : signed := p1_inst/coef_signal end macro;
macro p1_data_algorithm : signed := p1_inst/data_algorithm_signal end macro;
macro p1_shiftreg : int_3 := p1_inst/shiftreg_signal end macro;

macro p2_acc_IN : signed := p2_inst/acc_signal_IN end macro;
macro p2_acc_C1 : signed := p2_inst/acc_signal_C1 end macro;
macro p2_acc_C2 : signed := p2_inst/acc_signal_C2 end macro;
macro p2_acc_C3 : signed := p2_inst/acc_signal_C3 end macro;
macro p2_coef : signed := p2_inst/coef_signal end macro;
macro p2_data_algorithm : signed := p2_inst/data_algorithm_signal end macro;
macro p2_shiftreg : int_3 := p2_inst/shiftreg_signal end macro;



constraint liveness := disable iff: not(reset_n);
    if (notify) then
        exists i in 0..(max_wait-1):
            next(sync,i);
        end exists;
    end if;
end constraint;

-- STATES --
macro data_in_1 : boolean := (p1_data_in_notify = true)
		and (p1_data_out_notify = false)
		and p1_coef = 1  
		and p1_shiftreg(0) = 0
		and p1_shiftreg(1) = 0
		and p1_shiftreg(2) = 0
		and p1_data_algorithm = 0
		and p1_acc_IN = 0 end macro;
macro C1_2 : boolean := (p1_data_in_notify = false)
		and (p1_data_out_notify = false) end macro;
macro C2_3 : boolean := (p1_data_in_notify = false)
		and (p1_data_out_notify = false) end macro;
macro C3_4 : boolean := (p1_data_in_notify = false)
		and (p1_data_out_notify = false) end macro;
macro data_out_5 : boolean := (p1_data_in_notify = false)
		and (p1_data_out_notify = true) end macro;


