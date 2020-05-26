library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.Component2_types.all;

entity Component2 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	--extra ports for compound types
	component2_in_data:		in signed(7 downto 0);
	component2_in_addr:		in signed(7 downto 0);
	component2_in_trans_type:	in trans_t;
	component2_in_sync:		in bool;
	component2_in_notify:		out bool;
	--extra ports for compound types
	component2_out_data:		out signed(7 downto 0);
	component2_out_addr:		out signed(7 downto 0);
	component2_out_trans_type:	out trans_t;
	component2_out_sync:		in bool;
	component2_out_notify:		out bool
);
end Component2;

architecture Component2_arch of Component2 is
	signal component2_in_notify_sig: bool;
	signal component2_out_notify_sig: bool;
	signal component2_out_running: bool;
	signal component2_in_running: bool;
	signal component2_in_running_help : bool;
	--internal compound register
	signal component2_in: bus_req_t;
	signal component2_out: bus_req_t;
	--counter
	signal counter2: unsigned(5 downto 0);

begin
	--Help Signals to be able to read
	component2_in_notify <= component2_in_notify_sig;
	component2_out_notify <= component2_out_notify_sig;

	--FSM
	FSM: process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			component2_in_notify_sig <= true;
			component2_out_notify_sig <= false;
			component2_out_running <= false;
			component2_in_running <= false;
			component2_in_running_help <= false;
			counter2 <= to_unsigned(0,6);
		else
			if component2_out_running = false and component2_in_running = false and component2_in_running_help = false then 
				if(component2_in_notify_sig = true and component2_in_sync = true) then
					component2_in_running_help <= true;
					component2_in_notify_sig <= false;
					counter2 <= to_unsigned(0,6);

				elsif(component2_out_notify_sig = true and component2_out_sync = true) then
					component2_out_running <= true;
					component2_out_notify_sig <= false;
					counter2 <= to_unsigned(0,6);
				end if;
			elsif component2_in_running_help = true then 
				component2_in_running <= true;
				component2_in_running_help <= false;
			else
				if (counter2 >= 24) then
					counter2 <= to_unsigned(0,6);
					if component2_out_running = true then 
						component2_in_notify_sig <= true;
						component2_out_running <= false;
					elsif component2_in_running = true then 
						component2_out_notify_sig <= true;
						component2_in_running <= false;
						component2_out <= component2_in;
					end if;
				else 
					counter2 <= counter2 +8;
				end if;
			end if;
		end if;
	end if;
	end process;

	--Communication
	comm_in: process(clk)
	begin
	if(clk='1' and clk'event) then

		if rst = '1' then
			component2_in.data <= to_signed(0,32);
			component2_in.addr <= to_signed(0,32);
		else
			if(component2_in_running = true) then 
				component2_in.addr(to_integer(counter2)+7 downto to_integer(counter2)) <= component2_in_addr;
				component2_in.data(to_integer(counter2)+7 downto to_integer(counter2)) <= component2_in_data;
				component2_in.trans_type <= component2_in_trans_type;
			end if;
		end if;
	end if;
	end process;

	comm_out: process(clk)
	begin
	if(clk='1' and clk'event) then

		if rst = '1' then
			component2_out_addr <= to_signed(0,8);
			component2_out_data <= to_signed(0,8);
		else
			if(component2_out_running = true) then 
				component2_out_addr <= component2_out.addr(to_integer(counter2)+7 downto to_integer(counter2));
				component2_out_data <= component2_out.data(to_integer(counter2)+7 downto to_integer(counter2));
				component2_out_trans_type <= component2_out.trans_type;
			end if;
		end if;
	end if;

	end process;

end Component2_arch;