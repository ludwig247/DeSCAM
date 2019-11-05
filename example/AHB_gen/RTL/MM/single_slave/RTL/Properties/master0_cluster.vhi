-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro from_bus_sync : boolean := if(from_bus_sig_hready = '1' or from_bus_sig_hresp = error_resp) then true else false end if; end macro;
macro from_master_sync : boolean := master_in0_sync end macro;
macro to_bus_sync : boolean := from_bus_sig_hready and from_bus_sig_hgrant end macro;
macro to_master_sync : boolean := master_out0_sync end macro;
macro from_bus_notify : boolean := if(phase = data) then true else false end if; end macro; --need solution
macro from_master_notify : boolean := master_in0_notify end macro;
macro to_bus_notify : boolean := if(phase = req_phase) then true else false end if; end macro;
macro to_master_notify : boolean := master_out0_notify end macro;


-- DP SIGNALS --
macro from_bus_sig_hgrant : boolean := mtx_to_mst0.hgrant end macro;
macro from_bus_sig_hrdata : unsigned := mtx_to_mst0.hrdata end macro;
macro from_bus_sig_hready : boolean := mtx_to_mst0.hready end macro;
macro from_bus_sig_hresp : unsigned := mtx_to_mst0.hresp end macro;
macro from_master_sig_haddr : unsigned := master_in0.haddr end macro;
macro from_master_sig_hsize : mask := if(master_in0.hsize = MT_BU) then MT_B elsif (master_in0.hsize = MT_HU) then MT_H else master_in0.hsize end if; end macro;
macro from_master_sig_hwdata : unsigned := master_in0.hwdata end macro;
macro from_master_sig_hwrite : trans_type := master_in0.hwrite end macro;
macro to_bus_sig_haddr : unsigned := mst_to_mtx0.haddr end macro;
macro to_bus_sig_hburst : unsigned := mst_to_mtx0.hburst end macro;
macro to_bus_sig_hbusreq : boolean := mst_to_mtx0.hbusreq end macro;
macro to_bus_sig_hlock : boolean := mst_to_mtx0.hlock end macro;
macro to_bus_sig_hprot : unsigned := mst_to_mtx0.hprot end macro;
macro to_bus_sig_hsize : mask := if(mst_to_mtx0.hsize = "010") then MT_W elsif(mst_to_mtx0.hsize = "001") then MT_H elsif (mst_to_mtx0.hsize = "000") then MT_B else MT_X end if; end macro;
macro to_bus_sig_htrans : unsigned := mst_to_mtx0.htrans end macro;
macro to_bus_sig_hwdata : unsigned := mst_to_mtx0.hwdata end macro;
macro to_bus_sig_hwrite : trans_type := if(mst_to_mtx0.hwrite = '1') then AHB_WRITE else AHB_READ end if; end macro;
macro to_master_sig_hrdata : unsigned := master_out0.hrdata end macro;
macro to_master_sig_hresp : unsigned := master_out0.hresp end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;
constraint always_sync := slave_in0_sync = true and slave_out0_sync = true; end constraint;
constraint never_splitretry := slave_in0.hresp = ok_resp or slave_in0.hresp = error_resp; end constraint;

-- VISIBLE REGISTERS --
macro ahb_mst_out_haddr : unsigned := mst0/haddr end macro;
macro ahb_mst_out_hburst : unsigned := mst0/hburst end macro;
macro ahb_mst_out_hbusreq : boolean := mst0/busreq end macro;
macro ahb_mst_out_hlock : boolean := mst0/hmastlock end macro;
macro ahb_mst_out_hprot : unsigned := mst0/hprot end macro;
macro ahb_mst_out_hsize : mask := if(mst0/hsize = "010") then MT_W elsif(mst0/hsize = "001") then MT_H elsif (mst0/hsize = "000") then MT_B else MT_X end if; end macro;
macro ahb_mst_out_htrans : unsigned := mst0/htrans end macro;
macro ahb_mst_out_hwdata : unsigned := mst0/hwdata end macro;
macro ahb_mst_out_hwrite : trans_type := if(mst0/hwrite = '1') then AHB_WRITE else AHB_READ end if; end macro;
macro phase : mWrp_sec := mst0/section end macro; -- changed here to mWrp_sec rather than change RTL to Phases, equivalent.
macro response_hrdata : unsigned := mst0/hrdata end macro;
macro response_hresp : unsigned := mst0/hresp end macro;


