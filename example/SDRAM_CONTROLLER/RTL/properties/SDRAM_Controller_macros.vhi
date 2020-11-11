-- @lang=vhi @ts=8

macro inputs_stable_single_cycle: boolean :=
    next(read_request_i)=read_request_i and
    next(write_request_i)=write_request_i and
    next(burst_single_i)=burst_single_i and
    next(address_i)=address_i;
end macro;

constraint protocol_inputs_stable :=
    disable iff: reset;
    -- inputs do not change for ongoing request
    if (read_request_i='1' or write_request_i='1') and
        ready_o='0' then
        inputs_stable_single_cycle and
    -- and for a burst request, inputs stay stable for 3 more cycles
        if burst_single_i='1' then
            foreach i in 1..3:
                next(inputs_stable_single_cycle,i)
            end foreach;
        end if
    end if;
end constraint;

constraint no_read_write_burst :=
    disable iff: reset;
    if read_request_i='1' and write_request_i='1' then
        burst_single_i='0';
    end if;
end constraint;

macro idle_state : boolean :=
  state = idle and acc_rw= false; 
end macro;

macro ra_state : boolean :=
  state = ra and  acc_rw= false; 
end macro;


macro row_act_state : boolean :=
  state = row_act and acc_rw= false; 
end macro;

macro last_row_reg : bit_vector :=
  last_row;
end macro;

macro read_request : boolean :=

	state = sr4 ; 
end macro;

macro sr3_state : boolean :=

	state = sr3 ; 
end macro;

macro precharge_state : boolean :=

	state = pr and acc_rw=false; 
end macro;

macro single_write : boolean :=

	state = sw1; 
end macro;

macro br6_state : boolean := 
	state = br6 and acc_rw=false;
end macro;

macro burst_read : boolean := 
	state = br7 and acc_rw=false;
end macro;

macro burst_write : boolean := 
	state = bw4 and acc_rw=false;
end macro;

macro read_write : boolean := 
	read_request_i and write_request_i and state=sw1 and acc_rw=true; 
end macro;

macro active_state :boolean := 
	state = row_act;
end macro;


-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro data_in_sync : boolean := (read_request_i or write_request_i or burst_single_i) and idle_state end macro;
macro data_in_notify : boolean := idle_state end  macro;
macro data_int_notify : boolean := if(next(precharge_state)) then false elsif(read_request_i and write_request_i) then active_state else row_act_state end if;  end  macro;
macro data_out_idle_notify : boolean := not(prev(read_request)) and not(prev(single_write)) and not(prev(burst_read)) and not(prev(burst_write)) and not(prev(read_write)) and row_act_state end  macro; 
macro data_out_single_read_notify : boolean := prev(sr3_state,1) end  macro;
macro data_out_single_write_notify : boolean := single_write end  macro; 
macro data_out_burst_read_notify : boolean := burst_read end  macro;  
macro data_out_burst_write_notify : boolean := burst_write end  macro;
macro data_out_read_write_notify : boolean := read_write end  macro; 






