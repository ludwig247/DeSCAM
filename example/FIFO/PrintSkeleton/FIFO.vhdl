library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.FIFO_types.all;

entity FIFO is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	consumer:		out int;
	consumer_sync:		in bool;
	consumer_notify:		out bool;
	producer:		in int;
	producer_sync:		in bool;
	producer_notify:		out bool
);
end FIFO;

architecture FIFO_arch of FIFO is
	signal section: FIFO_SECTIONS;
	signal buffer_signal: int_3;
	signal can_read_signal: bool;
	signal can_write_signal: bool;
	signal from_reset_signal: bool;
	signal head_signal: unsigned (31 downto 0);
	signal is_empty_signal: bool;
	signal is_full_signal: bool;
	signal tail_signal: unsigned (31 downto 0);
	signal value_in_signal: int;
	signal value_out_signal: int;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			section <= run;
			buffer_signal <= (others <= to_signed(0, 32));
			can_read_signal <= false;
			can_write_signal <= false;
			from_reset_signal <= false;
			head_signal <= to_unsigned(0, 32);
			is_empty_signal <= true;
			is_full_signal <= false;
			tail_signal <= to_unsigned(0, 32);
			value_in_signal <= to_signed(0, 32);
			value_out_signal <= to_signed(0, 32);
			consumer_notify <= false;
			producer_notify <= false;
		else
			if section = idle then
				if (producer_sync = true and consumer_sync = true and is_full_signal = false and is_empty_signal = false) then
					producer_notify <= true;
					buffer_signal(tail_signal) <= producer_in;
					tail_signal <= (tail_signal + 1) mod 5;
					consumer_notify <= true;
					consumer_out <= buffer_signal(head_signal);
					head_signal <= (head_signal + 1) mod 5;
					section <= read_write;

				elsif (producer_sync = true and consumer_sync = false and is_full_signal = false)  then
					producer_notify <= true;
					buffer_signal(tail_signal) <= producer_in;
					tail_signal <= (tail_signal + 1) mod 5;
					section <= read;

				elsif (producer_sync = false and consumer_sync = true and is_empty = false) then
					consumer_notify <= true;
					consumer_out <= buffer_signal(head_signal);
					head_signal <= (head_signal + 1) mod 5;
					section <= write;
				end if;

			elsif section = read_write then
				producer_notify <= false;
				consumer_notify <= false;
				section <= idle;

			elsif section = read then
				producer_notify <= false;
				if (tail_signal == head_signal and not is_empty_signal) then
					is_full_signal <= true;
				else
					is_empty <= false;
				end if;
				section <= idle;

			elsif section = write then
				consumer_notify <= false;
				if (tail_signal == head_signal and not is_full_signal) then
					is_empty_signal <= true;
				else
					is_full_signal <= false;				
				end if;
				section <= idle;
			end if;
		end if;
	end if;
	end process;
end FIFO_arch;
