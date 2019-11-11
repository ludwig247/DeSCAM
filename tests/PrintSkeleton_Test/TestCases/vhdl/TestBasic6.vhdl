library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.TestBasic6_types.all;

entity TestBasic6 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in int;
	b_in_sync:		in bool;
	b_in_notify:		out bool;
	b_in2:		in int;
	b_in2_sync:		in bool;
	b_in2_notify:		out bool
);
end TestBasic6;

architecture TestBasic6_arch of TestBasic6 is
	signal nb_result_signal: bool;
	signal var_signal: int;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			nb_result_signal <= false;
			var_signal <= to_signed(4, 32);
			b_in_notify <= true;
			b_in2_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic6_arch;