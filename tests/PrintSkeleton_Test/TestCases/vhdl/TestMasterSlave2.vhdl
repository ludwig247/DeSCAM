library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.TestMasterSlave2_types.all;

entity TestMasterSlave2 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	s_out:		out int
);
end TestMasterSlave2;

architecture TestMasterSlave2_arch of TestMasterSlave2 is
	signal section: TestMasterSlave2_SECTIONS;
	signal val_signal: int;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			section <= SECTION_A;
			val_signal <= to_signed(1337, 32);
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
end TestMasterSlave2_arch;
