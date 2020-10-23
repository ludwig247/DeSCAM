library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestMasterSlave11_types.all;

entity TestMasterSlave11 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	s_in:		in signed(31 downto 0);
	s_in_sync:		in bool;
	sh_in:		in bool;
	sh_out:		out signed(31 downto 0)
);
end TestMasterSlave11;

architecture TestMasterSlave11_arch of TestMasterSlave11 is
	signal nextphase_signal: Phases;
	signal phase_signal: Phases;
	signal val_signal: signed(31 downto 0);

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			nextphase_signal <= SECTION_A;
			phase_signal <= SECTION_A;
			val_signal <= to_signed(0, 32);
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestMasterSlave11_arch;