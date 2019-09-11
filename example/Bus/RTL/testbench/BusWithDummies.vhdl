
library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;


entity BusWithDummies is
	port(
		clk           	: 	in 	std_logic;
		rst          	: 	in 	std_logic
	);
end BusWithDummies;

architecture RTL of BusWithDummies is


function To_Std_Logic(L: bool) return std_logic is
begin
if L then
return('1');
else
return('0');
end if;
end function To_Std_Logic;

function To_Bool(L: std_logic) return bool is
begin
if L='1' then
return true;
else
return false;
end if;
end function To_Bool;

component Bus1 port(
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
end component;


component MasterDummy is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	bus_req:		out bus_req_t;
	bus_req_sync:	 in bool;
	bus_req_notify:	 out bool;
	bus_resp:		in bus_resp_t;
	bus_resp_sync:	 in bool;
	bus_resp_notify:	 out bool);
end component;


component SlaveDummy is
port(
	clk:		in std_logic;
	rst:		in std_logic;
	bus_req:		in bus_req_t;
	bus_req_sync:	 in bool;
	bus_req_notify:	 out bool;
	bus_resp:		out bus_resp_t;
	bus_resp_sync:	 in bool;
	bus_resp_notify:	 out bool);
end component;

signal m_bus_req: bus_req_t;
signal m_bus_req_sync: bool;
signal m_bus_req_notify: bool;
signal m_bus_resp: bus_resp_t;
signal m_bus_resp_sync: bool;
signal m_bus_resp_notify: bool;

signal s0_bus_req: bus_req_t;
signal s0_bus_req_sync: bool;
signal s0_bus_req_notify: bool;
signal s0_bus_resp: bus_resp_t;
signal s0_bus_resp_sync: bool;
signal s0_bus_resp_notify: bool;

signal s1_bus_req: bus_req_t;
signal s1_bus_req_sync: bool;
signal s1_bus_req_notify: bool;
signal s1_bus_resp: bus_resp_t;
signal s1_bus_resp_sync: bool;
signal s1_bus_resp_notify: bool;


signal s2_bus_req: bus_req_t;
signal s2_bus_req_sync: bool;
signal s2_bus_req_notify: bool;
signal s2_bus_resp: bus_resp_t;
signal s2_bus_resp_sync: bool;
signal s2_bus_resp_notify: bool;


signal s3_bus_req: bus_req_t;
signal s3_bus_req_sync: bool;
signal s3_bus_req_notify: bool;
signal s3_bus_resp: bus_resp_t;
signal s3_bus_resp_sync: bool;
signal s3_bus_resp_notify: bool;


signal m_bus_req_sync_logic :std_logic;
signal m_bus_req_notify_logic :std_logic;
signal m_bus_resp_sync_logic :std_logic;
signal m_bus_resp_notify_logic :std_logic;
signal s0_bus_req_sync_logic :std_logic;
signal s0_bus_req_notify_logic :std_logic;
signal s0_bus_resp_sync_logic :std_logic;
signal s0_bus_resp_notify_logic :std_logic;
signal s1_bus_req_sync_logic :std_logic;
signal s1_bus_req_notify_logic :std_logic;
signal s1_bus_resp_sync_logic :std_logic;
signal s1_bus_resp_notify_logic :std_logic;
signal s2_bus_req_sync_logic :std_logic;
signal s2_bus_req_notify_logic :std_logic;
signal s2_bus_resp_sync_logic :std_logic;
signal s2_bus_resp_notify_logic :std_logic;
signal s3_bus_req_sync_logic :std_logic;
signal s3_bus_req_notify_logic :std_logic;
signal s3_bus_resp_sync_logic :std_logic;
signal s3_bus_resp_notify_logic :std_logic;


begin


masterD: MasterDummy port map(clk,rst,
		m_bus_req,
		m_bus_req_sync,
		m_bus_req_notify,
		m_bus_resp,
		m_bus_resp_sync,
		m_bus_resp_notify
		);


