library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;

entity Bus1 is
port(
	clk:		in std_logic;
	rst:		in std_logic;
	master_in:		in bus_req_t;
	master_in_sync:	 in std_logic;
	master_in_notify:	 out std_logic;
	master_out:		out bus_resp_t;
	master_out_sync:	 in std_logic;
	master_out_notify:	 out std_logic;
	slave_in0:		in bus_resp_t;
	slave_in0_sync:	 in std_logic;
	slave_in0_notify:	 out std_logic;
	slave_in1:		in bus_resp_t;
	slave_in1_sync:	 in std_logic;
	slave_in1_notify:	 out std_logic;
	slave_in2:		in bus_resp_t;
	slave_in2_sync:	 in std_logic;
	slave_in2_notify:	 out std_logic;
	slave_in3:		in bus_resp_t;
	slave_in3_sync:	 in std_logic;
	slave_in3_notify:	 out std_logic;
	slave_out0:		out bus_req_t;
	slave_out0_sync:	 in std_logic;
	slave_out0_notify:	 out std_logic;
	slave_out1:		out bus_req_t;
	slave_out1_sync:	 in std_logic;
	slave_out1_notify:	 out std_logic;
	slave_out2:		out bus_req_t;
	slave_out2_sync:	 in std_logic;
	slave_out2_notify:	 out std_logic;
	slave_out3:		out bus_req_t;
	slave_out3_sync:	 in std_logic;
	slave_out3_notify:	 out std_logic);
end Bus1;


architecture Bus_arch of Bus1 is
signal section: Bus_SECTIONS;
			 signal req_signal:bus_req_t;
			 signal resp_signal:bus_resp_t;
			signal  slave_out0_notify_tmp:std_logic;
			signal  slave_out1_notify_tmp:std_logic;
			signal  slave_out2_notify_tmp:std_logic;
			signal  slave_out3_notify_tmp:std_logic;
			signal 	slave_in0_notify_tmp: std_logic;
			signal 	slave_in1_notify_tmp: std_logic;
			signal 	slave_in2_notify_tmp: std_logic;
			signal 	slave_in3_notify_tmp: std_logic;
			signal 	master_in_notify_tmp: std_logic;
			signal 	master_out_notify_tmp: std_logic;

begin	
	slave_out0_notify <= slave_out0_notify_tmp;
	slave_out1_notify <= slave_out1_notify_tmp;
	slave_out2_notify <= slave_out2_notify_tmp;
	slave_out3_notify <= slave_out3_notify_tmp;
	slave_in0_notify <= slave_in0_notify_tmp;
	slave_in1_notify <= slave_in1_notify_tmp;
	slave_in2_notify <= slave_in2_notify_tmp;
	slave_in3_notify <= slave_in3_notify_tmp;
	master_in_notify <= master_in_notify_tmp;
	master_out_notify <= master_out_notify_tmp;	

