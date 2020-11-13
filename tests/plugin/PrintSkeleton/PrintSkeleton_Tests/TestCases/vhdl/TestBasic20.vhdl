library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestBasic20_types.all;

entity TestBasic20 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_out:		out CompoundType;
	b_out_sync:		in bool;
	b_out_notify:		out bool;
	m_in:		in CompoundType
);
end TestBasic20;

architecture TestBasic20_arch of TestBasic20 is
	signal phase_signal: Phases;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			phase_signal <= SECTION_A;
			b_out_notify <= true;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic20_arch;