-- STATES --
macro state_30 : boolean := phase = idle_phase end macro;
macro state_38 : boolean := phase = req_phase end macro;
macro state_43 : boolean := phase = addr end macro;
macro state_47 : boolean := phase = data end macro;
macro state_53 : boolean := phase = error_phase end macro;
macro state_56 : boolean := phase = resp end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_30;
	 at t: ahb_mst_out_haddr = resize(0,32);
	 at t: ahb_mst_out_hburst = resize(0,32);
	 at t: ahb_mst_out_hbusreq = false;
	 at t: ahb_mst_out_hlock = false;
	 at t: ahb_mst_out_hprot = resize(3,32);
	 at t: ahb_mst_out_hsize = MT_W;
	 at t: ahb_mst_out_htrans = resize(0,32);
	 at t: ahb_mst_out_hwdata = resize(0,32);
	 at t: ahb_mst_out_hwrite = AHB_READ;
	 at t: phase = idle_phase;
	 at t: response_hrdata = resize(0,32);
	 at t: response_hresp = resize(0,32);
	 at t: from_bus_notify = false;
	 at t: from_master_notify = true;
	 at t: to_bus_notify = false;
	 at t: to_master_notify = false;
end property;


property state_30_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ahb_mst_out_hburst_at_t = ahb_mst_out_hburst@t,
	ahb_mst_out_hlock_at_t = ahb_mst_out_hlock@t,
	ahb_mst_out_hprot_at_t = ahb_mst_out_hprot@t,
	ahb_mst_out_htrans_at_t = ahb_mst_out_htrans@t,
	from_master_sig_haddr_at_t = from_master_sig_haddr@t,
	from_master_sig_hsize_at_t = from_master_sig_hsize@t,
	from_master_sig_hwdata_at_t = from_master_sig_hwdata@t,
	from_master_sig_hwrite_at_t = from_master_sig_hwrite@t,
	response_hrdata_at_t = response_hrdata@t,
	response_hresp_at_t = response_hresp@t;
assume:
	at t: state_30;
	at t: from_master_sync;
	at t: not((phase = req_phase));
	at t: not((phase = addr));
	at t: not((phase = data));
	at t: not((phase = error_phase));
	at t: not((phase = resp));
prove:
	at t_end: state_38;
	at t_end: ahb_mst_out_haddr = from_master_sig_haddr_at_t;
	at t_end: ahb_mst_out_hburst = ahb_mst_out_hburst_at_t;
	at t_end: ahb_mst_out_hbusreq = true;
	at t_end: ahb_mst_out_hlock = ahb_mst_out_hlock_at_t;
	at t_end: ahb_mst_out_hprot = ahb_mst_out_hprot_at_t;
	at t_end: ahb_mst_out_hsize = from_master_sig_hsize_at_t;
	at t_end: ahb_mst_out_htrans = ahb_mst_out_htrans_at_t;
	at t_end: ahb_mst_out_hwdata = from_master_sig_hwdata_at_t;
	at t_end: ahb_mst_out_hwrite = from_master_sig_hwrite_at_t;
	at t_end: phase = req_phase;
	at t_end: response_hrdata = response_hrdata_at_t;
	at t_end: response_hresp = response_hresp_at_t;
	at t_end: to_bus_sig_haddr = from_master_sig_haddr_at_t;
	at t_end: to_bus_sig_hburst = ahb_mst_out_hburst_at_t;
	at t_end: to_bus_sig_hbusreq = true;
	at t_end: to_bus_sig_hlock = ahb_mst_out_hlock_at_t;
	at t_end: to_bus_sig_hprot = ahb_mst_out_hprot_at_t;
	at t_end: to_bus_sig_hsize = from_master_sig_hsize_at_t;
	at t_end: to_bus_sig_htrans = ahb_mst_out_htrans_at_t;
	at t_end: to_bus_sig_hwdata = from_master_sig_hwdata_at_t;
	at t_end: to_bus_sig_hwrite = from_master_sig_hwrite_at_t;
	during[t+1, t_end]: from_bus_notify = false;
	during[t+1, t_end]: from_master_notify = false;
	during[t+1, t_end-1]: to_bus_notify = false;
	at t_end: to_bus_notify = true;
	during[t+1, t_end]: to_master_notify = false;
