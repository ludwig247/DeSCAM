library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestBasic28_types.all;

entity TestBasic28 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	test_in:		in signed(31 downto 0);
	test_in_sync:		in bool;
	test_in_notify:		out bool;
	test_out:		out unsigned (31 downto 0);
	test_out_sync:		in bool;
	test_out_notify:		out bool
);
end TestBasic28;

architecture TestBasic28_arch of TestBasic28 is
	signal bar_signal: unsigned (31 downto 0);

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			bar_signal <= to_unsigned(0, 32);
			test_in_notify <= true;
			test_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic28_arch;