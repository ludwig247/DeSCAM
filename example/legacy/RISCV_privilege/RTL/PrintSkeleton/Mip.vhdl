library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Mip is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	MEIP_port:		in bool;
	MEIP_port_sync:	 in bool;
	MEIP_port_notify:	 out bool;
	MSIP_port:		in bool;
	MSIP_port_sync:	 in bool;
	MSIP_port_notify:	 out bool;
	MTIP_port:		in bool;
	MTIP_port_sync:	 in bool;
	MTIP_port_notify:	 out bool;
	mip_isa_Port:		out unsigned;
	mip_isa_Port_sync:	 in bool;
	mip_isa_Port_notify:	 out bool);
end Mip;

architecture Mip_arch of Mip is
signal section: Mip_SECTIONS;
			 signal mip_signal:unsigned(31 down to 0);
			 signal temp_signal:bool;
begin
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=run;
			mip_signal:= (others => 0);
			temp_signal<=false;
			mip_isa_Port_notify <= true;
		 else
		 if section = run then
		 -- FILL OUT HERE;
		 end if;
		 end if;
	 end if;
	 end process;
end Mip_arch;
