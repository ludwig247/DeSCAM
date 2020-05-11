library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.BubbleSort_types.all;

entity BubbleSort is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	data_in:		in int_8;
	data_in_sync:		in bool;
	data_in_notify:		out bool;
	data_out:		out int_8;
	data_out_sync:		in bool;
	data_out_notify:		out bool
);
end BubbleSort;

architecture BubbleSort_arch of BubbleSort is
	signal data_algorithm_signal: int_8;
	signal i_signal: int;
	signal j_signal: int;
	signal phase_algorithm_signal: phases;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			data_algorithm_signal <= (others => to_signed(0, 32));
			i_signal <= to_signed(0, 32);
			j_signal <= to_signed(0, 32);
			phase_algorithm_signal <= IDLE;
			data_in_notify <= true;
			data_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end BubbleSort_arch;