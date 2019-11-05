library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;

entity top is
port(	
	clk:			in std_logic;
	rst:			in std_logic;
	b_in:			in signed(31 downto 0);
	b_in_sync:	 	in boolean;
	b_in_notify:	out boolean;
	b_out:			out signed(31 downto 0);
	b_out_sync:	 	in boolean;
	b_out_notify:	out boolean);
end top;

ARCHITECTURE top_arch OF top IS

signal b_in_notify1:boolean;
signal b_in_notify2:boolean;

signal b_out_notify1:boolean;
signal b_out_notify2:boolean;

signal b_in_free:boolean;
signal b_out_free:boolean;

signal b_out1:signed(31 downto 0);
signal b_out2:signed(31 downto 0);


component unit
generic (initial_state : states := A);
port (	
	clk:			in std_logic;
	rst:			in std_logic;
	b_in:			in signed(31 downto 0);
	b_in_sync:	 	in boolean;
	b_in_free:	 	in boolean;
	b_in_notify:	out boolean;
	b_out:			out signed(31 downto 0);
	b_out_sync:	 	in boolean;
	b_out_free:	 	in boolean;
	b_out_notify:	out boolean);
end component;

begin 

b_out_notify <= b_out_notify1 or b_out_notify2;
b_in_notify <= b_in_notify1 or b_in_notify2;
b_out <= b_out1 when b_out_notify1 else b_out2;

b_in_free <= not(b_in_notify1 or b_in_notify2) or (b_in_sync and (b_in_notify1 or b_in_notify2));
b_out_free <= not(b_out_notify1 or b_out_notify2) or (b_out_sync and (b_out_notify1 or b_out_notify2));

s1 : component unit
generic map (initial_state => A)
port map (	
	clk => clk,
	rst => rst,
	b_in =>	b_in,
	b_in_sync => b_in_sync,
	b_in_free => b_in_free,
	b_in_notify => b_in_notify1,
	b_out => b_out1,
	b_out_sync => b_out_sync,
	b_out_free => b_out_free,
	b_out_notify => b_out_notify1);

s2 : component unit
generic map (initial_state => Aw)
port map (	
	clk => clk,
	rst => rst,
	b_in =>	b_in,
	b_in_sync => b_in_sync,
	b_in_free => b_in_free,
	b_in_notify => b_in_notify2,
	b_out => b_out2,
	b_out_sync => b_out_sync,
	b_out_free => b_out_free,
	b_out_notify => b_out_notify2);

end top_arch;