library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;

entity FPI_Master is
port(
	clk:		in std_logic;
	rst:		in std_logic;
	abort_en_o:		out bool;
	abort_o:		out bool;
	ack_i:		in ack_t;
	addr_en_o:		out bool;
	addr_o:		out int;
	buffer1:		in req_t;
	buffer2:		in req_t;
	buffer3:		in req_t;
	data_en_o:		out bool;
	data_i:		in int;
	data_o:		out int;
	gnt_i:		in bool;
	master_done:		out result_t;
	master_done_sync:	 in bool;
	master_done_notify:	 out bool;
	master_result_o_sync:	 in bool;
	master_result_o_notify:	 out bool;
	opc_o:		out opc_t;
	ready_i:		in bool;
	ready_i_sync:	 in bool;
	ready_i_notify:	 out bool;
	status1:		in req_status_t;
	status2:		in req_status_t;
	status3:		in req_status_t;
	updateQ_o:		out update_t;
	updateQ_o_sync:	 in bool;
	updateQ_o_notify:	 out bool;
	wait_cnt_end:		in bool);
end FPI_Master;


architecture FPI_Master_arch of FPI_Master is
signal section: FPI_Master_SECTIONS;
			 signal ack_tmp_signal:ack_t;
			 signal btrCnt_signal:int;
			 signal buffer1_tmp_signal_addr:int;
			 signal gnt_signal:bool;
			 signal nop_signal:bool;
			 signal tmp_bool_signal:bool;
			 signal updateQ_cycle_tmp_signal:bool;
			 signal updateQ_msg_tmp_signal:update_t;
