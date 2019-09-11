library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
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
	signal section: TestBasic20_SECTIONS;
	signal color_signal: color_t;
	signal compoundType_signal: CompoundType;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			section <= SECTION_A;
			color_signal <= GREEN;
			compoundType_signal.mode <= READ;
			compoundType_signal.x <= to_signed(0, 32);
			compoundType_signal.y <= false;
			b_out_notify <= true;
		else
			if section = SECTION_A then
			 -- FILL OUT HERE;
			end if;
			if section = SECTION_B then
			 -- FILL OUT HERE;
			end if;
		end if;
	end if;
	end process;
end TestBasic20_arch;
