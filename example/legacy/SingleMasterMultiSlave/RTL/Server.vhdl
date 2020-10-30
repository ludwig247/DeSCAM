library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;

entity Server is
port(
	clk:		in std_logic;
	rst:		in std_logic;
	bus_in:		in bus_resp_t;
	bus_in_sync:	 in std_logic;
	bus_in_notify:	 out std_logic;
	bus_out:		out bus_req_t;
	bus_out_sync:	 in std_logic;
	bus_out_notify:	 out std_logic;
	heat_power:		out bool;
	mix_power:		out bool;
	sample_timer_sync:	 in std_logic;
	sample_timer_notify:	 out std_logic;
	uP_in:		in config_t;
	uP_in_sync:	 in std_logic;
	uP_in_notify:	 out std_logic;
	uP_report_out:		out err_id_t;
	uP_report_out_sync:	 in std_logic;
	uP_report_out_notify:	 out std_logic);
end Server;


architecture Server_arch of Server is
signal section: Server_SECTIONS;
			 signal err_id_signal:err_id_t;
			 signal heat_signal:act_t;
			 signal mix_signal:act_t;
			 signal nb_result_signal:bool;
			 signal req_signal:bus_req_t;
			 signal resp_signal:bus_resp_t;
			 signal resp_bot_signal:bus_resp_t;
			 signal resp_top_signal:bus_resp_t;
			 signal temp_bot_signal:sensor_t;
			 signal temp_top_signal:sensor_t;
			 signal uP_signal:config_t;
			 signal bus_in_notify_tmp: std_logic;
			 signal bus_out_notify_tmp: std_logic;
			 signal sample_timer_notify_tmp: std_logic;
			 signal uP_report_out_notify_tmp: std_logic;
			 signal uP_in_notify_tmp: std_logic;
			 signal heat_power_tmp: bool;
			 signal mix_power_tmp: bool;
			 signal help:int;
