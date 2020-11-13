library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestBasic26_types.all;

entity TestBasic26 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	m_in_1:		in signed(31 downto 0);
	m_in_2:		in signed(31 downto 0);
	m_in_3:		in signed(31 downto 0);
	m_out_1:		out signed(31 downto 0);
	m_out_1_notify:		out bool;
	m_out_2:		out signed(31 downto 0);
	m_out_2_notify:		out bool;
	m_out_3:		out signed(31 downto 0);
	m_out_3_notify:		out bool
);
end TestBasic26;

architecture TestBasic26_arch of TestBasic26 is

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			m_out_1_notify <= false;
			m_out_2_notify <= false;
			m_out_3_notify <= true;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic26_arch;