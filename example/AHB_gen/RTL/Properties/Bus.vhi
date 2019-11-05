-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro master_in_sync : boolean :=  end macro;
--macro master_out_sync : boolean := end macro;
--macro slave_in0_sync : boolean := end macro;
--macro slave_in1_sync : boolean := end macro;
--macro slave_in2_sync : boolean := end macro;
--macro slave_out0_sync : boolean := end macro;
--macro slave_out1_sync : boolean := end macro;
--macro slave_out2_sync : boolean := end macro;
--macro master_in_notify : boolean := end macro;
--macro master_out_notify : boolean := end macro;
--macro slave_in0_notify : boolean := end macro;
--macro slave_in1_notify : boolean := end macro;
--macro slave_in2_notify : boolean := end macro;
--macro slave_out0_notify : boolean := end macro;
--macro slave_out1_notify : boolean := end macro;
--macro slave_out2_notify : boolean := end macro;


-- DP SIGNALS --
macro master_in_sig_haddr : unsigned := master_in.haddr end macro;
macro master_in_sig_hsize : mask := 
if(master_in.hsize = MT_BU) then
MT_B
elsif(master_in.hsize = MT_HU) then
MT_H
else
master_in.hsize
end if;
 end macro;
macro master_in_sig_hwdata : unsigned := master_in.hwdata end macro;
macro master_in_sig_hwrite : trans_type := master_in.hwrite end macro;
macro master_out_sig_hrdata : unsigned := master_out.hrdata end macro;
macro master_out_sig_hresp : unsigned := master_out.hresp end macro;
macro slave_in0_sig_hrdata : unsigned := slave_in0.hrdata end macro;
macro slave_in0_sig_hresp : unsigned := 
if(slave_in0.hresp /= AHB_OKAY) then
AHB_ERROR
else
AHB_OKAY
end if;
 end macro;
macro slave_in1_sig_hrdata : unsigned := slave_in1.hrdata end macro;
macro slave_in1_sig_hresp : unsigned := 
if(slave_in1.hresp /= AHB_OKAY) then
AHB_ERROR
else
AHB_OKAY
end if;
  end macro;
macro slave_in2_sig_hrdata : unsigned := slave_in2.hrdata end macro;
macro slave_in2_sig_hresp : unsigned := 
if(slave_in2.hresp /= AHB_OKAY) then
AHB_ERROR
else
AHB_OKAY
end if;
  end macro;
macro slave_out0_sig_haddr : unsigned := slave_out0.haddr end macro;
macro slave_out0_sig_hsize : mask := slave_out0.hsize end macro;
macro slave_out0_sig_hwdata : unsigned := slave_out0.hwdata end macro;
macro slave_out0_sig_hwrite : trans_type := slave_out0.hwrite end macro;
macro slave_out1_sig_haddr : unsigned := slave_out1.haddr end macro;
macro slave_out1_sig_hsize : mask := slave_out1.hsize end macro;
macro slave_out1_sig_hwdata : unsigned := slave_out1.hwdata end macro;
macro slave_out1_sig_hwrite : trans_type := slave_out1.hwrite end macro;
macro slave_out2_sig_haddr : unsigned := slave_out2.haddr end macro;
macro slave_out2_sig_hsize : mask := slave_out2.hsize end macro;
macro slave_out2_sig_hwdata : unsigned := slave_out2.hwdata end macro;
macro slave_out2_sig_hwrite : trans_type := slave_out2.hwrite end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro req_haddr : unsigned :=
if(mwrp/addr_reg >= x"10000000" and mwrp/addr_reg < x"10010000") then
swrp1/wrp_to_slv.haddr;
elsif(mwrp/addr_reg >= x"20000000" and mwrp/addr_reg < x"20010000") then
swrp2/wrp_to_slv.haddr;
else
mwrp/addr_reg;
end if;
end macro;

macro req_hsize : mask := 
if(mwrp/size_reg = MT_BU) then
MT_B
elsif(mwrp/size_reg = MT_HU) then
MT_H
else
mwrp/size_reg
end if;
end macro;

macro req_hwdata : unsigned := 
if(mwrp/writing = resize(0,1)) then
resize(0,32) else
mwrp/hwdata;
end if; 
end macro;

macro req_hwrite : trans_type :=
if(mwrp/writing = resize(1,1)) then
AHB_WRITE;
else
AHB_READ;
end if;
end macro;

macro resp_hrdata : unsigned := mwrp/hrdata end macro;
macro resp_hresp : unsigned := mwrp/hresp end macro;


-- STATES --
macro run_0 : boolean := 
    master_in_notify and 
    not(slave_out0_notify) and
    not(slave_in0_notify) and
    not(master_out_notify) and
    not(slave_out1_notify) and
    not(slave_in1_notify) and
    not(slave_out2_notify) and
    not(slave_in2_notify)
end macro;
macro run_1 : boolean :=
    not(master_in_notify) and 
    slave_out0_notify and
    not(slave_in0_notify) and
    not(master_out_notify) and
    not(slave_out1_notify) and
    not(slave_in1_notify) and
    not(slave_out2_notify) and
    not(slave_in2_notify)
end macro;
macro run_2 : boolean :=
    not(master_in_notify) and 
    not(slave_out0_notify) and
    slave_in0_notify and
    not(master_out_notify) and
    not(slave_out1_notify) and
    not(slave_in1_notify) and
    not(slave_out2_notify) and
    not(slave_in2_notify) 
 
end macro;
macro run_3 : boolean :=
    not(master_in_notify) and 
    not(slave_out0_notify) and
    not(slave_in0_notify) and
    master_out_notify and
    not(slave_out1_notify) and
    not(slave_in1_notify) and
    not(slave_out2_notify) and
    not(slave_in2_notify)
end macro;
macro run_4 : boolean :=
    not(master_in_notify) and 
    not(slave_out0_notify) and
    not(slave_in0_notify) and
    not(master_out_notify) and
    slave_out1_notify and
    not(slave_in1_notify) and
    not(slave_out2_notify) and
    not(slave_in2_notify)
end macro;
macro run_5 : boolean :=
    not(master_in_notify) and 
    not(slave_out0_notify) and
    not(slave_in0_notify) and
    not(master_out_notify) and
    not(slave_out1_notify) and
    slave_in1_notify and
    not(slave_out2_notify) and
    not(slave_in2_notify)
