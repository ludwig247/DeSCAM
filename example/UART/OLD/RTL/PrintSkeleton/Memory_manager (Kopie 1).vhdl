library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.Mem_man_functions.all;

entity Memory_manager is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	bus_to_mem_man:		in CUtoME_IF;
	bus_to_mem_man_sync:	 in bool;
	bus_to_mem_man_notify:	 out bool;
	ctrl_to_mem_man:		in reg_files;
	ctrl_to_mem_man_sync:	 in bool;
	ctrl_to_mem_man_notify:	 out bool;
	mem_man_to_bus:		out MEtoCU_IF;
	mem_man_to_bus_sync:	 in bool;
	mem_man_to_bus_notify:	 out bool;
	mem_man_to_ctrl:		out CUtoME_IF;
	mem_man_to_ctrl_sync:	 in bool;
	mem_man_to_ctrl_notify:	 out bool);
end Memory_manager;

architecture Memory_manager_arch of Memory_manager is
signal section: Memory_manager_SECTIONS;
			 signal regs_signal:reg_files;
			 signal request_signal:CUtoME_IF;
			 signal response_signal:MEtoCU_IF;
begin
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=run;
			regs_signal.CR_reg<=(others => '0');
			regs_signal.DR_reg<=(others => '0');
			regs_signal.SR_reg<=(others => '0');
			regs_signal.r_act<=CR_RD;
			request_signal.addrIn<=(others => '0');
			request_signal.dataIn<=(others => '0');
			request_signal.mask<=MT_B;
			request_signal.req<=ME_RD;
			response_signal.loadedData<=(others => '0');
			bus_to_mem_man_notify <= true;
			mem_man_to_bus_notify <= false;
			mem_man_to_ctrl_notify <= false;
		 else
		 if section = run then
		 -- FILL OUT HERE;
		 end if;
		 end if;
	 end if;
	 end process;
end Memory_manager_arch;
