library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestBasic4_types.all;

entity TestBasic4 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_out:		out signed(31 downto 0);
	b_out_sync:		in bool;
	b_out_notify:		out bool
);
end TestBasic4;

architecture TestBasic4_arch of TestBasic4 is
	signal var_signal: signed(31 downto 0);

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			var_signal <= to_signed(4, 32);
			b_out_notify <= true;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic4_arch;