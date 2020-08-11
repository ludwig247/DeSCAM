-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro master0_in_sync : boolean :=  master_in0_sync  ; end macro;
--macro master0_in_sync : boolean :=  master_in0_sync or mst0/section = request_phase ; end macro;
macro master0_out_sync : boolean :=  master_out0_sync end macro;
--macro master1_in_sync : boolean :=  (master_in1_sync) or mst1/section = request_phase ; end macro;
macro master1_in_sync : boolean :=  (master_in1_sync)  ; end macro;
macro master1_out_sync : boolean := master_out1_sync end macro;
--macro master2_in_sync : boolean :=  (master_in2_sync) or mst2/section = request_phase ; end macro;
macro master2_in_sync : boolean :=  (master_in2_sync) ; end macro;
macro master2_out_sync : boolean :=  master_out2_sync end macro;
--macro master3_in_sync : boolean :=  (master_in3_sync) or mst3/section = request_phase ; end macro;
macro master3_in_sync : boolean :=  (master_in3_sync); end macro;
macro master3_out_sync : boolean := master_out3_sync end macro;
macro slave0_in_sync : boolean := slave_in0_sync end macro;
macro slave0_out_sync : boolean := slave_out0_sync end macro;

macro master0_in_notify : boolean := not(prev(rst)) and prev(master_in0_notify and master_in0_sync); end macro;
macro master0_out_notify : boolean := master_out0_notify end macro;
macro master1_in_notify : boolean :=  not(prev(rst)) and prev(master_in1_notify and master_in1_sync); end macro;
macro master1_out_notify : boolean := master_out1_notify end macro;
macro master2_in_notify : boolean := not(prev(rst)) and prev(master_in2_notify and master_in2_sync); end macro;
macro master2_out_notify : boolean := master_out2_notify end macro;
macro master3_in_notify : boolean := not(prev(rst)) and prev(master_in3_notify and master_in3_sync); end macro;
macro master3_out_notify : boolean := master_out3_notify end macro;
macro slave0_in_notify : boolean := slave_in0_notify end macro;
macro slave0_out_notify : boolean := slave_out0_notify end macro;

-- DP SIGNALS --

--macro master0_in_sig : bus_req_t := end macro;*/
macro master0_in_sig_haddr : unsigned := prev(master_in0.haddr,1) end macro;
macro master0_in_sig_hsize : mask := prev(
	if(master_in0.hsize = MT_HU) then MT_H 
	elsif(master_in0.hsize = MT_BU) then MT_B 
	else master_in0.hsize  end if,1); 
end macro;
macro master0_in_sig_hwdata : unsigned := prev(master_in0.hwdata,1) end macro;
macro master0_in_sig_hwrite : trans_type := prev(master_in0.hwrite,1) end macro;
--macro master0_out_sig : bus_resp_t := master_out0 end macro;
macro master0_out_sig_hrdata : unsigned :=  master_out0.hrdata end macro;
macro master0_out_sig_hresp : unsigned := master_out0.hresp end macro;
--macro master1_in_sig : bus_req_t := end macro;
macro master1_in_sig_haddr : unsigned := prev(master_in1.haddr,1) end macro;
macro master1_in_sig_hsize : mask := prev(
	if(master_in1.hsize = MT_HU) then MT_H 
	elsif(master_in1.hsize = MT_BU) then MT_B 
	else master_in1.hsize  end if,1); 
end macro;
macro master1_in_sig_hwdata : unsigned := prev(master_in1.hwdata,1) end macro;
macro master1_in_sig_hwrite : trans_type := prev(master_in1.hwrite,1) end macro;
--macro master1_out_sig : bus_resp_t := master_out1 end macro;
macro master1_out_sig_hrdata : unsigned :=  master_out1.hrdata end macro;
macro master1_out_sig_hresp : unsigned := master_out1.hresp end macro;
--macro master2_in_sig : bus_req_t := end macro;
macro master2_in_sig_haddr : unsigned := prev(master_in2.haddr,1) end macro;
macro master2_in_sig_hsize : mask := prev(
	if(master_in2.hsize = MT_HU) then MT_H 
	elsif(master_in2.hsize = MT_BU) then MT_B 
	else master_in2.hsize  end if,1); 
end macro;
macro master2_in_sig_hwdata : unsigned := prev(master_in2.hwdata,1) end macro;
macro master2_in_sig_hwrite : trans_type := prev(master_in2.hwrite,1) end macro;
--macro master2_out_sig : bus_resp_t := master_out2 end macro;
macro master2_out_sig_hrdata : unsigned :=  master_out2.hrdata end macro;
macro master2_out_sig_hresp : unsigned := master_out2.hresp end macro;
macro master3_in_sig_haddr : unsigned := prev(master_in3.haddr,1) end macro;
macro master3_in_sig_hsize : mask := prev(
	if(master_in3.hsize = MT_HU) then MT_H 
	elsif(master_in3.hsize = MT_BU) then MT_B 
	else master_in3.hsize  end if,1);
