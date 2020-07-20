library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.FIR_types.all;

entity FIR is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	data_in:		in signed(31 downto 0);
	data_in_sync:		in bool;
	data_in_notify:		out bool;
	data_out:		out signed(31 downto 0);
	data_out_sync:		in bool;
	data_out_notify:		out bool
);
end FIR;

architecture FIR_arch of FIR is
	signal acc_signal: signed(31 downto 0);
	signal coef_signal: int_3;
	signal data_algorithm_signal: signed(31 downto 0);
	signal i_signal: signed(31 downto 0);
	signal phase_algorithm_signal: phases;
	signal shiftreg_signal: int_3;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			acc_signal <= to_signed(0, 32);
			coef_signal <= (others => to_signed(0, 32));
			data_algorithm_signal <= to_signed(0, 32);
			i_signal <= to_signed(0, 32);
			phase_algorithm_signal <= IDLE;
			shiftreg_signal <= (others => to_signed(0, 32));
			data_in_notify <= true;
			data_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end FIR_arch;