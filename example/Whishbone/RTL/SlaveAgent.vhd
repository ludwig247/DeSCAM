library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;

entity SlaveAgent is
port(
	clk:		in std_logic;
	rst:		in std_logic;
	agent_to_bus:		out slave_signals;
	agent_to_slave:		out bus_req_t;
	agent_to_slave_sync:	 in std_logic;
	agent_to_slave_notify:	 out std_logic;
	bus_to_agent:		in master_signals;
	slave_to_agent:		in bus_resp_t;
	slave_to_agent_sync:	 in std_logic;
	slave_to_agent_notify:	 out std_logic);
end SlaveAgent;


architecture SlaveAgent_arch of SlaveAgent is
signal section: SlaveAgent_SECTIONS;
			 signal agent_to_slave_req_signal:bus_req_t;
			 signal slave_to_agent_resp_signal:bus_resp_t;
			 signal wb_in_signal:master_signals;
			 signal wb_out_signal:slave_signals;
			 signal agent_to_slave_notify_int: std_logic;
			 signal slave_to_agent_notify_int: std_logic;
			 signal is_done: bool;
begin
	 agent_to_slave_notify <= agent_to_slave_notify_int;	
	 slave_to_agent_notify <=  slave_to_agent_notify_int;
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			section <=IDLE;
			agent_to_bus <= slave_signals_default;
			agent_to_slave_req_signal.addr<=0;
			agent_to_slave_req_signal.data<=0;
			agent_to_slave_req_signal.trans_type<=SINGLE_READ;
			slave_to_agent_resp_signal.ack<=ERR;
			slave_to_agent_resp_signal.data<=0;
			wb_in_signal.addr<=0;
			wb_in_signal.cyc<=false;
			wb_in_signal.data<=0;
			wb_in_signal.stb<=false;
			wb_in_signal.we<=false;
			wb_out_signal.ack<=false;
			wb_out_signal.data<=0;
			wb_out_signal.err<=false;
			slave_to_agent_notify_int <= '0';
			agent_to_slave_notify_int <= '0';
			is_done <= false;
			
		 else
		 if section = DONE then
			
			if(is_done) then 
				is_done <= false;
				if(not(wb_in_signal.cyc or wb_in_signal.stb)) then
					section <= IDLE;
				end if;
			else
				is_done <= true;
				if(not(bus_to_agent.cyc)  and not(bus_to_agent.stb)) then
					wb_in_signal <= bus_to_agent;

					wb_out_signal.ack <= false;
					wb_out_signal.data <= 0;
					wb_out_signal.err <= false;
			
					agent_to_bus.ack <= false;
					agent_to_bus.data <= 0;
					agent_to_bus.err <= false;

					agent_to_slave_notify_int <= '0';
					slave_to_agent_notify_int <= '0';
					
				else
					wb_in_signal <= bus_to_agent;

					wb_out_signal.ack <= true;
					wb_out_signal.err <= not(slave_to_agent_resp_signal.ack = OK);

					agent_to_bus.ack <= true;
					agent_to_bus.err <= not(slave_to_agent_resp_signal.ack = OK);
	

					if(bus_to_agent.we) then
						wb_out_signal.data <= 0;
						agent_to_bus.data <= 0;
					else	
						wb_out_signal.data <= slave_to_agent_resp_signal.data;
						agent_to_bus.data <= slave_to_agent_resp_signal.data;
					end if;
				end if;
			end if;
		
		 end if;
		 if section = IDLE then
			wb_in_signal <= bus_to_agent;
			if(bus_to_agent.cyc  and bus_to_agent.stb) then
				agent_to_slave_notify_int <= '1';
				slave_to_agent_notify_int <= '0';
				if(bus_to_agent.we) then
					section <= WRITE;
					agent_to_slave_req_signal.addr <= bus_to_agent.addr;
					agent_to_slave_req_signal.data <= bus_to_agent.data;
					agent_to_slave_req_signal.trans_type <= SINGLE_WRITE;

					agent_to_slave.addr <= bus_to_agent.addr;
					agent_to_slave.data <= bus_to_agent.data;
					agent_to_slave.trans_type <= SINGLE_WRITE;
				else
					section <= READ;
					agent_to_slave_req_signal.addr <= bus_to_agent.addr;
					agent_to_slave_req_signal.trans_type <= SINGLE_READ;
					agent_to_slave_req_signal.data <= 0;

					agent_to_slave.addr <= bus_to_agent.addr;
					agent_to_slave.data <= 0;
					agent_to_slave.trans_type <= SINGLE_READ;
				end if;
			end if;
		 end if;
		 if section = READ then
			if(agent_to_slave_notify_int = '1' and slave_to_agent_notify_int = '0' and agent_to_slave_sync = '1') then
				agent_to_slave_notify_int <= '0';
				slave_to_agent_notify_int <= '1';
			elsif(agent_to_slave_notify_int = '0' and slave_to_agent_notify_int = '1' and slave_to_agent_sync = '1') then
				agent_to_slave_notify_int <= '0';
				slave_to_agent_notify_int <= '0';
				slave_to_agent_resp_signal <= slave_to_agent;
				section <= DONE;
			end if;
		 end if;
		 if section = WRITE then
		 	if(agent_to_slave_notify_int = '1' and slave_to_agent_notify_int = '0' and agent_to_slave_sync = '1') then
				agent_to_slave_notify_int <= '0';
				slave_to_agent_notify_int <= '1';
			elsif(agent_to_slave_notify_int = '0' and slave_to_agent_notify_int = '1' and slave_to_agent_sync = '1') then
				agent_to_slave_notify_int <= '0';
				slave_to_agent_notify_int <= '0';
				slave_to_agent_resp_signal <= slave_to_agent;
				slave_to_agent_resp_signal.data <= 0;
				section <= DONE;
			end if;
		 end if;
		 end if;
	 end if;
	 end process;
end SlaveAgent_arch;
