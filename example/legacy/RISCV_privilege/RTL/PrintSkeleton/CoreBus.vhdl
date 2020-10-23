library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity CoreBus is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	BUStoCLINT_port:		out CUtoME_IF;
	BUStoCLINT_port_sync:	 in bool;
	BUStoCLINT_port_notify:	 out bool;
	BUStoMEM_port:		out CUtoME_IF;
	BUStoMEM_port_sync:	 in bool;
	BUStoMEM_port_notify:	 out bool;
	BUStoPLIC_port:		out CUtoME_IF;
	BUStoPLIC_port_sync:	 in bool;
	BUStoPLIC_port_notify:	 out bool;
	CLINTtoBUS_port:		in MEtoCU_IF;
	CLINTtoBUS_port_sync:	 in bool;
	CLINTtoBUS_port_notify:	 out bool;
	MEMtoBUS_port:		in MEtoCU_IF;
	MEMtoBUS_port_sync:	 in bool;
	MEMtoBUS_port_notify:	 out bool;
	PLICtoBUS_port:		in MEtoCU_IF;
	PLICtoBUS_port_sync:	 in bool;
	PLICtoBUS_port_notify:	 out bool;
	bus_ecall_Port:		out MEtoCU_IF;
	bus_ecall_Port_sync:	 in bool;
	bus_ecall_Port_notify:	 out bool;
	bus_isa_Port:		out MEtoCU_IF;
	bus_isa_Port_sync:	 in bool;
	bus_isa_Port_notify:	 out bool;
	ecall_bus_Port:		in CUtoME_IF;
	ecall_bus_Port_sync:	 in bool;
	ecall_bus_Port_notify:	 out bool;
	isa_bus_Port:		in CUtoME_IF;
	isa_bus_Port_sync:	 in bool;
	isa_bus_Port_notify:	 out bool);
end CoreBus;

architecture CoreBus_arch of CoreBus is
signal section: CoreBus_SECTIONS;
			 signal CPtoME_data_signal:CUtoME_IF;
			 signal MEtoCP_data_signal:MEtoCU_IF;
			 signal blet_signal:int;
			 signal rec_signal:bool;
begin
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=run;
			CPtoME_data_signal.addrIn<=0;
			CPtoME_data_signal.dataIn<=0;
			CPtoME_data_signal.mask<=MT_B;
			CPtoME_data_signal.req<=ME_RD;
			MEtoCP_data_signal.loadedData<=0;
			blet_signal<=0;
			rec_signal<=false;
			BUStoCLINT_port_notify <= false;
			BUStoMEM_port_notify <= false;
			BUStoPLIC_port_notify <= false;
			CLINTtoBUS_port_notify <= false;
			MEMtoBUS_port_notify <= false;
			PLICtoBUS_port_notify <= false;
			bus_ecall_Port_notify <= false;
			bus_isa_Port_notify <= false;
			ecall_bus_Port_notify <= false;
			isa_bus_Port_notify <= true;
		 else
		 if section = run then
		 -- FILL OUT HERE;
		 end if;
		 end if;
	 end if;
	 end process;
end CoreBus_arch;
