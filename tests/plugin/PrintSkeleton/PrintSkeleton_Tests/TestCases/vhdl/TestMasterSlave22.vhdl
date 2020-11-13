library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestMasterSlave22_types.all;

entity TestMasterSlave22 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	s_in_1:		in signed(31 downto 0);
	s_in_1_sync:		in bool;
	s_in_2:		in signed(31 downto 0);
	s_in_2_sync:		in bool;
	s_in_3:		in signed(31 downto 0);
	s_in_3_sync:		in bool
);
end TestMasterSlave22;

architecture TestMasterSlave22_arch of TestMasterSlave22 is

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
end TestMasterSlave22_arch;