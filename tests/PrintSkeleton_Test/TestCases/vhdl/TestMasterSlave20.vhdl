library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestMasterSlave20_types.all;

entity TestMasterSlave20 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	s_in_1:		in signed(31 downto 0);
	s_in_1_sync:		in bool;
	s_in_2:		in signed(31 downto 0);
	s_in_2_sync:		in bool;
	s_in_3:		in signed(31 downto 0);
	s_in_3_sync:		in bool;
	s_out_1:		out signed(31 downto 0);
	s_out_2:		out signed(31 downto 0);
	s_out_3:		out signed(31 downto 0)
);
end TestMasterSlave20;

architecture TestMasterSlave20_arch of TestMasterSlave20 is
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
end TestMasterSlave20_arch;