begin
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			section <=IDLE;
			ack_tmp_signal<=ERR;
			btrCnt_signal<=0;
			buffer1_tmp_signal_addr<=0;	
			gnt_signal<=false;
			addr_o <= 0;
			addr_en_o <= false;
			abort_en_o <= false;
			abort_o <= false;
			data_o <= 0;
			data_en_o <= false;
			opc_o <= BTR2_OPC;
			nop_signal<=false;
			tmp_bool_signal<=false;
			updateQ_cycle_tmp_signal<=false;
			updateQ_msg_tmp_signal<=NXT_BTR_Q;
			master_done_notify <= false;
			master_result_o_notify <= false;
			ready_i_notify <= true;
			updateQ_o_notify <= false;
		 else
		 if section = ADDR then
			master_done_notify <= false;
			master_result_o_notify <= false;
			buffer1_tmp_signal_addr <= buffer1.addr;
			data_en_o <= false;
			updateQ_o_notify <= true;
			abort_en_o <= true;
			abort_o <= buffer1.abort;
			
			section <= DATA;

			if(not(gnt_i)) then 
				nop_signal <= false;
				
				addr_en_o <= false;
				updateQ_o <= NXT_PHASE_Q;
				if((buffer1.opc = WRITE_OPC)) then
					data_en_o <= true;
					data_o <= buffer1.data;
				end if;
			elsif(gnt_i) then
				if(buffer1.opc = WRITE_OPC) then
					data_en_o <= true;
					data_o <= buffer1.data;
				end if;
				
				if((buffer1.opc = BTR2_OPC) or (buffer1.opc = BTR4_OPC) or (buffer1.opc = BTR8_OPC)) then
					section <= BTR_CONT;

					abort_en_o <= true;
					abort_o <= buffer1.abort;
					
					addr_en_o <= true;
					addr_o <= (1 + buffer1.addr);

					btrCnt_signal <= 0;
					
					opc_o <= buffer1.opc;

					updateQ_o_notify <= true;
					updateQ_o <= NXT_BTR_Q;
				else 	
					if( status2 = REQ_STATUS) then 
						section <= DATA_ADDR;

						addr_en_o <= true;
						addr_o <= (buffer2.addr);

						nop_signal <= false;

						opc_o <= buffer2.opc;

						updateQ_o_notify <= true;
						updateQ_o <= NXT_GRANT_Q;
						
					else	
						addr_en_o <= true;
						addr_o <= (0);
						nop_signal <= true;
						opc_o <= nop_opc;
						updateQ_o <= NXT_PHASE_Q;
					
					end if;					
				end if;
			end if;
		 end if;
		 if section = BTR_CONT then
			master_done_notify <= false;
			master_result_o_notify <= false;
			updateQ_o_notify <= true;
			buffer1_tmp_signal_addr <= buffer1.addr;
			if( ack_i = RTY and btrCnt_signal = 0) then
				if(not(gnt_i))  then
					section <= WAIT_BEFORE_RETRY;
					abort_en_o <= true;
					abort_o <= true;
					addr_en_o <= false;
					data_en_o <= false;
					nop_signal <= false;
					updateQ_o <= RTY_Q;
				else		
					section <= WAIT_BEFORE_RETRY;
					abort_en_o <= true;
					abort_o <= true;
					addr_en_o <= true;
					addr_o <= 0;
					data_en_o <= false;
					nop_signal <= true;
					opc_o <= nop_opc;
					updateQ_o <= RTY_Q;
				end if;
			else 
				master_done_notify <= true;
				master_done.data <= data_i;
				master_done.err <= not(ack_i = OK);
				btrCnt_signal <= btrCnt_signal + 1;
				abort_en_o <= true;
				abort_o <= false;
				updateQ_o_notify <= false;
				if( not(buffer1.opc = BTR2_OPC and btrCnt_signal = 0)  and not(((buffer1.opc = BTR4_OPC) and (btrCnt_signal = 2))) and not(((buffer1.opc = BTR8_OPC) and (btrCnt_signal = 6)))) then
					updateQ_o_notify <= false;
					data_en_o <= false;
					if((gnt_i)) then
						addr_en_o <= true;
						--addr_o <= ((1 + buffer1_tmp_signal_addr) + btrCnt_signal);
						addr_o <= ((2 + buffer1.addr) + btrCnt_signal);
						opc_o <= buffer1.opc;
					end if;
				else 	
					
						updateQ_o_notify <= true;
						if((gnt_i)) then
							section <= data_addr;
							addr_en_o <= true; 
							addr_o <= buffer2.addr;

							updateQ_o <= NXT_GRANT_Q;
							opc_o <= buffer2.opc;
							if(not(status2 = req_status)) then
								section <= data;
								nop_signal <= true;
								opc_o <= nop_opc;
								updateQ_o <= NXT_PHASE_Q;
								addr_o <= 0;
							end if;
						else
							section <= data;
							addr_en_o <= false; 
							buffer1_tmp_signal_addr <= buffer1.addr;
							
							updateQ_o_notify <= true;
							updateQ_o <= NXT_PHASE_Q;
							nop_signal <= false;
					end if;
							
						

				end if;
			end if;	
		 end if;
		 if section = DATA then
			master_done_notify <= false;
			master_result_o_notify <= false;
			updateQ_o_notify <= true;
			if( ack_i = RTY and buffer1.opc = RMW_OPC) then
				section <= WAIT_BEFORE_RETRY;
				abort_en_o <= false;
				data_en_o <= false;
				updateQ_o <= RTY_Q;
				updateQ_o_notify <= true;
				buffer1_tmp_signal_addr <= buffer1.addr;
				nop_signal <= gnt_i;
				if(nop_signal) then
					abort_en_o <= true;
					abort_o <= false;
					data_en_o <= true;
					data_o <= 0;	
				end if;
			else 	
				abort_en_o <= false;
				buffer1_tmp_signal_addr <= buffer1.addr;
				master_done_notify <= true;
				master_done.data <= data_i;
				master_done.err <= not(ack_i = OK);
				if(status2 = REQ_STATUS) then
					
					updateQ_o <= NXT_PHASE_Q;
					addr_en_o <= false;
					if(nop_signal) then
						section <= ADDR;
						
					
						abort_en_o <= true;
						abort_o <= false;
						data_en_o <= true;
						
						nop_signal <= false;					
						
						data_en_o <= false;
						
						updateQ_o_notify <= true;

						if(gnt_i) then
							addr_en_o <= true;
							addr_o <= buffer2.addr;
							data_en_o <= true;
							data_o <= 0;
							opc_o <= buffer2.opc;
							updateQ_o <= NXT_GRANT_Q;
						else 
							section<= IDLE;
							data_en_o <= true;
							data_o <= 0;
							addr_en_o <= false;
							updateQ_o <= NXT_PHASE_Q;
						
						end if;
					else
						if(gnt_i) then
							section <= ADDR;
							abort_en_o <= false;
							addr_en_o <= true;
							addr_o <= buffer2.addr;							
							data_en_o <= false;
							opc_o <= buffer2.opc;
							updateQ_o <= NXT_GRANT_Q;
						else 
							section <= IDLE;
							abort_en_o <= false;
							addr_en_o <= false;
							data_en_o <= false;
							nop_signal <= false;
							
						end if;
				
	
					end if;
				else 
					updateQ_o <= NXT_PHASE_Q;
					updateQ_o_notify <= true;
					addr_en_o <= false;
					data_en_o <= false;
					section <= IDLE;
					if(not(nop_signal)) then
						if(gnt_i) then	
							addr_en_o <= true;
							addr_o <= 0;
							nop_signal <= true;
							opc_o <= nop_opc;
						else 
							addr_en_o <= false;
							nop_signal <= false;
						end if;
					else
						if(gnt_i) then	
							addr_en_o <= true;
							addr_o <= 0;
							abort_en_o <= true;
							abort_o <= false;
							nop_signal <= true;
							data_en_o <= true;
							data_o <= 0;
							opc_o <= nop_opc;
						else 
							abort_en_o <= true;
							abort_o <= false;
							addr_en_o <= false;
							data_en_o <= true;
							data_o <= 0;
							nop_signal <= false;
						end if;
					end if;
					
				end if;
			end if;
		 end if;
		 if section = DATA_ADDR then
			if( (ack_i = RTY) and (buffer1.opc = RMW_OPC)   ) then
				section <= WAIT_BEFORE_RETRY;
				abort_en_o <= true;
				abort_o <= true;
				buffer1_tmp_signal_addr <= buffer1.addr;
				updateQ_o <= RTY_Q;
				updateQ_o_notify <= true;
				master_done_notify <= false;
				if(not(gnt_i)) then
					addr_en_o <= false;
					nop_signal <= false;		
					data_en_o <=  false;
					if((buffer2.opc = WRITE_OPC)) then 
						data_en_o <=  true;
						data_o <= 0;
					end if;
				else 
					addr_en_o <= true;
					addr_o <= 0;
					nop_signal <= true;
					opc_o <= nop_opc;
					data_en_o <=  false;
					if((buffer2.opc = WRITE_OPC)) then 
						data_en_o <=  true;
						data_o <= 0;
					end if;
				end if;
			else 
				section <= DATA;
				abort_en_o <= true;
				abort_o <= buffer2.abort;
				buffer1_tmp_signal_addr <= buffer1.addr;
				master_done_notify <= true;
				master_done.data <= data_i;
				master_done.err <= not(ack_i = OK);
				updateQ_o_notify <= false;
				if(not(gnt_i)) then
					addr_en_o <= false;
					nop_signal <= false;		
					data_en_o <=  false;
					if((buffer2.opc = WRITE_OPC)) then 
						data_en_o <=  true;
						data_o <= buffer2.data;
					end if;
				else 
					if((buffer2.opc = BTR2_OPC) or (buffer2.opc = BTR4_OPC) or (buffer2.opc = BTR8_OPC)) then	
					
						section <= BTR_CONT;
						addr_en_o <= true;
						addr_o <= buffer2.addr+1; 
						btrCnt_signal <= 0;
						opc_o <= buffer2.opc;
						data_en_o <=  false;
						updateQ_o_notify <= true;
						updateQ_o <= NXT_BTR_Q;
					elsif(not((buffer2.opc = BTR2_OPC) or (buffer2.opc = BTR4_OPC) or (buffer2.opc = BTR8_OPC))) then	
						section <= data_addr;
						addr_en_o <= true;
						addr_o <= buffer3.addr; 
						opc_o <= buffer3.opc;
						data_en_o <=  false;
						updateQ_o_notify <= true;
						updateQ_o <= NXT_GRANT_Q;
					
						if((buffer2.opc = WRITE_OPC)) then 
							data_en_o <=  true;
							data_o <= buffer2.data;
							if(status3 = REQ_STATUS) then
								data_en_o <=  true;
								data_o <= buffer2.data;
							else 
							section <= DATA;
								addr_o <= 0; 
								nop_signal <= true;
								opc_o <= nop_opc;
								updateQ_o <= NXT_PHASE_Q;
							end if;
						else 
							if(status3 = REQ_STATUS) then
								--data_en_o <=  true;
								--data_o <= buffer2.data;
							else 
								section <= DATA;
								addr_o <= 0; 
								nop_signal <= true;
								opc_o <= nop_opc;
								updateQ_o <= NXT_PHASE_Q;
							end if;
						end if;
					end if;
				end if;
			end if;
		 end if;
		 if section = IDLE then
			master_done_notify <= false;
			master_result_o_notify <= false;
			abort_en_o <= false;
			abort_en_o <= false;
			addr_en_o <= false;
			data_en_o <= false;
			nop_signal <= false;
			master_done_notify <= false;
			master_result_o_notify <= false;
			updateQ_o_notify <= false;
			buffer1_tmp_signal_addr <= buffer1.addr;

			if(nop_signal and not(gnt_i)) then
				abort_en_o <= true;
				abort_o <= false;
				data_en_o <= true;
				data_o <= 0;

			end if;
			if((gnt_i) and not(status1 = REQ_STATUS))  then
				addr_en_o <= true;
				addr_o <= 0;
				nop_signal <= true;
				opc_o  <= NOP_OPC;
				if(nop_signal) then 
					data_en_o <= true;
					data_o <= 0;
					abort_en_o <= true;
					abort_o <= false;
				end if;

					
			end if;	
			
			if(gnt_i and (status1 = REQ_STATUS))  then
				addr_en_o <= true;
				addr_o <= buffer1.addr;
				opc_o <= buffer1.opc;
				updateQ_o_notify <= true;
				updateQ_o <= NXT_GRANT_Q;
				
				section <= ADDR;
				if(nop_signal) then
					abort_en_o <= true;
					abort_o <= false;
					data_en_o <= true;
					data_o <= 0;
				end if;
			end if;


		 end if;
		 if section = WAIT_BEFORE_RETRY then
			if(wait_cnt_end) then
				if(not(nop_signal)) then

					abort_en_o <= false;
					addr_en_o <= false;
					data_en_o <= false;
					nop_signal <= false;
					master_done_notify <= false;
					master_result_o_notify <= false;
					updateQ_o_notify <= false;
					section <= IDLE;
					
					
				else 

					abort_en_o <= true;
					abort_o <= false;
					addr_en_o <= false;
					data_en_o <= true;
					data_o <= 0;
					nop_signal <= false;
					master_done_notify <= false;
					master_result_o_notify <= false;
					updateQ_o_notify <= false;
					section <= IDLE;
	
				end if;
				if(gnt_i) then
						addr_en_o <= true;	
						addr_o <= 0;
						nop_signal <= true;
						opc_o <= nop_opc;
				end if;
			else	
				
				abort_en_o <= false;
				addr_en_o <= false;
				data_en_o <= false;
				nop_signal <= false;
				master_done_notify <= false;
				master_result_o_notify <= false;
				updateQ_o_notify <= false;				
				if(nop_signal and not(gnt_i)) then
					abort_en_o <= true;
					abort_o <= false;
					data_en_o <= true;
					data_o <= 0;
				elsif(not(nop_signal) and (gnt_i)) then 
					addr_en_o <= true;
					addr_o <= 0;
					nop_signal <= true;
					opc_o <= nop_opc;
				elsif((nop_signal) and (gnt_i)) then 
					abort_en_o <= true;
					abort_o <= false;
					addr_en_o <= true;
					addr_o <= 0;
					nop_signal <= true;
					data_en_o <= true;
					data_o <= 0;
					opc_o <= nop_opc;
				end if;
			end if;
		 end if;
		 end if;
	 end if;
	 end process;
end FPI_Master_arch;