-- @lang=vhi @ts=8

------------------------Comments---------------------------
--System has been simplified to behave equally for read and write, and that has not been corrected yet, I assume there will be two extra states per slave when corrected (excluding default slave) 
--Visible registers have not been implemented yet
--Hresp and possibly hrdata need to be determined when default slave is chosen.




constraint no_reset := rst = '0'; end constraint;
constraint no_split_retry := (slave_in0.hresp = ok_resp or slave_in0.hresp = error_resp); end constraint; 

constraint bounded_slave_out0_sync := 
if(slave_out0_notify) then 
slave_out0_sync or
next(slave_out0_sync,2) or
next(slave_out0_sync,3) or
next(slave_out0_sync,4)
end if;
end constraint; 

constraint bounded_slave_in0_sync := 
if(slave_in0_notify) then 
slave_in0_sync or
next(slave_in0_sync,2) or
next(slave_in0_sync,3) or
next(slave_in0_sync,4)
end if;
end constraint;

macro slave0_range(haddr: unsigned) : boolean := haddr >= x"00000000" and haddr < x"00010000" end macro;


----------------INPUTS---------------------------------
macro master0_stage : mWrp_sec := mst0/section end macro;
macro master1_stage : mWrp_sec := mst1/section end macro;  
macro m0_request : boolean := mst_to_mtx0.hbusreq end macro;
macro m1_request : boolean := mst_to_mtx1.hbusreq end macro;
macro master0_haddr : unsigned := mst_to_mtx0.haddr end macro;
macro master0_hwdata : unsigned := mst_to_mtx0.hwdata end macro;
macro master0_hwrite : boolean := mst_to_mtx0.hwrite end macro;
macro master0_hsize : unsigned := mst_to_mtx0.hsize end macro;
macro master1_haddr : unsigned := mst_to_mtx1.haddr end macro;
macro master1_hwdata : unsigned := mst_to_mtx1.hwdata end macro;
macro master1_hwrite : boolean := mst_to_mtx1.hwrite end macro;
macro master1_hsize : unsigned := mst_to_mtx1.hsize end macro;

-----------------OUTPUTS-----------------------------------
macro master0_hresp : unsigned := mtx_to_mst0.hresp end macro;
macro master0_hrdata : unsigned := mtx_to_mst0.hrdata end macro;
macro master0_hready : boolean := mtx_to_mst0.hready end macro;
macro master0_hgrant : boolean := mtx_to_mst0.hgrant end macro;
macro master1_hresp : unsigned := mtx_to_mst1.hresp end macro;
macro master1_hrdata : unsigned := mtx_to_mst1.hrdata end macro;
macro master1_hready : boolean := mtx_to_mst1.hready end macro;
macro master1_hgrant : boolean := mtx_to_mst1.hgrant end macro;


---------------REGISTERS----------------
macro ahb_slv_in_m0_haddr : unsigned := master0_haddr end macro;
macro ahb_slv_in_m0_hwdata : unsigned := master0_hwdata end macro;
macro ahb_slv_in_m0_hwrite : trans_type := if(master0_hwrite) then AHB_WRITE else AHB_READ end if; end macro;
macro ahb_slv_in_m0_hsize : mask := if(master0_hsize = "010") then MT_W elsif(master0_hsize = "001") then MT_H elsif(master0_hsize = "000") then MT_B else MT_X end if; end macro;
macro ahb_slv_in_m1_haddr : unsigned := master1_haddr end macro;
macro ahb_slv_in_m1_hwdata : unsigned := master1_hwdata end macro;
macro ahb_slv_in_m1_hwrite : trans_type := if(master1_hwrite) then AHB_WRITE else AHB_READ end if; end macro;
macro ahb_slv_in_m1_hsize : mask := if(master1_hsize = "010") then MT_W elsif(master1_hsize = "001") then MT_H elsif(master1_hsize = "000") then MT_B else MT_X end if; end macro;

