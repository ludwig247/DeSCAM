library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity TestArray1 is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	m_in:		in int;
	m_in_sync:	 in bool;
	m_in_notify:	 out bool;
	m_out:		out int;
	m_out_sync:	 in bool;
	m_out_notify:	 out bool);
end TestArray1;

architecture TestArray1_arch of TestArray1 is
signal section: TestArray1_SECTIONS;
			 signal regfile_signal:int_2;
			 signal rs1_signal:int;
			 signal flip:std_logic;
begin
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=run;
			regfile_signal<=(to_signed(0,32),to_signed(0,32));
			rs1_signal<= to_signed(0,32);
			m_in_notify <= true;
			m_out_notify <= false;
			flip <= '0';
		 else
		 if section = run then
			if(flip = '0') then
				if(m_in_sync = true) then
					m_out <= m_in +1;
					regfile_signal(0)<= resize(m_in +1,32);
					regfile_signal(1)<= resize(m_in +1,32);
					m_in_notify <= false;
					m_out_notify <= true;
					flip<='1';
				end if;
			else
				if(m_out_sync = true) then
					m_in_notify <= true;
					m_out_notify <= false;
					flip <= '0';
				end if;
			end if;
		 end if;
		 end if;
	 end if;
	 end process;
end TestArray1_arch;
