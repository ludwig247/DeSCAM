library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.TestArray3_types.all;

entity TestArray3 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in int_5;
	b_in_sync:		in bool;
	b_in_notify:		out bool;
	b_out:		out int;
	b_out_sync:		in bool;
	b_out_notify:		out bool
);
end TestArray3;

architecture TestArray3_arch of TestArray3 is
	signal myArray_signal: int_5;
	signal test_signal: int;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			myArray_signal <= (others => to_signed(0, 32));
			test_signal <= to_signed(2, 32);
			b_in_notify <= true;
			b_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestArray3_arch;