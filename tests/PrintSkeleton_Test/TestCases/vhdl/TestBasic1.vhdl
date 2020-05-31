library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestBasic1_types.all;

entity TestBasic1 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in signed(31 downto 0);
	b_in_sync:		in bool;
	b_in_notify:		out bool
);
end TestBasic1;

architecture TestBasic1_arch of TestBasic1 is
	signal section_signal: Sections;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			section_signal <= SECTION_A;
			b_in_notify <= true;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic1_arch;