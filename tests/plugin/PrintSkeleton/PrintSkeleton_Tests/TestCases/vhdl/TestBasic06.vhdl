library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestBasic06_types.all;

entity TestBasic06 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in signed(31 downto 0);
	b_in_sync:		in bool;
	b_in_notify:		out bool;
	b_in2:		in signed(31 downto 0);
	b_in2_sync:		in bool;
	b_in2_notify:		out bool
);
end TestBasic06;

architecture TestBasic06_arch of TestBasic06 is

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			b_in_notify <= true;
			b_in2_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic06_arch;