library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.TestArray5_types.all;

entity TestArray5 is
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
end TestArray5;

architecture TestArray5_arch of TestArray5 is
	signal myArray_signal: int_2;
	signal succ_signal: bool;
	signal test_signal: int;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			myArray_signal <= (others => to_signed(0, 32));
			succ_signal <= false;
			test_signal <= to_signed(0, 32);
			b_in_notify <= true;
			b_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestArray5_arch;