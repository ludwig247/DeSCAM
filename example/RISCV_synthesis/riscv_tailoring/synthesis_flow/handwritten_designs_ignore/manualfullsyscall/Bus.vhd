--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 30.11.18
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity CoreBus is
port(
	clk							: in std_logic;
	rst							: in std_logic;

	--------------- CPU - Bus ---------------
	--  blocking_in<CUtoME_IF> syscall_bus_port_sig
	syscall_bus_port_sig		: in CUtoME_IF;
	syscall_bus_port_sync	: in bool;
	syscall_bus_port_notify	: out bool;

	--  blocking_in<CUtoME_IF> isa_bus_port_sig
	isa_bus_port_sig			: in CUtoME_IF;
	isa_bus_port_sync		: in bool;
	isa_bus_port_notify		: out bool;


	--  blocking_out<MEtoCP_IF> bus_syscall_port_sig
	bus_syscall_port_sig		: out MEtoCU_IF;
	bus_syscall_port_sync	: in bool;
	bus_syscall_port_notify	: out bool;

	--  blocking_out<MEtoCP_IF> bus_isa_port_sig
	bus_isa_port_sig			: out MEtoCU_IF;
	bus_isa_port_sync		: in bool;
	bus_isa_port_notify		: out bool;


	--------------- Bus - Memory ---------------
	--  blocking_out<CUtoME_IF> BUS_MEM_port_sig
	BUStoMEM_port_sig			: out CUtoME_IF;
	BUStoMEM_port_sync		: in bool;
	BUStoMEM_port_notify		: out bool;

	--  blocking_in<MEtoCP_IF> BUS_MEM_port_sig
	MEMtoBUS_port_sig			: in MEtoCU_IF;
	MEMtoBUS_port_sync		: in bool;
	MEMtoBUS_port_notify		: out bool;


	--------------- Bus - CLINT ---------------
	--  blocking_out<CUtoME_IF> BUS_CLINT_port_sig
	BUStoCLINT_port_sig			: out CUtoME_IF;
	BUStoCLINT_port_sync		: in bool;
	BUStoCLINT_port_notify	: out bool;

	--  blocking_in<MEtoCP_IF> BUS_CLINT_port_sig
	CLINTtoBUS_port_sig				: in MEtoCU_IF;
	CLINTtoBUS_port_sync		: in bool;
	CLINTtoBUS_port_notify	: out bool
);
end CoreBus;

architecture CoreBus_arch of CoreBus is

type COREBUS_SECTIONS is (isa_bus_read, isa_bus_mem_write, isa_bus_mem_read, bus_isa_mem_write,
                                        isa_bus_clint_write, isa_bus_clint_read, bus_isa_clint_write,
                          syscall_bus_read, syscall_bus_mem_write, syscall_bus_mem_read, bus_syscall_write );
signal section : COREBUS_SECTIONS;

signal memoryRequest : CUtoME_IF;
signal memoryResponse : MEtoCU_IF;

