library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.Bus_new_types.all;

entity Bus_new is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	master_in:		in bus_req_t;
	master_in_sync:		in bool;
	master_in_notify:		out bool;
	master_out:		out bus_resp_t;
	master_out_sync:		in bool;
	master_out_notify:		out bool;
	slave_in0:		in bus_resp_t;
	slave_in0_sync:		in bool;
	slave_in0_notify:		out bool;
	slave_in1:		in bus_resp_t;
	slave_in1_sync:		in bool;
	slave_in1_notify:		out bool;
	slave_in2:		in bus_resp_t;
	slave_in2_sync:		in bool;
	slave_in2_notify:		out bool;
	slave_in3:		in bus_resp_t;
	slave_in3_sync:		in bool;
	slave_in3_notify:		out bool;
	slave_out0:		out bus_req_t;
	slave_out0_sync:		in bool;
	slave_out0_notify:		out bool;
	slave_out1:		out bus_req_t;
	slave_out1_sync:		in bool;
	slave_out1_notify:		out bool;
	slave_out2:		out bus_req_t;
	slave_out2_sync:		in bool;
	slave_out2_notify:		out bool;
	slave_out3:		out bus_req_t;
	slave_out3_sync:		in bool;
	slave_out3_notify:		out bool
);
end Bus_new;

architecture Bus_new_arch of Bus_new is
	signal req_signal: bus_req_t;
	signal resp_signal: bus_resp_t;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			req_signal.trans_type <= SINGLE_READ;
			resp_signal.ack <= OK;
			resp_signal.data <= to_signed(0, 32);
			master_in_notify <= true;
			master_out_notify <= false;
			slave_in0_notify <= false;
			slave_in1_notify <= false;
			slave_in2_notify <= false;
			slave_in3_notify <= false;
			slave_out0_notify <= false;
			slave_out1_notify <= false;
			slave_out2_notify <= false;
			slave_out3_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end Bus_new_arch;