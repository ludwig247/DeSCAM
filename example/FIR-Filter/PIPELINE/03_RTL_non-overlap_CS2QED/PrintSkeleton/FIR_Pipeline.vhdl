library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.FIR_types.all;

entity FIR_Pipeline is
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
end FIR_Pipeline;

architecture FIR_Pipeline_arch of FIR_Pipeline is
	signal acc_signal: signed(31 downto 0);
	signal coef_signal: int_3;
	signal data_algorithm_signal: signed(31 downto 0);
	signal phase_algorithm_signal: phases;
	signal shiftreg_signal: int_3;

	signal data_in_notify_sig: bool;
	signal data_out_notify_sig: bool;

begin

	data_in_notify <= data_in_notify_sig;
	data_out_notify <= data_out_notify_sig;

	process(clk)

	variable acc_signal_var64: signed(63 downto 0);
	variable acc_signal_var: signed(31 downto 0);

	begin

	if(clk='1' and clk'event) then
		if rst = '1' then
			acc_signal <= to_signed(0, 32);
			coef_signal <= (others => to_signed(1, 32));
			data_algorithm_signal <= to_signed(0, 32);
			shiftreg_signal <= (others => to_signed(0, 32));
			phase_algorithm_signal <= IDLE;
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
				phase_algorithm_signal <= RUN_C1;

				shiftreg_signal(2) <= shiftreg_signal(1);
				shiftreg_signal(1) <= shiftreg_signal(0);
				shiftreg_signal(0) <= data_in;

			elsif (phase_algorithm_signal = RUN_C1 and data_out_notify_sig = false) then --STATE_C1

				acc_signal_var64 := acc_signal + (shiftreg_signal(2) * coef_signal(2));
				acc_signal <= acc_signal_var64(31 downto 0);
				phase_algorithm_signal <= RUN_C2;

			elsif (phase_algorithm_signal = RUN_C2 and data_out_notify_sig = false) then --STATE_C2

				acc_signal_var64 := acc_signal + (shiftreg_signal(1) * coef_signal(1));
				acc_signal <= acc_signal_var64(31 downto 0);
				phase_algorithm_signal <= RUN_C3;

			elsif (phase_algorithm_signal = RUN_C3 and data_out_notify_sig = false) then --STATE_C3

				acc_signal_var64 := acc_signal + (shiftreg_signal(0) * coef_signal(0));
				acc_signal <= acc_signal_var64(31 downto 0);

				data_out <= acc_signal_var64(31 downto 0);

				coef_signal(2) <= coef_signal(1);
				coef_signal(1) <= coef_signal(0);
				coef_signal(0) <= acc_signal_var64(31 downto 0);

				data_out_notify_sig <= true;
				data_in_notify_sig <= false;
				phase_algorithm_signal <= RUN_OUT;

			end if;


			if(phase_algorithm_signal = RUN_OUT and data_out_notify_sig = true and data_out_sync = false) then	--STATE: DATA_OUT
				data_out_notify_sig <= true;
				data_in_notify_sig <= false;
				
			elsif(phase_algorithm_signal = RUN_OUT and data_out_notify_sig = true and data_out_sync = true) then
				data_out_notify_sig <= false;
				data_in_notify_sig <= true;
				phase_algorithm_signal <= IDLE;
								
			end if;

		end if;
	end if;

	end process;
end FIR_Pipeline_arch;