wait_for_master: process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			section <=run;
			req_signal.addr<=0;
			req_signal.data<=0;
			req_signal.trans_type<=SINGLE_READ;
			resp_signal.ack<=ERR;
			resp_signal.data<=0;
			slave_out0_notify_tmp<= '0';
			slave_out1_notify_tmp<= '0';
			slave_out2_notify_tmp<= '0';
			slave_out3_notify_tmp<= '0';
			slave_in0_notify_tmp<= '0';
			slave_in1_notify_tmp<= '0';
			slave_in2_notify_tmp<= '0';
			slave_in3_notify_tmp<= '0';
			master_out_notify_tmp <= '0';
			master_in_notify_tmp <= '1';
		 else
		 if section = run then
			if(master_in_notify_tmp = '1' and master_in_sync = '1') then
				master_in_notify_tmp <= '0';
				req_signal <= master_in;
				if(master_in.trans_type = SINGLE_READ) then
					req_signal.data <= 0;
				end if;
				if(master_in.addr >= 0 and master_in.addr <= -7) then
					slave_out0_notify_tmp <= '1';			
					slave_out0 <= master_in;
					if(master_in.trans_type = SINGLE_READ) then
						slave_out0.data <= 0;
					end if;

				elsif(master_in.addr >= 8 and master_in.addr <= 15) then
					slave_out1_notify_tmp <= '1';			
					slave_out1 <= master_in;
					if(master_in.trans_type = SINGLE_READ) then
						slave_out1.data <= 0;
					end if;
					req_signal.addr <= master_in.addr - 8;
					slave_out1.addr <= master_in.addr - 8; 
				elsif(master_in.addr >= 16 and master_in.addr <= 23) then
					slave_out2_notify_tmp <= '1';			
					slave_out2 <= master_in;
					if(master_in.trans_type = SINGLE_READ) then
						slave_out2.data <= 0;
					end if;
					req_signal.addr <= master_in.addr - 16;
					slave_out2.addr <= master_in.addr - 16; 
				elsif(master_in.addr >= 24 and master_in.addr <= 31) then
					slave_out3_notify_tmp <= '1';			
					slave_out3 <= master_in;
					if(master_in.trans_type = SINGLE_READ) then
						slave_out3.data <= 0;
					end if;
					req_signal.addr <= master_in.addr - 24;
					slave_out3.addr <= master_in.addr - 24; 
				else 
					master_out_notify_tmp <= '1';
					master_out<= resp_signal;
					if(master_in.trans_type = SINGLE_WRITE) then
						resp_signal.data <= 0;
						master_out.data <= 0;
					end if;
				end if;
				
			end if;

			if(slave_out0_notify_tmp = '1' and slave_out0_sync = '1') then 
				slave_out0_notify_tmp <= '0';
				slave_in0_notify_tmp <= '1'; 
			elsif( slave_out1_notify_tmp = '1' and slave_out1_sync = '1') then 
				slave_out1_notify_tmp <= '0';
				slave_in1_notify_tmp <= '1'; 	
			elsif( slave_out2_notify_tmp = '1' and slave_out2_sync = '1') then 
				slave_out2_notify_tmp <= '0';
				slave_in2_notify_tmp <= '1'; 	
			elsif( slave_out3_notify_tmp = '1' and slave_out3_sync = '1') then 
				slave_out3_notify_tmp <= '0';
				slave_in3_notify_tmp <= '1'; 	
			end if;

			if(slave_in0_notify_tmp = '1' and slave_in0_sync = '1') then 
				slave_in0_notify_tmp <= '0';
				master_out <= slave_in0;
				master_out_notify_tmp <= '1';
				resp_signal <= slave_in0;
				if(req_signal.trans_type = SINGLE_WRITE) then
						master_out.data <= 0;
						resp_signal.data <= 0;
				end if;

			elsif(slave_in1_notify_tmp = '1' and slave_in1_sync = '1') then 
				slave_in1_notify_tmp <= '0';
				master_out <= slave_in1;
				master_out_notify_tmp <= '1';
				resp_signal <= slave_in1;
				if(req_signal.trans_type = SINGLE_WRITE) then
						master_out.data <= 0;
						resp_signal.data <= 0;
				end if;
			elsif(slave_in2_notify_tmp = '1' and slave_in2_sync = '1') then 
				slave_in2_notify_tmp <= '0';
				master_out <= slave_in2;
				master_out_notify_tmp <= '1';
				resp_signal <= slave_in2;
				if(req_signal.trans_type = SINGLE_WRITE) then
						master_out.data <= 0;
						resp_signal.data <= 0;
				end if;
			elsif(slave_in3_notify_tmp = '1' and slave_in3_sync = '1') then 
				slave_in3_notify_tmp <= '0';
				master_out <= slave_in3;
				master_out_notify_tmp <= '1';
				resp_signal <= slave_in3;
				if(req_signal.trans_type = SINGLE_WRITE) then
						master_out.data <= 0;
						resp_signal.data <= 0;
				end if;
			
			end if;
			if(master_out_notify_tmp = '1' and master_out_sync = '1') then
				master_out_notify_tmp <= '0';
				master_in_notify_tmp <= '1';
			end if;
		
		 end if;
		 end if;
	 end if;
	 end process;

		
end Bus_arch;
