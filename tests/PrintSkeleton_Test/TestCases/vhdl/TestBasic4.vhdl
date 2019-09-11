library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.TestBasic4_types.all;

entity TestBasic4 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_out:		out int;
	b_out_sync:		in bool;
	b_out_notify:		out bool
);
end TestBasic4;

architecture TestBasic4_arch of TestBasic4 is
	signal section: TestBasic4_SECTIONS;
	signal nb_result_signal: bool;
	signal var_signal: int;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			section <= run;
			nb_result_signal <= false;
			var_signal <= to_signed(4, 32);
			b_out_notify <= true;
		else
			if section = run then
			 -- FILL OUT HERE;
			end if;
		end if;
	end if;
	end process;
end TestBasic4_arch;
