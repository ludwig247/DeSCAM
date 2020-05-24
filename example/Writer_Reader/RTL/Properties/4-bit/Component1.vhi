
property reset is
assume:
	 reset_sequence;
prove:
	 at t: component1_write_1;
	 at t: cnt = resize(1,32);
	 at t: component1_out_sig_addr = resize(8,32);
	 at t: component1_out_sig_data = resize(1,32);
	 at t: component1_out_sig_trans_type = SINGLE_WRITE;
	 at t: component1_in_notify = false;
	 at t: component1_out_notify = true;
end property;

property component1_read_2_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+messages+1;
freeze:
	cnt_at_t = cnt@t,
	component1_in_addr_at_t = component1_in_addr@t+1,
	component1_in_addr_at_2t = component1_in_addr@t+2,
	component1_in_addr_at_3t = component1_in_addr@t+3,
	component1_in_addr_at_4t = component1_in_addr@t+4,
	component1_in_addr_at_5t = component1_in_addr@t+5,
	component1_in_addr_at_6t = component1_in_addr@t+6,
	component1_in_addr_at_7t = component1_in_addr@t+7,
	component1_in_addr_at_8t = component1_in_addr@t+8,
	component1_in_data_at_t = component1_in_data@t+1,
	component1_in_data_at_2t = component1_in_data@t+2,
	component1_in_data_at_3t = component1_in_data@t+3,
	component1_in_data_at_4t = component1_in_data@t+4,
	component1_in_data_at_5t = component1_in_data@t+5,
	component1_in_data_at_6t = component1_in_data@t+6,
	component1_in_data_at_7t = component1_in_data@t+7,
	component1_in_data_at_8t = component1_in_data@t+8;
assume:
	at t: component1_read_2;
	at t: component1_in_sync;
	--at t: no_transmission_running;
prove:
	at t_end: component1_write_1;
	at t_end: cnt = (1 + cnt_at_t)(31 downto 0);
	at t_end: component1_out_sig_addr = 8;
	at t_end: component1_out_sig_data = (1 + cnt_at_t)(31 downto 0);
	at t_end: component1_out_sig_trans_type = SINGLE_WRITE;
	at t_end: component1_in_notify = false;
	during[t+1, t_end-1]: component1_out_notify = false;
	at t_end: component1_out_notify = true;

	at t+2: component1_in_sig_data(3 downto 0) = component1_in_data_at_t;
	at t+3: component1_in_sig_data(7 downto 4) = component1_in_data_at_2t;
	at t+4: component1_in_sig_data(11 downto 8)= component1_in_data_at_3t;
	at t+5: component1_in_sig_data(15 downto 12)= component1_in_data_at_4t;
	at t+6: component1_in_sig_data(19 downto 16)= component1_in_data_at_5t;
	at t+7: component1_in_sig_data(23 downto 20)= component1_in_data_at_6t;
	at t+8: component1_in_sig_data(27 downto 24)= component1_in_data_at_7t;
	at t+9: component1_in_sig_data(31 downto 28)= component1_in_data_at_8t;

	at t+2: component1_in_sig_addr(3 downto 0) = component1_in_addr_at_t;
	at t+3: component1_in_sig_addr(7 downto 4) = component1_in_addr_at_2t;
	at t+4: component1_in_sig_addr(11 downto 8)= component1_in_addr_at_3t;
	at t+5: component1_in_sig_addr(15 downto 12)= component1_in_addr_at_4t;
	at t+6: component1_in_sig_addr(19 downto 16)= component1_in_addr_at_5t;
	at t+7: component1_in_sig_addr(23 downto 20)= component1_in_addr_at_6t;
	at t+8: component1_in_sig_addr(27 downto 24)= component1_in_addr_at_7t;
	at t+9: component1_in_sig_addr(31 downto 28)= component1_in_addr_at_8t;
end property;


property component1_write_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+messages;
freeze:
	cnt_at_t = cnt@t;
assume:
	at t: component1_write_1;
	at t: component1_out_sync;
	--at t: no_transmission_running;
prove:
	at t_end: component1_read_2;
	at t_end: cnt = cnt_at_t;
	during[t+1, t_end-1]: component1_in_notify = false;
	at t+1: component1_out_data = component1_out_sig_data(3 downto 0);
	at t+2: component1_out_data = component1_out_sig_data(7 downto 4);
	at t+3: component1_out_data = component1_out_sig_data(11 downto 8);
	at t+4: component1_out_data = component1_out_sig_data(15 downto 12);
	at t+5: component1_out_data = component1_out_sig_data(19 downto 16);
	at t+6: component1_out_data = component1_out_sig_data(23 downto 20);
	at t+7: component1_out_data = component1_out_sig_data(27 downto 24);
	at t+8: component1_out_data = component1_out_sig_data(31 downto 28);
	at t+1: component1_out_sig_data = cnt_at_t;
	at t+1: component1_out_addr = component1_out_sig_addr(3 downto 0);
	at t+2: component1_out_addr = component1_out_sig_addr(7 downto 4);
	at t+3: component1_out_addr = component1_out_sig_addr(11 downto 8);
	at t+4: component1_out_addr = component1_out_sig_addr(15 downto 12);
	at t+5: component1_out_addr = component1_out_sig_addr(19 downto 16);
	at t+6: component1_out_addr = component1_out_sig_addr(23 downto 20);
	at t+7: component1_out_addr = component1_out_sig_addr(27 downto 24);
	at t+8: component1_out_addr = component1_out_sig_addr(31 downto 28);
	at t_end: component1_in_notify = true;
	at t_end: component1_out_notify = false;
end property;


property wait_component1_read_2 is
dependencies: no_reset;--, no_transmission_running;
	
freeze:
	cnt_at_t = cnt@t;
assume:
	at t: component1_read_2;
	at t: not(component1_in_sync);
prove:
	at t+1: component1_read_2;
	at t+1: cnt = cnt_at_t;
	at t+1: component1_in_notify = true;
	at t+1: component1_out_notify = false;
end property;


property wait_component1_write_1 is
dependencies: no_reset;--, no_transmission_running;

freeze:
	cnt_at_t = cnt@t,
	component1_out_sig_at_t = component1_out_sig@t;
assume:
	at t: component1_write_1;
	at t: not(component1_out_sync);
prove:
	at t+1: component1_write_1;
	at t+1: cnt = cnt_at_t;
	at t+1: component1_out_sig = component1_out_sig_at_t;
	at t+1: component1_in_notify = false;
	at t+1: component1_out_notify = true;
end property;