-- DP SIGNALS --
--macro data_in_sig : request :={resize(0,32), false, false, false} end macro;
macro data_in_sig_address_in : unsigned :=address_i end macro;
macro data_in_sig_burst_single : boolean :=burst_single_i end macro;
macro data_in_sig_read_req : boolean :=read_request_i end macro;
macro data_in_sig_write_req : boolean :=write_request_i end macro;
macro data_in_end_read_op_sig_address_in : unsigned := next(address_i)  end macro;
macro data_in_end_read_op_sig_burst_single : boolean :=next(burst_single_i) end macro;
macro data_in_end_read_op_sig_read_req : boolean := next(read_request_i) end macro;
macro data_in_end_read_op_sig_write_req : boolean :=next(write_request_i) end macro;
--macro data_int_sig : resp_activ :={resize(0,32), resize(0,32), false, false} end macro;
macro data_int_sig_address : unsigned := next(sdram_addr_o,1)  end macro;
macro data_int_sig_last_row : unsigned :=last_row_reg end macro;
macro data_int_sig_ready : boolean :=((prev(ready_o,1))  and (ready_o)) end macro;
macro data_int_sig_sdram_status : boolean :=if(prev(read_request)or prev(burst_read) or prev(burst_write)) then sdram_nop elsif(  prev(single_write)or prev(read_write)) then sdram_stop else prev(sdram_active,1)  and sdram_nop end if; end macro;
--macro data_out_idle_sig : resp_idle :={resize(0,32), resize(0,32)} end macro;
macro data_out_idle_sig_address : unsigned :=sdram_addr_o end macro;
macro data_out_idle_sig_last_row : unsigned :=last_row_reg end macro;
--macro data_out_single_read_sig : resp :={resize(0,32), resize(0,32), resize(0,32), false, false} end macro;
macro data_out_single_read_sig_address : unsigned := prev(sdram_addr_o,3) end macro;
macro data_out_single_read_sig_data_out : unsigned := read_data_o end macro; 
macro data_out_single_read_sig_last_row : unsigned :=last_row_reg end macro;
macro data_out_single_read_sig_ready : boolean :=  (prev(ready_o,3)) and  (prev(ready_o,2)) and (prev(ready_o,1)) and   not(prev(ready_o,0))  end macro;
macro data_out_single_read_sig_sdram_status : boolean :=  prev(sdram_read,3)  and  prev(sdram_stop,2) and  prev(sdram_nop,1) and prev(sdram_nop,0)    
 end macro;
macro sdram_data_in_sig : unsigned := next(sdram_read_data_i,3) end macro;

-- single write 

--macro data_in_end_write_op_sig : request :={resize(0,32), false, false, false} end macro;
macro data_in_end_write_op_sig_address_in : unsigned := next(address_i) end macro;
macro data_in_end_write_op_sig_burst_single : boolean :=next(burst_single_i) end macro;
macro data_in_end_write_op_sig_read_req : boolean :=next(read_request_i) end macro;
macro data_in_end_write_op_sig_write_req : boolean :=next(write_request_i) end macro;

--macro data_out_single_write_sig : resp :={resize(0,32), resize(0,32), resize(0,32), false, false} end macro;
macro data_out_single_write_sig_address : unsigned :=(sdram_addr_o) end macro;
macro data_out_single_write_sig_data_out : unsigned :=sdram_write_data_o end macro;
macro data_out_single_write_sig_last_row : unsigned :=last_row_reg end macro;
macro data_out_single_write_sig_ready : boolean := (prev(ready_o,1)) and not(ready_o) end macro;
macro data_out_single_write_sig_sdram_status : boolean := (sdram_write)  end macro;
macro CPU_data_in_sig : unsigned :=(write_data_i) end macro;


-- burst read 
--macro data_in_end_burst_read_op_sig : request :={resize(0,32), false, false, false} end macro; 
macro data_in_end_burst_read_op_sig_address_in : unsigned :=next(address_i)  end macro;
macro data_in_end_burst_read_op_sig_burst_single : boolean :=next(burst_single_i) end macro;
macro data_in_end_burst_read_op_sig_read_req : boolean :=next(read_request_i) end macro;
macro data_in_end_burst_read_op_sig_write_req : boolean :=next(write_request_i) end macro;

--macro data_out_burst_read_sig : resp_burst :={resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), false, false} end macro; 
macro data_out_burst_read_sig_address : unsigned :=prev(sdram_addr_o,6) end macro;
macro data_out_burst_read_sig_data_1 : unsigned :=prev(read_data_o,3) end macro;
macro data_out_burst_read_sig_data_2 : unsigned :=prev(read_data_o,2) end macro;
macro data_out_burst_read_sig_data_3 : unsigned :=prev(read_data_o,1) end macro;
macro data_out_burst_read_sig_data_4 : unsigned :=(read_data_o) end macro;
macro data_out_burst_read_sig_last_row : unsigned :=last_row_reg end macro;
macro data_out_burst_read_sig_ready : boolean := prev((ready_o),6) and prev(ready_o,5) and prev(ready_o,4) and not prev(ready_o,3) and not  prev(ready_o,2) and not prev(ready_o,1) and  not prev(ready_o,0) end macro;
macro data_out_burst_read_sig_sdram_status : boolean :=prev(sdram_read,6) and prev(sdram_nop,5) and prev(sdram_nop,4) and prev(sdram_nop,3) and prev(sdram_nop,2) and prev(sdram_nop,1) and  prev(sdram_nop,0)     end macro;

