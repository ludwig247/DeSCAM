library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.TestBasic1_types.all;

entity TestBasic1 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in int;
	b_in_sync:		in bool;
	b_in_notify:		out bool
);
end TestBasic1;

architecture TestBasic1_arch of TestBasic1 is
	signal nextsection_signal: Sections;
	signal section_signal: Sections;
	signal x_signal: int;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			nextsection_signal <= SECTION_A;
			section_signal <= SECTION_A;
			x_signal <= to_signed(0, 32);
			b_in_notify <= true;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic1_arch;