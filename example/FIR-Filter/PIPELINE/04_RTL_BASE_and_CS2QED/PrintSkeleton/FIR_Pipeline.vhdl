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

	signal acc_signal_IN: signed(31 downto 0);
	signal acc_signal_C1: signed(31 downto 0);
	signal acc_signal_C2: signed(31 downto 0);
	signal acc_signal_C3: signed(31 downto 0);
	signal acc_signal_OUT: signed(31 downto 0);

	signal valid_IN: bool;
	signal valid_C1: bool;
	signal valid_C2: bool;
	signal valid_C3: bool;
	signal valid_OUT: bool;

	signal coef_signal: signed(31 downto 0);
	signal data_algorithm_signal: signed(31 downto 0);
	signal shiftreg_signal: int_3;

	signal data_in_notify_sig: bool;
	signal data_out_notify_sig: bool;

	constant zeros: std_logic_vector(1 downto 0) := (others => '0');

begin

	data_in_notify <= data_in_notify_sig;
	data_out_notify <= data_out_notify_sig;

	Stage_IN: process(clk)

	begin

		if(clk='1' and clk'event) then

			if rst = '1' then
				acc_signal_IN <= to_signed(0, 32);
				data_algorithm_signal <= to_signed(0, 32);
				shiftreg_signal <= (others => to_signed(0, 32));
				data_in_notify_sig <= true;
				valid_IN <= false;

			elsif (data_in_sync = false) then 
				data_in_notify_sig <= true;
				valid_IN <= false;

			elsif (data_in_sync = true and ((not data_out_notify_sig) or data_out_sync)) then
				--data_in_notify_sig <= false;
				data_algorithm_signal <= data_in;
				acc_signal_IN <= to_signed(0, 32);
				shiftreg_signal(2) <= shiftreg_signal(1);
				shiftreg_signal(1) <= shiftreg_signal(0);
				shiftreg_signal(0) <= data_in;
				valid_IN <= true;
			
			end if;
			
		end if;

	end process Stage_IN;

	Stage_C1: process(clk)

	variable acc_signal_var64_C1: signed(63 downto 0);

	begin

		if(clk='1' and clk'event) then

			if rst = '1' then
				acc_signal_C1 <= to_signed(0, 32);
				valid_C1 <= false;

			elsif (data_in_sync = true and ((not data_out_notify_sig) or data_out_sync)) then --STATE_C1

				acc_signal_var64_C1 := acc_signal_IN + (shiftreg_signal(2) * coef_signal);
				acc_signal_C1 <= acc_signal_var64_C1(31 downto 0);
				valid_C1 <= valid_IN;

			end if;
		end if;

	end process Stage_C1;

	Stage_C2: process(clk)

	variable acc_signal_var64_C2: signed(63 downto 0);

	begin

		if(clk='1' and clk'event) then

			if rst = '1' then
				acc_signal_C2 <= to_signed(0, 32);
				valid_C2 <= false;

			elsif (data_in_sync = true and ((not data_out_notify_sig) or data_out_sync)) then --STATE_C2

				acc_signal_var64_C2 := acc_signal_C1 + (shiftreg_signal(2) * coef_signal);
				acc_signal_C2 <= acc_signal_var64_C2(31 downto 0);
				valid_C2 <= valid_C1;

			end if;
		end if;

	end process Stage_C2;

	Stage_C3: process(clk)

	variable acc_signal_var64_C3: signed(63 downto 0);

	begin

		if(clk='1' and clk'event) then

			if rst = '1' then
				acc_signal_C3 <= to_signed(0, 32);
				coef_signal <= to_signed(1, 32);
				valid_C3 <= false;

			elsif (data_in_sync = true and ((not data_out_notify_sig) or data_out_sync)) then --STATE_C3

				acc_signal_var64_C3 := acc_signal_C2 + (shiftreg_signal(2) * coef_signal);
				acc_signal_C3 <= acc_signal_var64_C3(31 downto 0);

				data_out <= acc_signal_var64_C3(31 downto 0);

				coef_signal <= acc_signal_var64_C3(31 downto 0);

				valid_C3 <= valid_C2;

			end if;
		end if;

	end process Stage_C3;

	Stage_OUT: process(clk)

	begin

		if(clk='1' and clk'event) then

			if rst = '1' then
				data_out_notify_sig <= false;

			elsif(data_in_sync = true and ((not data_out_notify_sig) or data_out_sync)) then	--STATE: DATA_OUT
				data_out_notify_sig <= valid_C3;
				
			else
				data_out_notify_sig <= data_out_notify_sig;
								
			end if;

		end if;

	end process Stage_OUT;


end FIR_Pipeline_arch;