end macro;
macro master3_in_sig_hwdata : unsigned := prev(master_in3.hwdata,1) end macro;
macro master3_in_sig_hwrite : trans_type := prev(master_in3.hwrite,1) end macro;
--macro master3_out_sig : bus_resp_t := master_out3 end macro;
macro master3_out_sig_hrdata : unsigned :=  master_out3.hrdata end macro;
macro master3_out_sig_hresp : unsigned := master_out3.hresp end macro;
--macro slave0_in_sig : bus_resp_t := end macro;
macro slave0_in_sig_hrdata : unsigned := slave_in0.hrdata end macro;
macro slave0_in_sig_hresp : unsigned :=  slave_in0.hresp end macro;
--macro slave0_out_sig : bus_req_t := end macro;
macro slave0_out_sig_haddr : unsigned := slave_out0.haddr end macro;
macro slave0_out_sig_hsize : mask := slave_out0.hsize end macro;
macro slave0_out_sig_hwdata : unsigned := slave_out0.hwdata end macro;
macro slave0_out_sig_hwrite : trans_type := slave_out0.hwrite end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;
macro max_wait: unsigned  := 3 ; end macro;
constraint slave0 :=
(if (slave_in0_notify) then
        exists i in 0..(max_wait-1):
            next(slave_in0_sync,i);
        end exists;
    end if) and
(if (slave_out0_notify) then
        exists i in 0..(max_wait-1):
            next(slave_out0_sync,i);
        end exists;
    end if) and
(if (slave_in1_notify) then
        exists i in 0..(max_wait-1):
            next(slave_in1_sync,i);
        end exists;
    end if) and
(if (slave_out1_notify) then
        exists i in 0..(max_wait-1):
            next(slave_out1_sync,i);
        end exists;
    end if) and 
(if (slave_in2_notify) then
        exists i in 0..(max_wait-1):
            next(slave_in2_sync,i);
        end exists;
    end if) and
(if (slave_out2_notify) then
        exists i in 0..(max_wait-1):
            next(slave_out2_sync,i);
        end exists;
    end if);
end constraint;

constraint master_2 :=
(if (master_out2_notify) then
        exists i in 0..(max_wait-1):
            next(master_out2_sync,i);
        end exists;
    end if);
end constraint;

constraint master_1 :=
(if (master_out1_notify) then
        exists i in 0..(max_wait-1):
            next(master_out1_sync,i);
        end exists;
    end if);
end constraint;

constraint master_0 :=
(if (master_out0_notify) then
        exists i in 0..(max_wait-1):
            next(master_out0_sync,i);
        end exists;
    end if);
end constraint;

constraint master_3 :=
(if (master_out3_notify) then
        exists i in 0..(max_wait-1):
            next(master_out3_sync,i);
        end exists;
    end if);
end constraint;

constraint no_starvation :=
(if (mst0/section = request_phase) then
        exists i in 0..(10):
            next(mst0/section = data_phase,i);
        end exists;
    end if);
end constraint;


constraint only_slave_0 :=
if(idle_1) then  master_in0.haddr = 0 and  master_in1.haddr = 0 and  master_in2.haddr = 0 and  master_in3.haddr = 0; end if;
end constraint;


constraint no_split_retry := 
(slave_in0.hresp = ok_resp or slave_in0.hresp = error_resp) and 
(slave_in1.hresp = ok_resp or slave_in1.hresp = error_resp) and 
(slave_in2.hresp = ok_resp or slave_in2.hresp = error_resp); 
end constraint;

-- VISIBLE REGISTERS --
--macro fromMaster : unsigned := end macro;

-- STATES --

macro idle_1 : boolean :=
	mst0/section = idle_phase  and
        mst1/section = idle_phase  and 
	mst2/section = idle_phase and 
	mst3/section = idle_phase;
end macro;

macro master3_in_2 : boolean :=  prev(master_in3_notify and master_in3_sync); end macro;
macro slave0_out_3 : boolean := slave0_out_notify end macro;
macro slave0_in_4 : boolean := slave0_in_notify  end macro;
macro master3_out_5 : boolean := (master3_out_notify) end macro;
macro master2_out_6 : boolean := true end macro;
macro master1_out_7 : boolean := true end macro;
macro master0_out_8 : boolean := master0_out_notify end macro;
macro master2_in_9 : boolean := prev(master_in2_notify and master_in2_sync); end macro;
macro master1_in_10 : boolean := prev(master_in1_notify and master_in1_sync); end macro;
macro master0_in_11 : boolean := prev(master_in0_notify and master_in0_sync);  end macro;


