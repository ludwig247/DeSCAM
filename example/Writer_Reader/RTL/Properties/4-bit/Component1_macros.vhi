-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro component1_in_sync : boolean := component1_inst/component1_in_sync end macro;
--macro component1_out_sync : boolean := component1_inst/component1_out_sync end macro;
--macro component1_in_notify : boolean := component1_inst/component1_in_notify end macro;
--macro component1_out_notify : boolean := component1_inst/component1_out_notify end macro;


-- DP SIGNALS --
macro component1_in_sig : bus_req_t := component1_in end macro;
macro component1_in_sig_addr : signed := component1_in.addr end macro;
macro component1_in_sig_data : signed := component1_in.data end macro;
macro component1_in_sig_trans_type : trans_t := component1_in.trans_type end macro;
macro component1_out_sig : bus_req_t := component1_out end macro;
macro component1_out_sig_addr : signed := component1_out.addr end macro;
macro component1_out_sig_data : signed := component1_out.data end macro;
macro component1_out_sig_trans_type : trans_t := component1_out.trans_type end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro cnt : signed := cnt_signal end macro;

--CONNECTION--
macro messages: unsigned := 8 end macro;

-- STATES --
macro component1_write_1 : boolean := component1_out_notify = true and component1_in_notify = false and component1_out_running = false and component1_in_running = false end macro;
macro component1_read_2 : boolean := component1_out_notify = false and component1_in_notify = true and component1_out_running = false and component1_in_running = false end macro;


