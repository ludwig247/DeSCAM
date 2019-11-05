library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;


entity top is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in signed(31 downto 0);
	b_in_sync:	 in bool;
	b_in_notify:	 out bool;
	b_out:		out signed(31 downto 0);
	b_out_sync:	 in bool;
	b_out_notify:	 out bool);
end top;

ARCHITECTURE a OF top IS

signal b_in_notify1:bool;
signal b_in_notify2:bool;

signal b_out_notify1:bool;
signal b_out_notify2:bool;

signal b_out1:signed(31 downto 0);
signal b_out2:signed(31 downto 0);


COMPONENT Pipeline
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in signed(31 downto 0);
	b_in_sync:	 in bool;
	b_in_free:	 in bool;
	b_in_notify:	 out bool;
	b_out:		out signed(31 downto 0);
	b_out_sync:	 in bool;
	b_out_free:	 in bool;
	b_out_notify:	 out bool);
END COMPONENT;

COMPONENT Pipeline2
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in signed(31 downto 0);
	b_in_sync:	 in bool;
	b_in_free:	 in bool;
	b_in_notify:	 out bool;
	b_out:		out signed(31 downto 0);
	b_out_sync:	 in bool;
	b_out_free:	 in bool;
	b_out_notify:	 out bool);
END COMPONENT;



begin 

b_out_notify <= b_out_notify1 or b_out_notify2;
b_in_notify <= b_in_notify1 or b_in_notify2;
b_out <= b_out1 when b_out_notify1 else b_out2;

 s1 : component Pipeline
port map (	
	clk => clk,
	rst => rst,
	b_in =>	b_in,
	b_in_sync => b_in_sync,
	b_in_free => not(b_in_notify1 or b_in_notify2),
	b_in_notify => b_in_notify1,
	b_out => b_out1,
	b_out_sync => b_out_sync,
	b_out_free => not(b_out_notify1 or b_out_notify2),
	b_out_notify => b_out_notify1);


 s2 : component Pipeline2
port map (	
	clk => clk,
	rst => rst,
	b_in =>	b_in,
	b_in_sync => b_in_sync,
	b_in_free => not(b_in_notify1 or b_in_notify2),
	b_in_notify => b_in_notify2,
	b_out => b_out2,
	b_out_sync => b_out_sync,
	b_out_free => not(b_out_notify1 or b_out_notify2),
	b_out_notify => b_out_notify2);



end a;

