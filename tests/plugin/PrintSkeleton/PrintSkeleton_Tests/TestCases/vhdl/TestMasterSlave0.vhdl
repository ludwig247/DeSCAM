library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestMasterSlave0_types.all;

entity TestMasterSlave0 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	s_in:		in signed(31 downto 0);
	s_in_sync:		in bool
);
end TestMasterSlave0;

architecture TestMasterSlave0_arch of TestMasterSlave0 is
	signal section_signal: Sections;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			section_signal <= SECTION_A;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestMasterSlave0_arch;