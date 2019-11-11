library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.TestBasic12_types.all;

entity TestBasic12 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in CompoundType;
	b_in_sync:		in bool;
	b_in_notify:		out bool;
	m_out:		out int;
	m_out_notify:		out bool
);
end TestBasic12;

architecture TestBasic12_arch of TestBasic12 is
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
			b_in_notify <= true;
			m_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic12_arch;