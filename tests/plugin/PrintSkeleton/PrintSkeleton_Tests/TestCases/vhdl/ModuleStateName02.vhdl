library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.ModuleStateName02_types.all;

entity ModuleStateName02 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	m_in:		in signed(31 downto 0);
	m_out:		out signed(31 downto 0);
	m_out_notify:		out bool
);
end ModuleStateName02;

architecture ModuleStateName02_arch of ModuleStateName02 is

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			m_out_notify <= true;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end ModuleStateName02_arch;