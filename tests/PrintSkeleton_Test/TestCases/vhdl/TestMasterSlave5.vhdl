library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.TestMasterSlave5_types.all;

entity TestMasterSlave5 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	s_in:		in int;
	s_in_sync:		in bool;
	s_in2:		in int;
	s_in2_sync:		in bool;
	s_out:		out int
);
end TestMasterSlave5;

architecture TestMasterSlave5_arch of TestMasterSlave5 is
	signal nextsection_signal: Sections;
	signal section_signal: Sections;
	signal val_signal: int;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			nextsection_signal <= SECTION_A;
			section_signal <= SECTION_A;
			val_signal <= to_signed(1337, 32);
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestMasterSlave5_arch;