begin

			bus_in_notify<= bus_in_notify_tmp;
			bus_out_notify<= bus_out_notify_tmp;
			sample_timer_notify <= sample_timer_notify_tmp;
			uP_report_out_notify <=  uP_report_out_notify_tmp;
			uP_in_notify <=  uP_in_notify_tmp;
			heat_power <= heat_power_tmp;
			mix_power <= mix_power_tmp;


	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=INIT;
			err_id_signal<=NO_ERR;
			heat_signal.Kd<=0;
			heat_signal.Ki<=0;
			heat_signal.Kp<=0;
			heat_signal.power_on<=false;
			heat_signal.sample_time<=0;
			heat_signal.sample_value<=0;
			heat_signal.setpoint<=0;
			mix_signal.Kd<=0;
			mix_signal.Ki<=0;
			mix_signal.Kp<=0;
			mix_signal.power_on<=false;
			mix_signal.sample_time<=0;
			mix_signal.sample_value<=0;
			mix_signal.setpoint<=0;
			nb_result_signal<=false;
			req_signal.addr<=0;
			req_signal.data<=0;
			req_signal.trans_type<=SINGLE_READ;
			resp_signal.ack<=ERR;
			resp_signal.data<=0;
			resp_bot_signal.ack<=ERR;
			resp_bot_signal.data<=0;
			resp_top_signal.ack<=ERR;
			resp_top_signal.data<=0;
			temp_bot_signal.data<=0;
			temp_bot_signal.data_stable<=false;
			temp_top_signal.data<=0;
			temp_top_signal.data_stable<=false;
			uP_signal.Kd_Heat<=0;
			uP_signal.Kd_Mix<=0;
			uP_signal.Ki_Heat<=0;
			uP_signal.Ki_Mix<=0;
			uP_signal.Kp_Heat<=0;
			uP_signal.Kp_Mix<=0;
			uP_signal.max_temp_diff<=0;
			uP_signal.sample_time<=0;
			uP_signal.target_temp<=0;
			heat_power_tmp <= true;
			mix_power_tmp <= false;
			bus_in_notify_tmp <= '0';
			bus_out_notify_tmp <= '0';
			bus_out.trans_type <= SINGLE_READ;
			bus_out.data <= 0;
			bus_out.addr <= 0;
			sample_timer_notify_tmp <= '0';
			uP_report_out_notify_tmp<= '0' ;
			uP_report_out <= ERR_MIX;
			uP_in_notify_tmp <= '0';
			help<=0;

		 else
		 if section = CONFIG then
			if(bus_in_notify_tmp = '0' and bus_out_notify_tmp <= '1') then
				if(bus_out_sync = '1') then
					bus_in_notify_tmp <= '1';
					bus_out_notify_tmp <= '0';
					sample_timer_notify_tmp <= '0';
					uP_report_out_notify_tmp <= '0';
					uP_in_notify_tmp <= '0';
				end if;
			elsif(bus_in_notify_tmp = '1' and bus_out_notify_tmp <= '0') then
				if(bus_in_sync = '1') then
					bus_in_notify_tmp <= '0';
					bus_out_notify_tmp <= '1';

					if(req_signal.addr = 1) then
						req_signal.addr <= 2;
						req_signal.data <= uP_signal.target_temp;
						resp_signal <= bus_in;
						bus_out.addr <= 2;
						bus_out.data <= uP_signal.target_temp;
					elsif(req_signal.addr = 2) then
						req_signal.addr <= 3;
						req_signal.data <= uP_signal.Kp_Heat;
						resp_signal <= bus_in;
						bus_out.addr <= 3;
						bus_out.data <= uP_signal.Kp_Heat;
					elsif(req_signal.addr = 3) then
						req_signal.addr <= 4;
						req_signal.data <= uP_signal.Ki_Heat;
						resp_signal <= bus_in;
						bus_out.addr <= 4;
						bus_out.data <= uP_signal.Ki_Heat;
					elsif(req_signal.addr = 4) then
						req_signal.addr <= 5;
						req_signal.data <= uP_signal.Kd_Heat;
						resp_signal <= bus_in;
						bus_out.addr <= 5;
						bus_out.data <= uP_signal.Kd_Heat;
					elsif(req_signal.addr = 5) then
						req_signal.addr <= 9;
						req_signal.data <= uP_signal.sample_time;
						resp_signal <= bus_in;
						bus_out.addr <= 9;
						bus_out.data <= uP_signal.sample_time;
					elsif(req_signal.addr = 9) then
						req_signal.addr <= 10;
						req_signal.data <= uP_signal.target_temp;
						resp_signal <= bus_in;
						bus_out.addr <= 10;
						bus_out.data <= uP_signal.target_temp;
					elsif(req_signal.addr = 10) then
						req_signal.addr <= 11;
						req_signal.data <= uP_signal.Kp_Mix;
						resp_signal <= bus_in;
						bus_out.addr <= 11;
						bus_out.data <= uP_signal.Kp_Mix;
					elsif(req_signal.addr = 11) then
						req_signal.addr <= 12;
						req_signal.data <= uP_signal.Ki_Mix;
						resp_signal <= bus_in;
						bus_out.addr <= 12;
						bus_out.data <= uP_signal.Ki_Mix;
					elsif(req_signal.addr = 12) then
						req_signal.addr <= 13;
						req_signal.data <= uP_signal.Kd_Mix;
						resp_signal <= bus_in;
						bus_out.addr <= 13;
						bus_out.data <= uP_signal.Kd_Mix;
					else
						section <= GET_TEMP;
						req_signal.addr <= 16;
						req_signal.data <= uP_signal.Kd_Mix;
						req_signal.trans_type <= SINGLE_READ;

						resp_signal <= bus_in;
						bus_out.addr <= 16;
						bus_out.trans_type <= SINGLE_READ;
						bus_out.data <= uP_signal.Kd_Mix;
					end if;
				end if;
			end if;
		 end if;
		 if section = ERROR then
			if(uP_report_out_notify_tmp = '0' and help=0) then
				help <= 1;
				mix_power_tmp <= false;
			elsif(uP_report_out_notify_tmp = '0' and help=1) then
				uP_report_out_notify_tmp <= '1';
				uP_report_out <= err_id_signal;
			elsif(help = 1 and  uP_report_out_notify_tmp = '1' and uP_report_out_sync = '1') then
				uP_report_out_notify_tmp <= '0';
				help<=0;
			end if;
		 end if;
		 if section = GET_TEMP then
			if(bus_out_notify_tmp = '1' and bus_in_notify_tmp = '0' and bus_out_sync = '1' and req_signal.addr = 16) then
					bus_in_notify_tmp <= '1';
					bus_out_notify_tmp <= '0';
					bus_out <= req_signal;
			elsif(bus_out_notify_tmp = '1' and bus_in_notify_tmp = '0' and bus_out_sync = '1' and req_signal.addr = 24) then
					bus_in_notify_tmp <= '1';
					bus_out_notify_tmp <= '0';
					bus_out <= req_signal;
			elsif(bus_out_notify_tmp = '0' and bus_in_notify_tmp = '1' and bus_in_sync = '1'and req_signal.addr = 16) then
					req_signal.addr<= 24;
					resp_top_signal <= bus_in;
					bus_in_notify_tmp <= '0';
					bus_out_notify_tmp <= '1';
					bus_out.addr <= 24;
					bus_out.trans_type <= req_signal.trans_type;
					bus_out.data <= req_signal.data;
			elsif(bus_out_notify_tmp = '0' and bus_in_notify_tmp = '1' and bus_in_sync = '1' and req_signal.addr = 24) then
					bus_in_notify_tmp <= '0';
					resp_bot_signal <= bus_in;
					if(not((resp_top_signal.ack = OK)) or not((bus_in.ack = OK))) then
						section <= ERROR;
						err_id_signal <= ERR_TEMP;
						heat_power_tmp <= false;

					elsif(resp_top_signal.data < 0 or resp_top_signal.data > 50 or bus_in.data < 0 or bus_in.data > 50) then
						section <= ERROR;
						err_id_signal <= ERR_TEMP;
						heat_power_tmp <= false;
					elsif(abs(resp_top_signal.data - bus_in.data) > uP_signal.max_temp_diff) then
						section <= ERROR;
						err_id_signal <= ERR_MIX;
						resp_bot_signal <= bus_in;
						heat_power_tmp <= false;
						bus_in_notify_tmp <= '0';
					else
						section <= SET_MIX;
						req_signal.addr <= 8;
						req_signal.data <= (resp_top_signal.data  + bus_in.data) / 2;
						req_signal.trans_type <= SINGLE_WRITE;

						bus_out.addr <= 8;
						bus_out.data <= (resp_top_signal.data + bus_in.data) / 2;
						bus_out.trans_type <= SINGLE_WRITE;

						bus_out_notify_tmp <= '1';

					end if;



			end if;
		 end if;
		 if section = IDLE then
			if(sample_timer_sync = '1' and uP_in_notify_tmp <= '0' and sample_timer_notify_tmp = '1') then
				sample_timer_notify_tmp <= '0';
				uP_in_notify_tmp <= '1';
			elsif(uP_in_sync = '1' and uP_in_notify_tmp <= '1' and sample_timer_notify_tmp = '0') then
				section <= CONFIG;
				nb_result_signal <= true;
				req_signal.addr <= 1;
				req_signal.data <= uP_in.sample_time;
				req_signal.trans_type <= SINGLE_WRITE;
				bus_out.addr <= 1;
				bus_out.data <= uP_in.sample_time;
				bus_out.trans_type <= SINGLE_WRITE;
				uP_in_notify_tmp <= '0';
				uP_signal <= uP_in;
				bus_out_notify_tmp <= '1';
			elsif(uP_in_sync = '0' and uP_in_notify_tmp = '1' and sample_timer_notify_tmp = '0') then
				section <= GET_TEMP;
				nb_result_signal <= false;
				req_signal.addr <= 16;
				req_signal.trans_type <= SINGLE_READ;
				bus_out.addr <= 16;
				bus_out.trans_type <= SINGLE_READ;
				uP_in_notify_tmp <= '0';
				bus_out_notify_tmp <= '1';
			end if;

		 end if;
		 if section = INIT then
		   if(bus_in_notify_tmp = '0' and bus_out_notify_tmp = '0' and sample_timer_notify_tmp = '0' and  uP_report_out_notify_tmp = '0' and uP_in_notify_tmp = '0' ) then
			if(heat_power_tmp = true and mix_power_tmp = false) then
				mix_power_tmp <= true;
			elsif(heat_power_tmp = true and mix_power_tmp = true) then
				uP_in_notify_tmp <= '1';
			end if;
		    elsif(bus_in_notify_tmp = '0' and bus_out_notify_tmp = '0' and sample_timer_notify_tmp = '0' and  uP_report_out_notify_tmp = '0' and uP_in_notify_tmp = '1' ) then
			if(uP_in_sync = '1') then
				section <= CONFIG;
				req_signal.addr <= 1;
				req_signal.data <= uP_in.sample_time;
				req_signal.trans_type <= SINGLE_WRITE;
				bus_out.addr <= 1;
				bus_out.data <= uP_in.sample_time;
				bus_out.trans_type <= SINGLE_WRITE;
				bus_in_notify_tmp <= '0';
				bus_out_notify_tmp <= '1';
				sample_timer_notify_tmp <= '0';
				uP_report_out_notify_tmp <= '0';
				uP_in_notify_tmp <= '0';
				uP_signal <= uP_in;

			end if ;
		    end if;
		 end if;
		 if section = SET_HEAT then
			if(bus_out_sync ='1' and bus_in_notify_tmp = '0') then
				bus_out_notify_tmp <= '0';
				bus_in_notify_tmp <= '1';
			elsif(bus_in_sync = '1' and bus_in_notify_tmp = '1') then

				resp_signal <= bus_in;

				bus_in_notify_tmp <= '0';
				bus_out_notify_tmp <= '0';
				sample_timer_notify_tmp <= '1';

				section <= IDLE;
			end if;
		 end if;
		 if section = SET_MIX then
			if(bus_out_sync ='1' and bus_in_notify_tmp = '0') then
				bus_out_notify_tmp <= '0';
				bus_in_notify_tmp <= '1';
			elsif(bus_in_sync = '1' and bus_in_notify_tmp = '1') then
				req_signal.addr <= 0;
				req_signal.data <= (resp_top_signal.data  + resp_bot_signal.data) / 2;
				req_signal.trans_type <= SINGLE_WRITE;

				bus_out.addr <= 0;
				bus_out.data <= (resp_top_signal.data + resp_bot_signal.data) / 2;
				bus_out.trans_type <= SINGLE_WRITE;
				resp_signal <= bus_in;

				bus_in_notify_tmp <= '0';
				bus_out_notify_tmp <= '1';

				section <= SET_HEAT;
			end if;

		 end if;
		 end if;
	 end if;
	 end process;
end Server_arch;