end macro;
macro run_6 : boolean :=
    not(master_in_notify) and 
    not(slave_out0_notify) and
    not(slave_in0_notify) and
    not(master_out_notify) and
    not(slave_out1_notify) and
    not(slave_in1_notify) and
    slave_out2_notify and
    not(slave_in2_notify)
end macro;
macro run_7 : boolean := 
    not(master_in_notify) and 
    not(slave_out0_notify) and
    not(slave_in0_notify) and
    not(master_out_notify) and
    not(slave_out1_notify) and
    not(slave_in1_notify) and
    not(slave_out2_notify) and
    slave_in2_notify
end macro;



-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: req_haddr = resize(0,32);
	 at t: req_hsize = MT_B;
	 at t: req_hwdata = resize(0,32);
	 at t: req_hwrite = AHB_READ;
	 at t: resp_hrdata = resize(0,32);
	 at t: resp_hresp = resize(0,32);
	 at t: master_in_notify = true;
	 at t: master_out_notify = false;
	 at t: slave_in0_notify = false;
	 at t: slave_in1_notify = false;
	 at t: slave_in2_notify = false;
	 at t: slave_out0_notify = false;
	 at t: slave_out1_notify = false;
	 at t: slave_out2_notify = false;
end property;


property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	t_end =t + 2..3 waits_for complete slave_out0_notify = true;
freeze:
	master_in_sig_haddr_at_t = master_in_sig_haddr@t,
	master_in_sig_hsize_at_t = master_in_sig_hsize@t,
	master_in_sig_hwdata_at_t = master_in_sig_hwdata@t,
	master_in_sig_hwrite_at_t = master_in_sig_hwrite@t,
	resp_hrdata_at_t = resp_hrdata@t,
	resp_hresp_at_t = resp_hresp@t;
assume:
	at t: run_0;
	at t: not((master_in_sig_hwrite = AHB_READ));
	at t: not((resize(65536,32) <= master_in_sig_haddr));
	at t: master_in_sync;
prove:
	at t_end: run_1;
	at t_end: req_haddr = master_in_sig_haddr_at_t;
	at t_end: req_hsize = master_in_sig_hsize_at_t;
	at t_end: req_hwdata = master_in_sig_hwdata_at_t;
	at t_end: req_hwrite = master_in_sig_hwrite_at_t;
	at t_end: resp_hrdata = resp_hrdata_at_t;
	at t_end: resp_hresp = resp_hresp_at_t;
	at t_end: slave_out0_sig_haddr = master_in_sig_haddr_at_t;
	at t_end: slave_out0_sig_hsize = master_in_sig_hsize_at_t;
	at t_end: slave_out0_sig_hwdata = master_in_sig_hwdata_at_t;
	at t_end: slave_out0_sig_hwrite = master_in_sig_hwrite_at_t;
	during[t+1, t_end]: master_in_notify = false;
	during[t+1, t_end]: master_out_notify = false;
	during[t+1, t_end]: slave_in0_notify = false;
	during[t+1, t_end]: slave_in1_notify = false;
	during[t+1, t_end]: slave_in2_notify = false;
	during[t+1, t_end-1]: slave_out0_notify = false;
	at t_end: slave_out0_notify = true;
	during[t+1, t_end]: slave_out1_notify = false;
	during[t+1, t_end]: slave_out2_notify = false;
end property;


property run_0_read_1 is
dependencies: no_reset;
for timepoints:
	t_end = t + 2..3 waits_for complete slave_out0_notify = true;
freeze:
	master_in_sig_haddr_at_t = master_in_sig_haddr@t,
	master_in_sig_hsize_at_t = master_in_sig_hsize@t,
	master_in_sig_hwrite_at_t = master_in_sig_hwrite@t,
	resp_hrdata_at_t = resp_hrdata@t,
	resp_hresp_at_t = resp_hresp@t;
assume:
	at t: run_0;
	at t: (master_in_sig_hwrite = AHB_READ);
	at t: not((resize(65536,32) <= master_in_sig_haddr));
	at t: master_in_sync;
prove:
	at t_end: run_1;
	at t_end: req_haddr = master_in_sig_haddr_at_t;
	at t_end: req_hsize = master_in_sig_hsize_at_t;
	at t_end: req_hwdata = 0;
	at t_end: req_hwrite = master_in_sig_hwrite_at_t;
	at t_end: resp_hrdata = resp_hrdata_at_t;
	at t_end: resp_hresp = resp_hresp_at_t;
	at t_end: slave_out0_sig_haddr = master_in_sig_haddr_at_t;
	at t_end: slave_out0_sig_hsize = master_in_sig_hsize_at_t;
	at t_end: slave_out0_sig_hwdata = 0;
	at t_end: slave_out0_sig_hwrite = master_in_sig_hwrite_at_t;
	during[t+1, t_end]: master_in_notify = false;
	during[t+1, t_end]: master_out_notify = false;
	during[t+1, t_end]: slave_in0_notify = false;
	during[t+1, t_end]: slave_in1_notify = false;
	during[t+1, t_end]: slave_in2_notify = false;
	during[t+1, t_end-1]: slave_out0_notify = false;
	at t_end: slave_out0_notify = true;
	during[t+1, t_end]: slave_out1_notify = false;
	during[t+1, t_end]: slave_out2_notify = false;
end property;


property run_0_read_2 is
dependencies: no_reset;
for timepoints:
	t_end = t + 3..4 waits_for complete master_out_notify = true;
freeze:
	master_in_sig_haddr_at_t = master_in_sig_haddr@t,
	master_in_sig_hsize_at_t = master_in_sig_hsize@t,
	master_in_sig_hwrite_at_t = master_in_sig_hwrite@t;
assume:
	at t: run_0;
	at t: (master_in_sig_hwrite = AHB_READ);
	at t: (resize(65536,32) <= master_in_sig_haddr);
	at t: not(((resize(268435456,32) <= master_in_sig_haddr) and not((resize(268500992,32) <= master_in_sig_haddr))));
	at t: not(((resize(536870912,32) <= master_in_sig_haddr) and not((resize(536936448,32) <= master_in_sig_haddr))));
	at t: master_in_sync;
