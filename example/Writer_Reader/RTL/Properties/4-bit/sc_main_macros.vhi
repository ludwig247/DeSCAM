-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro component2_out_transmission_complete : boolean := component2_inst/component2_in_notify end macro;
--macro component1_out_transmission_complete : boolean := component2_inst/component2_out_notify end macro;




macro component2_in_sig : bus_req_t := component2_inst/component2_in end macro;
macro component2_out_sig : bus_req_t := component2_inst/component2_out end macro;
macro component1_in_sig : bus_req_t := component1_inst/component1_in end macro;
macro component1_out_sig : bus_req_t := component1_inst/component1_out end macro;
-- VISIBLE REGISTERS --

--Transmission Macros--
macro messages: unsigned := 8 end macro;



-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;
	

macro component2_read_1 : boolean :=  component2_inst/component2_out_notify = false and component2_inst/component2_in_notify = true and component2_inst/component2_out_running = false and component2_inst/component2_in_running = false end macro;
macro component2_write_2 : boolean := component2_inst/component2_out_notify = true and component2_inst/component2_in_notify = false and component2_inst/component2_out_running = false and component2_inst/component2_in_running = false end macro;
macro component1_write_1 : boolean := component1_inst/component1_out_notify = true and component1_inst/component1_in_notify = false and component1_inst/component1_out_running = false and component1_inst/component1_in_running = false end macro;
macro component1_read_2 : boolean := component1_inst/component1_out_notify = false and component1_inst/component1_in_notify = true and component1_inst/component1_out_running = false and component1_inst/component1_in_running = false end macro;

