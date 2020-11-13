library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestMasterSlave18_types.all;

entity TestMasterSlave18 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	s_out_1:		out signed(31 downto 0);
	s_out_2:		out signed(31 downto 0);
	s_out_3:		out signed(31 downto 0)
);
end TestMasterSlave18;

architecture TestMasterSlave18_arch of TestMasterSlave18 is
	signal data1_signal: signed(31 downto 0);
	signal data2_signal: signed(31 downto 0);
	signal data3_signal: signed(31 downto 0);

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			data1_signal <= to_signed(0, 32);
			data2_signal <= to_signed(0, 32);
			data3_signal <= to_signed(0, 32);
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestMasterSlave18_arch;