end property;


property state_38_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ahb_mst_out_haddr_at_t = ahb_mst_out_haddr@t,
	ahb_mst_out_hburst_at_t = ahb_mst_out_hburst@t,
	ahb_mst_out_hlock_at_t = ahb_mst_out_hlock@t,
	ahb_mst_out_hprot_at_t = ahb_mst_out_hprot@t,
	ahb_mst_out_hsize_at_t = ahb_mst_out_hsize@t,
	ahb_mst_out_hwdata_at_t = ahb_mst_out_hwdata@t,
	ahb_mst_out_hwrite_at_t = ahb_mst_out_hwrite@t,
	response_hrdata_at_t = response_hrdata@t,
	response_hresp_at_t = response_hresp@t;
assume:
	at t: state_38;
	at t: to_bus_sync;
	at t: not((phase = addr));
	at t: not((phase = data));
	at t: not((phase = error_phase));
	at t: not((phase = resp));
prove:
	at t_end: state_43;
	at t_end: ahb_mst_out_haddr = ahb_mst_out_haddr_at_t;
	at t_end: ahb_mst_out_hburst = ahb_mst_out_hburst_at_t;
	at t_end: ahb_mst_out_hbusreq = false;
	at t_end: ahb_mst_out_hlock = ahb_mst_out_hlock_at_t;
	at t_end: ahb_mst_out_hprot = ahb_mst_out_hprot_at_t;
	at t_end: ahb_mst_out_hsize = ahb_mst_out_hsize_at_t;
	at t_end: ahb_mst_out_htrans = 2;
	at t_end: ahb_mst_out_hwdata = ahb_mst_out_hwdata_at_t;
	at t_end: ahb_mst_out_hwrite = ahb_mst_out_hwrite_at_t;
	at t_end: phase = addr;
	at t_end: response_hrdata = response_hrdata_at_t;
	at t_end: response_hresp = response_hresp_at_t;
	during[t+1, t_end]: from_bus_notify = false;
	during[t+1, t_end]: from_master_notify = false;
	during[t+1, t_end]: to_bus_notify = false;
	during[t+1, t_end]: to_master_notify = false;
end property;


property state_43_3 is
dependencies: no_reset, always_sync, never_splitretry;
for timepoints:
        t_ready = t + 0..3 waits_for complete from_bus_sig_hready,
	t_end = t_ready + 1;
freeze:
	ahb_mst_out_haddr_at_t = ahb_mst_out_haddr@t,
	ahb_mst_out_hburst_at_t = ahb_mst_out_hburst@t,
	ahb_mst_out_hbusreq_at_t = ahb_mst_out_hbusreq@t,
	ahb_mst_out_hlock_at_t = ahb_mst_out_hlock@t,
	ahb_mst_out_hprot_at_t = ahb_mst_out_hprot@t,
	ahb_mst_out_hsize_at_t = ahb_mst_out_hsize@t,
	ahb_mst_out_hwdata_at_t = ahb_mst_out_hwdata@t,
	ahb_mst_out_hwrite_at_t = ahb_mst_out_hwrite@t,
	response_hrdata_at_t = response_hrdata@t,
	response_hresp_at_t = response_hresp@t;
assume:
	at t: state_43;
	at t: not((phase = data));
	at t: not((phase = error_phase));
	at t: not((phase = resp));
