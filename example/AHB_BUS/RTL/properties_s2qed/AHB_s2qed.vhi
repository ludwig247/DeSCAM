
------------------------------------------------------------------------------------------------------------------------
-- Master3 to Slave 0 read
------------------------------------------------------------------------------------------------------------------------
/* General idea: 
assume: 
	inst1_idle()@t
	inst2_ready()@t
	master3_in_inst1@t = master_2_in_inst2@t
	slave0_in_inst1@t_slave_in_inst1 = slave0_in_inst2@t_slave_in_inst2
prove: 
	at t_last: master3_out_inst1@t_master_out = master_3_out_inst2@t_master_out
	at t_last: slave0_out_inst1@t_slave_out_inst1 = slave0_out_inst2@t_slave_out_inst2

Observations: 
1) A consistency of state variables does not need to be assumed, because there is no dependencies between them 
2) Next step is to figure out whether this operation cover the gaps result form the simple operations. 
3) The operation prove the same as the operation from keerthi with difference that we are only proving a transaction from master 3 to slave 0 and back
*/	
property s2qed_master3_to_slave0 is
  dependencies: no_reset,no_split_retry, only_slave_0,slave0,master_3;

  for timepoints: 
    t_slave_out_inst1  = t + 4, 
    t_slave_out_inst1_done  = t_slave_out_inst1 + 0 .. max_wait waits_for complete ahb1/slave_out0_sync, 
    t_slave_in_inst1  = t_slave_out_inst1_done + 1 .. max_wait waits_for complete ahb1/slave_in0_sync,
    t_master_out_inst1  = t_slave_in_inst1 + 3,

    t_slave_out_inst2  = t + 4 .. 30 waits_for complete ahb2/slave_out0_notify and ahb2/mst3/section = data_phase,
    t_slave_out_inst2_done  = t_slave_out_inst2 + 0 .. max_wait waits_for complete ahb2/slave_out0_sync,
    t_slave_in_inst2  = t_slave_out_inst2_done + 1 .. max_wait waits_for complete ahb2/slave_in0_sync,
    t_master_out_inst2  = t_slave_in_inst2 + 3;

  freeze:
    slave0_out_inst1 = ahb1/slave_out0@t_slave_out_inst1,
    slave0_out_inst2 = ahb2/slave_out0@t_slave_out_inst2,
    
    master3_out_inst1 = ahb1/master_out3@t_master_out_inst1,
    master3_out_inst2 = ahb2/master_out3@t_master_out_inst2,

    slave0_in_inst1 = ahb1/slave_in0@t_slave_in_inst1,
    slave0_in_inst2 = ahb2/slave_in0@t_slave_in_inst2;

--============================
  assume:
--============================
    -- assumptions on initial state 
    at t: inst1_idle;
    at t: inst2_ready_master3; -- in this case instance 2 ready means, that master3 is ready to receive a message 
    -- new messages available
    at t: ahb2/master_in3_sync;
    at t: ahb1/master_in3_sync;
   
    -- Consistent inputs
    at t: ahb1/master_in3 = ahb2/master_in3;
    at t: slave0_in_inst1 = slave0_in_inst2;
--============================
  prove:
--============================
    --visible states of slave(s)
    at t_last: slave0_out_inst1 = slave0_out_inst2;
    --visible states of master(s)
    at t_last: master3_out_inst1 = master3_out_inst2;
end property;


property s2qed_master2_to_slave0 is
  dependencies: no_reset,no_split_retry, only_slave_0,slave0;

  for timepoints: 
    t_slave_out_inst1  = t + 4, 
    t_slave_out_inst1_done  = t_slave_out_inst1 + 0 .. max_wait waits_for complete ahb1/slave_out0_sync, 
    t_slave_in_inst1  = t_slave_out_inst1_done + 1 .. max_wait waits_for complete ahb1/slave_in0_sync,
    t_master_out_inst1  = t_slave_in_inst1 + 3,

    t_slave_out_inst2  = t + 4 .. 50 waits_for complete ahb2/slave_out0_notify and ahb2/mst2/section = data_phase,
    t_slave_out_inst2_done  = t_slave_out_inst2 + 0 .. max_wait waits_for complete ahb2/slave_out0_sync,
    t_slave_in_inst2  = t_slave_out_inst2_done + 1 .. max_wait waits_for complete ahb2/slave_in0_sync,
    t_master_out_inst2  = t_slave_in_inst2 + 3;

  freeze:
    slave0_out_inst1 = ahb1/slave_out0@t_slave_out_inst1,
    slave0_out_inst2 = ahb2/slave_out0@t_slave_out_inst2,
    
    master2_out_inst1 = ahb1/master_out2@t_master_out_inst1,
    master2_out_inst2 = ahb2/master_out2@t_master_out_inst2,

    slave0_in_inst1 = ahb1/slave_in0@t_slave_in_inst1,
    slave0_in_inst2 = ahb2/slave_in0@t_slave_in_inst2;

