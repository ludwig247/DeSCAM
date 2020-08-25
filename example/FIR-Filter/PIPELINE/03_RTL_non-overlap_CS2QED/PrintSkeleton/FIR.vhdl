library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.FIR_types.all;

entity FIR_TOP is
port(	
	clk:			in std_logic;
	rst:			in std_logic;

	data_in_1_top:		in signed(31 downto 0);
	data_in_sync_1_top:		in bool;
	data_in_notify_1_top:	out bool;
	data_out_1_top:		out signed(31 downto 0);
	data_out_sync_1_top:	in bool;
	data_out_notify_1_top:	out bool;

	data_in_2_top:		in signed(31 downto 0);
	data_in_sync_2_top:	in bool;
	data_in_notify_2_top:	out bool;
	data_out_2_top:		out signed(31 downto 0);
	data_out_sync_2_top:	in bool;
	data_out_notify_2_top:	out bool
);
end FIR_TOP;

architecture FIR_TOP_arch of FIR_TOP is
	
	component FIR_Pipeline is
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
	end component;

begin
	p1_inst: FIR_Pipeline
	port map (
		clk => clk,
		rst => rst,
		data_in => data_in_1_top,
		data_in_sync => data_in_sync_1_top,
		data_in_notify => data_in_notify_1_top,
		data_out => data_out_1_top,
		data_out_sync => data_out_sync_1_top,
		data_out_notify => data_out_notify_1_top
	);

	p2_inst: FIR_Pipeline
	port map (
		clk => clk,
		rst => rst,
		data_in => data_in_2_top,
		data_in_sync => data_in_sync_2_top,
		data_in_notify => data_in_notify_2_top,
		data_out => data_out_2_top,
		data_out_sync => data_out_sync_2_top,
		data_out_notify => data_out_notify_2_top
	);

end FIR_TOP_arch;