prove:
	at t_end: run_3;
	at t_end: master_out_sig_hrdata = 0;
	at t_end: master_out_sig_hresp = 1;
	at t_end: req_haddr = master_in_sig_haddr_at_t;
	at t_end: req_hsize = master_in_sig_hsize_at_t;
	at t_end: req_hwdata = 0;
	at t_end: req_hwrite = master_in_sig_hwrite_at_t;
	at t_end: resp_hrdata = 0;
	at t_end: resp_hresp = 1;
	during[t+1, t_end]: master_in_notify = false;
	during[t+1, t_end-1]: master_out_notify = false;
	at t_end: master_out_notify = true;
	during[t+1, t_end]: slave_in0_notify = false;
	during[t+1, t_end]: slave_in1_notify = false;
	during[t+1, t_end]: slave_in2_notify = false;
	during[t+1, t_end]: slave_out0_notify = false;
	during[t+1, t_end]: slave_out1_notify = false;
	during[t+1, t_end]: slave_out2_notify = false;
end property;


property run_0_read_3 is
dependencies: no_reset;
for timepoints:
	t_end = t + 3..4 waits_for complete master_out_notify = true;
freeze:
	master_in_sig_haddr_at_t = master_in_sig_haddr@t,
	master_in_sig_hsize_at_t = master_in_sig_hsize@t,
	master_in_sig_hwdata_at_t = master_in_sig_hwdata@t,
	master_in_sig_hwrite_at_t = master_in_sig_hwrite@t;
assume:
	at t: run_0;
	at t: (resize(65536,32) <= master_in_sig_haddr);
	at t: not(((resize(268435456,32) <= master_in_sig_haddr) and not((resize(268500992,32) <= master_in_sig_haddr))));
	at t: not(((resize(536870912,32) <= master_in_sig_haddr) and not((resize(536936448,32) <= master_in_sig_haddr))));
	at t: (master_in_sig_hwrite = AHB_WRITE);
	at t: master_in_sync;
prove:
	at t_end: run_3;
	at t_end: master_out_sig_hrdata = 0;
	at t_end: master_out_sig_hresp = 1;
	at t_end: req_haddr = master_in_sig_haddr_at_t;
	at t_end: req_hsize = master_in_sig_hsize_at_t;
	at t_end: req_hwdata = master_in_sig_hwdata_at_t;
	at t_end: req_hwrite = master_in_sig_hwrite_at_t;
	at t_end: resp_hrdata = 0;
	at t_end: resp_hresp = 1;
	during[t+1, t_end]: master_in_notify = false;
	during[t+1, t_end-1]: master_out_notify = false;
	at t_end: master_out_notify = true;
	during[t+1, t_end]: slave_in0_notify = false;
	during[t+1, t_end]: slave_in1_notify = false;
	during[t+1, t_end]: slave_in2_notify = false;
	during[t+1, t_end]: slave_out0_notify = false;
	during[t+1, t_end]: slave_out1_notify = false;
	during[t+1, t_end]: slave_out2_notify = false;
end property;


property run_0_read_4 is
dependencies: no_reset;
for timepoints:
	t_end = t + 2..3 waits_for complete slave_out1_notify = true;
freeze:
	master_in_sig_haddr_at_t = master_in_sig_haddr@t,
	master_in_sig_hsize_at_t = master_in_sig_hsize@t,
	master_in_sig_hwdata_at_t = master_in_sig_hwdata@t,
	master_in_sig_hwrite_at_t = master_in_sig_hwrite@t,
	resp_hrdata_at_t = resp_hrdata@t,
	resp_hresp_at_t = resp_hresp@t;
assume:
	at t: run_0;
	at t: not((master_in_sig_hwrite = AHB_READ));
	at t: (resize(268435456,32) <= master_in_sig_haddr);
	at t: not((resize(268500992,32) <= master_in_sig_haddr));
	at t: master_in_sync;
prove:
	at t_end: run_4;
	at t_end: req_haddr = (4026531840 + master_in_sig_haddr_at_t)(31 downto 0);
	at t_end: req_hsize = master_in_sig_hsize_at_t;
	at t_end: req_hwdata = master_in_sig_hwdata_at_t;
	at t_end: req_hwrite = master_in_sig_hwrite_at_t;
	at t_end: resp_hrdata = resp_hrdata_at_t;
	at t_end: resp_hresp = resp_hresp_at_t;
	at t_end: slave_out1_sig_haddr = (4026531840 + master_in_sig_haddr_at_t)(31 downto 0);
	at t_end: slave_out1_sig_hsize = master_in_sig_hsize_at_t;
	at t_end: slave_out1_sig_hwdata = master_in_sig_hwdata_at_t;
	at t_end: slave_out1_sig_hwrite = master_in_sig_hwrite_at_t;
	during[t+1, t_end]: master_in_notify = false;
	during[t+1, t_end]: master_out_notify = false;
	during[t+1, t_end]: slave_in0_notify = false;
	during[t+1, t_end]: slave_in1_notify = false;
	during[t+1, t_end]: slave_in2_notify = false;
	during[t+1, t_end]: slave_out0_notify = false;
	during[t+1, t_end-1]: slave_out1_notify = false;
	at t_end: slave_out1_notify = true;
	during[t+1, t_end]: slave_out2_notify = false;
end property;


property run_0_read_5 is
dependencies: no_reset;
for timepoints:
	t_end = t + 2..3 waits_for complete slave_out1_notify = true;
freeze:
	master_in_sig_haddr_at_t = master_in_sig_haddr@t,
	master_in_sig_hsize_at_t = master_in_sig_hsize@t,
	master_in_sig_hwrite_at_t = master_in_sig_hwrite@t,
	resp_hrdata_at_t = resp_hrdata@t,
	resp_hresp_at_t = resp_hresp@t;
assume:
	at t: run_0;
	at t: (master_in_sig_hwrite = AHB_READ);
	at t: (resize(268435456,32) <= master_in_sig_haddr);
	at t: not((resize(268500992,32) <= master_in_sig_haddr));
	at t: master_in_sync;