--============================
  assume:
--============================
    -- assumptions on initial state 
    at t: inst1_idle;
    at t: inst2_ready_master2; -- in this case instance 2 ready means, that master3 is ready to receive a message 
    -- new messages available
    at t: ahb2/master_in2_sync;
    at t: ahb1/master_in3_sync = false; -- this results from the simple operations and is required to fire only master 2 -> slave 0 
    at t: ahb1/master_in2_sync;
   
    -- Consistent inputs
    at t: ahb1/master_in2 = ahb2/master_in2;
    at t: slave0_in_inst1 = slave0_in_inst2;
--============================
  prove:
--============================
    --visible states of slave(s)
    at t_last: slave0_out_inst1 = slave0_out_inst2;
    --visible states of master(s)
    at t_last: master2_out_inst1 = master2_out_inst2;
end property;



property s2qed_master1_to_slave0 is
  dependencies: no_reset,no_split_retry, only_slave_0,slave0;

  for timepoints: 
    t_slave_out_inst1  = t + 4, 
    t_slave_out_inst1_done  = t_slave_out_inst1 + 0 .. max_wait waits_for complete ahb1/slave_out0_sync, 
    t_slave_in_inst1  = t_slave_out_inst1_done + 1 .. max_wait waits_for complete ahb1/slave_in0_sync,
    t_master_out_inst1  = t_slave_in_inst1 + 3,

    t_slave_out_inst2  = t + 4 .. 50 waits_for complete ahb2/slave_out0_notify and ahb2/mst1/section = data_phase,
    t_slave_out_inst2_done  = t_slave_out_inst2 + 0 .. max_wait waits_for complete ahb2/slave_out0_sync,
    t_slave_in_inst2  = t_slave_out_inst2_done + 1 .. max_wait waits_for complete ahb2/slave_in0_sync,
    t_master_out_inst2  = t_slave_in_inst2 + 3;

  freeze:
    slave0_out_inst1 = ahb1/slave_out0@t_slave_out_inst1,
    slave0_out_inst2 = ahb2/slave_out0@t_slave_out_inst2,
    
    master1_out_inst1 = ahb1/master_out1@t_master_out_inst1,
    master1_out_inst2 = ahb2/master_out1@t_master_out_inst2,

    slave0_in_inst1 = ahb1/slave_in0@t_slave_in_inst1,
    slave0_in_inst2 = ahb2/slave_in0@t_slave_in_inst2;

--============================
  assume:
--============================
    -- assumptions on initial state 
    at t: inst1_idle;
    at t: inst2_ready_master1; -- in this case instance 2 ready means, that master3 is ready to receive a message 
    -- new messages available
    at t: ahb2/master_in1_sync;
    at t: ahb1/master_in3_sync = false; -- this results from the simple operations and is required to fire only master 2 -> slave 0 
    at t: ahb1/master_in2_sync = false; -- this results from the simple operations and is required to fire only master 2 -> slave 0 
    at t: ahb1/master_in1_sync;
   
    -- Consistent inputs
    at t: ahb1/master_in1 = ahb2/master_in1;
    at t: slave0_in_inst1 = slave0_in_inst2;
--============================
  prove:
--============================
    --visible states of slave(s)
    at t_last: slave0_out_inst1 = slave0_out_inst2;
    --visible states of master(s)
    at t_last: master1_out_inst1 = master1_out_inst2;
end property;



