library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.top_level_types.all;
use work.TestMasterSlave17_types.all;

entity TestMasterSlave17 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	s_out_1:		out bus_req_t;
	s_out_2:		out bus_req_t;
	s_out_3:		out bus_req_t
);
end TestMasterSlave17;

architecture TestMasterSlave17_arch of TestMasterSlave17 is
	signal data1_signal: bus_req_t;
	signal data2_signal: bus_req_t;
	signal data3_signal: bus_req_t;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			data1_signal.data <= to_signed(0, 32);
			data1_signal.trans_type <= SINGLE_READ;
			data2_signal.data <= to_signed(0, 32);
			data2_signal.trans_type <= SINGLE_READ;
			data3_signal.data <= to_signed(0, 32);
			data3_signal.trans_type <= SINGLE_READ;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestMasterSlave17_arch;