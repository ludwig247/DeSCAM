library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.FIR_types.all;

entity FIR is
port(	
	clk:			in std_logic;
	rst:			in std_logic;
	data_in:		in signed(31 downto 0);
	data_in_sync:		in bool;
	data_in_notify:		out bool;
	data_out:		out signed(31 downto 0);
	data_out_sync:		in bool;
	data_out_notify:	out bool
);
end FIR;

architecture FIR_arch of FIR is
	signal acc_signal: signed(31 downto 0);
	signal coef_signal: int_3;
	signal data_algorithm_signal: signed(31 downto 0);
	signal i_signal: signed(31 downto 0);
	signal phase_algorithm_signal: phases;
	signal shiftreg_signal: int_3;

	signal data_in_notify_sig: bool;
	signal data_out_notify_sig: bool;
 
begin

	data_in_notify <= data_in_notify_sig;
	data_out_notify <= data_out_notify_sig;

	process(clk)

	begin

	if(clk='1' and clk'event) then
		if rst = '1' then
			acc_signal <= to_signed(0, 32);
			coef_signal <= (others => to_signed(1, 32));
			data_algorithm_signal <= to_signed(0, 32);
			i_signal <= to_signed(2, 32);
			phase_algorithm_signal <= IDLE;
			shiftreg_signal <= (others => to_signed(0, 32));
			data_in_notify_sig <= true;
			data_out_notify_sig <= false;
		else
			 -- FILL OUT HERE;
			if (phase_algorithm_signal = IDLE and data_in_sync = false) then --STATE: DATA_IN
				data_in_notify_sig <= true;
				data_out_notify_sig <= false;
				phase_algorithm_signal <= IDLE;

			elsif (phase_algorithm_signal = IDLE and data_in_sync = true) then
				data_in_notify_sig <= false;
				data_out_notify_sig <= false;
				data_algorithm_signal <= data_in;
				acc_signal <= to_signed(0, 32);
				phase_algorithm_signal <= RUN;
				i_signal <= to_signed(2, 32);

				--shiftreg_signal(2) <= shiftreg_signal(1);
				--acc_signal <= acc_signal + resize(shiftreg_signal(2) * coef_signal(2), acc_signal'length);

				--i_signal <= to_signed(1,32);--i_signal - 1;

			elsif (phase_algorithm_signal = RUN and data_out_notify_sig = false) then

				if (i_signal >= 0) then
			
					if (i_signal = 2) then

						shiftreg_signal(2) <= shiftreg_signal(1);
						acc_signal <= acc_signal + resize(shiftreg_signal(1) * coef_signal(2), acc_signal'length);
					
					elsif (i_signal = 1) then

						shiftreg_signal(1) <= shiftreg_signal(0);
						acc_signal <= acc_signal + resize(shiftreg_signal(0) * coef_signal(1), acc_signal'length);

					elsif (i_signal = 0) then

						acc_signal <= acc_signal + resize(data_algorithm_signal * coef_signal(0), acc_signal'length);
						shiftreg_signal(0) <= data_algorithm_signal;
					
					end if;

				i_signal <= i_signal - 1;

				else	
					data_out_notify_sig <= true;
					data_in_notify_sig <= false;
					data_out <= acc_signal;

				end if;

			end if;


			if(phase_algorithm_signal = RUN and data_out_notify_sig = true and data_out_sync = false) then	--STATE: DATA_OUT
				data_out_notify_sig <= true;
				data_in_notify_sig <= false;
				
			elsif(phase_algorithm_signal = RUN and data_out_notify_sig = true and data_out_sync = true) then
				data_out_notify_sig <= false;
				data_in_notify_sig <= true;
				phase_algorithm_signal <= IDLE;
				--i_signal <= to_signed(2,32);
								
			end if;

		end if;
	end if;

	end process;
end FIR_arch;