--macro sdram_data_in_burst_sig : burst :={resize(0,32), resize(0,32), resize(0,32), resize(0,32)} end macro;
macro sdram_data_in_burst_sig_data_1 : unsigned := next(sdram_read_data_i,3) end macro;
macro sdram_data_in_burst_sig_data_2 : unsigned := next(sdram_read_data_i,4)end macro;
macro sdram_data_in_burst_sig_data_3 : unsigned :=next(sdram_read_data_i,5) end macro;
macro sdram_data_in_burst_sig_data_4 : unsigned :=next(sdram_read_data_i,6) end macro;

--burst write 
--macro CPU_data_in_burst_sig : burst :={resize(0,32), resize(0,32), resize(0,32), resize(0,32)} end macro;
macro CPU_data_in_burst_sig_data_1 : unsigned :=next(write_data_i,1) end macro;
macro CPU_data_in_burst_sig_data_2 : unsigned :=next(write_data_i,2)  end macro;
macro CPU_data_in_burst_sig_data_3 : unsigned :=next(write_data_i,3) end macro;
macro CPU_data_in_burst_sig_data_4 : unsigned :=next(write_data_i,4) end macro;

--macro data_in_end_burst_write_op_sig : request :={resize(0,32), false, false, false} end macro;
macro data_in_end_burst_write_op_sig_address_in : unsigned :=next(address_i)  end macro;
macro data_in_end_burst_write_op_sig_burst_single : boolean :=next(burst_single_i) end macro;
macro data_in_end_burst_write_op_sig_read_req : boolean :=next(read_request_i) end macro;
macro data_in_end_burst_write_op_sig_write_req : boolean :=next(write_request_i) end macro;

--macro data_out_burst_write_sig : resp_burst :={resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), false, false} end macro; 
macro data_out_burst_write_sig_address : unsigned :=prev(sdram_addr_o,2) end macro;
macro data_out_burst_write_sig_data_1 : unsigned :=prev(sdram_write_data_o,2) end macro;
macro data_out_burst_write_sig_data_2 : unsigned :=prev(sdram_write_data_o,1) end macro;
macro data_out_burst_write_sig_data_3 : unsigned :=prev(sdram_write_data_o,0) end macro;
macro data_out_burst_write_sig_data_4 : unsigned :=next(sdram_write_data_o,1) end macro;
macro data_out_burst_write_sig_last_row : unsigned :=last_row_reg end macro;
macro data_out_burst_write_sig_ready : boolean := not prev(ready_o,4) and not prev(ready_o,3) and not  prev(ready_o,2) and not prev(ready_o,1) and   prev(ready_o,0) end macro; 
macro data_out_burst_write_sig_sdram_status : boolean := prev(sdram_nop,3) and prev(sdram_write,2) and prev(sdram_nop,1)  and  prev(sdram_nop,0) end macro;

--read write 
--macro CPU_sdram_data_in_sig : rd_wrt :={resize(0,32), resize(0,32)} end macro;
macro CPU_sdram_data_in_sig_read_data : unsigned :=next(sdram_read_data_i,3)end macro;
macro CPU_sdram_data_in_sig_write_data : unsigned :=write_data_i end macro;

