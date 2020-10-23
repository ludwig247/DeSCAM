library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity ECallHandler is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	ecall_isa_Port:		out bool;
	ecall_isa_Port_sync:	 in bool;
	ecall_isa_Port_notify:	 out bool;
	ecall_reg_Port:		out RegfileWriteType;
	ecall_reg_Port_sync:	 in bool;
	ecall_reg_Port_notify:	 out bool;
	fromMemoryPort:		in MEtoCU_IF;
	fromMemoryPort_sync:	 in bool;
	fromMemoryPort_notify:	 out bool;
	isa_ecall_Port:		in bool;
	isa_ecall_Port_sync:	 in bool;
	isa_ecall_Port_notify:	 out bool;
	reg_ecall_Port:		in RegfileECallType;
	reg_ecall_Port_sync:	 in bool;
	reg_ecall_Port_notify:	 out bool;
	toMemoryPort:		out CUtoME_IF;
	toMemoryPort_sync:	 in bool;
	toMemoryPort_notify:	 out bool);
end ECallHandler;

architecture ECallHandler_arch of ECallHandler is
signal section: ECallHandler_SECTIONS;
			 signal ans_signal:unsigned(31 down to 0);
			 signal fromMemoryData_signal:MEtoCU_IF;
			 signal index_signal:unsigned(31 down to 0);
			 signal isaREQ_signal:bool;
			 signal memoryAccess_signal:CUtoME_IF;
			 signal regfileSyscall_signal:RegfileECallType;
			 signal regfileWrite_signal:RegfileWriteType;
			 signal sysRES_signal:bool;
begin
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=idle;
			ans_signal:= (others => 0);
			fromMemoryData_signal.loadedData<=0;
			index_signal:= (others => 0);
			isaREQ_signal<=false;
			memoryAccess_signal.addrIn<=0;
			memoryAccess_signal.dataIn<=0;
			memoryAccess_signal.mask<=MT_B;
			memoryAccess_signal.req<=ME_RD;
			regfileSyscall_signal.reg_file_10<=0;
			regfileSyscall_signal.reg_file_11<=0;
			regfileSyscall_signal.reg_file_12<=0;
			regfileSyscall_signal.reg_file_17<=0;
			regfileWrite_signal.dst<=0;
			regfileWrite_signal.dstData<=0;
			regfileWrite_signal.exception<=0;
			sysRES_signal<=false;
			ecall_isa_Port_notify <= false;
			ecall_reg_Port_notify <= false;
			fromMemoryPort_notify <= false;
			isa_ecall_Port_notify <= true;
			toMemoryPort_notify <= false;
		 else
		 if section = idle then
		 -- FILL OUT HERE;
		 end if;
		 if section = process then
		 -- FILL OUT HERE;
		 end if;
		 if section = writing then
		 -- FILL OUT HERE;
		 end if;
		 end if;
	 end if;
	 end process;
end ECallHandler_arch;
