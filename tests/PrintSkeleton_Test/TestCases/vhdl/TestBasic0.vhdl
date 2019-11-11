library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.TestBasic0_types.all;

entity TestBasic0 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_out:		out int;
	b_out_sync:		in bool;
	b_out_notify:		out bool
);
end TestBasic0;

architecture TestBasic0_arch of TestBasic0 is
	signal nextsection_signal: Sections;
	signal section_signal: Sections;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			nextsection_signal <= SECTION_A;
			section_signal <= SECTION_A;
			b_out_notify <= true;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic0_arch;