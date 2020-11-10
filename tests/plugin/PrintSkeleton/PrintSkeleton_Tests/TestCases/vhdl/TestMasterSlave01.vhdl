library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestMasterSlave01_types.all;

entity TestMasterSlave01 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	s_out:		out signed(31 downto 0)
);
end TestMasterSlave01;

architecture TestMasterSlave01_arch of TestMasterSlave01 is
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
end TestMasterSlave01_arch;