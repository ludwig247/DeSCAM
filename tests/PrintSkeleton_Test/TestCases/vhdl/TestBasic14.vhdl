library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestBasic14_types.all;

entity TestBasic14 is
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
end TestBasic14;

architecture TestBasic14_arch of TestBasic14 is
	signal nextphase_signal: Phases;
	signal phase_signal: Phases;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			nextphase_signal <= SECTION_A;
			phase_signal <= SECTION_A;
			b_in_notify <= true;
			b_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic14_arch;