prove:
	at t_end: state_47;
	at t_end: ahb_mst_out_haddr = ahb_mst_out_haddr_at_t;
	at t_end: ahb_mst_out_hburst = ahb_mst_out_hburst_at_t;
	at t_end: ahb_mst_out_hbusreq = ahb_mst_out_hbusreq_at_t;
	at t_end: ahb_mst_out_hlock = ahb_mst_out_hlock_at_t;
	at t_end: ahb_mst_out_hprot = ahb_mst_out_hprot_at_t;
	at t_end: ahb_mst_out_hsize = ahb_mst_out_hsize_at_t;
	at t_end: ahb_mst_out_htrans = 0;
	at t_end: ahb_mst_out_hwdata = ahb_mst_out_hwdata_at_t;
	at t_end: ahb_mst_out_hwrite = ahb_mst_out_hwrite_at_t;
	at t_end: phase = data;
	at t_end: response_hrdata = response_hrdata_at_t;
	at t_end: response_hresp = response_hresp_at_t;
	during[t+1, t_end-1]: from_bus_notify = false;
	at t_end: from_bus_notify = true;
	during[t+1, t_end]: from_master_notify = false;
	during[t+1, t_end]: to_bus_notify = false;
	during[t+1, t_end]: to_master_notify = false;
end property;


property state_47_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ahb_mst_out_haddr_at_t = ahb_mst_out_haddr@t,
	ahb_mst_out_hburst_at_t = ahb_mst_out_hburst@t,
	ahb_mst_out_hbusreq_at_t = ahb_mst_out_hbusreq@t,
	ahb_mst_out_hlock_at_t = ahb_mst_out_hlock@t,
	ahb_mst_out_hprot_at_t = ahb_mst_out_hprot@t,
	ahb_mst_out_hsize_at_t = ahb_mst_out_hsize@t,
	ahb_mst_out_htrans_at_t = ahb_mst_out_htrans@t,
	ahb_mst_out_hwdata_at_t = ahb_mst_out_hwdata@t,
	ahb_mst_out_hwrite_at_t = ahb_mst_out_hwrite@t,
	from_bus_sig_hrdata_at_t = from_bus_sig_hrdata@t,
	from_bus_sig_hresp_at_t = from_bus_sig_hresp@t;
assume:
	at t: state_47;
	at t: from_bus_sync;
	at t: not((phase = error_phase));
	at t: not((phase = resp));
	at t: (from_bus_sig_hresp = resize(1,32));
prove:
	at t_end: state_53;
	at t_end: ahb_mst_out_haddr = ahb_mst_out_haddr_at_t;
	at t_end: ahb_mst_out_hburst = ahb_mst_out_hburst_at_t;
	at t_end: ahb_mst_out_hbusreq = ahb_mst_out_hbusreq_at_t;
	at t_end: ahb_mst_out_hlock = ahb_mst_out_hlock_at_t;
	at t_end: ahb_mst_out_hprot = ahb_mst_out_hprot_at_t;
	at t_end: ahb_mst_out_hsize = ahb_mst_out_hsize_at_t;
	at t_end: ahb_mst_out_htrans = ahb_mst_out_htrans_at_t;
	at t_end: ahb_mst_out_hwdata = ahb_mst_out_hwdata_at_t;
	at t_end: ahb_mst_out_hwrite = ahb_mst_out_hwrite_at_t;
	at t_end: phase = error_phase;
	at t_end: response_hrdata = from_bus_sig_hrdata_at_t;
	at t_end: response_hresp = from_bus_sig_hresp_at_t;
	during[t+1, t_end]: from_bus_notify = false;
	during[t+1, t_end]: from_master_notify = false;
	during[t+1, t_end]: to_bus_notify = false;
	during[t+1, t_end]: to_master_notify = false;
end property;


property state_47_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ahb_mst_out_haddr_at_t = ahb_mst_out_haddr@t,
	ahb_mst_out_hburst_at_t = ahb_mst_out_hburst@t,
	ahb_mst_out_hbusreq_at_t = ahb_mst_out_hbusreq@t,
	ahb_mst_out_hlock_at_t = ahb_mst_out_hlock@t,
	ahb_mst_out_hprot_at_t = ahb_mst_out_hprot@t,
	ahb_mst_out_hsize_at_t = ahb_mst_out_hsize@t,
	ahb_mst_out_htrans_at_t = ahb_mst_out_htrans@t,
	ahb_mst_out_hwdata_at_t = ahb_mst_out_hwdata@t,
	ahb_mst_out_hwrite_at_t = ahb_mst_out_hwrite@t,
	from_bus_sig_hrdata_at_t = from_bus_sig_hrdata@t,
	from_bus_sig_hresp_at_t = from_bus_sig_hresp@t;