------------------STATES-----------------------
macro idle_state : boolean := 
master0_stage /= addr and master0_stage /= data and master1_stage /= addr and master1_stage /= data
end macro;

----------------

macro nonseq_m0 : boolean := 
master0_stage = addr and master1_stage /= data
end macro;


macro nonseq_m1_slave0_m0_start :  boolean :=
master0_stage = data and master1_stage = addr and prev(master0_stage = addr) and slave0_range(prev(master0_haddr))
end macro;

macro nonseq_m1_slave0_m0_end :  boolean :=
prev(master0_stage) = data and master1_stage = addr and prev((slave_in0_notify = true) and (slave_in0_sync = true))
end macro;

--------------

macro idle_m1_slave0_m0_start :  boolean :=
master0_stage = data and master1_stage /= addr and prev(master0_stage = addr) and slave0_range(prev(master0_haddr))
end macro;

macro idle_m1_slave0_m0_end :  boolean :=
prev(master0_stage) = data and master1_stage /= addr and prev((slave_in0_notify = true) and (slave_in0_sync = true)) 
end macro;

----------------

macro nonseq_m1_defslave_m0 :  boolean :=
master0_stage = data and master1_stage = addr and prev(master0_stage = addr) and not(slave0_range(prev(master0_haddr)))
end macro;

macro idle_m1_defslave_m0 :  boolean :=
master0_stage = data and master1_stage /= addr and prev(master0_stage = addr) and not(slave0_range(prev(master0_haddr)))
end macro;

----------------

macro nonseq_m1_error_m0 : boolean  :=
master1_stage = addr and master0_stage = error_phase
end macro;

macro idle_m1_error_m0 : boolean  :=
master1_stage /= addr and master0_stage = error_phase
end macro;

-----------------

macro nonseq_m1 : boolean :=  
master1_stage = addr and master0_stage /= data
end macro;

macro nonseq_m0_slave0_m1_start : boolean :=
master1_stage = data and master0_stage = addr and prev(master1_stage = addr) and slave0_range(prev(master1_haddr))
end macro;

macro nonseq_m0_slave0_m1_end :  boolean :=
prev(master1_stage) = data and master0_stage = addr and prev((slave_in0_notify = true) and (slave_in0_sync = true))
end macro;

------------------

macro idle_m0_defslave_m1:  boolean :=
master1_stage = data and master0_stage /= addr and prev(master1_stage = addr) and not(slave0_range(prev(master1_haddr)))
end macro;

macro nonseq_m0_defslave_m1 : boolean :=
master1_stage = data and master0_stage = addr and prev(master1_stage = addr) and not(slave0_range(prev(master1_haddr)))
end macro;

------------------

macro idle_m0_slave0_m1_start :  boolean :=
master1_stage = data and master0_stage /= addr and prev(master1_stage = addr) and slave0_range(prev(master1_haddr))
end macro;

macro idle_m0_slave0_m1_end :  boolean :=
prev(master1_stage) = data and master0_stage /= addr and prev((slave_in0_notify = true) and (slave_in0_sync = true))
end macro;

------------------

macro nonseq_m0_error_m1 : boolean :=
master0_stage = addr and master1_stage = error_phase
end macro;

macro idle_m0_error_m1 : boolean := 
master0_stage /= addr and master1_stage = error_phase
end macro;


property reset is

assume:
  reset_sequence;

prove:
  at t: idle_state;
  at t: slave_out0_notify = false;
  at t: slave_in0_notify = false;
  at t: master0_hready = true;
  at t: master1_hready = true;
  at t: master0_hgrant = false;
  at t: master1_hgrant = true;

end property;

------------------------------------
property from_idle_state_to_idle_state is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: idle_state;
     at t: not(m1_request);
     at t: not(m0_request);

prove: 
     at t_end: idle_state;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = true;
     at t_end: master1_hready = true;
     at t_end: master0_hgrant = false;
     at t: master1_hgrant = true;
