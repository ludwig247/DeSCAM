library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestBasic23_types.all;

entity TestBasic23 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_out:		out unsigned (31 downto 0);
	b_out_sync:		in bool;
	b_out_notify:		out bool;
	b_out2:		out signed(31 downto 0);
	b_out2_sync:		in bool;
	b_out2_notify:		out bool
);
end TestBasic23;

architecture TestBasic23_arch of TestBasic23 is
	signal section_signal: Sections;
	signal val_signed_signal: signed(31 downto 0);
	signal val_unsigned_signal: unsigned (31 downto 0);

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			section_signal <= SECTION_A;
			val_signed_signal <= to_signed(-7, 32);
			val_unsigned_signal <= to_unsigned(13, 32);
			b_out_notify <= true;
			b_out2_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestBasic23_arch;