assume:
	at t: state_47;
	at t: from_bus_sync;
	at t: not((from_bus_sig_hresp = resize(1,32)));
	at t: not((phase = error_phase));
	at t: not((phase = resp));
prove:
	at t_end: state_56;
	at t_end: ahb_mst_out_haddr = ahb_mst_out_haddr_at_t;
	at t_end: ahb_mst_out_hburst = ahb_mst_out_hburst_at_t;
	at t_end: ahb_mst_out_hbusreq = ahb_mst_out_hbusreq_at_t;
	at t_end: ahb_mst_out_hlock = ahb_mst_out_hlock_at_t;
	at t_end: ahb_mst_out_hprot = ahb_mst_out_hprot_at_t;
	at t_end: ahb_mst_out_hsize = ahb_mst_out_hsize_at_t;
	at t_end: ahb_mst_out_htrans = ahb_mst_out_htrans_at_t;
	at t_end: ahb_mst_out_hwdata = ahb_mst_out_hwdata_at_t;
	at t_end: ahb_mst_out_hwrite = ahb_mst_out_hwrite_at_t;
	at t_end: phase = resp;
	at t_end: response_hrdata = from_bus_sig_hrdata_at_t;
	at t_end: response_hresp = from_bus_sig_hresp_at_t;
	at t_end: to_master_sig_hrdata = from_bus_sig_hrdata_at_t;
	at t_end: to_master_sig_hresp = from_bus_sig_hresp_at_t;
	during[t+1, t_end]: from_bus_notify = false;
	during[t+1, t_end]: from_master_notify = false;
	during[t+1, t_end]: to_bus_notify = false;
	during[t+1, t_end-1]: to_master_notify = false;
	at t_end: to_master_notify = true;
end property;


property state_53_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ahb_mst_out_haddr_at_t = ahb_mst_out_haddr@t,
	ahb_mst_out_hburst_at_t = ahb_mst_out_hburst@t,
	ahb_mst_out_hbusreq_at_t = ahb_mst_out_hbusreq@t,
	ahb_mst_out_hlock_at_t = ahb_mst_out_hlock@t,
	ahb_mst_out_hprot_at_t = ahb_mst_out_hprot@t,
	ahb_mst_out_hsize_at_t = ahb_mst_out_hsize@t,
	ahb_mst_out_htrans_at_t = ahb_mst_out_htrans@t,
	ahb_mst_out_hwdata_at_t = ahb_mst_out_hwdata@t,
	ahb_mst_out_hwrite_at_t = ahb_mst_out_hwrite@t,
	response_hrdata_at_t = response_hrdata@t,
	response_hresp_at_t = response_hresp@t;
assume:
	at t: state_53;
	at t: not((phase = resp));
prove:
	at t_end: state_56;
	at t_end: ahb_mst_out_haddr = ahb_mst_out_haddr_at_t;
	at t_end: ahb_mst_out_hburst = ahb_mst_out_hburst_at_t;
	at t_end: ahb_mst_out_hbusreq = ahb_mst_out_hbusreq_at_t;
	at t_end: ahb_mst_out_hlock = ahb_mst_out_hlock_at_t;
	at t_end: ahb_mst_out_hprot = ahb_mst_out_hprot_at_t;
	at t_end: ahb_mst_out_hsize = ahb_mst_out_hsize_at_t;
	at t_end: ahb_mst_out_htrans = ahb_mst_out_htrans_at_t;
	at t_end: ahb_mst_out_hwdata = ahb_mst_out_hwdata_at_t;
	at t_end: ahb_mst_out_hwrite = ahb_mst_out_hwrite_at_t;
	at t_end: phase = resp;
	at t_end: response_hrdata = response_hrdata_at_t;
	at t_end: response_hresp = response_hresp_at_t;
	at t_end: to_master_sig_hrdata = response_hrdata_at_t;
	at t_end: to_master_sig_hresp = response_hresp_at_t;
	during[t+1, t_end]: from_bus_notify = false;
	during[t+1, t_end]: from_master_notify = false;
	during[t+1, t_end]: to_bus_notify = false;
	during[t+1, t_end-1]: to_master_notify = false;
	at t_end: to_master_notify = true;
