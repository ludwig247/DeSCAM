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
	m_in_sync:		in bool;
	m_in_notify:		out bool;
	m_out:		out int_5;
	m_out_sync:		in bool;
	m_out_notify:		out bool
);
end TestArray04;

architecture TestArray04_arch of TestArray04 is
	signal myArray_signal: int_5;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			myArray_signal <= (others => to_signed(0, 32));
			m_in_notify <= true;
			m_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestArray04_arch;