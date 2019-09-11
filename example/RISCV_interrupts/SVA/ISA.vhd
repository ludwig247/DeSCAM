--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 30.11.18
--

library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.ISA_functions.all;
use work.testBench_Signals_pkg.all;

entity ISA is
port(    
	clk: in std_logic;
	rst: in std_logic;

	--  blocking_in<MEtoCP_IF> fromMemoryPort
	fromMemoryPort				: in MEtoCU_IF;
	fromMemoryPort_sync		: in bool;
	fromMemoryPort_notify	: out bool;

	--  master_in<RegfileType> fromRegsPort
	fromRegsPort				: in RegfileType;

	--  blocking_out<bool> isa_syscall_Port
	isa_syscall_Port			: out bool;
	isa_syscall_Port_sync	: in bool;
	isa_syscall_Port_notify	: out bool;

	--  master_in<unsigned int> mip_isa_Port
	mip_isa_Port				: in unsigned (31 downto 0);

	--  blocking_in<bool> syscall_isa_Port
	syscall_isa_Port			: in bool;
	syscall_isa_Port_sync	: in bool;
	syscall_isa_Port_notify	: out bool;

	--  blocking_out<CUtoME_IF> toMemoryPort
	toMemoryPort				: out CUtoME_IF;
	toMemoryPort_sync			: in bool;
	toMemoryPort_notify		: out bool;

	--  master_out<RegfileWriteType> toRegsPort
	toRegsPort					: out RegfileWriteType;
	toRegsPort_notify			: out bool
);
end ISA;

architecture ISA_arch of ISA is

--type ISA_SECTIONS is (fetch, execute, store, load1, load2, syscall1, syscall2);
signal section: ISA_SECTIONS;

signal pcReg_signal: unsigned (31 downto 0);
signal csr_mcause_signal: unsigned (31 downto 0);
signal csr_mepc_signal: unsigned (31 downto 0);
signal csr_mie_signal: unsigned (31 downto 0);
signal csr_mip_signal: unsigned (31 downto 0);
signal csr_mstatus_signal: unsigned (31 downto 0);
signal csr_mtvec_signal: unsigned (31 downto 0);
signal sysRES : bool;

begin

