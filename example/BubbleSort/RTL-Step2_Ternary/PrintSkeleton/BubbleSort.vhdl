library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.BubbleSort_types.all;

entity BubbleSort is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	data_in:		in int_256;
	data_in_sync:		in bool;
	data_in_notify:		out bool;
	data_out:		out int_256;
	data_out_sync:		in bool;
	data_out_notify:		out bool
);
end BubbleSort;

architecture BubbleSort_arch of BubbleSort is
	signal data_algorithm_signal: int_256;
	signal i_signal: signed(31 downto 0);
	signal j_signal: signed(31 downto 0);
	signal phase_algorithm_signal: phases;

	signal data_in_notify_sig: bool;
	signal data_out_notify_sig: bool;

	constant ARRAY_SIZE : integer := 256;

begin
	
	data_in_notify <= data_in_notify_sig;
	data_out_notify <= data_out_notify_sig;

	process(clk)

		variable swap: int;
		variable data_array: int_256;

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
				
				if(i_signal < ARRAY_SIZE) then 
					
					if(j_signal < ARRAY_SIZE - i_signal - 1) then 

						if(data_algorithm_signal(to_integer(j_signal)) > data_algorithm_signal(to_integer(j_signal) + 1)) then
							data_algorithm_signal(to_integer(j_signal)) <= data_algorithm_signal(to_integer(j_signal) + 1); 
							data_algorithm_signal(to_integer(j_signal) + 1) <= data_algorithm_signal(to_integer(j_signal));
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