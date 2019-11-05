
library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Pipeline is
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
end Pipeline;

architecture Pipeline_arch of Pipeline is
	signal section: Pipeline_SECTIONS;
	signal state: states;
	signal result_signal:signed(31 downto 0);
	signal b_out_store:signed(31 downto 0);

	--signal result_signal:int; -- flages some weirred error. versioning problem?
begin
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			section <=run;
			result_signal<= to_signed(0,32);
			b_in_notify <= true;
			b_out_notify <= false;
			state <= A;

		 else
		 if state = A and b_in_sync then
			result_signal <= b_in + 1;
			b_in_notify <= false;
			if(b_out_free) then 
				b_out <= b_in + to_signed(1,32);
				b_out_notify <= true;
				state <= B;
			else 
				state <= Bw;
				b_out_store <= b_in + to_signed(1,32);
			end if;
		elsif state = Aw and b_in_free then
				b_in_notify <= true;
				state <= A;
	
		 elsif state = Bw and b_out_free then
				b_out_notify <= true;
				state <= B;
				b_out <= b_out_store;
		 elsif state = B and b_out_sync then
			b_out_notify <= false;
			if(b_in_free) then
				b_in_notify <= true;
				state <= A;
			else 
				state <= Aw;
			end if;
		 end if;
		 end if;
	 end if;
	 end process;

	
end Pipeline_arch;