Breaking_sig <= sysRES ; -- needed for testBench

	process(clk)

		variable next_section	: ISA_SECTIONS;
		variable encodedInstr	: Unsigned (31 downto 0);
		variable aluOp1			: Unsigned (31 downto 0);
		variable aluOp2			: Unsigned (31 downto 0);
		variable aluResult		: Unsigned (31 downto 0);

		variable temp_pc			: Unsigned (31 downto 0);
		variable temp_mie			: Unsigned (31 downto 0);
		variable temp_mip			: Unsigned (31 downto 0);
		variable temp_mepc		: Unsigned (31 downto 0);
		variable temp_mtvec		: Unsigned (31 downto 0);
		variable temp_mcause		: Unsigned (31 downto 0);
		variable temp_mstatus	: Unsigned (31 downto 0);

	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			section <=fetch;
			csr_mcause_signal<=(others => '0');
			csr_mepc_signal<=(others => '0');
			csr_mie_signal<=(others => '0');
			csr_mip_signal<=(others => '0');
			csr_mstatus_signal<=(others => '0');
			csr_mtvec_signal<=(others => '0');
			pcReg_signal<=(others => '0');
			toRegsPort.dst<=(others => '0');
			toRegsPort.dstData<=(others => '0');
			toMemoryPort.addrIn<=(others => '0');
			toMemoryPort.dataIn<=(others => '0');
			toMemoryPort.mask<=MT_W;
			toMemoryPort.req<=ME_RD;
			fromMemoryPort_notify <= false;
			isa_syscall_Port_notify <= false;
			syscall_isa_Port_notify <= false;
			toMemoryPort_notify <= true;
			toRegsPort_notify <= false;
			sysRES <= true;
		else

			-- Send fetch request to Memory
			if (section = fetch) then
				toRegsPort_notify <= false;
				isa_syscall_Port_notify <= false;
				syscall_isa_Port_notify <= false;

				if (toMemoryPort_sync = true) then
					toMemoryPort_notify   <= false;
					fromMemoryPort_notify <= true;
					--next_section := execute;
					section <= execute;
				else
					toMemoryPort_notify   <= true;
					fromMemoryPort_notify <= false;
					section <= fetch;
				end if;

			else
			
				temp_mie := csr_mie_signal;
				temp_mip := csr_mip_signal;
				temp_mepc := csr_mepc_signal;
				temp_mtvec := csr_mtvec_signal;
				temp_mcause := csr_mcause_signal;
				temp_mstatus := csr_mstatus_signal;

				-- Receive, decode and execute instruction
				if (section = execute) then

					if (fromMemoryPort_sync = true) then

						fromMemoryPort_notify <= false;
						encodedInstr := fromMemoryPort.loadedData;

						-- ENC_R
						if(getEncType(encodedInstr) = ENC_R) then

							aluOp1 := readRegfile(getRs1Addr(encodedInstr), fromRegsPort);
							aluOp2 := readRegfile(getRs2Addr(encodedInstr), fromRegsPort);
							aluResult := getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2);

							toRegsPort.dst     <= getRdAddr(encodedInstr);
							toRegsPort.dstData <= aluResult;
							toRegsPort_notify  <= true;
							
							temp_pc := pcReg_signal + 4;
							next_section := fetch;
						-- ENC_B
						elsif (getEncType(encodedInstr) = ENC_B) then

							aluOp1 := readRegfile(getRs1Addr(encodedInstr), fromRegsPort);
							aluOp2 := readRegfile(getRs2Addr(encodedInstr), fromRegsPort);
							aluResult := getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2);

							toRegsPort_notify  <= false;

							temp_pc := getBranchresult(encodedInstr, aluResult, pcReg_signal);
							next_section := fetch;

						-- ENC_S
						elsif (getEncType(encodedInstr) = ENC_S) then

							aluOp1 := readRegfile(getRs1Addr(encodedInstr), fromRegsPort);
							aluOp2 := getImmediate(encodedInstr);
							aluResult := getALUresult(ALU_ADD, aluOp1, aluOp2);

							toRegsPort_notify  <= false;

							toMemoryPort.req <= ME_WR;
							toMemoryPort.mask <= getMemoryMask(getInstrType(encodedInstr));
							toMemoryPort.addrIn <= aluResult;
							toMemoryPort.dataIn <= readRegfile(getRs2Addr(encodedInstr), fromRegsPort);
							toMemoryPort_notify <= true;

							next_section := store;

						-- ENC_U
						elsif (getEncType(encodedInstr) = ENC_U) then

							aluOp1 := pcReg_signal;
							aluOp2 := getImmediate(encodedInstr);
							aluResult := getALUresult_U((encodedInstr), aluOp1, aluOp2);

							toRegsPort.dst     <= getRdAddr(encodedInstr);
							toRegsPort.dstData <= aluResult;
							toRegsPort_notify  <= true;

							temp_pc := pcReg_signal + 4;
							next_section := fetch;

						-- ENC_J
						elsif (getEncType(encodedInstr) = ENC_J) then

							toRegsPort.dst     <= getRdAddr(encodedInstr);
							toRegsPort.dstData <= (pcReg_signal + 4);
							toRegsPort_notify  <= true;

							temp_pc :=  (pcReg_signal + getImmediate(encodedInstr));
							next_section := fetch;

						-- ENC_I_I
						elsif (getEncType(encodedInstr) = ENC_I_I) then

							aluOp1 := readRegfile(getRs1Addr(encodedInstr), fromRegsPort);
							aluOp2 := getImmediate(encodedInstr);
							aluResult := getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2);

							toRegsPort.dst     <= getRdAddr(encodedInstr);
							toRegsPort.dstData <= aluResult;
							toRegsPort_notify  <= true;

							temp_pc := pcReg_signal + 4;
							next_section := fetch;

						-- ENC_I_L
						elsif (getEncType(encodedInstr) = ENC_I_L) then

							aluOp1 := readRegfile(getRs1Addr(encodedInstr), fromRegsPort);
							aluOp2 := getImmediate(encodedInstr);
							aluResult := getALUresult(ALU_ADD, aluOp1, aluOp2);

							toRegsPort.dst <= getRdAddr(encodedInstr);

							toMemoryPort.req <= ME_RD;
							toMemoryPort.mask <= getMemoryMask(getInstrType(encodedInstr));
							toMemoryPort.addrIn <= aluResult;
							toMemoryPort.dataIn <= to_unsigned(0,32);
							toMemoryPort_notify <= true;

							next_section := load1;

						-- ENC_I_J
						elsif (getEncType(encodedInstr) = ENC_I_J) then

							toRegsPort.dst     <= getRdAddr(encodedInstr);
							toRegsPort.dstData <= (pcReg_signal + 4);
							toRegsPort_notify  <= true;

							temp_pc := readRegfile(getRs1Addr(encodedInstr), fromRegsPort) + getImmediate(encodedInstr);
							next_section := fetch;

						-- ENC_I_M
						elsif (getEncType(encodedInstr) = ENC_I_M) then

							temp_pc := pcReg_signal + 4;
							next_section := fetch;

						-- ENC_I_S --dholds
						elsif (getEncType(encodedInstr) = ENC_I_S) then

							if ( (getInstrType(encodedInstr) = INSTR_CSRRW) or (getInstrType(encodedInstr) = INSTR_CSRRS) or (getInstrType(encodedInstr) = INSTR_CSRRC) ) then

								aluOp1 := readRegfile(getRs1Addr(encodedInstr), fromRegsPort);
								aluOp2 := getCSR(encodedInstr, temp_mstatus,temp_mie,temp_mtvec,temp_mepc,temp_mcause,temp_mip);
								aluResult := getCSRresult(getInstrType(encodedInstr), aluOp1, aluOp2);


								toRegsPort.dst     <= getRdAddr(encodedInstr);
								toRegsPort.dstData <= aluOp2;
								toRegsPort_notify  <= true;

								if (getImmediate(encodedInstr) = MCSR_MSTATUS) then
									temp_mstatus := aluResult;
								elsif (getImmediate(encodedInstr) = MCSR_MIE) then
									temp_mie := aluResult;
								elsif (getImmediate(encodedInstr) = MCSR_MTVEC) then
									temp_mtvec := aluResult;
								elsif (getImmediate(encodedInstr) = MCSR_MEPC) then
									temp_mepc := aluResult;
								elsif (getImmediate(encodedInstr) = MCSR_MCAUSE) then
									temp_mcause := aluResult;
								elsif (getImmediate(encodedInstr) = MCSR_MIP) then
									temp_mip := aluResult;
								end if;

								temp_pc := pcReg_signal + 4;
								next_section := fetch;

							elsif ( (getInstrType(encodedInstr) = INSTR_CSRRWI) or (getInstrType(encodedInstr) = INSTR_CSRRSI) or (getInstrType(encodedInstr) = INSTR_CSRRCI) ) then

								aluOp1 := getRs1Addr(encodedInstr);
								aluOp2 := getCSR(encodedInstr, temp_mstatus,temp_mie,temp_mtvec,temp_mepc,temp_mcause,temp_mip);
								aluResult := getCSRresult(getInstrType(encodedInstr), aluOp1, aluOp2);

								toRegsPort.dst     <= getRdAddr(encodedInstr);
								toRegsPort.dstData <= aluOp2;
								toRegsPort_notify  <= true;

								if (getImmediate(encodedInstr) = MCSR_MSTATUS) then
									temp_mstatus := aluResult;
								elsif (getImmediate(encodedInstr) = MCSR_MIE) then
									temp_mie := aluResult;
								elsif (getImmediate(encodedInstr) = MCSR_MTVEC) then
									temp_mtvec := aluResult;
								elsif (getImmediate(encodedInstr) = MCSR_MEPC) then
									temp_mepc := aluResult;
								elsif (getImmediate(encodedInstr) = MCSR_MCAUSE) then
									temp_mcause := aluResult;
								elsif (getImmediate(encodedInstr) = MCSR_MIP) then
									temp_mip := aluResult;
								end if;

								temp_pc := pcReg_signal + 4;
								next_section := fetch;

							elsif ( getInstrType(encodedInstr) = INSTR_PRIV) then
								if (getPrivInstrType(encodedInstr) = INSTR_ECALL) then

									isa_syscall_Port <= true;
									isa_syscall_Port_notify <= true;
									next_section := syscall1;

								elsif (getPrivInstrType(encodedInstr) = INSTR_EBREAK) then
									sysRES <= false;
									temp_pc := pcReg_signal;
									next_section := fetch;

								elsif (getPrivInstrType(encodedInstr) = INSTR_MRET) then

									temp_mstatus := (temp_mstatus or (X"00000008"));
									temp_mcause := to_unsigned(0,32);
									temp_pc := temp_mepc;
									next_section := fetch;

								else

									temp_pc := pcReg_signal + 4;
									next_section := fetch;

								end if; -- getPrivInstrType
							else

								temp_pc := pcReg_signal;
								next_section := fetch;

							end if;

						else

							temp_pc := pcReg_signal;
							next_section := fetch;

						end if;

					else
						fromMemoryPort_notify <= true;
						isa_syscall_Port_notify <= false;
						syscall_isa_Port_notify <= false;
						toMemoryPort_notify <= false;
						toRegsPort_notify <= false;
						next_section := section;
					end if; -- (fromMemoryPort_sync = true)

				--end (section = excute)

				-- Write data to memory
				elsif (section = store) then
					if (toMemoryPort_sync = true) then
						temp_pc := pcReg_signal + 4;
						next_section := fetch;
					else
						fromMemoryPort_notify <= false;
						isa_syscall_Port_notify <= false;
						syscall_isa_Port_notify <= false;
						toMemoryPort_notify <= true;
						toRegsPort_notify <= false;
						next_section := store;
					end if;

				-- Request data from memory
				elsif (section = load1) then
					if (toMemoryPort_sync = true) then
						toMemoryPort_notify <= false;
						fromMemoryPort_notify <= true;
						next_section := load2;
					else
						fromMemoryPort_notify <= false;
						isa_syscall_Port_notify <= false;
						syscall_isa_Port_notify <= false;
						toMemoryPort_notify <= true;
						toRegsPort_notify <= false;
						next_section := load1;
					end if;

				-- Receive data and writeback to register-file
				elsif (section = load2) then
					if (fromMemoryPort_sync = true) then
						fromMemoryPort_notify <= false;

						toRegsPort.dstData <= fromMemoryPort.loadedData;
						toRegsPort_notify  <= true;

						temp_pc := pcReg_signal + 4;
						next_section := fetch;
					else
						fromMemoryPort_notify <= true;
						isa_syscall_Port_notify <= false;
						syscall_isa_Port_notify <= false;
						toMemoryPort_notify <= false;
						toRegsPort_notify <= false;
						next_section := load2;
					end if;

				-- Request to SYSCALL Handler
				elsif (section = syscall1) then
					if (isa_syscall_Port_sync = true) then
						isa_syscall_Port_notify <= false;
						syscall_isa_Port_notify <= true;
						next_section := syscall2;
					else
						isa_syscall_Port <= true;
						fromMemoryPort_notify <= false;
						isa_syscall_Port_notify <= true;
						syscall_isa_Port_notify <= false;
						toMemoryPort_notify <= false;
						toRegsPort_notify <= false;
						next_section := syscall1;
					end if;

				-- Receive from SYSCALL Handler
				elsif (section = syscall2) then
					if (syscall_isa_Port_sync = true) then
						sysRES <= syscall_isa_Port;
						syscall_isa_Port_notify <= false;

						temp_pc := pcReg_signal + 4;
						next_section := fetch;
					else
						fromMemoryPort_notify <= false;
						isa_syscall_Port_notify <= false;
						syscall_isa_Port_notify <= true;
						toMemoryPort_notify <= false;
						toRegsPort_notify <= false;
						next_section := syscall2;
					end if;
				end if; -- section

				if (next_section = fetch) then

					temp_mip := mip_isa_Port;
					temp_mcause := updateMCAUSE(temp_mstatus, temp_mie, temp_mip, temp_mcause);
					temp_mepc := updateMEPC(temp_mstatus, temp_mie, temp_mip, temp_mcause, temp_mepc, temp_pc);
					temp_pc := updatePC(temp_mstatus, temp_mie, temp_mip, temp_mcause, temp_mtvec, temp_pc);
					temp_mstatus := updateMSTATUS(temp_mstatus, temp_mie, temp_mip, temp_mcause);

					csr_mie_signal <= temp_mie;
					csr_mip_signal <= temp_mip;
					csr_mepc_signal <= temp_mepc;
					csr_mtvec_signal <= temp_mtvec;
					csr_mcause_signal <= temp_mcause;
					csr_mstatus_signal <= temp_mstatus;
					pcReg_signal <= temp_pc;
				
					isa_syscall_Port_notify <= false;
					syscall_isa_Port_notify <= false;

					toMemoryPort.addrIn <= temp_pc;
					toMemoryPort.dataIn <= to_unsigned(0,32);
					toMemoryPort.mask <= MT_W;
					toMemoryPort.req <= ME_RD;
					toMemoryPort_notify <= true;
				end if;

				section <= next_section;
			end if; -- else(section = fetch)
			
		end if; -- rst
	end if; -- clk
end process;
end ISA_arch;