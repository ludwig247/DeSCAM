library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestArray06_types.all;

entity TestArray06 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_out:		out unsigned (31 downto 0);
	b_out_sync_d:		in bool;
	b_out_notify_d:		out bool;
	m_in:		in unsigned_4
);
end TestArray06;

architecture TestArray06_arch of TestArray06 is

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			b_out_notify_d <= true;
		else
			if b_out_sync_d = true then
				b_out <= m_in(0);
			end if;
		end if;
	end if;
	end process;
end TestArray06_arch;