property s2qed_master0_to_slave0 is
  dependencies: no_reset,no_split_retry, only_slave_0,slave0, master_3,master_0,master_1,master_2, no_starvation;

  for timepoints: 
    t_slave_out_inst1  = t + 4, 
    t_slave_out_inst1_done  = t_slave_out_inst1 + 0 .. max_wait waits_for complete ahb1/slave_out0_sync, 
    t_slave_in_inst1  = t_slave_out_inst1_done + 1 .. max_wait waits_for complete ahb1/slave_in0_sync,
    t_master_out_inst1  = t_slave_in_inst1 + 3,

    t_slave_out_inst2  = t + 4 .. 50+(7*max_wait)+1 waits_for complete ahb2/slave_out0_notify and ahb2/mst0/section = data_phase,
    t_slave_out_inst2_done  = t_slave_out_inst2 + 0 .. max_wait waits_for complete ahb2/slave_out0_sync,
    t_slave_in_inst2  = t_slave_out_inst2_done + 1 .. max_wait waits_for complete ahb2/slave_in0_sync,
    t_master_out_inst2  = t_slave_in_inst2 + 3;

  freeze:
    slave0_out_inst1 = ahb1/slave_out0@t_slave_out_inst1,
    slave0_out_inst2 = ahb2/slave_out0@t_slave_out_inst2,
    
    master0_out_inst1 = ahb1/master_out0@t_master_out_inst1,
    master0_out_inst2 = ahb2/master_out0@t_master_out_inst2,

    slave0_in_inst1 = ahb1/slave_in0@t_slave_in_inst1,
    slave0_in_inst2 = ahb2/slave_in0@t_slave_in_inst2;

--============================
  assume:
--============================
    -- assumptions on initial state 
    at t: inst1_idle;
    at t: inst2_ready_master0; -- in this case instance 2 ready means, that master3 is ready to receive a message 
    -- new messages available
    at t: ahb2/master_in0_sync;

    at t: ahb1/master_in3_sync = false; -- this results from the simple operations and is required to fire only master 2 -> slave 0 
    at t: ahb1/master_in2_sync = false; -- this results from the simple operations and is required to fire only master 2 -> slave 0 
    at t: ahb1/master_in1_sync = false; -- this results from the simple operations and is required to fire only master 2 -> slave 0 
    at t: ahb1/master_in0_sync;
   
    -- Consistent inputs
    at t: ahb1/master_in0 = ahb2/master_in0;
    at t: slave0_in_inst1 = slave0_in_inst2;
--============================
  prove:
--============================
    --visible states of slave(s)
    at t_last: slave0_out_inst1 = slave0_out_inst2;
    --visible states of master(s)
    at t_last: master0_out_inst1 = master0_out_inst2;
end property;



-- CONSTRAINTS --
macro max_wait: unsigned  := 2 ; end macro;
constraint slave0 :=
(if (ahb1/slave_in0_notify) then
        exists i in 0..(max_wait-1):
            next(ahb1/slave_in0_sync,i);
        end exists;
    end if) and
(if (ahb1/slave_out0_notify) then
        exists i in 0..(max_wait-1):
            next(ahb1/slave_out0_sync,i);
        end exists;
    end if) and
(if (ahb1/slave_in1_notify) then
        exists i in 0..(max_wait-1):
            next(ahb1/slave_in1_sync,i);
        end exists;
    end if) and
(if (ahb1/slave_out1_notify) then
        exists i in 0..(max_wait-1):
            next(ahb1/slave_out1_sync,i);
        end exists;
    end if) and 
(if (ahb1/slave_in2_notify) then
        exists i in 0..(max_wait-1):
            next(ahb1/slave_in2_sync,i);
        end exists;
    end if) and
(if (ahb1/slave_out2_notify) then
        exists i in 0..(max_wait-1):
            next(ahb1/slave_out2_sync,i);
        end exists;
    end if) and 

(if (ahb2/slave_in0_notify) then
        exists i in 0..(max_wait-1):
            next(ahb2/slave_in0_sync,i);
        end exists;
    end if) and
(if (ahb2/slave_out0_notify) then
        exists i in 0..(max_wait-1):
            next(ahb2/slave_out0_sync,i);
        end exists;
    end if) and
(if (ahb2/slave_in1_notify) then
        exists i in 0..(max_wait-1):
            next(ahb2/slave_in1_sync,i);
        end exists;
    end if) and
