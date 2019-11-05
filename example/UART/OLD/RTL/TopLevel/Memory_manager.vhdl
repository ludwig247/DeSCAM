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
	mem_man_to_bus:		out MEtoCU_IF;
	mem_man_to_bus_sync:	 in bool;
	mem_man_to_bus_notify:	 out bool;
	mem_man_to_ctrl:		out CUtoME_IF;
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
			 section <=RUN1;
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
		 if section = RUN1 then
		  

                    if(bus_to_mem_man_sync = true and bus_to_mem_man.req /= ME_RD) then 
                    mem_man_to_ctrl <= bus_to_mem_man;
                    bus_to_mem_man_notify <= true;
                    mem_man_to_ctrl_notify <= true;
                    mem_man_to_bus_notify <= false;
                    section <= RUN1;
                   elsif(bus_to_mem_man_sync = true and bus_to_mem_man.req = ME_RD) then
                       response_signal.loadedData <= response_data(ctrl_to_mem_man, bus_to_mem_man);   
                       mem_man_to_bus.loadedData <= response_data(ctrl_to_mem_man, bus_to_mem_man);                       
                       mem_man_to_ctrl <= bus_to_mem_man;
                       bus_to_mem_man_notify <= false;
                       mem_man_to_ctrl_notify <= true;
                       mem_man_to_bus_notify <= true;
                    section <= RUN2;
                   elsif(bus_to_mem_man_sync = false) then
                    bus_to_mem_man_notify <= true;
                    mem_man_to_ctrl_notify <= false;
                    mem_man_to_bus_notify <= false;
                    section <= RUN1;
                   end if;

		 end if;
              if section = RUN2 then
              
                 if(mem_man_to_bus_sync = true) then
                   bus_to_mem_man_notify <= true;
                   mem_man_to_bus_notify <= false;
                   mem_man_to_ctrl_notify <= false;
                   section <= RUN1;
                 else
                   
                   bus_to_mem_man_notify <= false;
                   mem_man_to_bus_notify <= true;
                   mem_man_to_ctrl_notify <= false;
                   section <= RUN2;
                 end if;

              end if;
		 end if;
	 end if;
	 end process;
end Memory_manager_arch;
