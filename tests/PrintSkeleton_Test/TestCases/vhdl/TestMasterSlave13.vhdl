library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestMasterSlave13_types.all;

entity TestMasterSlave13 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	m_in:		in signed(31 downto 0);
	m_out:		out signed(31 downto 0);
	m_out_notify:		out bool;
	s_in:		in signed(31 downto 0);
	s_in_sync:		in bool;
	s_in2:		in signed(31 downto 0);
	s_in2_sync:		in bool;
	sh_out:		out signed(31 downto 0);
	sh_out2:		out signed(31 downto 0)
);
end TestMasterSlave13;

architecture TestMasterSlave13_arch of TestMasterSlave13 is
	signal nextphase_signal: Phases;
	signal phase_signal: Phases;
	signal save_val_signal: signed(31 downto 0);
	signal succ_signal: bool;
	signal val_signal: signed(31 downto 0);

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			nextphase_signal <= SECTION_A;
			phase_signal <= SECTION_A;
			save_val_signal <= to_signed(0, 32);
			succ_signal <= false;
			val_signal <= to_signed(0, 32);
			m_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestMasterSlave13_arch;