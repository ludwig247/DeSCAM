-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: component2_read_1;
	 at t: component2_in_notify = true;
	 at t: component2_out_notify = false;
end property;



property component2_read_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+messages+1;
freeze:
	component2_in_sig_addr_at_t = component2_in_sig_addr@t_end-1,
	component2_in_sig_data_at_t = component2_in_sig_data@t_end-1,
	component2_in_sig_trans_type_at_t = component2_in_sig_trans_type@t_end-1,
	component2_in_addr_at_t = component2_in_addr@t+1,
	component2_in_addr_at_2t = component2_in_addr@t+2,
	component2_in_addr_at_3t = component2_in_addr@t+3,
	component2_in_addr_at_4t = component2_in_addr@t+4,
	component2_in_data_at_t = component2_in_data@t+1,
	component2_in_data_at_2t = component2_in_data@t+2,
	component2_in_data_at_3t = component2_in_data@t+3,
	component2_in_data_at_4t = component2_in_data@t+4;
assume:
	at t: component2_read_1;
	at t: component2_in_sync;
prove:
	at t_end: component2_write_2;
	at t_end: component2_out_sig_addr = component2_in_sig_addr_at_t;
	at t_end: component2_out_sig_data = component2_in_sig_data_at_t;
	at t_end: component2_out_sig_trans_type = component2_in_sig_trans_type_at_t;
	during[t+1, t_end]: component2_in_notify = false;
	during[t+1, t_end-1]: component2_out_notify = false;
	at t_end: component2_out_notify = true;
	
	at t+2: component2_in_sig_data(7 downto 0) = component2_in_data_at_t;
	at t+3: component2_in_sig_data(15 downto 8) = component2_in_data_at_2t;
	at t+4: component2_in_sig_data(23 downto 16)= component2_in_data_at_3t;
	at t+5: component2_in_sig_data(31 downto 24)= component2_in_data_at_4t;

	at t+2: component2_in_sig_addr(7 downto 0) = component2_in_addr_at_t;
	at t+3: component2_in_sig_addr(15 downto 8) = component2_in_addr_at_2t;
	at t+4: component2_in_sig_addr(23 downto 16)= component2_in_addr_at_3t;
	at t+5: component2_in_sig_addr(31 downto 24)= component2_in_addr_at_4t;
end property;


property component2_write_2_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+messages;
freeze:
	component2_out_sig_data_at_t = component2_out_sig_data@t,
	component2_out_sig_addr_at_t = component2_out_sig_addr@t;
assume:
	at t: component2_write_2;
	at t: component2_out_sync;
prove:
	at t_end: component2_read_1;
	during[t+1, t_end-1]: component2_in_notify = false;
	at t_end: component2_in_notify = true;
	during[t+1, t_end]: component2_out_notify = false;
	
	at t+1: component2_out_data = component2_out_sig_data_at_t(7 downto 0);
	at t+2: component2_out_data = component2_out_sig_data_at_t(15 downto 8);
	at t+3: component2_out_data = component2_out_sig_data_at_t(23 downto 16);
	at t+4: component2_out_data = component2_out_sig_data_at_t(31 downto 24);

	at t+1: component2_out_addr = component2_out_sig_addr_at_t(7 downto 0);
	at t+2: component2_out_addr = component2_out_sig_addr_at_t(15 downto 8);
	at t+3: component2_out_addr = component2_out_sig_addr_at_t(23 downto 16);
	at t+4: component2_out_addr = component2_out_sig_addr_at_t(31 downto 24);
end property;


property wait_component2_read_1 is
dependencies: no_reset;--, no_transmission_running;
assume:
	at t: component2_read_1;
	at t: not(component2_in_sync);
prove:
	at t+1: component2_read_1;
	at t+1: component2_in_notify = true;
	at t+1: component2_out_notify = false;
end property;


property wait_component2_write_2 is
dependencies: no_reset;--, no_transmission_running;
freeze:
	component2_out_sig_at_t = component2_out_sig@t;
assume:
	at t: component2_write_2;
	at t: not(component2_out_sync);
prove:
	at t+1: component2_write_2;
	at t+1: component2_out_sig = component2_out_sig_at_t;
	at t+1: component2_in_notify = false;
	at t+1: component2_out_notify = true;
end property;