end property;


property state_56_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ahb_mst_out_haddr_at_t = ahb_mst_out_haddr@t,
	ahb_mst_out_hburst_at_t = ahb_mst_out_hburst@t,
	ahb_mst_out_hbusreq_at_t = ahb_mst_out_hbusreq@t,
	ahb_mst_out_hlock_at_t = ahb_mst_out_hlock@t,
	ahb_mst_out_hprot_at_t = ahb_mst_out_hprot@t,
	ahb_mst_out_hsize_at_t = ahb_mst_out_hsize@t,
	ahb_mst_out_htrans_at_t = ahb_mst_out_htrans@t,
	ahb_mst_out_hwdata_at_t = ahb_mst_out_hwdata@t,
	ahb_mst_out_hwrite_at_t = ahb_mst_out_hwrite@t,
	response_hrdata_at_t = response_hrdata@t,
	response_hresp_at_t = response_hresp@t;
assume:
	at t: state_56;
	at t: to_master_sync;
prove:
	at t_end: state_30;
	at t_end: ahb_mst_out_haddr = ahb_mst_out_haddr_at_t;
	at t_end: ahb_mst_out_hburst = ahb_mst_out_hburst_at_t;
	at t_end: ahb_mst_out_hbusreq = ahb_mst_out_hbusreq_at_t;
	at t_end: ahb_mst_out_hlock = ahb_mst_out_hlock_at_t;
	at t_end: ahb_mst_out_hprot = ahb_mst_out_hprot_at_t;
	at t_end: ahb_mst_out_hsize = ahb_mst_out_hsize_at_t;
	at t_end: ahb_mst_out_htrans = ahb_mst_out_htrans_at_t;
	at t_end: ahb_mst_out_hwdata = ahb_mst_out_hwdata_at_t;
	at t_end: ahb_mst_out_hwrite = ahb_mst_out_hwrite_at_t;
	at t_end: phase = idle_phase;
	at t_end: response_hrdata = response_hrdata_at_t;
	at t_end: response_hresp = response_hresp_at_t;
	during[t+1, t_end]: from_bus_notify = false;
	during[t+1, t_end-1]: from_master_notify = false;
	at t_end: from_master_notify = true;
	during[t+1, t_end]: to_bus_notify = false;
	during[t+1, t_end]: to_master_notify = false;
end property;


property wait_state_30 is
dependencies: no_reset;
freeze:
	ahb_mst_out_haddr_at_t = ahb_mst_out_haddr@t,
	ahb_mst_out_hburst_at_t = ahb_mst_out_hburst@t,
	ahb_mst_out_hbusreq_at_t = ahb_mst_out_hbusreq@t,
	ahb_mst_out_hlock_at_t = ahb_mst_out_hlock@t,
	ahb_mst_out_hprot_at_t = ahb_mst_out_hprot@t,
	ahb_mst_out_hsize_at_t = ahb_mst_out_hsize@t,
	ahb_mst_out_htrans_at_t = ahb_mst_out_htrans@t,
	ahb_mst_out_hwdata_at_t = ahb_mst_out_hwdata@t,
	ahb_mst_out_hwrite_at_t = ahb_mst_out_hwrite@t,
	phase_at_t = phase@t,
	response_hrdata_at_t = response_hrdata@t,
	response_hresp_at_t = response_hresp@t;
assume:
	at t: state_30;
	at t: not(from_master_sync);
prove:
	at t+1: state_30;
	at t+1: ahb_mst_out_haddr = ahb_mst_out_haddr_at_t;
	at t+1: ahb_mst_out_hburst = ahb_mst_out_hburst_at_t;
	at t+1: ahb_mst_out_hbusreq = ahb_mst_out_hbusreq_at_t;
	at t+1: ahb_mst_out_hlock = ahb_mst_out_hlock_at_t;
	at t+1: ahb_mst_out_hprot = ahb_mst_out_hprot_at_t;
	at t+1: ahb_mst_out_hsize = ahb_mst_out_hsize_at_t;
	at t+1: ahb_mst_out_htrans = ahb_mst_out_htrans_at_t;
	at t+1: ahb_mst_out_hwdata = ahb_mst_out_hwdata_at_t;
	at t+1: ahb_mst_out_hwrite = ahb_mst_out_hwrite_at_t;
	at t+1: phase = phase_at_t;
	at t+1: response_hrdata = response_hrdata_at_t;
	at t+1: response_hresp = response_hresp_at_t;
	at t+1: from_bus_notify = false;
	at t+1: from_master_notify = true;
	at t+1: to_bus_notify = false;
	at t+1: to_master_notify = false;