prove:
	at t_end: run_4;
	at t_end: req_haddr = (4026531840 + master_in_sig_haddr_at_t)(31 downto 0);
	at t_end: req_hsize = master_in_sig_hsize_at_t;
	at t_end: req_hwdata = 0;
	at t_end: req_hwrite = master_in_sig_hwrite_at_t;
	at t_end: resp_hrdata = resp_hrdata_at_t;
	at t_end: resp_hresp = resp_hresp_at_t;
	at t_end: slave_out1_sig_haddr = (4026531840 + master_in_sig_haddr_at_t)(31 downto 0);
	at t_end: slave_out1_sig_hsize = master_in_sig_hsize_at_t;
	at t_end: slave_out1_sig_hwdata = 0;
	at t_end: slave_out1_sig_hwrite = master_in_sig_hwrite_at_t;
	during[t+1, t_end]: master_in_notify = false;
	during[t+1, t_end]: master_out_notify = false;
	during[t+1, t_end]: slave_in0_notify = false;
	during[t+1, t_end]: slave_in1_notify = false;
	during[t+1, t_end]: slave_in2_notify = false;
	during[t+1, t_end]: slave_out0_notify = false;
	during[t+1, t_end-1]: slave_out1_notify = false;
	at t_end: slave_out1_notify = true;
	during[t+1, t_end]: slave_out2_notify = false;
end property;


property run_0_read_6 is
dependencies: no_reset;
for timepoints:
	t_end = t + 2..3 waits_for complete slave_out2_notify = true;
freeze:
	master_in_sig_haddr_at_t = master_in_sig_haddr@t,
	master_in_sig_hsize_at_t = master_in_sig_hsize@t,
	master_in_sig_hwdata_at_t = master_in_sig_hwdata@t,
	master_in_sig_hwrite_at_t = master_in_sig_hwrite@t,
	resp_hrdata_at_t = resp_hrdata@t,
	resp_hresp_at_t = resp_hresp@t;
assume:
	at t: run_0;
	at t: not((master_in_sig_hwrite = AHB_READ));
	at t: (resize(536870912,32) <= master_in_sig_haddr);
	at t: not((resize(536936448,32) <= master_in_sig_haddr));
	at t: master_in_sync;
prove:
	at t_end: run_6;
	at t_end: req_haddr = (3758096384 + master_in_sig_haddr_at_t)(31 downto 0);
	at t_end: req_hsize = master_in_sig_hsize_at_t;
	at t_end: req_hwdata = master_in_sig_hwdata_at_t;
	at t_end: req_hwrite = master_in_sig_hwrite_at_t;
	at t_end: resp_hrdata = resp_hrdata_at_t;
	at t_end: resp_hresp = resp_hresp_at_t;
	at t_end: slave_out2_sig_haddr = (3758096384 + master_in_sig_haddr_at_t)(31 downto 0);
	at t_end: slave_out2_sig_hsize = master_in_sig_hsize_at_t;
	at t_end: slave_out2_sig_hwdata = master_in_sig_hwdata_at_t;
	at t_end: slave_out2_sig_hwrite = master_in_sig_hwrite_at_t;
	during[t+1, t_end]: master_in_notify = false;
	during[t+1, t_end]: master_out_notify = false;
	during[t+1, t_end]: slave_in0_notify = false;
	during[t+1, t_end]: slave_in1_notify = false;
	during[t+1, t_end]: slave_in2_notify = false;
	during[t+1, t_end]: slave_out0_notify = false;
	during[t+1, t_end]: slave_out1_notify = false;
	during[t+1, t_end-1]: slave_out2_notify = false;
	at t_end: slave_out2_notify = true;
end property;


property run_0_read_7 is
dependencies: no_reset;
for timepoints:
	t_end = t + 2..3 waits_for complete slave_out2_notify = true;
freeze:
	master_in_sig_haddr_at_t = master_in_sig_haddr@t,
	master_in_sig_hsize_at_t = master_in_sig_hsize@t,
	master_in_sig_hwrite_at_t = master_in_sig_hwrite@t,
	resp_hrdata_at_t = resp_hrdata@t,
	resp_hresp_at_t = resp_hresp@t;
assume:
	at t: run_0;
	at t: (master_in_sig_hwrite = AHB_READ);
	at t: (resize(536870912,32) <= master_in_sig_haddr);
	at t: not((resize(536936448,32) <= master_in_sig_haddr));
	at t: master_in_sync;
prove:
	at t_end: run_6;
	at t_end: req_haddr = (3758096384 + master_in_sig_haddr_at_t)(31 downto 0);
	at t_end: req_hsize = master_in_sig_hsize_at_t;
	at t_end: req_hwdata = 0;
	at t_end: req_hwrite = master_in_sig_hwrite_at_t;
	at t_end: resp_hrdata = resp_hrdata_at_t;
	at t_end: resp_hresp = resp_hresp_at_t;
	at t_end: slave_out2_sig_haddr = (3758096384 + master_in_sig_haddr_at_t)(31 downto 0);
	at t_end: slave_out2_sig_hsize = master_in_sig_hsize_at_t;
	at t_end: slave_out2_sig_hwdata = 0;
	at t_end: slave_out2_sig_hwrite = master_in_sig_hwrite_at_t;
	during[t+1, t_end]: master_in_notify = false;
	during[t+1, t_end]: master_out_notify = false;
	during[t+1, t_end]: slave_in0_notify = false;
	during[t+1, t_end]: slave_in1_notify = false;
	during[t+1, t_end]: slave_in2_notify = false;
	during[t+1, t_end]: slave_out0_notify = false;
	during[t+1, t_end]: slave_out1_notify = false;
	during[t+1, t_end-1]: slave_out2_notify = false;
	at t_end: slave_out2_notify = true;
end property;


property run_1_write_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_haddr_at_t = req_haddr@t,
	req_hsize_at_t = req_hsize@t,
	req_hwdata_at_t = req_hwdata@t,
	req_hwrite_at_t = req_hwrite@t,
	resp_hrdata_at_t = resp_hrdata@t,
	resp_hresp_at_t = resp_hresp@t;
assume:
	at t: run_1;
	at t: slave_out0_sync;
prove:
	at t_end: run_2;
	at t_end: req_haddr = req_haddr_at_t;
	at t_end: req_hsize = req_hsize_at_t;
	at t_end: req_hwdata = req_hwdata_at_t;
	at t_end: req_hwrite = req_hwrite_at_t;
	at t_end: resp_hrdata = resp_hrdata_at_t;
	at t_end: resp_hresp = resp_hresp_at_t;
	during[t+1, t_end]: master_in_notify = false;
	during[t+1, t_end]: master_out_notify = false;
	during[t+1, t_end-1]: slave_in0_notify = false;
	at t_end: slave_in0_notify = true;
	during[t+1, t_end]: slave_in1_notify = false;
	during[t+1, t_end]: slave_in2_notify = false;
	during[t+1, t_end]: slave_out0_notify = false;
	during[t+1, t_end]: slave_out1_notify = false;
	during[t+1, t_end]: slave_out2_notify = false;
