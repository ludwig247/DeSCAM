library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestArray00_types.all;

entity TestArray00 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in_d:		in signed(31 downto 0);
	b_in_sync_d:		in bool;
	b_in_notify_d:		out bool;
	b_out_d:		out int_2;
	b_out_sync_d:		in bool;
	b_out_notify_d:		out bool
);
end TestArray00;

architecture TestArray00_arch of TestArray00 is
	type state_t is (IDLE, WRITEVALUE);

	signal myArray_signal_d: int_2;
	signal currentstate: state_t;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			b_in_notify_d <= true;
			b_out_notify_d <= false;
			myArray_signal_d <= (others => to_signed(0, myArray_signal_d(0)'length));
			currentstate <= IDLE;
		else
			case currentstate is
			when IDLE =>
				if b_in_sync_d = true then
					myArray_signal_d(1) <= b_in_d;
					b_out_d(0) <= b_in_d + myArray_signal_d(1);
					b_out_d(1) <= b_in_d;
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
end TestArray00_arch;