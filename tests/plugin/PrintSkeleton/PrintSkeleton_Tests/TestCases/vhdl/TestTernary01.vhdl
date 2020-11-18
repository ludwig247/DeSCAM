library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestTernary01_types.all;

entity TestTernary01 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	data_in:		in signed(31 downto 0);
	data_in_sync:		in bool;
	data_in_notify:		out bool;
	data_out:		out bool;
	valid_out:		out signed(31 downto 0);
	valid_out_sync:		in bool;
	valid_out_notify:		out bool
);
end TestTernary01;

architecture TestTernary01_arch of TestTernary01 is
	signal valid_signal: bool;
	signal value_in_signal: signed(31 downto 0);

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			valid_signal <= false;
			value_in_signal <= to_signed(0, 32);
			data_in_notify <= true;
			valid_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestTernary01_arch;