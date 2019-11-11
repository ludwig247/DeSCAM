library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.TestBasic7_types.all;

entity TestBasic7 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in int;
	b_in_sync:		in bool;
	b_in_notify:		out bool;
	m_out:		out int;
	m_out_notify:		out bool
);
end TestBasic7;

architecture TestBasic7_arch of TestBasic7 is
	signal nb_result_signal: bool;
	signal var_signal: int;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			nb_result_signal <= false;
			var_signal <= to_signed(1337, 32);
			b_in_notify <= true;
			m_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic7_arch;