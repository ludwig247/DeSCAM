library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.TestFunction0_types.all;

entity TestFunction0 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in int;
	b_in_sync:		in bool;
	b_in_notify:		out bool;
	b_out:		out unsigned (31 downto 0);
	b_out_sync:		in bool;
	b_out_notify:		out bool
);
end TestFunction0;

architecture TestFunction0_arch of TestFunction0 is
	signal x_signal: int;
	signal y_signal: unsigned (31 downto 0);

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			x_signal <= to_signed(0, 32);
			y_signal <= to_unsigned(0, 32);
			b_in_notify <= true;
			b_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestFunction0_arch;