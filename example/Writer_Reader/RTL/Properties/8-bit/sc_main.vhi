-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: component2_read_1;
	 at t: component1_write_1;
	 
end property;


property transmission_1_to_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+messages+2;
freeze:
	component1_out_sig_at_t = component1_out_sig@t;
assume:
	at t: component1_write_1;
	at t: component2_read_1;
prove:
	at t_end: component2_write_2;
	at t_end: component1_read_2;
	at t_end: component2_in_sig = component1_out_sig_at_t;
end property;

property transmission_2_to_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+messages+2;
freeze:
	component2_out_sig_at_t = component2_out_sig@t;
assume:
	at t: component2_write_2;
	at t: component1_read_2;
prove:
	at t_end: component1_write_1;
	at t_end: component2_read_1;
	at t_end: component1_in_sig = component2_out_sig_at_t;
end property;
