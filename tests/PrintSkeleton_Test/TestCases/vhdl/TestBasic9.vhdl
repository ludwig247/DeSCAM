library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.TestBasic9_types.all;

entity TestBasic9 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in int;
	b_in_sync:		in bool;
	b_in_notify:		out bool;
	m_in:		in int
);
end TestBasic9;

architecture TestBasic9_arch of TestBasic9 is
	signal section: TestBasic9_SECTIONS;
	signal nb_result_signal: bool;
	signal var_signal: int;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			section <= run;
			nb_result_signal <= false;
			var_signal <= to_signed(1337, 32);
			b_in_notify <= true;
		else
			if section = run then
			 -- FILL OUT HERE;
			end if;
		end if;
	end if;
	end process;
end TestBasic9_arch;
