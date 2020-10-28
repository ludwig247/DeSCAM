-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro rxd_sync : boolean := true end macro;
macro events_out_notify : boolean := true end  macro;
macro rxd_notify : boolean := true end  macro;


-- DP SIGNALS --
--macro events_out_sig : rx_events_t :={resize(0,32), false, false} end macro;
macro events_out_sig_error_src : unsigned :=resize(0,32) end macro;
macro events_out_sig_ready : boolean :=false end macro;
macro events_out_sig_timeout : boolean :=false end macro;
macro rxd_sig : boolean :=false end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro events_out_msg_timeout : boolean :=false end macro;


-- STATES --
macro IDLE_1 : boolean := true end macro;
macro GET_STOP_BIT_2 : boolean := true end macro;


