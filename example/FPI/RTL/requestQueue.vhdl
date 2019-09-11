library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;

entity requesteQ is
port(
	clk:		in std_logic;
	rst:		in std_logic;
	buffer1:		out req_t;
	buffer2:		out req_t;
	buffer3:		out req_t;
	peripheral_request_i:		in req_t;
	peripheral_request_i_sync:	 in bool;
	peripheral_request_i_notify:	 out bool;
	req_o:		out bool;
	status1:		out req_status_t;
	status2:		out req_status_t;
	status3:		out req_status_t;
	updateQ_i:		in update_t;
	updateQ_i_sync:	 in bool;
	updateQ_i_notify:	 out bool);
end requesteQ;


architecture requesteQ_arch of requesteQ is
signal section: requesteQ_SECTIONS;
			 --signal buffer1_var_signal:req_t;
			 signal buffer2_var_signal:req_t;
			 signal buffer3_var_signal:req_t;
			 signal status1_var_signal:req_status_t;
			 signal status2_var_signal:req_status_t;
			 signal status3_var_signal:req_status_t;
			 signal tmp_buffer_signal:req_t;
begin
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			section <=EMPTY;
			buffer1.addr <= 0;
			buffer1.data <= 0;
			buffer2.addr <= 0;
			buffer2.data <= 0;
			buffer3.addr <= 0;
			buffer3.data <= 0;
			req_o <= false;
			status1 <= empty_status;
			status2 <= empty_status;
			status3 <= empty_status;
			--buffer1_var_signal.abort<=false;
			--buffer1_var_signal.addr<=0;
			--buffer1_var_signal.data<=0;
			--buffer1_var_signal.opc<=BTR2_OPC;
			buffer2_var_signal.abort<=false;
			buffer2_var_signal.addr<=0;
			buffer2_var_signal.data<=0;
			buffer2_var_signal.opc<=BTR2_OPC;
			buffer3_var_signal.abort<=false;
			buffer3_var_signal.addr<=0;
			buffer3_var_signal.data<=0;
			buffer3_var_signal.opc<=BTR2_OPC;
			status1_var_signal<=EMPTY_STATUS;
			status2_var_signal<=EMPTY_STATUS;
			status3_var_signal<=EMPTY_STATUS;
			tmp_buffer_signal.abort<=false;
			tmp_buffer_signal.addr<=0;
			tmp_buffer_signal.data<=0;
			tmp_buffer_signal.opc<=BTR2_OPC;
			updateQ_i_notify <= true;
		 
		 elsif section = EMPTY then
				section <= NON_EMPTY;
				req_o <= true;
				status1 <= req_status;
		 elsif section = NON_EMPTY then
			tmp_buffer_signal <= peripheral_request_i;
			if(status1_var_signal = EMPTY_STATUS and status3_var_signal = EMPTY_STATUS) then
				status1_var_signal <= req_status;
				if(status2_var_signal = EMPTY_STATUS and updateQ_i_sync and updateQ_i = RTY_Q) then
					buffer2_var_signal <= peripheral_request_i;
					status2_var_signal <= req_status;
				end if;
			elsif(status1_var_signal /= EMPTY_STATUS and status2_var_signal = EMPTY_STATUS and status3_var_signal = EMPTY_STATUS) then
				buffer2_var_signal <= peripheral_request_i;
				status2_var_signal <= req_status;
				if(status1_var_signal = req_status and  updateQ_i = nxt_grant_q and updateQ_i_sync) then
					status1_var_signal <= addr_status;
				end if;
			elsif(status1_var_signal /= EMPTY_STATUS and status2_var_signal /= EMPTY_STATUS and status3_var_signal = EMPTY_STATUS) then
				if(updateQ_i_sync) then	
					if(status1_var_signal = REQ_STATUS) then
						buffer3_var_signal <= peripheral_request_i;
						status3_var_signal <= req_status;
						if(updateQ_i = nxt_grant_q) then	
						
							status1_var_signal <= addr_status;
						
						elsif(updateQ_i = RTY_Q) then
						
						end if;
					elsif(status1_var_signal = addr_status) then
						buffer3_var_signal <= peripheral_request_i;
						status3_var_signal <= req_status;
						if(updateQ_i = NXT_PHASE_Q) then
							status1_var_signal <= data_staus;
						elsif(updateQ_i = NXT_BTR_Q) then
							--status1_var_signal <= req_status;
						elsif(updateQ_i = RTY_Q) then
							status1_var_signal <= req_status;
						else
							status1_var_signal <= data_staus;
							status2_var_signal <= addr_status;
						end if;
					end if;
				else
					buffer3_var_signal <= peripheral_request_i;
					status3_var_signal <= req_status;
				end if;	
			elsif (status2_var_signal /= EMPTY_STATUS and status3_var_signal /= EMPTY_STATUS) then
				tmp_buffer_signal <= tmp_buffer_signal;
				if(status1_var_signal = REQ_STATUS) then 
					if(updateQ_i_sync and updateQ_i = NXT_GRANT_Q) then
						status1_var_signal <= addr_status;		
					end if;
				elsif(status1_var_signal = addr_status) then 
					if(updateQ_i_sync and updateQ_i = NXT_PHASE_Q) then
						status1_var_signal <= data_staus;
					end if;
				elsif(status1_var_signal = data_staus) then
					if(updateQ_i_sync and updateQ_i = NXT_BTR_Q) then
						status1_var_signal <= data_staus;
					elsif(updateQ_i_sync and updateQ_i = NXT_GRANT_Q) then
						buffer2_var_signal <= buffer3_var_signal;
						buffer3_var_signal <= peripheral_request_i;
						tmp_buffer_signal <= peripheral_request_i;
						
					end if;
				end if;
				if(status2_var_signal /= addr_status) then 
					if(updateQ_i_sync and updateQ_i = RTY_Q) then
						status1_var_signal <= req_status;
					elsif(updateQ_i_sync and updateQ_i = NXT_GRANT_Q) then
						if(status1_var_signal = data_staus) then
							status1_var_signal <= addr_status;
							status2_var_signal <= status3_var_signal;
						elsif(status1_var_signal /= REQ_STATUS) then
							
							status1_var_signal <= data_staus;
							status2_var_signal <= addr_status;
						end if;
					elsif(updateQ_i_sync and updateQ_i = NXT_PHASE_Q) then
						if(status1_var_signal = data_staus) then
						buffer2_var_signal <= buffer3_var_signal;
						buffer3_var_signal <= peripheral_request_i;
						tmp_buffer_signal <= peripheral_request_i;
						status1_var_signal <= status2_var_signal;
						end if;
					elsif(updateQ_i_sync and updateQ_i = NXT_BTR_Q) then	
						if(status1_var_signal = data_staus) then		
								buffer2_var_signal <= buffer3_var_signal;
								buffer3_var_signal <= peripheral_request_i;
								tmp_buffer_signal <= peripheral_request_i;
								status1_var_signal <= addr_status;
								status2_var_signal <= status3_var_signal;
						end if;			

					end if;
				else
					if(updateQ_i_sync and updateQ_i = RTY_Q) then
							status1_var_signal <= req_status;
							status2_var_signal <= req_status;
					elsif(updateQ_i_sync and updateQ_i = NXT_PHASE_Q) then
					
							buffer2_var_signal <= buffer3_var_signal;
							buffer3_var_signal <= peripheral_request_i;
							tmp_buffer_signal <= peripheral_request_i;
					elsif(updateQ_i_sync and updateQ_i = NXT_BTR_Q) then		
							buffer2_var_signal <= buffer3_var_signal;
							buffer3_var_signal <= peripheral_request_i;
							tmp_buffer_signal <= peripheral_request_i;
							status1_var_signal <= addr_status;
							status2_var_signal <= status3_var_signal;
								
					end if;
					
				end if;
			else 
				status1_var_signal <= status1_var_signal;
				status2_var_signal <= status2_var_signal;
				status3_var_signal <= status3_var_signal;
				tmp_buffer_signal <= tmp_buffer_signal;
			end if;

		 end if;
	 end if;
	 end process;
end requesteQ_arch;