--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 30.11.18
--

-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --


-- DP SIGNALS --
macro MEIP_port_sig : bool := MEIP_port end macro;
macro MSIP_port_sig : bool := MSIP_port end macro;
macro MTIP_port_sig : bool := MTIP_port end macro;
macro mip_isa_Port_sig : unsigned := mip_isa_Port end macro;


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
--macro mip : unsigned := end macro;


-- STATES -- 
macro run_0 : boolean := true end macro;


--Operations --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: mip = resize(0,32);
	 at t: mip_isa_Port_sig = resize(0,32);
end property;


property run_0_write_0 is
dependencies: no_reset;
freeze:
	MEIP_port_sig_at_t = MEIP_port_sig@t,
	MSIP_port_sig_at_t = MSIP_port_sig@t,
	MTIP_port_sig_at_t = MTIP_port_sig@t,
	mip_at_t = mip@t;
assume:
	 at t: run_0;
prove:
	 at t+1: run_0;
	 at t+1: mip = manageBit(MEIP_port_sig_at_t,manageBit(MTIP_port_sig_at_t,manageBit(MSIP_port_sig_at_t,manageBit(MEIP_port_sig_at_t,manageBit(MTIP_port_sig_at_t,manageBit(MSIP_port_sig_at_t,mip_at_t,3),7),11),3),7),11);
	 at t+1: mip_isa_Port_sig = manageBit(MEIP_port_sig_at_t,manageBit(MTIP_port_sig_at_t,manageBit(MSIP_port_sig_at_t,manageBit(MEIP_port_sig_at_t,manageBit(MTIP_port_sig_at_t,manageBit(MSIP_port_sig_at_t,mip_at_t,3),7),11),3),7),11);
end property;