end property;


property run_2_read_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+2..3 waits_for complete master_out_notify = true;
freeze:
	req_haddr_at_t = req_haddr@t,
	req_hsize_at_t = req_hsize@t,
	req_hwdata_at_t = req_hwdata@t,
	req_hwrite_at_t = req_hwrite@t,
	slave_in0_sig_hrdata_at_t = slave_in0_sig_hrdata@t,
	slave_in0_sig_hresp_at_t = slave_in0_sig_hresp@t;
assume:
	at t: run_2;
	at t: not((req_hwrite = AHB_WRITE));
	at t: slave_in0_sync;
prove:
	at t_end: run_3;
	at t_end: master_out_sig_hrdata = slave_in0_sig_hrdata_at_t;
	at t_end: master_out_sig_hresp = slave_in0_sig_hresp_at_t;
	at t_end: req_haddr = req_haddr_at_t;
	at t_end: req_hsize = req_hsize_at_t;
	at t_end: req_hwdata = req_hwdata_at_t;
	at t_end: req_hwrite = req_hwrite_at_t;
	at t_end: resp_hrdata = slave_in0_sig_hrdata_at_t;
	at t_end: resp_hresp = slave_in0_sig_hresp_at_t;
	during[t+1, t_end]: master_in_notify = false;
	during[t+1, t_end-1]: master_out_notify = false;
	at t_end: master_out_notify = true;
	during[t+1, t_end]: slave_in0_notify = false;
	during[t+1, t_end]: slave_in1_notify = false;
	during[t+1, t_end]: slave_in2_notify = false;
	during[t+1, t_end]: slave_out0_notify = false;
	during[t+1, t_end]: slave_out1_notify = false;
	during[t+1, t_end]: slave_out2_notify = false;
end property;


property run_2_read_10 is
dependencies: no_reset;
for timepoints:
	t_end =t+2..3 waits_for complete master_out_notify = true;
freeze:
	req_haddr_at_t = req_haddr@t,
	req_hsize_at_t = req_hsize@t,
	req_hwdata_at_t = req_hwdata@t,
	req_hwrite_at_t = req_hwrite@t,
	slave_in0_sig_hresp_at_t = slave_in0_sig_hresp@t;
assume:
	at t: run_2;
	at t: (req_hwrite = AHB_WRITE);
	at t: slave_in0_sync;
prove:
	at t_end: run_3;
	at t_end: master_out_sig_hrdata = 0;
	at t_end: master_out_sig_hresp = slave_in0_sig_hresp_at_t;
	at t_end: req_haddr = req_haddr_at_t;
	at t_end: req_hsize = req_hsize_at_t;
	at t_end: req_hwdata = req_hwdata_at_t;
	at t_end: req_hwrite = req_hwrite_at_t;
	at t_end: resp_hrdata = 0;
	at t_end: resp_hresp = slave_in0_sig_hresp_at_t;
	during[t+1, t_end]: master_in_notify = false;
	during[t+1, t_end-1]: master_out_notify = false;
	at t_end: master_out_notify = true;
	during[t+1, t_end]: slave_in0_notify = false;
	during[t+1, t_end]: slave_in1_notify = false;
	during[t+1, t_end]: slave_in2_notify = false;
	during[t+1, t_end]: slave_out0_notify = false;
	during[t+1, t_end]: slave_out1_notify = false;
	during[t+1, t_end]: slave_out2_notify = false;
end property;


property run_3_write_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_haddr_at_t = req_haddr@t,
	req_hsize_at_t = req_hsize@t,
	req_hwdata_at_t = req_hwdata@t,
	req_hwrite_at_t = req_hwrite@t,
	resp_hrdata_at_t = resp_hrdata@t,
	resp_hresp_at_t = resp_hresp@t;
assume:
	at t: run_3;
	at t: master_out_sync;
prove:
	at t_end: run_0;
	at t_end: req_haddr = req_haddr_at_t;
	at t_end: req_hsize = req_hsize_at_t;
	at t_end: req_hwdata = req_hwdata_at_t;
	at t_end: req_hwrite = req_hwrite_at_t;
	at t_end: resp_hrdata = resp_hrdata_at_t;
	at t_end: resp_hresp = resp_hresp_at_t;
	during[t+1, t_end-1]: master_in_notify = false;
	at t_end: master_in_notify = true;
	during[t+1, t_end]: master_out_notify = false;
	during[t+1, t_end]: slave_in0_notify = false;
	during[t+1, t_end]: slave_in1_notify = false;
	during[t+1, t_end]: slave_in2_notify = false;
	during[t+1, t_end]: slave_out0_notify = false;
	during[t+1, t_end]: slave_out1_notify = false;
	during[t+1, t_end]: slave_out2_notify = false;
end property;


property run_4_write_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_haddr_at_t = req_haddr@t,
	req_hsize_at_t = req_hsize@t,
	req_hwdata_at_t = req_hwdata@t,
	req_hwrite_at_t = req_hwrite@t,
	resp_hrdata_at_t = resp_hrdata@t,
	resp_hresp_at_t = resp_hresp@t;
assume:
	at t: run_4;
	at t: slave_out1_sync;
prove:
	at t_end: run_5;
	at t_end: req_haddr = req_haddr_at_t;
	at t_end: req_hsize = req_hsize_at_t;
	at t_end: req_hwdata = req_hwdata_at_t;
	at t_end: req_hwrite = req_hwrite_at_t;
	at t_end: resp_hrdata = resp_hrdata_at_t;
	at t_end: resp_hresp = resp_hresp_at_t;
	during[t+1, t_end]: master_in_notify = false;
	during[t+1, t_end]: master_out_notify = false;
	during[t+1, t_end]: slave_in0_notify = false;
	during[t+1, t_end-1]: slave_in1_notify = false;
	at t_end: slave_in1_notify = true;
	during[t+1, t_end]: slave_in2_notify = false;
	during[t+1, t_end]: slave_out0_notify = false;
	during[t+1, t_end]: slave_out1_notify = false;
	during[t+1, t_end]: slave_out2_notify = false;
