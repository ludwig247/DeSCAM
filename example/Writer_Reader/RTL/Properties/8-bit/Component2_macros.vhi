-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro component2_in_sync : boolean := component2_in_sync end macro;
--macro component2_out_sync : boolean := component2_out_sync end macro;
--macro component2_in_notify : boolean := component2_in_notify end macro;
--macro component2_out_notify : boolean := component2_out_notify end macro;


-- DP SIGNALS --
macro component2_in_sig : bus_req_t := component2_in end macro;
macro component2_in_sig_addr : signed := component2_in.addr end macro;
macro component2_in_sig_data : signed := component2_in.data end macro;
macro component2_in_sig_trans_type : trans_t := component2_in.trans_type end macro;
macro component2_out_sig : bus_req_t := component2_out end macro;
macro component2_out_sig_addr : signed := component2_out.addr end macro;
macro component2_out_sig_data : signed := component2_out.data end macro;
macro component2_out_sig_trans_type : trans_t := component2_out.trans_type end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;

--CONNECTION--
macro messages: unsigned := 4 end macro;


-- VISIBLE REGISTERS --


-- STATES --
macro component2_read_1 : boolean :=  component2_out_notify = false and component2_in_notify = true and component2_out_running = false and component2_in_running = false end macro;
macro component2_write_2 : boolean := component2_out_notify = true and component2_in_notify = false and component2_out_running = false and component2_in_running = false end macro;


