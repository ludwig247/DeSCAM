library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.ModuleStateName03_types.all;

entity ModuleStateName03 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	m_in:		in signed(31 downto 0);
	m_out:		out signed(31 downto 0);
	m_out_notify:		out bool;
	s_in:		in signed(31 downto 0);
	s_in_sync:		in bool;
	s_out:		out signed(31 downto 0)
);
end ModuleStateName03;

architecture ModuleStateName03_arch of ModuleStateName03 is

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			m_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end ModuleStateName03_arch;