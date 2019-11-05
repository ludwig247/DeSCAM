library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity unit is
generic(initial_state : states := A);
port(	
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
end unit;

architecture unit_arch of unit is
	signal state: states;
	signal b_out_store:signed(31 downto 0);

begin
process(clk)
begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			if initial_state = Aw then
				b_in_notify <= false;
				b_out_notify <= false;
				state <= Aw;
			else
				b_in_notify <= true;
				b_out_notify <= false;
				state <= A;
			end if;
		else
			if state = A and b_in_sync then
				b_in_notify <= false;
				if(b_out_free) then 
					b_out <= b_in + to_signed(1,32);
					--b_out_store <= b_in + to_signed(1,32);
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
	
end unit_arch;