begin

	process(clk)	
	begin
		if(clk='1' and clk'event) then

			-- Reset Sequence
			if rst = '1' then
				memoryRequest.addrIn <= (others => '0');
				memoryRequest.dataIn <= (others => '0');
				memoryRequest.mask <= MT_B;
				memoryRequest.req <= ME_RD;
				memoryResponse.loadedData <= (others => '0');
				BUStoCLINT_port_notify <= false;
				BUStoMEM_port_notify <= false;
				CLINTtoBUS_port_notify <= false;
				MEMtoBUS_port_notify <= false;
				bus_isa_port_notify <= false;
				bus_syscall_port_notify <= false;
				isa_bus_port_notify <= true;
				syscall_bus_port_notify <= false;
				section <= isa_bus_read;
			else
				
				if section = isa_bus_read then

					isa_bus_port_notify <= false;

					if isa_bus_port_sync = true then

						memoryRequest.addrIn <= isa_bus_port_sig.addrIn;
						memoryRequest.dataIn <= isa_bus_port_sig.dataIn;
						memoryRequest.mask <= isa_bus_port_sig.mask;
						memoryRequest.req <= isa_bus_port_sig.req;

						if ( (isa_bus_port_sig.addrIn >= MEM_START_ADDR) and (isa_bus_port_sig.addrIn < MEM_END_ADDR) ) then

							BUStoMEM_port_sig.addrIn <= isa_bus_port_sig.addrIn;
							BUStoMEM_port_sig.dataIn <= isa_bus_port_sig.dataIn;
							BUStoMEM_port_sig.mask <= isa_bus_port_sig.mask;
							BUStoMEM_port_sig.req <= isa_bus_port_sig.req;

							BUStoMEM_port_notify <= true;
							section <= isa_bus_mem_write;

						elsif ( (isa_bus_port_sig.addrIn >= CLINT_START_ADDR) and (isa_bus_port_sig.addrIn < CLINT_END_ADDR) ) then

							BUStoCLINT_port_sig.addrIn <= isa_bus_port_sig.addrIn;
							BUStoCLINT_port_sig.dataIn <= isa_bus_port_sig.dataIn;
							BUStoCLINT_port_sig.mask <= isa_bus_port_sig.mask;
							BUStoCLINT_port_sig.req <= isa_bus_port_sig.req;

							BUStoCLINT_port_notify <= true;
							section <= isa_bus_clint_write;

						else -- not a valid address => go back to reading a new CPU request

							syscall_bus_port_notify <= true;
							section <= syscall_bus_read;

						end if;
					else

						syscall_bus_port_notify <= true;
						section <= syscall_bus_read;

					end if;



				elsif section = isa_bus_mem_write then
					if BUStoMEM_port_sync = true then
						BUStoMEM_port_notify <= false;

						if ( memoryRequest.req = ME_RD ) then
							MEMtoBUS_port_notify <= true;
							section <= isa_bus_mem_read;
						else
							syscall_bus_port_notify <= true;
							section <= syscall_bus_read;
						end if;
					else
						BUStoMEM_port_notify <= true;
						section <= isa_bus_mem_write;
					end if;

				elsif section = isa_bus_mem_read then
					if MEMtoBUS_port_sync = true then
						MEMtoBUS_port_notify <= false;

						bus_isa_port_sig <= MEMtoBUS_port_sig;
						memoryResponse <= MEMtoBUS_port_sig;
						bus_isa_port_notify <= true;
						section <= bus_isa_mem_write;
					else
						MEMtoBUS_port_notify <= true;
						section <= isa_bus_mem_read;
					end if;

				elsif section = bus_isa_mem_write then
					if bus_isa_port_sync = true then
						bus_isa_port_notify <= false;

						syscall_bus_port_notify <= true;
						section <= syscall_bus_read;
					else
						bus_isa_port_notify <= true;
						section <= bus_isa_mem_write;
					end if;



				elsif section = isa_bus_clint_write then
					if BUStoCLINT_port_sync = true then
						BUStoCLINT_port_notify <= false;

						if ( memoryRequest.req = ME_RD ) then
							CLINTtoBUS_port_notify <= true;
							section <= isa_bus_clint_read;
						else
							syscall_bus_port_notify <= true;
							section <= syscall_bus_read;
						end if;
					else
						BUStoCLINT_port_notify <= true;
						section <= isa_bus_clint_write;
					end if;

				elsif section = isa_bus_clint_read then
					if CLINTtoBUS_port_sync = true then
						CLINTtoBUS_port_notify <= false;

						bus_isa_port_sig <= CLINTtoBUS_port_sig;
						memoryResponse <= CLINTtoBUS_port_sig;
						bus_isa_port_notify <= true;
						section <= bus_isa_clint_write;
					else
						CLINTtoBUS_port_notify <= true;
						section <= isa_bus_clint_read;
					end if;

				elsif section = bus_isa_clint_write then
					if bus_isa_port_sync = true then
						bus_isa_port_notify <= false;

						syscall_bus_port_notify <= true;
						section <= syscall_bus_read;
					else
						bus_isa_port_notify <= true;
						section <= bus_isa_clint_write;
					end if;


				elsif section = syscall_bus_read then

					syscall_bus_port_notify <= false;

					if syscall_bus_port_sync = true then

						memoryRequest.addrIn <= syscall_bus_port_sig.addrIn;
						memoryRequest.dataIn <= syscall_bus_port_sig.dataIn;
						memoryRequest.mask <= syscall_bus_port_sig.mask;
						memoryRequest.req <= syscall_bus_port_sig.req;

						if ( (syscall_bus_port_sig.addrIn >= MEM_START_ADDR) and (syscall_bus_port_sig.addrIn < MEM_END_ADDR) ) then

							BUStoMEM_port_sig.addrIn <= syscall_bus_port_sig.addrIn;
							BUStoMEM_port_sig.dataIn <= syscall_bus_port_sig.dataIn;
							BUStoMEM_port_sig.mask <= syscall_bus_port_sig.mask;
							BUStoMEM_port_sig.req <= syscall_bus_port_sig.req;

							BUStoMEM_port_notify <= true;
							section <= syscall_bus_mem_write;

						else -- not a valid address => go back to reading a new CPU request

							isa_bus_port_notify <= true;
							section <= isa_bus_read;

						end if;
					else
						isa_bus_port_notify <= true;
						section <= isa_bus_read;
					end if;

				elsif section = syscall_bus_mem_write then
					if BUStoMEM_port_sync = true then
						BUStoMEM_port_notify <= false;

						if ( memoryRequest.req = ME_RD ) then
							MEMtoBUS_port_notify <= true;
							section <= syscall_bus_mem_read;
						else
							isa_bus_port_notify <= true;
							section <= isa_bus_read;
						end if;
					else
						BUStoMEM_port_notify <= true;
						section <= syscall_bus_mem_write;
					end if;

				elsif section = syscall_bus_mem_read then
					if MEMtoBUS_port_sync = true then
						MEMtoBUS_port_notify <= false;

						bus_syscall_port_sig <= MEMtoBUS_port_sig;
						memoryResponse <= MEMtoBUS_port_sig;
						bus_syscall_port_notify <= true;
						section <= bus_syscall_write;
					else
						MEMtoBUS_port_notify <= true;
						section <= syscall_bus_mem_read;
					end if;

				elsif section = bus_syscall_write then
					if bus_syscall_port_sync = true then
						bus_syscall_port_notify <= false;

						isa_bus_port_notify <= true;
						section <= isa_bus_read;
					else
						bus_syscall_port_notify <= true;
						section <= bus_syscall_write;
					end if;

				end if; -- SECTION
			end if; -- RST
		end if; -- CLK
	end process;
end CoreBus_arch;