(if (ahb2/slave_out1_notify) then
        exists i in 0..(max_wait-1):
            next(ahb2/slave_out1_sync,i);
        end exists;
    end if) and 
(if (ahb2/slave_in2_notify) then
        exists i in 0..(max_wait-1):
            next(ahb2/slave_in2_sync,i);
        end exists;
    end if) and
(if (ahb2/slave_out2_notify) then
        exists i in 0..(max_wait-1):
            next(ahb2/slave_out2_sync,i);
        end exists;
    end if);
end constraint;

constraint master_2 :=
(if (ahb1/master_out2_notify) then
        exists i in 0..(max_wait-1):
            next(ahb1/master_out2_sync,i);
        end exists;
    end if) and 
(if (ahb2/master_out2_notify) then
        exists i in 0..(max_wait-1):
            next(ahb2/master_out2_sync,i);
        end exists;
    end if);
end constraint;

constraint master_1 :=
(if (ahb1/master_out1_notify) then
        exists i in 0..(max_wait-1):
            next(ahb1/master_out1_sync,i);
        end exists;
    end if) and 
(if (ahb2/master_out1_notify) then
        exists i in 0..(max_wait-1):
            next(ahb2/master_out1_sync,i);
        end exists;
    end if);
end constraint;

constraint master_0 :=
(if (ahb1/master_out0_notify) then
        exists i in 0..(max_wait-1):
            next(ahb1/master_out0_sync,i);
        end exists;
    end if) and 
(if (ahb2/master_out0_notify) then
        exists i in 0..(max_wait-1):
            next(ahb2/master_out0_sync,i);
        end exists;
    end if);
end constraint;

constraint master_3 :=
(if (ahb1/master_out3_notify) then
        exists i in 0..(max_wait-1):
            next(ahb1/master_out3_sync,i);
        end exists;
    end if) and  
(if (ahb2/master_out3_notify) then
        exists i in 0..(max_wait-1):
            next(ahb2/master_out3_sync,i);
        end exists;
    end if);
end constraint;

constraint no_starvation :=
(if (ahb1/mst0/section = request_phase) then
        exists i in 0..(10):
            next(ahb1/mst0/section = address_phase,i);
        end exists;
    end if) and 
(if (ahb2/mst0/section = request_phase) then
        exists i in 0..(10):
            next(ahb2/mst0/section = address_phase,i);
        end exists;
    end if);
end constraint;


constraint only_slave_0 :=
if(inst1_idle) then  ahb1/master_in0.haddr = 0 and  ahb1/master_in1.haddr = 0 and  ahb1/master_in2.haddr = 0 and  ahb1/master_in3.haddr = 0; end if;
end constraint;


constraint no_split_retry := 
(ahb1/slave_in0.hresp = ok_resp or ahb1/slave_in0.hresp = error_resp) and 
(ahb1/slave_in1.hresp = ok_resp or ahb1/slave_in1.hresp = error_resp) and 
(ahb1/slave_in2.hresp = ok_resp or ahb1/slave_in2.hresp = error_resp) and
(ahb2/slave_in0.hresp = ok_resp or ahb2/slave_in0.hresp = error_resp) and 
(ahb2/slave_in1.hresp = ok_resp or ahb2/slave_in1.hresp = error_resp) and 
(ahb2/slave_in2.hresp = ok_resp or ahb2/slave_in2.hresp = error_resp); 
end constraint;

constraint no_reset :=
    (rst = 0);
end constraint;


macro inst1_idle : boolean :=
	ahb1/mst0/section = idle_phase  and
        ahb1/mst1/section = idle_phase  and 
	ahb1/mst2/section = idle_phase and 
	ahb1/mst3/section = idle_phase;
end macro;

macro inst2_ready_master3 : boolean :=
	ahb2/mst3/section = idle_phase;
end macro;

macro inst2_ready_master2 : boolean :=
	ahb2/mst2/section = idle_phase;
end macro;

macro inst2_ready_master1 : boolean :=
	ahb2/mst1/section = idle_phase;
end macro;

macro inst2_ready_master0 : boolean :=
	ahb2/mst0/section = idle_phase;
end macro;

