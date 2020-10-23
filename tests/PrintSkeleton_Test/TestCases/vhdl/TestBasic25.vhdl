library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestBasic25_types.all;

entity TestBasic25 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	alu_in:		in signed(31 downto 0);
	alu_out:		out signed(31 downto 0);
	alu_out_notify:		out bool;
	reg_in:		in signed(31 downto 0);
	reg_out:		out signed(31 downto 0);
	reg_out_notify:		out bool
);
end TestBasic25;

architecture TestBasic25_arch of TestBasic25 is

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			alu_out_notify <= true;
			reg_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic25_arch;