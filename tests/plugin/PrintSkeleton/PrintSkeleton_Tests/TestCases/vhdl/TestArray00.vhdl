library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestArray00_types.all;

entity TestArray00 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in signed(31 downto 0);
	b_in_sync:		in bool;
	b_in_notify:		out bool;
	b_out:		out int_2;
	b_out_sync:		in bool;
	b_out_notify:		out bool
);
end TestArray00;

architecture TestArray00_arch of TestArray00 is
	signal myArray_signal: int_2;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			myArray_signal <= (others => to_signed(0, 32));
			b_in_notify <= true;
			b_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestArray00_arch;