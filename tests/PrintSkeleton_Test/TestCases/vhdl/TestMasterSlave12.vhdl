library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.TestMasterSlave12_types.all;

entity TestMasterSlave12 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	s_in:		in int;
	s_in_sync:		in bool;
	s_in2:		in int;
	s_in2_sync:		in bool;
	s_out:		out int
);
end TestMasterSlave12;

architecture TestMasterSlave12_arch of TestMasterSlave12 is
	signal section: TestMasterSlave12_SECTIONS;
	signal succ_signal: bool;
	signal val_signal: int;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			section <= SECTION_A;
			succ_signal <= false;
			val_signal <= to_signed(0, 32);
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
end TestMasterSlave12_arch;
