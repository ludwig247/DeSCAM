library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestGlobal2_types.all;

entity TestGlobal2 is
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
end TestGlobal2;

architecture TestGlobal2_arch of TestGlobal2 is
	signal bar_signal: unsigned (31 downto 0);
	signal list_signal: unsigned_5;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			bar_signal <= to_unsigned(0, 32);
			list_signal <= (others => to_unsigned(0, 32));
			test_in_notify <= true;
			test_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestGlobal2_arch;