end property;


property from_idle_state_to_nonseq_m1 is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: idle_state;
     at t: m1_request;

prove: 
     at t_end: nonseq_m1;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = true;
     at t_end: master1_hready = true;
end property;

--data start m1    

property from_nonseq_m1_to_slave0_m1_idle_m0 is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: nonseq_m1;
     at t: not(m0_request);
     at t: master1_haddr >= x"00000000" and master1_haddr < x"00010000";

prove: 
     at t_end: idle_m0_slave0_m1_start;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = false;
     at t_end: master1_hready = false;
     at t: master0_hgrant = false;
     at t: master1_hgrant = true;

end property;

property from_nonseq_m1_to_slave0_m1_nonseq_m0 is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: nonseq_m1;
     at t: m0_request;
     at t: master1_haddr >= x"00000000" and master1_haddr < x"00010000";

prove: 
     at t_end: nonseq_m0_slave0_m1_start;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = false;
     at t_end: master1_hready = false;
     at t: master0_hgrant = true;
     at t: master1_hgrant = false;

end property;

---data end m1

property slave0_m1_idle_m0_start is 
dependencies: no_reset, bounded_slave_in0_sync, bounded_slave_out0_sync, no_split_retry;

for timepoints: 
t_slv_o_sync =  t+1..5 waits_for complete slave_out0_sync,
t_slv_i = t_slv_o_sync+1, 
t_slv_i_sync = t_slv_i + 0..4 waits_for complete slave_in0_sync,
t_end = t_slv_i_sync+1;

freeze:
  ahb_slv_in_m1_haddr_at_t = ahb_slv_in_m1_haddr@t,
  ahb_slv_in_m1_hwdata_at_t = ahb_slv_in_m1_hwdata@t,
  ahb_slv_in_m1_hwrite_at_t = ahb_slv_in_m1_hwrite@t,
  ahb_slv_in_m1_hsize_at_t = ahb_slv_in_m1_hsize@t;

assume:
     at t: idle_m0_slave0_m1_start;
     
prove:
     during[t+1, t_slv_i-1]: slave_out0_notify = true;
     during[t_slv_i, t_end]: slave_out0_notify = false;
     during[t+1, t_slv_i-1]: slave_out0.haddr = ahb_slv_in_m1_haddr_at_t;
     during[t+1, t_slv_i-1]: slave_out0.hwdata = ahb_slv_in_m1_hwdata_at_t;
     during[t+1, t_slv_i-1]: slave_out0.hwrite = ahb_slv_in_m1_hwrite_at_t;
     during[t+1, t_slv_i-1]: slave_out0.hsize = ahb_slv_in_m1_hsize_at_t;
     during[t+1, t_slv_i-1]: slave_in0_notify = false;
     during[t_slv_i, t_end-1]: slave_in0_notify = true;
     at t_end:slave_in0_notify = false;
     during[t+1,t_end-1]: master0_hready = false;
     during[t+1,t_end-1]: master1_hready = false;
     at t_end: master0_hready = true;
     at t_end: master1_hready = true;
     at t_end-1: master0_hresp = slave_in0.hresp;
     at t_end: master0_hresp = prev(slave_in0.hresp);
     at t_end: master0_hrdata = prev(slave_in0.hrdata); 
     at t_end-1:master1_hresp = slave_in0.hresp;
     at t_end: master1_hresp = prev(slave_in0.hresp);
     at t_end: master1_hrdata = prev(slave_in0.hrdata); 
     during[t,t_end-1]: master0_hgrant = false;
     during[t,t_end-1]: master1_hgrant = true;
     at t_end:idle_m0_slave0_m1_end;

  

right_hook: t_end;      

end property;

property slave0_m1_nonseq_m0_start is 
dependencies: no_reset, bounded_slave_in0_sync, bounded_slave_out0_sync, no_split_retry;

