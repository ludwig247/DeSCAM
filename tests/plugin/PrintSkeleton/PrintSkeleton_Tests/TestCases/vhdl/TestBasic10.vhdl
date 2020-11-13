library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestBasic10_types.all;

entity TestBasic10 is
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
end TestBasic10;

architecture TestBasic10_arch of TestBasic10 is
	signal phase_signal: Phases;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			phase_signal <= SECTION_A;
			b_in_notify <= true;
			b_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic10_arch;