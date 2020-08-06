library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;

entity PID_Actuator is
port(
	clk:		in std_logic;
	rst:		in std_logic;
	bus_req:		in bus_req_t;
	bus_req_sync:	 in std_logic;
	bus_req_notify:	 out std_logic;
	bus_resp:		out bus_resp_t;
	bus_resp_sync:	 in std_logic;
	bus_resp_notify:	 out std_logic;
	dac:		out int;
	power:		in bool);
end PID_Actuator;



architecture PID_Actuator_arch of PID_Actuator is
signal section: PID_Actuator_SECTIONS;
			 signal Kd_signal:int;
			 signal Ki_signal:int;
			 signal Kp_signal:int;
			 signal deriv_signal:int;
			 signal device_power_signal:bool;
			 signal error_signal:int;
			 signal integral_signal:int;
			 signal prev_err_signal:int;
			 signal req_signal:bus_req_t;
			 signal resp_signal:bus_resp_t;
			 signal sample_signal:int;
			 signal sample_time_signal:int;
			 signal setpoint_signal:int;
			 signal setup_correct_signal:bool;
			 signal bus_resp_notify_temp:std_logic;
			 signal bus_req_notify_temp:std_logic;
			 signal wait_signal:int; 
begin
	 bus_req_notify <= bus_req_notify_temp;
	 bus_resp_notify <= bus_resp_notify_temp;

	 process(Kd_signal,Ki_signal,Kp_signal,sample_time_signal,sample_signal,setpoint_signal)
		begin 
			if(Kp_signal<1 or Kp_signal > 9) then setup_correct_signal <= false;
			elsif(Ki_signal<1 or Ki_signal > 9) then setup_correct_signal <= false;
			elsif(Kd_signal<1 or Kd_signal > 9) then setup_correct_signal <= false;
			elsif(setpoint_signal < 1 or setpoint_signal > 99) then setup_correct_signal <= false;
			elsif(abs(setpoint_signal-sample_signal))>9 then setup_correct_signal <= false;
			elsif(sample_time_signal < 2 or sample_time_signal > 999) then setup_correct_signal <= false;
			else setup_correct_signal <= true;
			end if;
		end process;
	 process(clk)	
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			section <=reading;
			Kd_signal<=0;
			Ki_signal<=0;
			Kp_signal<=0;
			deriv_signal<=0;
			device_power_signal<=false;
			error_signal<=0;
			integral_signal<=0;
			prev_err_signal<=0;
			req_signal.addr<=0;
			req_signal.data<=0;
			req_signal.trans_type<=SINGLE_READ;
			resp_signal.ack<=ERR;
			resp_signal.data<=0;
			sample_signal<=20;
			sample_time_signal<=10;
			setpoint_signal<=20;
			--setup_correct_signal<=false;
			bus_req_notify_temp <= '1';
			bus_resp_notify_temp <= '0';
			wait_signal <= 0;

		 else
		 if section = checking then
			if(wait_signal = 1) then 
				bus_resp_notify_temp <= '0';
				bus_req_notify_temp <= '1';
				wait_signal <= 0;
				section <= reading;
			elsif(setup_correct_signal and power) then
				section <= compute;
				wait_signal <= 4;
				device_power_signal<= power;
			else
				device_power_signal<= power;
				dac <= 0;
				wait_signal <= 1;
			end if;
		 elsif section = compute then
				bus_resp_notify_temp <= '0';
				bus_req_notify_temp <= '0';
				if(wait_signal = 4) then	
					error_signal <= setpoint_signal - sample_signal;
					wait_signal <= 3;
				elsif wait_signal = 3 then
					deriv_signal <= (setpoint_signal - sample_signal- prev_err_signal) / sample_time_signal;
					if(integral_signal + sample_time_signal * (setpoint_signal - sample_signal) < -65535) then
						integral_signal <= -65535;
					elsif(integral_signal + sample_time_signal * (setpoint_signal - sample_signal) > 65535) then
						integral_signal <= 65535;
					else 
						integral_signal <= integral_signal + sample_time_signal * (setpoint_signal - sample_signal);
					end if;
					wait_signal <=2;
				elsif wait_signal = 2 then
					prev_err_signal <= error_signal;
					dac <= (Kp_signal *(setpoint_signal - sample_signal))+ (Ki_signal * integral_signal) + (Kd_signal * deriv_signal);	
					wait_signal <= 1;
				elsif wait_signal = 1 then
					section <= reading;
					bus_resp_notify_temp <= '0';
					bus_req_notify_temp <= '1';
					wait_signal <= 0;
				end if;


				
		
		 elsif section = reading then
			if(bus_req_sync = '1' and bus_req_notify_temp <= '1' and bus_resp_notify_temp <= '0') then
				bus_resp_notify_temp <= '1';
				bus_req_notify_temp <= '0';
				req_signal.addr <= bus_req.addr;
				req_signal.data <= bus_req.data;
				req_signal.trans_type <= bus_req.trans_type;
				resp_signal.ack <= OK;
				bus_resp.ack <= OK;	
				bus_resp.data <= resp_signal.data;
				if(bus_req.addr = 0) then	
					sample_signal <= bus_req.data;
				elsif(bus_req.addr = 1) then
					sample_time_signal <= bus_req.data;
				elsif(bus_req.addr = 2) then 
					setpoint_signal <= bus_req.data;
				elsif(bus_req.addr = 3) then 
					Kp_signal <= bus_req.data;
				elsif(bus_req.addr = 4) then 
					Ki_signal <= bus_req.data;
				elsif(bus_req.addr = 5) then 
					Kd_signal <= bus_req.data;
				else 
					resp_signal.ack <= ERR;	
					bus_resp.ack <= ERR;	
				end if;
			elsif(bus_resp_sync = '1' and bus_req_notify_temp <= '0' and bus_resp_notify_temp <= '1') then
				bus_resp_notify_temp <= '0';
				bus_req_notify_temp <= '0';
				section <= checking;
			end if;
			
			
		 end if;
		 end if;
	 end if;
	 end process;
end PID_Actuator_arch;