for timepoints: 
t_slv_o_sync =  t+1..5 waits_for complete slave_out0_sync,
t_slv_i = t_slv_o_sync+1, 
t_slv_i_sync = t_slv_i + 0..4 waits_for complete slave_in0_sync,
t_end = t_slv_i_sync+1;

freeze:
  ahb_slv_in_m1_haddr_at_t = ahb_slv_in_m1_haddr@t,
  ahb_slv_in_m1_hwdata_at_t = ahb_slv_in_m1_hwdata@t,
  ahb_slv_in_m1_hwrite_at_t = ahb_slv_in_m1_hwrite@t,
  ahb_slv_in_m1_hsize_at_t = ahb_slv_in_m1_hsize@t;

assume:
     at t: nonseq_m0_slave0_m1_start;
     
prove:
     during[t+1, t_slv_i-1]: slave_out0_notify = true;
     during[t_slv_i, t_end]: slave_out0_notify = false;
     during[t+1, t_slv_i-1]: slave_out0.haddr = ahb_slv_in_m1_haddr_at_t;
     during[t+1, t_slv_i-1]: slave_out0.hwdata = ahb_slv_in_m1_hwdata_at_t;
     during[t+1, t_slv_i-1]: slave_out0.hwrite = ahb_slv_in_m1_hwrite_at_t;
     during[t+1, t_slv_i-1]: slave_out0.hsize = ahb_slv_in_m1_hsize_at_t;
     during[t+1, t_slv_i-1]: slave_in0_notify = false;
     during[t_slv_i, t_end-1]: slave_in0_notify = true;
     at t_end:slave_in0_notify = false;
     during[t+1,t_end-1]: master0_hready = false;
     during[t+1,t_end-1]: master1_hready = false;
     at t_end: master0_hready = true;
     at t_end: master1_hready = true;
     at t_end-1: master0_hresp = slave_in0.hresp;
     at t_end: master0_hresp = prev(slave_in0.hresp);
     at t_end: master0_hrdata = prev(slave_in0.hrdata); 
     at t_end-1:master1_hresp = slave_in0.hresp;
     at t_end: master1_hresp = prev(slave_in0.hresp);
     at t_end: master1_hrdata = prev(slave_in0.hrdata); 
     at t_end:nonseq_m0_slave0_m1_end;
     during[t,t_end-1]: master0_hgrant = true;
     during[t,t_end-1]: master1_hgrant = false;  
      
right_hook: t_end;

end property;

---from data end m1
--from idle_data_end
property from_slave0_m1_idle_m0_to_idle_state is
dependencies: no_reset, no_split_retry;

for timepoints: t_end = t+1;

assume: 
    at t: idle_m0_slave0_m1_end;
    at t: not(m0_request);

prove:
    at t_end: idle_state;
    at t_end: slave_out0_notify = false;
    at t_end: slave_in0_notify = false;
    at t_end: master0_hready = true;
    at t_end: master1_hready = true;
    at t: master0_hgrant = false;
    at t: master1_hgrant = true;


end property;

property from_slave0_m1_idle_m0_to_nonseq_m0 is
dependencies: no_reset, no_split_retry;

for timepoints: t_end = t+1;

assume: 
    at t: idle_m0_slave0_m1_end;
    at t: m0_request;

prove:
    at t_end: nonseq_m0;
    at t_end: slave_out0_notify = false;
    at t_end: slave_in0_notify = false;
    at t_end: master0_hready = true;
    at t_end: master1_hready = true;
    at t: master0_hgrant = true;
    at t: master1_hgrant = false;

end property;



--from nonseq_data_end
property from_slave0_m1_nonseq_m0_to_slave0_m0 is
dependencies: no_reset, no_split_retry;

for timepoints: t_end = t+1;

assume: 
    at t: nonseq_m0_slave0_m1_end;
    at t: master0_haddr >= x"00000000" and master0_haddr < x"00010000";