--macro data_in_end_read_write_op_sig : request :={resize(0,32), false, false, false} end macro; 
macro data_in_end_read_write_op_sig_address_in : unsigned :=next(address_i)  end macro;
macro data_in_end_read_write_op_sig_burst_single : boolean :=next(burst_single_i) end macro;
macro data_in_end_read_write_op_sig_read_req : boolean :=next(read_request_i) end macro;
macro data_in_end_read_write_op_sig_write_req : boolean :=next(write_request_i) end macro;

--macro data_out_read_write_sig : resp_rd_wrt :={resize(0,32), resize(0,32), resize(0,32), false, false, resize(0,32)} end macro;
macro data_out_read_write_sig_address : unsigned :=prev(sdram_addr_o,5) end macro;
macro data_out_read_write_sig_last_row : unsigned :=last_row_reg end macro;
macro data_out_read_write_sig_rd_data : unsigned := read_data_o end macro;
macro data_out_read_write_sig_ready : boolean :=prev(ready_o,5) and prev(ready_o,4) and prev(ready_o,3) and prev(ready_o,2) and prev(ready_o,1) and not ready_o end macro;
macro data_out_read_write_sig_sdram_status : boolean :=prev(sdram_read,5) and prev(sdram_stop,4) and prev(sdram_nop,3) and prev(sdram_nop,2) and prev(sdram_nop,1) and sdram_write  end macro;
macro data_out_read_write_sig_wrt_data : unsigned :=sdram_write_data_o end macro;


--macro precharge_read_sig : request :={resize(0,32), false, false, false} end macro;
macro precharge_read_sig_address_in : unsigned :=next(address_i) end macro;
macro precharge_read_sig_burst_single : boolean :=next(burst_single_i) end macro;
macro precharge_read_sig_read_req : boolean :=next(read_request_i) end macro;
macro precharge_read_sig_write_req : boolean :=next(write_request_i) end macro;

-- CONSTRAINTS --
constraint no_reset := reset = '0' and protocol_inputs_stable and  no_read_write_burst; end constraint;

-- VISIBLE REGISTERS --

macro CPU_input_data_read_write : unsigned :=if prev(reset) then resize(0,32) else write_data_i end if; end macro;


macro data_in_req_address_in : unsigned :=
	if prev(reset) then resize(0,32) 
	elsif(precharge_state) then prev(address_i)
	elsif(idle_state and not(prev(precharge_state))) then prev(address_i)
	else (address_i) end if; 
end macro;


macro data_in_req_burst_single : boolean := 
	if prev(reset) then '0'
	elsif(precharge_state) then prev(burst_single_i)
	elsif(idle_state and not(prev(precharge_state))) then prev(burst_single_i)
	else (burst_single_i) end if; 
end macro;

macro data_in_req_read_req : boolean := 
	if prev(reset) then '0' 
	elsif(precharge_state) then prev(read_request_i)
	elsif(idle_state and not(prev(precharge_state))) then prev(read_request_i)
	else(read_request_i) end if;
end macro;

macro data_in_req_write_req : boolean := 
	if prev(reset) then '0' 
	elsif(precharge_state) then prev(write_request_i)
	elsif(idle_state and not(prev(precharge_state))) then prev(write_request_i)
	else (write_request_i) end if;
end macro;

macro response_idle_last_row : unsigned :=  if prev(reset) then resize(0,32)  	elsif(idle_state) then prev(last_row) 
elsif(read_request and acc_rw) then (shift_right((data_in_req_address_in and resize(16777215,32)),resize(12,32)))else 
 last_row_reg end if; end macro;


-- STATES --
macro idle_1 : boolean := idle_state end macro;
macro end_read_op_2 : boolean := prev(read_request) end macro;
macro PRECHARGE_2 : boolean := precharge_state end macro;
macro single_read_4 : boolean := read_request end macro;
macro activate_3 : boolean := if(read_request_i and write_request_i) then state = row_act else row_act_state end if; end macro; -- note that row_act_state is a constrained row_act state where acc_rw = 0
macro single_write_5 : boolean := single_write end macro; 
macro burst_read_6 : boolean := burst_read end macro;
macro burst_write_7 : boolean := burst_write end macro; 







