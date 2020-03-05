library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestArray0_types.all;

entity TestArray0 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in int;
	b_in_sync:		in bool;
	b_in_notify:		out bool;
	b_out:		out int_2;
	b_out_sync:		in bool;
	b_out_notify:		out bool
);
end TestArray0;

architecture TestArray0_arch of TestArray0 is
	signal myArray_signal: int_2;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			b_in_notify <= true;
			b_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestArray0_arch;