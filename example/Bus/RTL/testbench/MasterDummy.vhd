library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;

entity MasterDummy is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	bus_req:		out bus_req_t;
	bus_req_sync:	 in bool;
	bus_req_notify:	 out bool;
	bus_resp:		in bus_resp_t;
	bus_resp_sync:	 in bool;
	bus_resp_notify:	 out bool);
end MasterDummy;


architecture MasterDummy_arch of MasterDummy is
signal section: MasterDummy_SECTIONS;
			 signal cnt_signal:int;
			 signal req_signal:bus_req_t;
			 signal resp_signal:bus_resp_t;
			 signal bus_resp_notify_tmp:bool;
			 signal bus_req_notify_tmp:bool;
begin	 
	bus_req <= req_signal;
	bus_resp_notify <= bus_resp_notify_tmp;
	bus_req_notify <= bus_req_notify_tmp;
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=run;
			cnt_signal<=1;
			req_signal.addr<=8;
			req_signal.data<=1;
			req_signal.trans_type<=SINGLE_WRITE;
			resp_signal.ack<=ERR;
			resp_signal.data<=0;
			bus_req_notify_tmp <= true;
			bus_resp_notify_tmp <= false;
		 else
		 if section = run then
			if(bus_req_notify_tmp = true and bus_resp_notify_tmp = false and bus_req_sync = true) then
				bus_req_notify_tmp <= false; 
				bus_resp_notify_tmp <= true;
			end if;
			if(bus_req_notify_tmp = false and bus_resp_notify_tmp = true and bus_resp_sync = true) then
				req_signal.data <= cnt_signal;
				if(cnt_signal < 10000000) then
					cnt_signal <= cnt_signal+1;
					req_signal.data <= cnt_signal+1;
					
				end if;

			  assert cnt_signal < 10000000 report "BLA" severity failure;
				if(req_signal.trans_type = SINGLE_READ) then
					req_signal.trans_type <= SINGLE_WRITE;
				else req_signal.trans_type <= SINGLE_READ;
				end if;

				if(req_signal.addr = 0) then 
					req_signal.addr <= 8;
				elsif(req_signal.addr = 8) then
					req_signal.addr <= 16;
				elsif(req_signal.addr = 16) then
					req_signal.addr <= 25;
				elsif(req_signal.addr = 25) then
					req_signal.addr <= 0;
				else req_signal.addr <= 0;
				end if;

				

				resp_signal <= bus_resp;
				bus_req_notify_tmp <= true; 
				bus_resp_notify_tmp <= false;
			end if;
		 end if;
		 end if;
	 end if;
	 end process;
end MasterDummy_arch;
