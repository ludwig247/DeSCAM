library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestMasterSlave06_types.all;

entity TestMasterSlave06 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	s_in:		in signed(31 downto 0);
	s_in_sync:		in bool
);
end TestMasterSlave06;

architecture TestMasterSlave06_arch of TestMasterSlave06 is
	signal phase_signal: Phases;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			phase_signal <= SECTION_A;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestMasterSlave06_arch;