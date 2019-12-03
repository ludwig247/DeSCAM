library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestMasterSlave10_types.all;

entity TestMasterSlave10 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	s_in:		in int;
	s_in_sync:		in bool;
	s_in2:		in int;
	s_in2_sync:		in bool;
	s_out:		out int;
	sharded_in:		in int
);
end TestMasterSlave10;

architecture TestMasterSlave10_arch of TestMasterSlave10 is
	signal nextsection_signal: Sections;
	signal section_signal: Sections;
	signal shared_signal: int;
	signal succ_signal: bool;
	signal val_signal: int;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			nextsection_signal <= SECTION_A;
			section_signal <= SECTION_A;
			shared_signal <= to_signed(0, 32);
			succ_signal <= false;
			val_signal <= to_signed(0, 32);
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestMasterSlave10_arch;