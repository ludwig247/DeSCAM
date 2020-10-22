library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestBasic24_types.all;

entity TestBasic24 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	alu_in:		in signed(31 downto 0);
	alu_out:		out signed(31 downto 0);
	alu_out_notify:		out bool;
	b_out:		out signed(31 downto 0);
	b_out_sync:		in bool;
	b_out_notify:		out bool;
	reg_in:		in signed(31 downto 0);
	reg_out:		out signed(31 downto 0);
	reg_out_notify:		out bool
);
end TestBasic24;

architecture TestBasic24_arch of TestBasic24 is
	signal var1_signal: signed(31 downto 0);

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			var1_signal <= to_signed(5, 32);
			alu_out_notify <= false;
			b_out_notify <= true;
			reg_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic24_arch;