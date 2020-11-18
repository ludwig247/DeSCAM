library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestArray05_types.all;

entity TestArray05 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in signed(31 downto 0);
	b_in_sync_d:		in bool;
	b_in_notify_d:		out bool;
	b_out:		out int_2;
	b_out_sync_d:		in bool;
	b_out_notify_d:		out bool
);
end TestArray05;

architecture TestArray05_arch of TestArray05 is

	type state_t is (IDLE, WRITEVALUE);

	signal myArray_signal: int_2;
	signal test_signal: signed(31 downto 0);
	signal currentstate: state_t;

begin
	process(clk)
		variable tmparray: int_2;
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			myArray_signal <= (others => to_signed(0, myArray_signal(0)'length));
			test_signal <= to_signed(0, 32);
			b_in_notify_d <= true;
			b_out_notify_d <= false;
			currentstate <= IDLE;
		else
			case currentstate is
			when IDLE =>
				if b_in_sync_d = true then
					test_signal <= b_in;
					tmparray(0) := b_in + myArray_signal(1);
					tmparray(1) := b_in;
				else
					tmparray(0) := test_signal + myArray_signal(1);
					tmparray(1) := test_signal;
				end if;
				myArray_signal <= tmparray;
				b_out <= tmparray;
				b_in_notify_d <= false;
				b_out_notify_d <= true;
				currentstate <= WRITEVALUE;
			when WRITEVALUE =>
				if b_out_sync_d = true then
					myArray_signal(1) <= myArray_signal(1) + to_signed(1, myArray_signal(1)'length);
				end if;
				b_in_notify_d <= true;
				b_out_notify_d <= false;
				currentstate <= IDLE;
			end case;
		end if;
	end if;
	end process;
end TestArray05_arch;