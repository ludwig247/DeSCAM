library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestMasterSlave09_types.all;

entity TestMasterSlave09 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	s_in:		in signed(31 downto 0);
	s_in_sync:		in bool;
	sh_out:		out signed(31 downto 0)
);
end TestMasterSlave09;

architecture TestMasterSlave09_arch of TestMasterSlave09 is
	signal phase_signal: Phases;
	signal val_signal: signed(31 downto 0);

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			phase_signal <= SECTION_A;
			val_signal <= to_signed(0, 32);
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestMasterSlave09_arch;