prove:
    at t_end: idle_m1_slave0_m0_start;
    at t_end: slave_out0_notify = false;
    at t_end: slave_in0_notify = false;
     at t_end: master0_hready = false;
     at t_end: master1_hready = false;
    at t: master0_hgrant = false; ---non default master loses grant one cycle before the end of addr phase
    at t: master1_hgrant = true;

end property;

property from_slave0_m1_nonseq_m0_to_defslave_m0 is
dependencies: no_reset, no_split_retry;

for timepoints: t_end = t+1;

assume: 
    at t: nonseq_m0_slave0_m1_end;
    at t: not(master0_haddr >= x"00000000" and master0_haddr < x"00010000");

prove:
    at t_end: idle_m1_defslave_m0;
    at t_end: slave_out0_notify = false;
    at t_end: slave_in0_notify = false;
     at t_end: master0_hready = false;
     at t_end: master1_hready = false;
     at t_end: master0_hresp = error_resp;
     at t_end: master1_hresp = error_resp;
    at t: master0_hgrant = false;
    at t: master1_hgrant = true;

end property;


---nonseq to err m1

property from_nonseq_m1_to_defslave_m1_idle_m0 is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: nonseq_m1;
     at t: not(m0_request);
     at t: not(master1_haddr >= x"00000000" and master1_haddr < x"00010000");

prove: 
     at t_end: idle_m0_defslave_m1;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = false;
     at t_end: master1_hready = false;
     at t_end: master0_hresp = error_resp;
     at t_end: master1_hresp = error_resp;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;

property from_nonseq_m1_to_defslave_m1_nonseq_m0 is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: nonseq_m1;
     at t: m0_request;
     at t: not(master1_haddr >= x"00000000" and master1_haddr < x"00010000");

prove: 
     at t_end: nonseq_m0_defslave_m1;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = false;
     at t_end: master1_hready = false;
     at t_end: master0_hresp = error_resp;
     at t_end: master1_hresp = error_resp;
     at t: master0_hgrant = true; 
     at t: master1_hgrant = false;

end property;

---from default slave m1 to error
property from_defslave_m1_idle_m0_to_idle_m0_error_m1  is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: idle_m0_defslave_m1;
prove: 
     at t_end: idle_m0_error_m1;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = true;
     at t_end: master1_hready = true;
     at t_end: master0_hresp = error_resp;
     at t_end: master1_hresp = error_resp;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;

property from_defslave_m1_nonseq_m0_to_nonseq_m0_error_m1  is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: nonseq_m0_defslave_m1;

prove: 
     at t_end: nonseq_m0_error_m1;
    at t_end: slave_out0_notify = false;
    at t_end: slave_in0_notify = false;
     at t_end: master0_hready = true;
     at t_end: master1_hready = true;
     at t_end: master0_hresp = error_resp;
     at t_end: master1_hresp = error_resp;
     at t: master0_hgrant = true; 
     at t: master1_hgrant = false;

end property;

---from error state m1

--idle_error
property from_error_m1_idle_m0_to_idle_state is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: idle_m0_error_m1;
     at t: not(m0_request);

prove: 

     at t_end: idle_state;
    at t_end: slave_out0_notify = false;
    at t_end: slave_in0_notify = false;
     at t_end: master0_hready = true;
     at t_end: master1_hready = true;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;

property from_error_m1_idle_m0_to_nonseq_m0 is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: idle_m0_error_m1;
     at t: m0_request;

prove: 

     at t_end: nonseq_m0;
    at t_end: slave_out0_notify = false;
    at t_end: slave_in0_notify = false;
     at t_end: master0_hready = true;
     at t_end: master1_hready = true;
     at t: master0_hgrant = true; 
     at t: master1_hgrant = false;

end property;

---from nonseq_error
property from_error_m1_nonseq_m0_to_slave0_m0 is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: nonseq_m0_error_m1;
     at t: master0_haddr >= x"00000000" and master0_haddr < x"00010000";

