-- @lang=VHDL @ts=8

library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;


entity top is
	port(
		clk           	: 	in 	std_logic;
		rst          	: 	in 	std_logic;
		-- REQUEST FROM MASTER
		master_to_agent:	in bus_req_t;
		master_to_agent_sync:	in std_logic;
		master_to_agent_notify:	out std_logic;
		-- RESPONSE TO MASTER
		agent_to_master:	out bus_resp_t;
		agent_to_master_sync:	in std_logic;
		agent_to_master_notify:	out std_logic;
		-- TO SLAVE 0
		agent_to_slave0:	 out bus_req_t;
		agent_to_slave0_sync:	 in std_logic;
		agent_to_slave0_notify:	 out std_logic;
		-- FROM SLAVE 0 
		slave_to_agent0:	 in bus_resp_t;
		slave_to_agent0_sync:	 in std_logic;
		slave_to_agent0_notify:	 out std_logic;
		-- TO SLAVE 1
		agent_to_slave1:	 out bus_req_t;
		agent_to_slave1_sync:	 in std_logic;
		agent_to_slave1_notify:	 out std_logic;
		-- FROM SLAVE 1 
		slave_to_agent1:	 in bus_resp_t;
		slave_to_agent1_sync:	 in std_logic;
		slave_to_agent1_notify:	 out std_logic;
		-- TO SLAVE 2
		agent_to_slave2:	 out bus_req_t;
		agent_to_slave2_sync:	 in std_logic;
		agent_to_slave2_notify:	 out std_logic;
		-- FROM SLAVE 2 
		slave_to_agent2:	 in bus_resp_t;
		slave_to_agent2_sync:	 in std_logic;
		slave_to_agent2_notify:	 out std_logic;
		-- TO SLAVE 3
		agent_to_slave3:	 out bus_req_t;
		agent_to_slave3_sync:	 in std_logic;
		agent_to_slave3_notify:	 out std_logic;
		-- FROM SLAVE 3 
		slave_to_agent3:	 in bus_resp_t;
		slave_to_agent3_sync:	 in std_logic;
		slave_to_agent3_notify:	 out std_logic);
end top;

architecture RTL of top is


component SlaveAgent is
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
end component;




component MasterAgent is
port(
	clk:		in std_logic;
	rst:		in std_logic;
	agent_to_bus:		out master_signals;
	agent_to_master:		out bus_resp_t;
	agent_to_master_sync:	 in std_logic;
	agent_to_master_notify:	 out std_logic;
	bus_to_agent:		in slave_signals;
	master_to_agent:		in bus_req_t;
	master_to_agent_sync:	 in std_logic;
	master_to_agent_notify:	 out std_logic);
end component;

component Interconnect is
port(
	clk:		in std_logic;
	rst:		in std_logic;
	master_in:		in master_signals;
	master_out:		out slave_signals;
	slave_in0:		in slave_signals;
	slave_in1:		in slave_signals;
	slave_in2:		in slave_signals;
	slave_in3:		in slave_signals;
	slave_out0:		out master_signals;
	slave_out1:		out master_signals;
	slave_out2:		out master_signals;
	slave_out3:		out master_signals);
end component;



signal master_to_bus: master_signals;
signal bus_to_master: slave_signals;
signal slave_0_to_bus:	slave_signals;
signal slave_1_to_bus:	slave_signals;
signal slave_2_to_bus:	slave_signals;
signal slave_3_to_bus:	slave_signals;
signal bus_to_slave_0:	master_signals;
signal bus_to_slave_1:	master_signals;
signal bus_to_slave_2:	master_signals;
signal bus_to_slave_3:	master_signals;


begin
master: MasterAgent port map(clk, rst,
            master_to_bus,
            agent_to_master,
            agent_to_master_sync,
            agent_to_master_notify,
            bus_to_master,
            master_to_agent,
            master_to_agent_sync,
            master_to_agent_notify);

intercon: Interconnect port map(clk,rst,
            master_to_bus,
            bus_to_master,
            slave_0_to_bus,
            slave_1_to_bus,
            slave_2_to_bus,
            slave_3_to_bus,
            bus_to_slave_0,
            bus_to_slave_1,
            bus_to_slave_2,
            bus_to_slave_3);


slave0: SlaveAgent port map(clk,rst,
            slave_0_to_bus,
            agent_to_slave0,
            agent_to_slave0_sync,
            agent_to_slave0_notify,
            bus_to_slave_0,
            slave_to_agent0,
            slave_to_agent0_sync,
            slave_to_agent0_notify);
            
slave1: SlaveAgent port map(clk,rst,
            slave_1_to_bus,
            agent_to_slave1,
            agent_to_slave1_sync,
            agent_to_slave1_notify,
            bus_to_slave_1,
            slave_to_agent1,
            slave_to_agent1_sync,
            slave_to_agent1_notify);
            
slave2: SlaveAgent port map(clk,rst,
            slave_2_to_bus,
            agent_to_slave2,
            agent_to_slave2_sync,
            agent_to_slave2_notify,
            bus_to_slave_2,
            slave_to_agent2,
            slave_to_agent2_sync,
            slave_to_agent2_notify);
            
slave3: SlaveAgent port map(clk,rst,
            slave_3_to_bus,
            agent_to_slave3,
            agent_to_slave3_sync,
            agent_to_slave3_notify,
            bus_to_slave_3,
            slave_to_agent3,
            slave_to_agent3_sync,
            slave_to_agent3_notify);
            
end RTL;
