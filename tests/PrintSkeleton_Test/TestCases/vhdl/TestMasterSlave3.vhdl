library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestMasterSlave3_types.all;

entity TestMasterSlave3 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	s_in:		in signed(31 downto 0);
	s_in_sync:		in bool;
	s_out:		out signed(31 downto 0)
);
end TestMasterSlave3;

architecture TestMasterSlave3_arch of TestMasterSlave3 is
	signal section_signal: Sections;
	signal val_signal: signed(31 downto 0);

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			section_signal <= SECTION_A;
			val_signal <= to_signed(1337, 32);
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestMasterSlave3_arch;