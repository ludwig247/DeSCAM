library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.TestArray4_types.all;

entity TestArray4 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	m_in:		in int;
	m_in_sync:		in bool;
	m_in_notify:		out bool;
	m_out:		out int_5;
	m_out_sync:		in bool;
	m_out_notify:		out bool
);
end TestArray4;

architecture TestArray4_arch of TestArray4 is
	signal myArray_signal: int_5;
	signal test_signal: int;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			myArray_signal <= (others => to_signed(0, 32));
			test_signal <= to_signed(0, 32);
			m_in_notify <= true;
			m_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestArray4_arch;