prove: 

     at t_end: idle_m1_slave0_m0_start;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = false;
     at t_end: master1_hready = false;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;

property from_error_m1_nonseq_m0_to_defslave_m0 is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: nonseq_m0_error_m1;
     at t: not(master0_haddr >= x"00000000" and master0_haddr < x"00010000");

prove: 

     at t_end: idle_m1_defslave_m0;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = false;
     at t_end: master1_hready = false;
     at t_end: master0_hresp = error_resp;
     at t_end: master1_hresp = error_resp;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;



------------------------------


property from_idle_state_to_nonseq_m0 is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: idle_state;
     at t: not(m1_request);
     at t: m0_request;

prove: 
     at t_end: nonseq_m0;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = true;
     at t_end: master1_hready = true;
     at t: master0_hgrant = true; 
     at t: master1_hgrant = false;

end property;

---data start s0

property from_nonseq_m0_to_slave0_m0_idle_m1 is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: nonseq_m0;
     at t: not(m1_request);
     at t: master0_haddr >= x"00000000" and master0_haddr < x"00010000";

prove: 
     at t_end: idle_m1_slave0_m0_start;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = false;
     at t_end: master1_hready = false;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;

property from_nonseq_m0_to_slave0_m0_nonseq_m1 is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: nonseq_m0;
     at t: m1_request;
     at t: master0_haddr >= x"00000000" and master0_haddr < x"00010000";

prove: 
     at t_end: nonseq_m1_slave0_m0_start;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = false;
     at t_end: master1_hready = false;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;

---data end s0

property slave0_m0_idle_m1_start is 
dependencies: no_reset, bounded_slave_in0_sync, bounded_slave_out0_sync, no_split_retry;

for timepoints: 
t_slv_o_sync =  t+1..5 waits_for complete slave_out0_sync,
t_slv_i = t_slv_o_sync+1, 
t_slv_i_sync = t_slv_i + 0..4 waits_for complete slave_in0_sync,
t_end = t_slv_i_sync+1;

freeze:
  ahb_slv_in_m0_haddr_at_t = ahb_slv_in_m0_haddr@t,
  ahb_slv_in_m0_hwdata_at_t = ahb_slv_in_m0_hwdata@t,
  ahb_slv_in_m0_hwrite_at_t = ahb_slv_in_m0_hwrite@t,
  ahb_slv_in_m0_hsize_at_t = ahb_slv_in_m0_hsize@t;

assume:
     at t: idle_m1_slave0_m0_start;
     
prove:
     during[t+1, t_slv_i-1]: slave_out0_notify = true;
     during[t_slv_i, t_end]: slave_out0_notify = false;
     during[t+1, t_slv_i-1]: slave_out0.haddr = ahb_slv_in_m0_haddr_at_t;
     during[t+1, t_slv_i-1]: slave_out0.hwdata = ahb_slv_in_m0_hwdata_at_t;
     during[t+1, t_slv_i-1]: slave_out0.hwrite = ahb_slv_in_m0_hwrite_at_t;
     during[t+1, t_slv_i-1]: slave_out0.hsize = ahb_slv_in_m0_hsize_at_t;
     during[t+1, t_slv_i-1]: slave_in0_notify = false;
     during[t_slv_i, t_end-1]: slave_in0_notify = true;
     at t_end:slave_in0_notify = false;
     during[t+1,t_end-1]: master0_hready = false;
     during[t+1,t_end-1]: master1_hready = false;
     at t_end: master0_hready = true;
     at t_end: master1_hready = true;
     at t_end-1: master0_hresp = slave_in0.hresp;
     at t_end: master0_hresp = prev(slave_in0.hresp);
     at t_end: master0_hrdata = prev(slave_in0.hrdata); 
     at t_end-1:master1_hresp = slave_in0.hresp;
     at t_end: master1_hresp = prev(slave_in0.hresp);
     at t_end: master1_hrdata = prev(slave_in0.hrdata); 
     during[t, t_end-1]: master0_hgrant = false; 
     during[t, t_end-1]: master1_hgrant = true;
     at t_end:idle_m1_slave0_m0_end;  

      
