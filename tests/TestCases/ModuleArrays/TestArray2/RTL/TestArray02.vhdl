library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestArray02_types.all;

entity TestArray02 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in signed(31 downto 0);
	b_in_sync_d:		in bool;
	b_in_notify_d:		out bool;
	b_out:		out signed(31 downto 0);
	b_out_sync_d:		in bool;
	b_out_notify_d:		out bool
);
end TestArray02;

architecture TestArray02_arch of TestArray02 is

	type state_t is (IDLE, WRITEVALUE);

	signal myArray_signal: int_5;
	signal currentstate: state_t;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			myArray_signal <= (others => to_signed(0, 32));
			b_in_notify_d <= true;
			b_out_notify_d <= false;
			currentstate <= IDLE;
		else
			case currentstate is
			when IDLE =>
				if b_in_sync_d = true then
					if b_in >= to_signed(0, b_in'length) and b_in < to_signed(5, b_in'length) then
						myArray_signal(0) <= myArray_signal(to_integer(b_in));
						b_out <= myArray_signal(to_integer(b_in));
					else
						b_out <= myArray_signal(0);
					end if;
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
end TestArray02_arch;