end property;


property run_5_read_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+2..3 waits_for complete master_out_notify = true;
freeze:
	req_haddr_at_t = req_haddr@t,
	req_hsize_at_t = req_hsize@t,
	req_hwdata_at_t = req_hwdata@t,
	req_hwrite_at_t = req_hwrite@t,
	slave_in1_sig_hrdata_at_t = slave_in1_sig_hrdata@t,
	slave_in1_sig_hresp_at_t = slave_in1_sig_hresp@t;
assume:
	at t: run_5;
	at t: not((req_hwrite = AHB_WRITE));
	at t: slave_in1_sync;
prove:
	at t_end: run_3;
	at t_end: master_out_sig_hrdata = slave_in1_sig_hrdata_at_t;
	at t_end: master_out_sig_hresp = slave_in1_sig_hresp_at_t;
	at t_end: req_haddr = req_haddr_at_t;
	at t_end: req_hsize = req_hsize_at_t;
	at t_end: req_hwdata = req_hwdata_at_t;
	at t_end: req_hwrite = req_hwrite_at_t;
	at t_end: resp_hrdata = slave_in1_sig_hrdata_at_t;
	at t_end: resp_hresp = slave_in1_sig_hresp_at_t;
	during[t+1, t_end]: master_in_notify = false;
	during[t+1, t_end-1]: master_out_notify = false;
	at t_end: master_out_notify = true;
	during[t+1, t_end]: slave_in0_notify = false;
	during[t+1, t_end]: slave_in1_notify = false;
	during[t+1, t_end]: slave_in2_notify = false;
	during[t+1, t_end]: slave_out0_notify = false;
	during[t+1, t_end]: slave_out1_notify = false;
	during[t+1, t_end]: slave_out2_notify = false;
end property;


property run_5_read_14 is
dependencies: no_reset;
for timepoints:
	t_end = t+2..3 waits_for complete master_out_notify = true;
freeze:
	req_haddr_at_t = req_haddr@t,
	req_hsize_at_t = req_hsize@t,
	req_hwdata_at_t = req_hwdata@t,
	req_hwrite_at_t = req_hwrite@t,
	slave_in1_sig_hresp_at_t = slave_in1_sig_hresp@t;
assume:
	at t: run_5;
	at t: (req_hwrite = AHB_WRITE);
	at t: slave_in1_sync;
prove:
	at t_end: run_3;
	at t_end: master_out_sig_hrdata = 0;
	at t_end: master_out_sig_hresp = slave_in1_sig_hresp_at_t;
	at t_end: req_haddr = req_haddr_at_t;
	at t_end: req_hsize = req_hsize_at_t;
	at t_end: req_hwdata = req_hwdata_at_t;
	at t_end: req_hwrite = req_hwrite_at_t;
	at t_end: resp_hrdata = 0;
	at t_end: resp_hresp = slave_in1_sig_hresp_at_t;
	during[t+1, t_end]: master_in_notify = false;
	during[t+1, t_end-1]: master_out_notify = false;
	at t_end: master_out_notify = true;
	during[t+1, t_end]: slave_in0_notify = false;
	during[t+1, t_end]: slave_in1_notify = false;
	during[t+1, t_end]: slave_in2_notify = false;
	during[t+1, t_end]: slave_out0_notify = false;
	during[t+1, t_end]: slave_out1_notify = false;
	during[t+1, t_end]: slave_out2_notify = false;
end property;


property run_6_write_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_haddr_at_t = req_haddr@t,
	req_hsize_at_t = req_hsize@t,
	req_hwdata_at_t = req_hwdata@t,
	req_hwrite_at_t = req_hwrite@t,
	resp_hrdata_at_t = resp_hrdata@t,
	resp_hresp_at_t = resp_hresp@t;
assume:
	at t: run_6;
	at t: slave_out2_sync;
prove:
	at t_end: run_7;
	at t_end: req_haddr = req_haddr_at_t;
	at t_end: req_hsize = req_hsize_at_t;
	at t_end: req_hwdata = req_hwdata_at_t;
	at t_end: req_hwrite = req_hwrite_at_t;
	at t_end: resp_hrdata = resp_hrdata_at_t;
	at t_end: resp_hresp = resp_hresp_at_t;
	during[t+1, t_end]: master_in_notify = false;
	during[t+1, t_end]: master_out_notify = false;
	during[t+1, t_end]: slave_in0_notify = false;
	during[t+1, t_end]: slave_in1_notify = false;
	during[t+1, t_end-1]: slave_in2_notify = false;
	at t_end: slave_in2_notify = true;
	during[t+1, t_end]: slave_out0_notify = false;
	during[t+1, t_end]: slave_out1_notify = false;
	during[t+1, t_end]: slave_out2_notify = false;
end property;


property run_7_read_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+2..3 waits_for complete master_out_notify = true;
freeze:
	req_haddr_at_t = req_haddr@t,
	req_hsize_at_t = req_hsize@t,
	req_hwdata_at_t = req_hwdata@t,
	req_hwrite_at_t = req_hwrite@t,
	slave_in2_sig_hrdata_at_t = slave_in2_sig_hrdata@t,
	slave_in2_sig_hresp_at_t = slave_in2_sig_hresp@t;
assume:
	at t: run_7;
	at t: not((req_hwrite = AHB_WRITE));
	at t: slave_in2_sync;
prove:
	at t_end: run_3;
	at t_end: master_out_sig_hrdata = slave_in2_sig_hrdata_at_t;
	at t_end: master_out_sig_hresp = slave_in2_sig_hresp_at_t;
	at t_end: req_haddr = req_haddr_at_t;
	at t_end: req_hsize = req_hsize_at_t;
	at t_end: req_hwdata = req_hwdata_at_t;
	at t_end: req_hwrite = req_hwrite_at_t;
	at t_end: resp_hrdata = slave_in2_sig_hrdata_at_t;
	at t_end: resp_hresp = slave_in2_sig_hresp_at_t;
	during[t+1, t_end]: master_in_notify = false;
	during[t+1, t_end-1]: master_out_notify = false;
	at t_end: master_out_notify = true;
	during[t+1, t_end]: slave_in0_notify = false;
	during[t+1, t_end]: slave_in1_notify = false;
	during[t+1, t_end]: slave_in2_notify = false;
	during[t+1, t_end]: slave_out0_notify = false;
	during[t+1, t_end]: slave_out1_notify = false;
	during[t+1, t_end]: slave_out2_notify = false;
