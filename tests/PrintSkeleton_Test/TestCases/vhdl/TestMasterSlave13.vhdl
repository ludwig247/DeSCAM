library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.TestMasterSlave13_types.all;

entity TestMasterSlave13 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	m_in:		in int;
	m_out:		out int;
	m_out_notify:		out bool;
	s_in:		in int;
	s_in_sync:		in bool;
	s_in2:		in int;
	s_in2_sync:		in bool;
	s_out:		out int;
	shared_out:		out int
);
end TestMasterSlave13;

architecture TestMasterSlave13_arch of TestMasterSlave13 is
	signal section: TestMasterSlave13_SECTIONS;
	signal save_val_signal: int;
	signal succ_signal: bool;
	signal val_signal: int;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			section <= SECTION_A;
			save_val_signal <= to_signed(0, 32);
			succ_signal <= false;
			val_signal <= to_signed(0, 32);
			m_out_notify <= false;
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
end TestMasterSlave13_arch;
