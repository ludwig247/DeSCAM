library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestArray03_types.all;

entity TestArray03 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in int_5;
	b_in_sync_d:		in bool;
	b_in_notify_d:		out bool;
	b_out:		out signed(31 downto 0);
	b_out_sync_d:		in bool;
	b_out_notify_d:		out bool
);
end TestArray03;

architecture TestArray03_arch of TestArray03 is

	type state_t is (IDLE, WRITEVALUE);

	signal currentstate: state_t;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			b_in_notify_d <= true;
			b_out_notify_d <= false;
			currentstate <= IDLE;
		else
			case currentstate is
			when IDLE =>
				if b_in_sync_d = true then
					b_out <= b_in(0) + to_signed(2, b_in(0)'length);
					b_in_notify_d <= false;
					b_out_notify_d <= true;
					currentstate <= WRITEVALUE;
				end if;
			when WRITEVALUE =>
				if b_out_sync_d = true then
					b_in_notify_d <= true;
					b_out_notify_d <= false;
					currentstate <= IDLE;
				end if;
			end case;
		end if;
	end if;
	end process;
end TestArray03_arch;