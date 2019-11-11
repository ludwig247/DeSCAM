library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.TestMasterSlave11_types.all;

entity TestMasterSlave11 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	s_in:		in int;
	s_in_sync:		in bool;
	s_out:		out int;
	shared_in:		in bool
);
end TestMasterSlave11;

architecture TestMasterSlave11_arch of TestMasterSlave11 is
	signal nextsection_signal: Sections;
	signal section_signal: Sections;
	signal succ_signal: bool;
	signal val_signal: int;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			nextsection_signal <= SECTION_A;
			section_signal <= SECTION_A;
			succ_signal <= false;
			val_signal <= to_signed(0, 32);
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestMasterSlave11_arch;