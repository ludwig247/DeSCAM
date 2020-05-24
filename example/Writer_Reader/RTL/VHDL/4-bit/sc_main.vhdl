library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.sc_main_types.all;

entity sc_main is
port(	
	clk:		in std_logic;
	rst:		in std_logic
);
end sc_main;

architecture sc_main_arch of sc_main is
	signal comp2tocomp1_data: signed(3 downto 0);
	signal comp2tocomp1_addr: signed(3 downto 0);
	signal comp2tocomp1_trans_type: trans_t;
	signal comp1tocomp2_data: signed(3 downto 0);
	signal comp1tocomp2_addr: signed(3 downto 0);
	signal comp1tocomp2_trans_type: trans_t;
	signal comp1_out_notify_out: bool;
	signal comp2_out_notify_out: bool;
	signal comp1_in_notify_out: bool;
	signal comp2_in_notify_out: bool;
	

	component Component1
	port(	
		clk:		in std_logic;
		rst:		in std_logic;
		component1_in_data:		in signed(3 downto 0);
		component1_in_addr:		in signed(3 downto 0);
		component1_in_trans_type:	in trans_t;
		component1_in_sync:		in bool;
		component1_in_notify:		out bool;
		component1_out_data:		out signed(3 downto 0);
		component1_out_addr:		out signed(3 downto 0);
		component1_out_trans_type:	out trans_t;
		component1_out_sync:		in bool;
		component1_out_notify:		out bool
	);
	end component;

	component Component2
	port(	
		clk:		in std_logic;
		rst:		in std_logic;
		component2_in_data:		in signed(3 downto 0);
		component2_in_addr:		in signed(3 downto 0);
		component2_in_trans_type:	in trans_t;
		component2_in_sync:		in bool;
		component2_in_notify:		out bool;
		component2_out_data:		out signed(3 downto 0);
		component2_out_addr:		out signed(3 downto 0);
		component2_out_trans_type:	out trans_t;
		component2_out_sync:		in bool;
		component2_out_notify:		out bool
	);
	end component;

begin
	component1_inst: Component1
	port map(
		clk	=>	clk,
		rst	=>	rst,
		component1_in_data	=>	comp2tocomp1_data,
		component1_in_addr	=>	comp2tocomp1_addr,
		component1_in_trans_type	=>	comp2tocomp1_trans_type,
		component1_in_sync	=>	comp2_out_notify_out,
		component1_in_notify	=>	comp1_in_notify_out,
		component1_out_data	=>	comp1tocomp2_data,
		component1_out_addr	=>	comp1tocomp2_addr,
		component1_out_trans_type	=>	comp1tocomp2_trans_type,
		component1_out_sync	=>	comp2_in_notify_out,
		component1_out_notify	=>	comp1_out_notify_out
	);

	component2_inst: Component2
	port map(
		clk	=>	clk,
		rst	=>	rst,
		component2_in_data => comp1tocomp2_data,
		component2_in_addr => comp1tocomp2_addr,
		component2_in_trans_type => comp1tocomp2_trans_type,
		component2_in_sync	=>	comp1_out_notify_out,
		component2_in_notify	=>	comp2_in_notify_out,
		component2_out_data	=>	comp2tocomp1_data,
		component2_out_addr	=>	comp2tocomp1_addr,
		component2_out_trans_type	=>	comp2tocomp1_trans_type,
		component2_out_sync	=>	comp1_in_notify_out,
		component2_out_notify	=>	comp2_out_notify_out
	);

	
end sc_main_arch;