right_hook: t_end;
end property;

property slave0_m0_nonseq_m1_start is 
dependencies: no_reset, bounded_slave_in0_sync, bounded_slave_out0_sync, no_split_retry;

for timepoints: 
t_slv_o_sync =  t+1..5 waits_for complete slave_out0_sync,
t_slv_i = t_slv_o_sync+1, 
t_slv_i_sync = t_slv_i + 0..4 waits_for complete slave_in0_sync,
t_end = t_slv_i_sync+1;

freeze:
  ahb_slv_in_m0_haddr_at_t = ahb_slv_in_m0_haddr@t,
  ahb_slv_in_m0_hwdata_at_t = ahb_slv_in_m0_hwdata@t,
  ahb_slv_in_m0_hwrite_at_t = ahb_slv_in_m0_hwrite@t,
  ahb_slv_in_m0_hsize_at_t = ahb_slv_in_m0_hsize@t;

assume:
     at t: nonseq_m1_slave0_m0_start;
     
prove:
     during[t+1, t_slv_i-1]: slave_out0_notify = true;
     during[t_slv_i, t_end]: slave_out0_notify = false;
     during[t+1, t_slv_i-1]: slave_out0.haddr = ahb_slv_in_m0_haddr_at_t;
     during[t+1, t_slv_i-1]: slave_out0.hwdata = ahb_slv_in_m0_hwdata_at_t;
     during[t+1, t_slv_i-1]: slave_out0.hwrite = ahb_slv_in_m0_hwrite_at_t;
     during[t+1, t_slv_i-1]: slave_out0.hsize = ahb_slv_in_m0_hsize_at_t;
     during[t+1, t_slv_i-1]: slave_in0_notify = false;
     during[t_slv_i, t_end-1]: slave_in0_notify = true;
     at t_end:slave_in0_notify = false;
     during[t+1,t_end-1]: master0_hready = false;
     during[t+1,t_end-1]: master1_hready = false;
     at t_end: master0_hready = true;
     at t_end: master1_hready = true;
     at t_end-1: master0_hresp = slave_in0.hresp;
     at t_end: master0_hresp = prev(slave_in0.hresp);
     at t_end: master0_hrdata = prev(slave_in0.hrdata); 
     at t_end-1:master1_hresp = slave_in0.hresp;
     at t_end: master1_hresp = prev(slave_in0.hresp);
     at t_end: master1_hrdata = prev(slave_in0.hrdata);
     during[t, t_end-1]: master0_hgrant = false; 
     during[t, t_end-1]: master1_hgrant = true; 
     at t_end:nonseq_m1_slave0_m0_end;  
      
right_hook: t_end;
end property;

----from data m0 end
--from idle_data
property from_slave0_m0_idle_m1_to_idle_state is
dependencies: no_reset, no_split_retry;

for timepoints: t_end = t+1;

assume:
     at t: idle_m1_slave0_m0_end;
     at t: not(m1_request);

prove: 
     at t_end: idle_state;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = true;
     at t_end: master1_hready = true;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;

property from_slave0_m0_idle_m1_to_nonseq_m1 is
dependencies: no_reset, no_split_retry;

for timepoints: t_end = t+1;

assume:
     at t: idle_m1_slave0_m0_end;
     at t: m1_request;

prove: 
     at t_end: nonseq_m1;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = true;
     at t_end: master1_hready = true;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;




--from nonseq_data
property from_slave0_m0_nonseq_m1_to_slave0_m1 is
dependencies: no_reset, no_split_retry;

for timepoints: t_end = t+1;

