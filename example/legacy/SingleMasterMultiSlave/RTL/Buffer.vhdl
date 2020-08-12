library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;


entity Buffer_new is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	bus_req:		in bus_req_t;
	bus_req_sync:	 in std_logic;
	bus_req_notify:	 out std_logic;
	bus_resp:		out bus_resp_t;
	bus_resp_sync:	 in std_logic;
	bus_resp_notify:	 out std_logic;
	value_in:		in int);
end Buffer_new;


architecture Buffer_arch of Buffer_new is
signal section: Buffer_SECTIONS;
			 signal nb_result_signal:bool;
			 signal req_signal:bus_req_t;
			 signal resp_signal:bus_resp_t;
			 signal bus_req_notify_temp:std_logic;
			 signal bus_resp_notify_temp:std_logic;
begin
	 bus_req_notify <= bus_req_notify_temp;
	 bus_resp_notify <= bus_resp_notify_temp;

	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			section <=run;
			nb_result_signal<=false;
			req_signal.addr<=0;
			req_signal.data<=0;
			req_signal.trans_type<=SINGLE_READ;
			resp_signal.ack<=ERR;
			resp_signal.data<=0;
			bus_req_notify_temp <= '1';
			bus_resp_notify_temp <= '0'; 
		 else
		 if section = run then
			if(bus_req_sync = '1' and bus_req_notify_temp = '1') then
				nb_result_signal <= true;
				req_signal <=  bus_req;
				bus_req_notify_temp <= '0';
			elsif(bus_req_notify_temp = '0' and bus_resp_notify_temp = '0' and nb_result_signal = true) then
				resp_signal.ack <= OK;
				resp_signal.data <= value_in;
				bus_resp_notify_temp <= '1';
				bus_resp.ack <= OK;
				bus_resp.data <= value_in;
			elsif(bus_req_sync = '0' and bus_req_notify_temp = '1') then
				nb_result_signal <= false;
			elsif(bus_resp_sync = '1' and bus_resp_notify_temp = '1') then
				bus_resp_notify_temp <= '0';
				bus_req_notify_temp <= '1';
			end if;
		 end if;
		 end if;
	 end if;
	 end process;
end Buffer_arch;
