property core_equivalence is
prove:
	during[t, t+1]: COtoME_port_notify1 = COtoME_port_notify2;
	during[t, t+1]: MEtoCO_port_notify1 = MEtoCO_port_notify2;
	during[t, t+1]: COtoME_port_sig1 = COtoME_port_sig2;
end property;