assume:
     at t: nonseq_m1_slave0_m0_end;
     at t: master1_haddr >= x"00000000" and master1_haddr < x"00010000";
prove: 
     at t_end: idle_m0_slave0_m1_start;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = false;
     at t_end: master1_hready = false;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;

property from_slave0_m0_nonseq_m1_to_defslave_m1 is
dependencies: no_reset, no_split_retry;

for timepoints: t_end = t+1;

assume:
     at t: nonseq_m1_slave0_m0_end;
     at t: not(master1_haddr >= x"00000000" and master1_haddr < x"00010000");
prove: 
     at t_end: idle_m0_defslave_m1;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = false;
     at t_end: master1_hready = false;
     at t_end: master0_hresp = error_resp;
     at t_end: master1_hresp = error_resp;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;



---nonseq to err m0

property from_nonseq_m0_to_defslave_m0_idle_m1 is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: nonseq_m0;
     at t: not(m1_request);
     at t: not(master0_haddr >= x"00000000" and master0_haddr < x"00010000");

prove: 
     at t_end: idle_m1_defslave_m0;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = false;
     at t_end: master1_hready = false;
     at t_end: master0_hresp = error_resp;
     at t_end: master1_hresp = error_resp;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;

property from_nonseq_m0_to_defslave_m0_nonseq_m1 is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: nonseq_m0;
     at t: m1_request;
     at t: not(master0_haddr >= x"00000000" and master0_haddr < x"00010000");

prove: 
     at t_end: nonseq_m1_defslave_m0;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = false;
     at t_end: master1_hready = false;
     at t_end: master0_hresp = error_resp;
     at t_end: master1_hresp = error_resp;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;

---from default slave m0 to error

property from_defslave_m0_idle_m1_to_idle_m1_error_m0  is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: idle_m1_defslave_m0;
prove: 
     at t_end: idle_m1_error_m0;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = true;
     at t_end: master1_hready = true;
     at t_end: master0_hresp = error_resp;
     at t_end: master1_hresp = error_resp;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;

property from_defslave_m0_nonseq_m1_to_nonseq_m1_error_m0  is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: nonseq_m1_defslave_m0;

prove: 
     at t_end: nonseq_m1_error_m0;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = true;
     at t_end: master_1_notify = true ;
     at t_end: master1_hready = true;
     at t_end: master0_hresp = error_resp;
     at t_end: master1_hresp = error_resp;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;


--from error m0
--idle_error
property from_error_m0_idle_m1_to_idle_state is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: idle_m1_error_m0;
     at t: not(m1_request);

prove: 

     at t_end: idle_state;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = true;
     at t_end: master1_hready = true;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;

property from_error_m0_idle_m1_to_nonseq_m1 is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: idle_m1_error_m0;
     at t: m1_request;

prove: 

     at t_end: nonseq_m1;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = true;
     at t_end: master1_hready = true;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;

---nonseq_error
property from_error_m0_nonseq_m1_to_slave0_m1 is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: nonseq_m1_error_m0;
     at t: master1_haddr >= x"00000000" and master1_haddr < x"00010000";

prove: 

     at t_end: idle_m0_slave0_m1_start;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = false;
     at t_end: master1_hready = false;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;

property from_error_m0_nonseq_m1_to_defslave_m1 is
dependencies: no_reset;

for timepoints: t_end = t+1;

assume:
     at t: nonseq_m1_error_m0;
     at t: not(master1_haddr >= x"00000000" and master1_haddr < x"00010000");

prove: 

     at t_end: idle_m0_defslave_m1;
     at t_end: slave_out0_notify = false;
     at t_end: slave_in0_notify = false;
     at t_end: master0_hready = false;
     at t_end: master1_hready = false;
     at t: master0_hgrant = false; 
     at t: master1_hgrant = true;

end property;

--property  is
--dependencies: no_reset;

--for timepoints: t_end = t+1;

--assume:
 --    at t: 

--prove: 

--end property;