end property;


property wait_state_38 is
dependencies: no_reset;
freeze:
	ahb_mst_out_haddr_at_t = ahb_mst_out_haddr@t,
	ahb_mst_out_hburst_at_t = ahb_mst_out_hburst@t,
	ahb_mst_out_hbusreq_at_t = ahb_mst_out_hbusreq@t,
	ahb_mst_out_hlock_at_t = ahb_mst_out_hlock@t,
	ahb_mst_out_hprot_at_t = ahb_mst_out_hprot@t,
	ahb_mst_out_hsize_at_t = ahb_mst_out_hsize@t,
	ahb_mst_out_htrans_at_t = ahb_mst_out_htrans@t,
	ahb_mst_out_hwdata_at_t = ahb_mst_out_hwdata@t,
	ahb_mst_out_hwrite_at_t = ahb_mst_out_hwrite@t,
	phase_at_t = phase@t,
	response_hrdata_at_t = response_hrdata@t,
	response_hresp_at_t = response_hresp@t;
assume:
	at t: state_38;
	at t: not(to_bus_sync);
prove:
	at t+1: state_38;
	at t+1: ahb_mst_out_haddr = ahb_mst_out_haddr_at_t;
	at t+1: ahb_mst_out_hburst = ahb_mst_out_hburst_at_t;
	at t+1: ahb_mst_out_hbusreq = ahb_mst_out_hbusreq_at_t;
	at t+1: ahb_mst_out_hlock = ahb_mst_out_hlock_at_t;
	at t+1: ahb_mst_out_hprot = ahb_mst_out_hprot_at_t;
	at t+1: ahb_mst_out_hsize = ahb_mst_out_hsize_at_t;
	at t+1: ahb_mst_out_htrans = ahb_mst_out_htrans_at_t;
	at t+1: ahb_mst_out_hwdata = ahb_mst_out_hwdata_at_t;
	at t+1: ahb_mst_out_hwrite = ahb_mst_out_hwrite_at_t;
	at t+1: phase = phase_at_t;
	at t+1: response_hrdata = response_hrdata_at_t;
	at t+1: response_hresp = response_hresp_at_t;
	at t+1: to_bus_sig_haddr = ahb_mst_out_haddr_at_t;
	at t+1: to_bus_sig_hburst = ahb_mst_out_hburst_at_t;
	at t+1: to_bus_sig_hbusreq = ahb_mst_out_hbusreq_at_t;
	at t+1: to_bus_sig_hlock = ahb_mst_out_hlock_at_t;
	at t+1: to_bus_sig_hprot = ahb_mst_out_hprot_at_t;
	at t+1: to_bus_sig_hsize = ahb_mst_out_hsize_at_t;
	at t+1: to_bus_sig_htrans = ahb_mst_out_htrans_at_t;
	at t+1: to_bus_sig_hwdata = ahb_mst_out_hwdata_at_t;
	at t+1: to_bus_sig_hwrite = ahb_mst_out_hwrite_at_t;
	at t+1: from_bus_notify = false;
	at t+1: from_master_notify = false;
	at t+1: to_bus_notify = true;
	at t+1: to_master_notify = false;
end property;


property wait_state_47 is
dependencies: no_reset;
freeze:
	ahb_mst_out_haddr_at_t = ahb_mst_out_haddr@t,
	ahb_mst_out_hburst_at_t = ahb_mst_out_hburst@t,
	ahb_mst_out_hbusreq_at_t = ahb_mst_out_hbusreq@t,
	ahb_mst_out_hlock_at_t = ahb_mst_out_hlock@t,
	ahb_mst_out_hprot_at_t = ahb_mst_out_hprot@t,
	ahb_mst_out_hsize_at_t = ahb_mst_out_hsize@t,
	ahb_mst_out_htrans_at_t = ahb_mst_out_htrans@t,
	ahb_mst_out_hwdata_at_t = ahb_mst_out_hwdata@t,
	ahb_mst_out_hwrite_at_t = ahb_mst_out_hwrite@t,
	phase_at_t = phase@t,
	response_hrdata_at_t = response_hrdata@t,
	response_hresp_at_t = response_hresp@t;
