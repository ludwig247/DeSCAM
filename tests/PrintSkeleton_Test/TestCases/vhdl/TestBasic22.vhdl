library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestBasic22_types.all;

entity TestBasic22 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	m_out:		out test_compound;
	m_out_notify:		out bool
);
end TestBasic22;

architecture TestBasic22_arch of TestBasic22 is
	signal section_signal: Sections;
	signal test_signal: test_compound;
	signal test2_signal: unsigned (31 downto 0);

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			section_signal <= SECTION_A;
			test.x_signal <= to_signed(0, 32);
			test.y_signal <= to_unsigned(0, 32);
			test2_signal <= to_unsigned(30, 32);
			m_out_notify <= true;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic22_arch;