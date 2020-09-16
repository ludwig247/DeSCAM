

library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;

entity SlaveDummy is
port(
	clk:		in std_logic;
	rst:		in std_logic;
	bus_req:		in bus_req_t;
	bus_req_sync:	 in bool;
	bus_req_notify:	 out bool;
	bus_resp:		out bus_resp_t;
	bus_resp_sync:	 in bool;
	bus_resp_notify:	 out bool);
end SlaveDummy;


architecture SlaveDummy_arch of SlaveDummy is
signal section: SlaveDummy_SECTIONS;
			 signal cnt_signal:int;
			 signal req_signal:bus_req_t;
			 signal resp_signal:bus_resp_t;
			 signal bus_req_notify_tmp:bool;
			 signal bus_resp_notify_tmp:bool;
begin
	bus_req_notify <= bus_req_notify_tmp;
	bus_resp_notify <= bus_resp_notify_tmp;
	
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=run;
			cnt_signal<=0;
			req_signal.addr<=0;
			req_signal.data<=0;
			req_signal.trans_type<=SINGLE_READ;
			resp_signal.ack<=ERR;
			resp_signal.data<=0;
			bus_req_notify_tmp <= true;
			bus_resp_notify_tmp <= false;
		 else
		 if section = run then
		 if(bus_req_notify_tmp = true and bus_resp_notify_tmp = false and bus_req_sync = true) then
				req_signal <= bus_req;

				resp_signal.ack <= OK;
				resp_signal.data <= bus_req.data; 
				
				bus_resp.ack <= OK;
				bus_resp.data <= bus_req.data;

				bus_req_notify_tmp <= false; 
				bus_resp_notify_tmp <= true;
			end if;
		if(bus_req_notify_tmp = false and bus_resp_notify_tmp = true and bus_resp_sync = true) then				

				bus_req_notify_tmp <= true; 
				bus_resp_notify_tmp <= false;
			end if;
		 end if;
		 end if;
	 end if;
	 end process;
end SlaveDummy_arch;
