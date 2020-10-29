library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestBasic27_types.all;

entity TestBasic27 is
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
end TestBasic27;

architecture TestBasic27_arch of TestBasic27 is
	signal data2_signal: signed(31 downto 0);
	signal data3_signal: signed(31 downto 0);

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			data2_signal <= to_signed(0, 32);
			data3_signal <= to_signed(0, 32);
			m_out_1_notify <= false;
			m_out_2_notify <= false;
			m_out_3_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic27_arch;