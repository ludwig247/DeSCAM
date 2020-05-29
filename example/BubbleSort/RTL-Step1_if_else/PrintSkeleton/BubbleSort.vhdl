library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.BubbleSort_types.all;

entity BubbleSort is
port(	
	clk:			in std_logic;
	rst:			in std_logic;
	data_in:		in int_8;
	data_in_sync:		in bool;
	data_in_notify:		out bool;
	data_out:		out int_8;
	data_out_sync:		in bool;
	data_out_notify:	out bool
);
end BubbleSort;

architecture BubbleSort_arch of BubbleSort is
	signal data_algorithm_signal: int_8;
	signal i_signal: int;
	signal j_signal: int;
	signal phase_algorithm_signal: phases;

	signal data_in_notify_sig: bool;
	signal data_out_notify_sig: bool;

	--signal swap: int;

begin

	data_in_notify <= data_in_notify_sig;
	data_out_notify <= data_out_notify_sig;

	process(clk)
		variable swap: int;
		variable data_array: int_8;
	begin

	if(clk='1' and clk'event) then
		if rst = '1' then
			data_algorithm_signal <= (others => to_signed(0, 32));
			i_signal <= to_signed(0, 32);
			j_signal <= to_signed(0, 32);
			phase_algorithm_signal <= IDLE;
			data_in_notify_sig <= true;
			data_out_notify_sig <= false;
		else
			 -- FILL OUT HERE;
			if (phase_algorithm_signal = IDLE and data_in_sync = false) then --STATE: DATA_IN
				data_in_notify_sig <= true;
				data_out_notify_sig <= false;
				--data_algorithm_signal <= (others => to_signed(0, 32));
				phase_algorithm_signal <= IDLE;
				--i_signal <= to_signed(0, 32);
				--j_signal <= to_signed(0, 32);

			elsif (phase_algorithm_signal = IDLE and data_in_sync = true) then
				data_in_notify_sig <= false;
				data_out_notify_sig <= false;
				data_algorithm_signal <= data_in;
				data_array := data_in;
				phase_algorithm_signal <= RUN;
				i_signal <= to_signed(0, 32);


				if(data_array(0) > data_array(1)) then
					swap := data_array(0);
					data_array(0) := data_array(1);
					data_array(1) := swap;
				end if;

				j_signal <= to_signed(1, 32);
				data_algorithm_signal <= data_array;

			elsif (phase_algorithm_signal = RUN and data_out_notify_sig = false) then
				
				if(i_signal < 8) then 
					
					if(j_signal < 8 - i_signal - 1) then 
						
						if(j_signal = 0) then
							if(data_algorithm_signal(0) > data_algorithm_signal(1)) then
								data_algorithm_signal(0) <= data_algorithm_signal(1);
								data_algorithm_signal(1) <= data_algorithm_signal(0);
							end if;

						elsif(j_signal = 1) then
							if(data_algorithm_signal(1) > data_algorithm_signal(2)) then	
								data_algorithm_signal(1) <= data_algorithm_signal(2);
								data_algorithm_signal(2) <= data_algorithm_signal(1);
							end if;

						elsif(j_signal = 2) then
							if(data_algorithm_signal(2) > data_algorithm_signal(3)) then	
								data_algorithm_signal(2) <= data_algorithm_signal(3);
								data_algorithm_signal(3) <= data_algorithm_signal(2);
							end if;

						elsif(j_signal = 3) then
							if(data_algorithm_signal(3) > data_algorithm_signal(4)) then	
								data_algorithm_signal(3) <= data_algorithm_signal(4);
								data_algorithm_signal(4) <= data_algorithm_signal(3);
							end if;

						elsif(j_signal = 4) then
							if(data_algorithm_signal(4) > data_algorithm_signal(5)) then	
								data_algorithm_signal(4) <= data_algorithm_signal(5);
								data_algorithm_signal(5) <= data_algorithm_signal(4);
							end if;

						elsif(j_signal = 5) then
							if(data_algorithm_signal(5) > data_algorithm_signal(6)) then	
								data_algorithm_signal(5) <= data_algorithm_signal(6);
								data_algorithm_signal(6) <= data_algorithm_signal(5);
							end if;

						elsif(j_signal = 6) then
							if(data_algorithm_signal(6) > data_algorithm_signal(7)) then	
								data_algorithm_signal(6) <= data_algorithm_signal(7);
								data_algorithm_signal(7) <= data_algorithm_signal(6);
							end if;
 							
						end if;
						
						j_signal <= j_signal + 1;
						

					else
						i_signal <= i_signal + 1;
						j_signal <= to_signed(0,32);
					end if;

				else 
					data_out_notify_sig <= true;
					data_in_notify_sig <= false;
					data_out <= data_algorithm_signal;
				end if;
			end if;

			if(phase_algorithm_signal = RUN and data_out_notify_sig = true and data_out_sync = false) then	--STATE: DATA_OUT
				data_out_notify_sig <= true;
				data_in_notify_sig <= false;
				
			elsif(phase_algorithm_signal = RUN and data_out_notify_sig = true and data_out_sync = true) then
				data_out_notify_sig <= false;
				data_in_notify_sig <= true;
				phase_algorithm_signal <= IDLE;
								
			end if;
					
		end if;

	end if;

--end if;
	--end if;

	end process;

end BubbleSort_arch;