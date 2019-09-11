library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity MMU is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	isa_mmu:		in MMU_in;
	isa_mmu_sync:	 in bool;
	isa_mmu_notify:	 out bool;
	mem_mmu:		in MEtoCU_IF;
	mem_mmu_sync:	 in bool;
	mem_mmu_notify:	 out bool;
	mmu_isa:		out MMU_return;
	mmu_isa_sync:	 in bool;
	mmu_isa_notify:	 out bool;
	mmu_mem:		out CUtoME_IF;
	mmu_mem_sync:	 in bool;
	mmu_mem_notify:	 out bool);
end MMU;

architecture MMU_arch of MMU is
signal section: MMU_SECTIONS;
			 signal i_signal:unsigned(31 down to 0);
			 signal lr_sc_addr_signal:unsigned(31 down to 0);
			 signal mem_req_signal:CUtoME_IF;
			 signal mem_resp_signal:MEtoCU_IF;
			 signal phys_addr_signal:unsigned(31 down to 0);
			 signal pt_addr_signal:unsigned(31 down to 0);
			 signal ptbase_signal:unsigned(31 down to 0);
			 signal pte_signal:unsigned(31 down to 0);
			 signal returndata_signal:MMU_return;
			 signal start_signal:int;
			 signal vm_request_signal:MMU_in;
begin
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=REQUEST;
			i_signal:= (others => 0);
			lr_sc_addr_signal:= (others => 0);
			mem_req_signal.addrIn<=0;
			mem_req_signal.dataIn<=0;
			mem_req_signal.mask<=MT_B;
			mem_req_signal.req<=ME_RD;
			mem_resp_signal.loadedData<=0;
			phys_addr_signal:= (others => 0);
			pt_addr_signal:= (others => 0);
			ptbase_signal:= (others => 0);
			pte_signal:= (others => 0);
			returndata_signal.data<=0;
			returndata_signal.exception<=0;
			returndata_signal.sc_success<=0;
			start_signal<=0;
			vm_request_signal.accesstype<=FETCH;
			vm_request_signal.data<=0;
			vm_request_signal.exception_in<=0;
			vm_request_signal.lrsc<=LR;
			vm_request_signal.mask<=MT_B;
			vm_request_signal.mstatus<=0;
			vm_request_signal.prv<=0;
			vm_request_signal.reset_lrsc<=0;
			vm_request_signal.satp<=0;
			vm_request_signal.v_addr<=0;
			isa_mmu_notify <= true;
			mem_mmu_notify <= false;
			mmu_isa_notify <= false;
			mmu_mem_notify <= false;
		 else
		 if section = MEMORY_OP then
		 -- FILL OUT HERE;
		 end if;
		 if section = PMA then
		 -- FILL OUT HERE;
		 end if;
		 if section = PTE_DECODE then
		 -- FILL OUT HERE;
		 end if;
		 if section = PTE_FETCH then
		 -- FILL OUT HERE;
		 end if;
		 if section = REQUEST then
		 -- FILL OUT HERE;
		 end if;
		 if section = RESPONSE then
		 -- FILL OUT HERE;
		 end if;
		 end if;
	 end if;
	 end process;
end MMU_arch;