end property;


property run_7_read_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+2..3 waits_for complete master_out_notify = true;
freeze:
	req_haddr_at_t = req_haddr@t,
	req_hsize_at_t = req_hsize@t,
	req_hwdata_at_t = req_hwdata@t,
	req_hwrite_at_t = req_hwrite@t,
	slave_in2_sig_hresp_at_t = slave_in2_sig_hresp@t;
assume:
	at t: run_7;
	at t: (req_hwrite = AHB_WRITE);
	at t: slave_in2_sync;
prove:
	at t_end: run_3;
	at t_end: master_out_sig_hrdata = 0;
	at t_end: master_out_sig_hresp = slave_in2_sig_hresp_at_t;
	at t_end: req_haddr = req_haddr_at_t;
	at t_end: req_hsize = req_hsize_at_t;
	at t_end: req_hwdata = req_hwdata_at_t;
	at t_end: req_hwrite = req_hwrite_at_t;
	at t_end: resp_hrdata = 0;
	at t_end: resp_hresp = slave_in2_sig_hresp_at_t;
	during[t+1, t_end]: master_in_notify = false;
	during[t+1, t_end-1]: master_out_notify = false;
	at t_end: master_out_notify = true;
	during[t+1, t_end]: slave_in0_notify = false;
	during[t+1, t_end]: slave_in1_notify = false;
	during[t+1, t_end]: slave_in2_notify = false;
	during[t+1, t_end]: slave_out0_notify = false;
	during[t+1, t_end]: slave_out1_notify = false;
	during[t+1, t_end]: slave_out2_notify = false;
end property;


property wait_run_0 is
dependencies: no_reset;
freeze:
	req_haddr_at_t = req_haddr@t,
	req_hsize_at_t = req_hsize@t,
	req_hwdata_at_t = req_hwdata@t,
	req_hwrite_at_t = req_hwrite@t,
	resp_hrdata_at_t = resp_hrdata@t,
	resp_hresp_at_t = resp_hresp@t;
assume:
	at t: run_0;
	at t: not(master_in_sync);
prove:
	at t+1: run_0;
	at t+1: req_haddr = req_haddr_at_t;
	at t+1: req_hsize = req_hsize_at_t;
	at t+1: req_hwdata = req_hwdata_at_t;
	at t+1: req_hwrite = req_hwrite_at_t;
	at t+1: resp_hrdata = resp_hrdata_at_t;
	at t+1: resp_hresp = resp_hresp_at_t;
	at t+1: master_in_notify = true;
	at t+1: master_out_notify = false;
	at t+1: slave_in0_notify = false;
	at t+1: slave_in1_notify = false;
	at t+1: slave_in2_notify = false;
	at t+1: slave_out0_notify = false;
	at t+1: slave_out1_notify = false;
	at t+1: slave_out2_notify = false;
end property;


property wait_run_1 is
dependencies: no_reset;
freeze:
	req_haddr_at_t = req_haddr@t,
	req_hsize_at_t = req_hsize@t,
	req_hwdata_at_t = req_hwdata@t,
	req_hwrite_at_t = req_hwrite@t,
	resp_hrdata_at_t = resp_hrdata@t,
	resp_hresp_at_t = resp_hresp@t;
assume:
	at t: run_1;
	at t: not(slave_out0_sync);
prove:
	at t+1: run_1;
	at t+1: req_haddr = req_haddr_at_t;
	at t+1: req_hsize = req_hsize_at_t;
	at t+1: req_hwdata = req_hwdata_at_t;
	at t+1: req_hwrite = req_hwrite_at_t;
	at t+1: resp_hrdata = resp_hrdata_at_t;
	at t+1: resp_hresp = resp_hresp_at_t;
	at t+1: slave_out0_sig_haddr = req_haddr_at_t;
	at t+1: slave_out0_sig_hsize = req_hsize_at_t;
	at t+1: slave_out0_sig_hwdata = req_hwdata_at_t;
	at t+1: slave_out0_sig_hwrite = req_hwrite_at_t;
	at t+1: master_in_notify = false;
	at t+1: master_out_notify = false;
	at t+1: slave_in0_notify = false;
	at t+1: slave_in1_notify = false;
	at t+1: slave_in2_notify = false;
	at t+1: slave_out0_notify = true;
	at t+1: slave_out1_notify = false;
	at t+1: slave_out2_notify = false;
end property;


property wait_run_2 is
dependencies: no_reset;
freeze:
	req_haddr_at_t = req_haddr@t,
	req_hsize_at_t = req_hsize@t,
	req_hwdata_at_t = req_hwdata@t,
	req_hwrite_at_t = req_hwrite@t,
	resp_hrdata_at_t = resp_hrdata@t,
	resp_hresp_at_t = resp_hresp@t;
assume:
	at t: run_2;
	at t: not(slave_in0_sync);
prove:
	at t+1: run_2;
	at t+1: req_haddr = req_haddr_at_t;
	at t+1: req_hsize = req_hsize_at_t;
	at t+1: req_hwdata = req_hwdata_at_t;
	at t+1: req_hwrite = req_hwrite_at_t;
	at t+1: resp_hrdata = resp_hrdata_at_t;
	at t+1: resp_hresp = resp_hresp_at_t;
	at t+1: master_in_notify = false;
	at t+1: master_out_notify = false;
	at t+1: slave_in0_notify = true;
	at t+1: slave_in1_notify = false;
	at t+1: slave_in2_notify = false;
	at t+1: slave_out0_notify = false;
	at t+1: slave_out1_notify = false;
	at t+1: slave_out2_notify = false;
end property;


property wait_run_3 is
dependencies: no_reset;
freeze:
	req_haddr_at_t = req_haddr@t,
	req_hsize_at_t = req_hsize@t,
	req_hwdata_at_t = req_hwdata@t,
	req_hwrite_at_t = req_hwrite@t,
	resp_hrdata_at_t = resp_hrdata@t,
	resp_hresp_at_t = resp_hresp@t;
assume:
	at t: run_3;
	at t: not(master_out_sync);
