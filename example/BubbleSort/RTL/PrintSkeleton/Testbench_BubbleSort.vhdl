library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use ieee.math_real.all;
use work.top_level_types.all;
use work.BubbleSort_types.all;

entity Testbench_BubbleSort is
end entity;

architecture sim of Testbench_Bubblesort is

	component BubbleSort
		port (
			clk:			in std_logic :='0';
			rst:			in std_logic;
			data_in:		in int_8;
			data_in_sync:		in bool;
			data_in_notify:		out bool;
			data_out:		out int_8;
			data_out_sync:		in bool;
			data_out_notify:	out bool
			);
	end component;

	constant CLK_PERIOD : time := 10 ns;

	signal clk:			std_logic := '0';
	signal rst:			std_logic;
	signal data_in_tb:		int_8;
	signal data_in_sync_tb:		bool;
	signal data_in_notify_tb:	bool;
	signal data_out_tb:		int_8;
	signal data_out_sync_tb:	bool;
	signal data_out_notify_tb:	bool;
	
begin
	dut: BubbleSort port map (
				clk => clk,
				rst => rst,
				data_in => data_in_tb,
				data_in_sync => data_in_sync_tb,
				data_in_notify => data_in_notify_tb,
				data_out => data_out_tb,
				data_out_sync => data_out_sync_tb,
				data_out_notify => data_out_notify_tb
				);

	clk_gen: process
	begin	
		clk <= not clk; 
		wait for CLK_PERIOD/2;
	end process clk_gen;


	stimuli: process
	
		variable seed1 : positive;
		variable seed2 : positive;
		variable rand : real;
		variable range_of_rand : real := 255.0;
		variable rand_num : signed(31 downto 0);

		variable v_time: time := 0 ns;

			

	begin
		wait for CLK_PERIOD;
		rst <= '1';
		wait for CLK_PERIOD;
		rst <= '0';
		wait for CLK_PERIOD;

		seed1 := 1;

		for i in 0 to 1000000 loop
		
			seed1 := seed1 + 1;
			seed2 := 1;

			for n in 0 to 7 loop
				uniform(seed1,seed2,rand);
				data_in_tb(n) <= to_signed(integer(rand * range_of_rand),32);
			end loop;

			--data_in_tb <= (x"00000000",x"00000002",x"00000003",x"00000005",x"00000008",x"00000009",x"0000000A",x"0000000C");
			wait for CLK_PERIOD;
			data_in_sync_tb <= true;
			wait for CLK_PERIOD;
			data_in_sync_tb <= false;
			wait for CLK_PERIOD;
			wait until data_out_notify_tb = true;
			data_out_sync_tb <= true;
			wait for CLK_PERIOD*2;
			data_out_sync_tb <= false;

		end loop;

		Report "time consumed: " &TIME'image(v_time);

		assert FALSE Report "Simulation ended after 10.000.000 runs" severity FAILURE;

	end process stimuli;


end architecture;
 		
