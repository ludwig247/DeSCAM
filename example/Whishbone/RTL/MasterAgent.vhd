library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;

entity MasterAgent is
port(
	clk:		in std_logic;
	rst:		in std_logic;
	agent_to_bus:		out master_signals;
	agent_to_master:	out bus_resp_t;
	agent_to_master_sync:	 in std_logic;
	agent_to_master_notify:	 out std_logic;
	bus_to_agent:		in slave_signals;
	master_to_agent:		in bus_req_t;
	master_to_agent_sync:	 in std_logic;
	master_to_agent_notify:	 out std_logic);
end MasterAgent;


architecture MasterAgent_arch of MasterAgent is
			 signal section: MasterAgent_SECTIONS;
			 signal agent_to_bus_req_signal:bus_req_t;
			 signal agent_to_bus_resp_signal:bus_resp_t;
			 signal wb_in_signal:slave_signals;
			 signal wb_out_signal:master_signals;
			 signal agent_to_master_notify_int:std_logic;
			 signal master_to_agent_notify_int:std_logic;
			 signal wait_signal:int;
begin
	agent_to_master_notify <= agent_to_master_notify_int; 
	master_to_agent_notify <= master_to_agent_notify_int;
	process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			section <=IDLE;				
			agent_to_bus_req_signal.addr<=0;
			agent_to_bus_req_signal.data<=0;
			agent_to_bus_req_signal.trans_type<=SINGLE_READ;
			agent_to_bus_resp_signal.ack<=ERR;
			agent_to_bus_resp_signal.data<=0;
			wb_in_signal.ack<=false;
			wb_in_signal.data<=0;
			wb_in_signal.err<=false;
			wb_out_signal.addr<=0;
			wb_out_signal.cyc<=false;
			wb_out_signal.data<=0;
			wb_out_signal.stb<=false;
			wb_out_signal.we<=false;
			agent_to_bus <= master_signals_default;
			agent_to_master.data <= 0;
			agent_to_master_notify_int <=  '0';
			master_to_agent_notify_int <= '1';
			wait_signal <= 0;
		 else
		 if section = DONE then
			wb_in_signal <= bus_to_agent;
			if(wait_signal = 1 and not(bus_to_agent.ack)) then
				wait_signal <= 0;
				agent_to_master_notify_int <=  '1';
				master_to_agent_notify_int <= '0';
			elsif(wait_signal = 0 and agent_to_master_sync = '1') then
					section <= IDLE;
					agent_to_master_notify_int <=  '0';
					master_to_agent_notify_int <= '1';
			end if;
		 end if;
		 if section = IDLE then
		 	if(agent_to_master_notify_int =  '0' and master_to_agent_notify_int = '1' and master_to_agent_sync = '1') then
				agent_to_bus_req_signal <= master_to_agent;
				wb_out_signal.addr <= master_to_agent.addr;
				wb_out_signal.cyc <= true;
				wb_out_signal.stb <= true;
				agent_to_bus.addr <= master_to_agent.addr;
				agent_to_bus.cyc <= true;
				agent_to_bus.stb <= true;

				agent_to_master_notify_int <=  '0';
				master_to_agent_notify_int <= '0';
				if(master_to_agent.trans_type = SINGLE_READ) then
					section <= READ;
					wb_out_signal.data <= 0;
					wb_out_signal.we <= false;

					agent_to_bus.data <= 0;
					agent_to_bus.we <= false;
				else
					section <= WRITE;
					wb_out_signal.data <= master_to_agent.data;
					wb_out_signal.we <= true;

					agent_to_bus.data <= master_to_agent.data;
					agent_to_bus.we <= true;
				end if;
			end if;
		 end if;
		 if section = READ then
			section <= WAITING;
		 end if;
		 if section = WAITING then
			if(wait_signal = 0) then
				wb_in_signal <= bus_to_agent;
				if(bus_to_agent.ack) then
					wb_in_signal <= bus_to_agent;
					wb_out_signal <= master_signals_default;
					agent_to_bus <= master_signals_default;
					if(agent_to_bus_req_signal.trans_type = SINGLE_READ) then
						agent_to_bus_resp_signal.data <= bus_to_agent.data;
					end if;	
					agent_to_bus_resp_signal.ack <= OK;
					if(bus_to_agent.err) then
						agent_to_bus_resp_signal.ack <= ERR;
						
					end if;
					wait_signal <= 1;
				end if;
			else
				wait_signal <= 1;
				agent_to_master <= agent_to_bus_resp_signal; 
				agent_to_master_notify_int <=  '0';
				master_to_agent_notify_int <= '0';
				section <= DONE;
			end if;

		 end if;
		 if section = WRITE then
			section <= WAITING;
		 end if;
		 end if;
	 end if;
	 end process;
end MasterAgent_arch;

