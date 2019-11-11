library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.TestBasic19_types.all;

entity TestBasic19 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_out:		out CompoundType;
	b_out_sync:		in bool;
	b_out_notify:		out bool;
	m_in:		in CompoundType
);
end TestBasic19;

architecture TestBasic19_arch of TestBasic19 is
	signal compoundType_signal: CompoundType;
	signal nextsection_signal: Sections;
	signal section_signal: Sections;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			compoundType_signal.mode <= READ;
			compoundType_signal.x <= to_signed(0, 32);
			compoundType_signal.y <= false;
			nextsection_signal <= SECTION_A;
			section_signal <= SECTION_A;
			b_out_notify <= true;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic19_arch;