slave0: SlaveDummy port map(clk,rst,
                s0_bus_req,
                s0_bus_req_sync,
                s0_bus_req_notify,
                s0_bus_resp,
                s0_bus_resp_sync,
                s0_bus_resp_notify);


slave1: SlaveDummy port map(clk,rst,
                s1_bus_req,
                s1_bus_req_sync,
                s1_bus_req_notify,
                s1_bus_resp,
                s1_bus_resp_sync,
                s1_bus_resp_notify);         
                

slave2: SlaveDummy port map(clk,rst,
                s2_bus_req,
                s2_bus_req_sync,
                s2_bus_req_notify,
                s2_bus_resp,
                s2_bus_resp_sync,
                s2_bus_resp_notify);                    


slave3: SlaveDummy port map(clk,rst,
                s3_bus_req,
                s3_bus_req_sync,
                s3_bus_req_notify,
                s3_bus_resp,
                s3_bus_resp_sync,
                s3_bus_resp_notify);


--Master
m_bus_req_sync <= To_Bool(m_bus_req_sync_logic);
m_bus_req_notify_logic <= To_Std_Logic(m_bus_req_notify);

m_bus_resp_sync <= To_Bool(m_bus_resp_sync_logic);
m_bus_resp_notify_logic <= To_Std_Logic(m_bus_resp_notify);

--Slave 0
s0_bus_req_sync <= To_Bool(s0_bus_req_sync_logic);
s0_bus_req_notify_logic <= To_Std_Logic(s0_bus_req_notify);
s0_bus_resp_sync <= To_Bool(s0_bus_resp_sync_logic);
s0_bus_resp_notify_logic <= To_Std_Logic(s0_bus_resp_notify);

--Slave 1
s1_bus_req_sync <= To_Bool(s1_bus_req_sync_logic);
s1_bus_req_notify_logic <= To_Std_Logic(s1_bus_req_notify);
s1_bus_resp_sync <= To_Bool(s1_bus_resp_sync_logic);
s1_bus_resp_notify_logic <= To_Std_Logic(s1_bus_resp_notify);

--Slave 2
s2_bus_req_sync <= To_Bool(s2_bus_req_sync_logic);
s2_bus_req_notify_logic <= To_Std_Logic(s2_bus_req_notify);
s2_bus_resp_sync <= To_Bool(s2_bus_resp_sync_logic);
s2_bus_resp_notify_logic <= To_Std_Logic(s2_bus_resp_notify);

--Slave 3
s3_bus_req_sync <= To_Bool(s3_bus_req_sync_logic);
s3_bus_req_notify_logic <= To_Std_Logic(s3_bus_req_notify);
s3_bus_resp_sync <= To_Bool(s3_bus_resp_sync_logic);
s3_bus_resp_notify_logic <= To_Std_Logic(s3_bus_resp_notify);

bus_full: Bus1 port map(clk,rst,
		m_bus_req,
		m_bus_req_notify_logic,
		m_bus_req_sync_logic,
		m_bus_resp,
		m_bus_resp_notify_logic,
		m_bus_resp_sync_logic,
		s0_bus_resp,
    s0_bus_resp_notify_logic,
    s0_bus_resp_sync_logic,
    s1_bus_resp,
    s1_bus_resp_notify_logic,
    s1_bus_resp_sync_logic,
    s2_bus_resp,
    s2_bus_resp_notify_logic,
    s2_bus_resp_sync_logic,
    s3_bus_resp,
    s3_bus_resp_notify_logic,
    s3_bus_resp_sync_logic,
		s0_bus_req,
		s0_bus_req_notify_logic,
		s0_bus_req_sync_logic,
		s1_bus_req,
		s1_bus_req_notify_logic,
		s1_bus_req_sync_logic,
		s2_bus_req,
		s2_bus_req_notify_logic,
		s2_bus_req_sync_logic,
		s3_bus_req,
		s3_bus_req_notify_logic,
		s3_bus_req_sync_logic
);


end rtl;

