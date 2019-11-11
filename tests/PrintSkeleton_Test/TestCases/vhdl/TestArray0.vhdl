library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
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
	signal test_signal: int;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			myArray_signal <= (others => to_signed(0, 32));
			test_signal <= to_signed(0, 32);
			b_in_notify <= true;
			b_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestArray0_arch;