assume:
	at t: state_47;
	at t: not(from_bus_sync);
prove:
	at t+1: state_47;
	at t+1: ahb_mst_out_haddr = ahb_mst_out_haddr_at_t;
	at t+1: ahb_mst_out_hburst = ahb_mst_out_hburst_at_t;
	at t+1: ahb_mst_out_hbusreq = ahb_mst_out_hbusreq_at_t;
	at t+1: ahb_mst_out_hlock = ahb_mst_out_hlock_at_t;
	at t+1: ahb_mst_out_hprot = ahb_mst_out_hprot_at_t;
	at t+1: ahb_mst_out_hsize = ahb_mst_out_hsize_at_t;
	at t+1: ahb_mst_out_htrans = ahb_mst_out_htrans_at_t;
	at t+1: ahb_mst_out_hwdata = ahb_mst_out_hwdata_at_t;
	at t+1: ahb_mst_out_hwrite = ahb_mst_out_hwrite_at_t;
	at t+1: phase = phase_at_t;
	at t+1: response_hrdata = response_hrdata_at_t;
	at t+1: response_hresp = response_hresp_at_t;
	at t+1: from_bus_notify = true;
	at t+1: from_master_notify = false;
	at t+1: to_bus_notify = false;
	at t+1: to_master_notify = false;
end property;


property wait_state_56 is
dependencies: no_reset;
freeze:
	ahb_mst_out_haddr_at_t = ahb_mst_out_haddr@t,
	ahb_mst_out_hburst_at_t = ahb_mst_out_hburst@t,
	ahb_mst_out_hbusreq_at_t = ahb_mst_out_hbusreq@t,
	ahb_mst_out_hlock_at_t = ahb_mst_out_hlock@t,
	ahb_mst_out_hprot_at_t = ahb_mst_out_hprot@t,
	ahb_mst_out_hsize_at_t = ahb_mst_out_hsize@t,
	ahb_mst_out_htrans_at_t = ahb_mst_out_htrans@t,
	ahb_mst_out_hwdata_at_t = ahb_mst_out_hwdata@t,
	ahb_mst_out_hwrite_at_t = ahb_mst_out_hwrite@t,
	phase_at_t = phase@t,
	response_hrdata_at_t = response_hrdata@t,
	response_hresp_at_t = response_hresp@t;
assume:
	at t: state_56;
	at t: not(to_master_sync);
prove:
	at t+1: state_56;
	at t+1: ahb_mst_out_haddr = ahb_mst_out_haddr_at_t;
	at t+1: ahb_mst_out_hburst = ahb_mst_out_hburst_at_t;
	at t+1: ahb_mst_out_hbusreq = ahb_mst_out_hbusreq_at_t;
	at t+1: ahb_mst_out_hlock = ahb_mst_out_hlock_at_t;
	at t+1: ahb_mst_out_hprot = ahb_mst_out_hprot_at_t;
	at t+1: ahb_mst_out_hsize = ahb_mst_out_hsize_at_t;
	at t+1: ahb_mst_out_htrans = ahb_mst_out_htrans_at_t;
	at t+1: ahb_mst_out_hwdata = ahb_mst_out_hwdata_at_t;
	at t+1: ahb_mst_out_hwrite = ahb_mst_out_hwrite_at_t;
	at t+1: phase = phase_at_t;
	at t+1: response_hrdata = response_hrdata_at_t;
	at t+1: response_hresp = response_hresp_at_t;
	at t+1: to_master_sig_hrdata = response_hrdata_at_t;
	at t+1: to_master_sig_hresp = response_hresp_at_t;
	at t+1: from_bus_notify = false;
	at t+1: from_master_notify = false;
	at t+1: to_bus_notify = false;
	at t+1: to_master_notify = true;
end property;


