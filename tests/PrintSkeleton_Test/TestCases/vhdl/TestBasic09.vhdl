library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestBasic09_types.all;

entity TestBasic09 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in signed(31 downto 0);
	b_in_sync:		in bool;
	b_in_notify:		out bool;
	m_in:		in signed(31 downto 0)
);
end TestBasic09;

architecture TestBasic09_arch of TestBasic09 is

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			b_in_notify <= true;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic09_arch;