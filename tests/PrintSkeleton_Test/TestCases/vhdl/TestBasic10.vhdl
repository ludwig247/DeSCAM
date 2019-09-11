library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
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
	signal section: TestBasic10_SECTIONS;
	signal compoundType_signal: CompoundType;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			section <= SECTION_A;
			compoundType_signal.mode <= READ;
			compoundType_signal.x <= to_signed(0, 32);
			compoundType_signal.y <= false;
			b_in_notify <= true;
			b_out_notify <= false;
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
end TestBasic10_arch;