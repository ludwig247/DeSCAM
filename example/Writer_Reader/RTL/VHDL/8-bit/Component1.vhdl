library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.Component1_types.all;

entity Component1 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	component1_in_data:		in signed(7 downto 0);
	component1_in_addr:		in signed(7 downto 0);
	component1_in_trans_type:	in trans_t;
	component1_in_sync:		in bool;
	component1_in_notify:		out bool;
	component1_out_data:		out signed(7 downto 0);
	component1_out_addr:		out signed(7 downto 0);
	component1_out_trans_type:	out trans_t;
	component1_out_sync:		in bool;
	component1_out_notify:		out bool
);
end Component1;

architecture Component1_arch of Component1 is
	signal cnt_signal: signed(31 downto 0);

	signal component1_in_notify_sig: bool;
	signal component1_out_notify_sig: bool;
	signal component1_out_running: bool;
	signal component1_in_running: bool;
	signal component1_in: bus_req_t;
	signal component1_out: bus_req_t;
	signal counter1: unsigned(5 downto 0);
begin
	
	component1_in_notify <= component1_in_notify_sig;
	component1_out_notify<= component1_out_notify_sig;

	--FSM
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			cnt_signal <= to_signed(1, 32);
			component1_in_notify_sig <= false;
			component1_out_notify_sig <= true;
			component1_out_running <= false;
			component1_in_running <= false;
			counter1 <= to_unsigned(0,6);
			
		else

			if component1_out_running = false and component1_in_running = false then 
				if(component1_out_notify_sig = true and component1_out_sync = true) then 
					component1_out_running <= true;
					component1_out_notify_sig <= false;
					component1_out_addr <= component1_out.addr(to_integer(counter1)+7 downto to_integer(counter1));
					component1_out_data <= component1_out.data(to_integer(counter1)+7 downto to_integer(counter1));
					counter1 <= to_unsigned(8,6);
				elsif(component1_in_notify_sig = true and component1_in_sync = true) then 
					component1_in_running <= true;
					component1_in_notify_sig <= false;
					counter1 <= to_unsigned(0,6);
				end if;
			else 
				if (counter1 >= 24) then
					counter1 <= to_unsigned(0,6);
					if component1_in_running = true then 
						component1_out_notify_sig <= true;
						component1_in_running <= false;
						cnt_signal <= cnt_signal +1;
						component1_out.data <= cnt_signal +1;
					elsif component1_out_running = true then 
						component1_in_notify_sig <= true;
						component1_out_running <= false;
					end if;
				else 
					counter1 <= counter1 +8;
				end if;
			end if;
		end if;
	end if;
	end process;


	--Communication
	process(clk)
	begin	
	if(clk='1' and clk'event) then
		if rst = '1' then
			component1_out.data <= to_signed(1,32);
			component1_out.addr <= to_signed(8,32);
			component1_out.trans_type <= SINGLE_WRITE;
		else
			if component1_in_running = true then 
				component1_in.addr(to_integer(counter1)+7 downto to_integer(counter1)) <= component1_in_addr;
				component1_in.data(to_integer(counter1)+7 downto to_integer(counter1)) <= component1_in_data;
				component1_in.trans_type <= component1_in_trans_type;
			elsif component1_out_running = true then 
				component1_out_addr <= component1_out.addr(to_integer(counter1)+7 downto to_integer(counter1));
				component1_out_data <= component1_out.data(to_integer(counter1)+7 downto to_integer(counter1));
				component1_out_trans_type <= component1_out.trans_type;
			end if;
		end if;
	end if;
	end process;
end Component1_arch;