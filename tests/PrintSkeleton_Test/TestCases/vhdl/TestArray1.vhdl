library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.TestArray1_types.all;

entity TestArray1 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	m_in:		in int;
	m_in_sync:		in bool;
	m_in_notify:		out bool;
	m_out:		out int;
	m_out_sync:		in bool;
	m_out_notify:		out bool
);
end TestArray1;

architecture TestArray1_arch of TestArray1 is
	signal regfile_signal: int_2;
	signal rs1_signal: int;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			regfile_signal <= (others => to_signed(0, 32));
			rs1_signal <= to_signed(0, 32);
			m_in_notify <= true;
			m_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end TestArray1_arch;