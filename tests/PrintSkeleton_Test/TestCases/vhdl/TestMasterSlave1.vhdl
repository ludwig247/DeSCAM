library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestMasterSlave1_types.all;

entity TestMasterSlave1 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	s_out:		out int
);
end TestMasterSlave1;

architecture TestMasterSlave1_arch of TestMasterSlave1 is

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestMasterSlave1_arch;