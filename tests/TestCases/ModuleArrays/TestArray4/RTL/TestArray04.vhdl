library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestArray04_types.all;

entity TestArray04 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	m_in:		in signed(31 downto 0);
	m_in_sync_d:		in bool;
	m_in_notify_d:		out bool;
	m_out:		out int_5;
	m_out_sync_d:		in bool;
	m_out_notify_d:		out bool
);
end TestArray04;

architecture TestArray04_arch of TestArray04 is

	type state_t is (IDLE, WRITEVALUE);

	signal myArray_signal: int_5;
	signal currentstate: state_t;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			m_in_notify_d <= true;
			m_out_notify_d <= false;
			m_out <= (others => to_signed(0, m_out(0)'length));
			myArray_signal <= (others => to_signed(0, myArray_signal(0)'length));
			currentstate <= IDLE;
		else
			case currentstate is
			when IDLE =>
				if m_in_sync_d = true then
					myArray_signal(0) <= m_in;
					m_out(0) <= m_in;
					m_in_notify_d <= false;
					m_out_notify_d <= true;
					currentstate <= WRITEVALUE;
				end if;
			when WRITEVALUE =>
				if m_out_sync_d = true then
					m_in_notify_d <= true;
					m_out_notify_d <= false;
					currentstate <= IDLE;
				end if;
			end case;
		end if;
	end if;
	end process;
end TestArray04_arch;