prove:
	at t+1: run_3;
	at t+1: master_out_sig_hrdata = resp_hrdata_at_t;
	at t+1: master_out_sig_hresp = resp_hresp_at_t;
	at t+1: req_haddr = req_haddr_at_t;
	at t+1: req_hsize = req_hsize_at_t;
	at t+1: req_hwdata = req_hwdata_at_t;
	at t+1: req_hwrite = req_hwrite_at_t;
	at t+1: resp_hrdata = resp_hrdata_at_t;
	at t+1: resp_hresp = resp_hresp_at_t;
	at t+1: master_in_notify = false;
	at t+1: master_out_notify = true;
	at t+1: slave_in0_notify = false;
	at t+1: slave_in1_notify = false;
	at t+1: slave_in2_notify = false;
	at t+1: slave_out0_notify = false;
	at t+1: slave_out1_notify = false;
	at t+1: slave_out2_notify = false;
end property;


property wait_run_4 is
dependencies: no_reset;
freeze:
	req_haddr_at_t = req_haddr@t,
	req_hsize_at_t = req_hsize@t,
	req_hwdata_at_t = req_hwdata@t,
	req_hwrite_at_t = req_hwrite@t,
	resp_hrdata_at_t = resp_hrdata@t,
	resp_hresp_at_t = resp_hresp@t;
assume:
	at t: run_4;
	at t: not(slave_out1_sync);
prove:
	at t+1: run_4;
	at t+1: req_haddr = req_haddr_at_t;
	at t+1: req_hsize = req_hsize_at_t;
	at t+1: req_hwdata = req_hwdata_at_t;
	at t+1: req_hwrite = req_hwrite_at_t;
	at t+1: resp_hrdata = resp_hrdata_at_t;
	at t+1: resp_hresp = resp_hresp_at_t;
	at t+1: slave_out1_sig_haddr = req_haddr_at_t;
	at t+1: slave_out1_sig_hsize = req_hsize_at_t;
	at t+1: slave_out1_sig_hwdata = req_hwdata_at_t;
	at t+1: slave_out1_sig_hwrite = req_hwrite_at_t;
	at t+1: master_in_notify = false;
	at t+1: master_out_notify = false;
	at t+1: slave_in0_notify = false;
	at t+1: slave_in1_notify = false;
	at t+1: slave_in2_notify = false;
	at t+1: slave_out0_notify = false;
	at t+1: slave_out1_notify = true;
	at t+1: slave_out2_notify = false;
end property;


property wait_run_5 is
dependencies: no_reset;
freeze:
	req_haddr_at_t = req_haddr@t,
	req_hsize_at_t = req_hsize@t,
	req_hwdata_at_t = req_hwdata@t,
	req_hwrite_at_t = req_hwrite@t,
	resp_hrdata_at_t = resp_hrdata@t,
	resp_hresp_at_t = resp_hresp@t;
assume:
	at t: run_5;
	at t: not(slave_in1_sync);
prove:
	at t+1: run_5;
	at t+1: req_haddr = req_haddr_at_t;
	at t+1: req_hsize = req_hsize_at_t;
	at t+1: req_hwdata = req_hwdata_at_t;
	at t+1: req_hwrite = req_hwrite_at_t;
	at t+1: resp_hrdata = resp_hrdata_at_t;
	at t+1: resp_hresp = resp_hresp_at_t;
	at t+1: master_in_notify = false;
	at t+1: master_out_notify = false;
	at t+1: slave_in0_notify = false;
	at t+1: slave_in1_notify = true;
	at t+1: slave_in2_notify = false;
	at t+1: slave_out0_notify = false;
	at t+1: slave_out1_notify = false;
	at t+1: slave_out2_notify = false;
end property;


property wait_run_6 is
dependencies: no_reset;
freeze:
	req_haddr_at_t = req_haddr@t,
	req_hsize_at_t = req_hsize@t,
	req_hwdata_at_t = req_hwdata@t,
	req_hwrite_at_t = req_hwrite@t,
	resp_hrdata_at_t = resp_hrdata@t,
	resp_hresp_at_t = resp_hresp@t;
assume:
	at t: run_6;
	at t: not(slave_out2_sync);
prove:
	at t+1: run_6;
	at t+1: req_haddr = req_haddr_at_t;
	at t+1: req_hsize = req_hsize_at_t;
	at t+1: req_hwdata = req_hwdata_at_t;
	at t+1: req_hwrite = req_hwrite_at_t;
	at t+1: resp_hrdata = resp_hrdata_at_t;
	at t+1: resp_hresp = resp_hresp_at_t;
	at t+1: slave_out2_sig_haddr = req_haddr_at_t;
	at t+1: slave_out2_sig_hsize = req_hsize_at_t;
	at t+1: slave_out2_sig_hwdata = req_hwdata_at_t;
	at t+1: slave_out2_sig_hwrite = req_hwrite_at_t;
	at t+1: master_in_notify = false;
	at t+1: master_out_notify = false;
	at t+1: slave_in0_notify = false;
	at t+1: slave_in1_notify = false;
	at t+1: slave_in2_notify = false;
	at t+1: slave_out0_notify = false;
	at t+1: slave_out1_notify = false;
	at t+1: slave_out2_notify = true;
end property;


property wait_run_7 is
dependencies: no_reset;
freeze:
	req_haddr_at_t = req_haddr@t,
	req_hsize_at_t = req_hsize@t,
	req_hwdata_at_t = req_hwdata@t,
	req_hwrite_at_t = req_hwrite@t,
	resp_hrdata_at_t = resp_hrdata@t,
	resp_hresp_at_t = resp_hresp@t;
assume:
	at t: run_7;
	at t: not(slave_in2_sync);
prove:
	at t+1: run_7;
	at t+1: req_haddr = req_haddr_at_t;
	at t+1: req_hsize = req_hsize_at_t;
	at t+1: req_hwdata = req_hwdata_at_t;
	at t+1: req_hwrite = req_hwrite_at_t;
	at t+1: resp_hrdata = resp_hrdata_at_t;
	at t+1: resp_hresp = resp_hresp_at_t;
	at t+1: master_in_notify = false;
	at t+1: master_out_notify = false;
	at t+1: slave_in0_notify = false;
	at t+1: slave_in1_notify = false;
	at t+1: slave_in2_notify = true;
	at t+1: slave_out0_notify = false;
	at t+1: slave_out1_notify = false;
	at t+1: slave_out2_notify = false;
end property;


