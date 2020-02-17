library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestBasic15_types.all;

entity TestBasic15 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in CompoundType;
	b_in_sync:		in bool;
	b_in_notify:		out bool;
	b_out:		out CompoundType;
	b_out_sync:		in bool;
	b_out_notify:		out bool
);
end TestBasic15;

architecture TestBasic15_arch of TestBasic15 is
	signal nextsection_signal: Sections;
	signal section_signal: Sections;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			nextsection_signal <= SECTION_A;
			section_signal <= SECTION_A;
			b_in_notify <= true;
			b_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic15_arch;