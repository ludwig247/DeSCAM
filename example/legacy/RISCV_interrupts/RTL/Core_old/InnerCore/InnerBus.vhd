--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity InnerBus is
port(
	clk							: in std_logic;
	rst							: in std_logic;
	
	--  blocking_in<MEtoCP_IF> fromMemoryPort
	fromMemoryPort				: in MEtoCP_IF;
	fromMemoryPort_sync		: in bool;
	fromMemoryPort_notify	: out bool;

	--  blocking_in<CUtoME_IF> isa_bus_Port
	isa_bus_Port				: in CUtoME_IF;
	isa_bus_Port_sync		: in bool;
	isa_bus_Port_notify	: out bool;

	--  blocking_in<CUtoME_IF> syscall_bus_Port
	syscall_bus_Port				: in CUtoME_IF;
	syscall_bus_Port_sync		: in bool;
	syscall_bus_Port_notify	: out bool;

	--  blocking_out<CUtoME_IF> toMemoryPort
	toMemoryPort				: out CUtoME_IF;
	toMemoryPort_sync			: in bool;
	toMemoryPort_notify		: out bool;

	--  blocking_out<MEtoCP_IF> bus_syscall_Port
	bus_syscall_Port				: out MEtoCP_IF;
	bus_syscall_Port_sync			: in bool;
	bus_syscall_Port_notify		: out bool;

	--  blocking_out<MEtoCP_IF> bus_isa_Port
	bus_isa_Port				: out MEtoCP_IF;
	bus_isa_Port_sync			: in bool;
	bus_isa_Port_notify		: out bool
);
end InnerBus;

architecture InnerBus_arch of InnerBus is

signal section : INNERBUS_SECTIONS;
signal memoryRequest : CUtoME_IF;
signal memoryResponse : MEtoCP_IF;

begin

	process(clk)

	variable requestType : ME_AccessType;
	
	begin
		if(clk='1' and clk'event) then

			-- Reset Sequence
			if rst = '1' then
				bus_isa_Port.loadedData <=(others => '0');
				bus_syscall_Port.loadedData <=(others => '0');
				toMemoryPort.addrIn <= (others => '0');
				toMemoryPort.dataIn <= (others => '0');
				toMemoryPort.mask <= MT_B;
				toMemoryPort.req <= ME_RD;
				memoryResponse.loadedData <=(others => '0');
				memoryRequest.addrIn <= (others => '0');
				memoryRequest.dataIn <= (others => '0');
				memoryRequest.mask <= MT_B;
				memoryRequest.req <= ME_RD;
				bus_isa_Port_notify <= false;
				bus_syscall_Port_notify <= false;
				fromMemoryPort_notify <= false;
				isa_bus_Port_notify <= true;
				syscall_bus_Port_notify <= false;
				toMemoryPort_notify <= false;
				section <= isa_bus_read;
			else

				if (section = isa_bus_read) then
					if (isa_bus_Port_sync = true) then
						isa_bus_Port_notify <= false;

						toMemoryPort.addrIn <= isa_bus_Port.addrIn;
						toMemoryPort.dataIn <= isa_bus_Port.dataIn;
						toMemoryPort.mask <= isa_bus_Port.mask;
						toMemoryPort.req <= isa_bus_Port.req;

						memoryRequest.addrIn <= isa_bus_Port.addrIn;
						memoryRequest.dataIn <= isa_bus_Port.dataIn;
						memoryRequest.mask <= isa_bus_Port.mask;
						memoryRequest.req <= isa_bus_Port.req;

						bus_isa_Port_notify <= false;
						bus_syscall_Port_notify <= false;
						fromMemoryPort_notify <= false;
						syscall_bus_Port_notify <= false;
						toMemoryPort_notify <= true;
						section <= isa_bus_mem_read;
					else
						bus_isa_Port_notify <= false;
						bus_syscall_Port_notify <= false;
						fromMemoryPort_notify <= false;
						isa_bus_Port_notify <= false;
						syscall_bus_Port_notify <= true;
						toMemoryPort_notify <= false;
						section <= syscall_bus_read;
					end if;

				elsif (section = isa_bus_mem_read) then
					if (toMemoryPort_sync = true) then
						toMemoryPort_notify <= false;
						bus_isa_Port_notify <= false;
						bus_syscall_Port_notify <= false;
						isa_bus_Port_notify <= false;

						if (memoryRequest.req = ME_RD) then
							fromMemoryPort_notify <= true;
							syscall_bus_Port_notify <= false;
							section <= isa_bus_mem_write;
						else
							fromMemoryPort_notify <= false;
							syscall_bus_Port_notify <= true;
							section <= syscall_bus_read;
						end if;
					else
						bus_isa_Port_notify <= false;
						bus_syscall_Port_notify <= false;
						fromMemoryPort_notify <= false;
						isa_bus_Port_notify <= false;
						syscall_bus_Port_notify <= false;
						toMemoryPort_notify <= true;
						section <= isa_bus_mem_read;
					end if;

				elsif (section = isa_bus_mem_write) then
					if (fromMemoryPort_sync = true) then
						fromMemoryPort_notify <= false;

						bus_isa_Port.loadedData <= fromMemoryPort.loadedData;
						bus_isa_Port_notify <= true;

						memoryResponse.loadedData <= fromMemoryPort.loadedData;

						bus_syscall_Port_notify <= false;
						isa_bus_Port_notify <= false;
						syscall_bus_Port_notify <= false;
						toMemoryPort_notify <= false;
						section <= isa_bus_write;
					else
						bus_isa_Port_notify <= false;
						bus_syscall_Port_notify <= false;
						fromMemoryPort_notify <= true;
						isa_bus_Port_notify <= false;
						syscall_bus_Port_notify <= false;
						toMemoryPort_notify <= false;
						section <= isa_bus_mem_write;
					end if;

				elsif (section = isa_bus_write) then
					if (bus_isa_Port_sync = true) then
						fromMemoryPort_notify <= false;
						bus_isa_Port_notify <= false;
						bus_syscall_Port_notify <= false;
						isa_bus_Port_notify <= false;
						syscall_bus_Port_notify <= true;
						toMemoryPort_notify <= false;
						section <= syscall_bus_read;
					else
						bus_isa_Port.loadedData <= memoryResponse.loadedData;
						bus_isa_Port_notify <= true;
						bus_syscall_Port_notify <= false;
						fromMemoryPort_notify <= false;
						isa_bus_Port_notify <= false;
						syscall_bus_Port_notify <= false;
						toMemoryPort_notify <= false;
						section <= isa_bus_write;
					end if;

				elsif (section = syscall_bus_read) then
					if (syscall_bus_Port_sync = true) then
						syscall_bus_Port_notify <= false;

						toMemoryPort.addrIn <= syscall_bus_Port.addrIn;
						toMemoryPort.dataIn <= syscall_bus_Port.dataIn;
						toMemoryPort.mask <= syscall_bus_Port.mask;
						toMemoryPort.req <= syscall_bus_Port.req;

						memoryRequest.addrIn <= syscall_bus_Port.addrIn;
						memoryRequest.dataIn <= syscall_bus_Port.dataIn;
						memoryRequest.mask <= syscall_bus_Port.mask;
						memoryRequest.req <= syscall_bus_Port.req;

						bus_isa_Port_notify <= false;
						bus_syscall_Port_notify <= false;
						fromMemoryPort_notify <= false;
						isa_bus_Port_notify <= false;
						toMemoryPort_notify <= true;
						section <= syscall_bus_mem_read;
					else
						bus_isa_Port_notify <= false;
						bus_syscall_Port_notify <= false;
						fromMemoryPort_notify <= false;
						isa_bus_Port_notify <= true;
						syscall_bus_Port_notify <= false;
						toMemoryPort_notify <= false;
						section <= isa_bus_read;
					end if;

				elsif (section = syscall_bus_mem_read) then
					if (toMemoryPort_sync = true) then
						toMemoryPort_notify <= false;
						bus_isa_Port_notify <= false;
						bus_syscall_Port_notify <= false;
						syscall_bus_Port_notify <= false;

						if (memoryRequest.req = ME_RD) then
							fromMemoryPort_notify <= true;
							isa_bus_Port_notify <= false;
							section <= syscall_bus_mem_write;
						else
							fromMemoryPort_notify <= false;
							isa_bus_Port_notify <= true;
							section <= isa_bus_read;
						end if;
					else
						bus_isa_Port_notify <= false;
						bus_syscall_Port_notify <= false;
						fromMemoryPort_notify <= false;
						isa_bus_Port_notify <= false;
						syscall_bus_Port_notify <= false;
						toMemoryPort_notify <= true;
						section <= syscall_bus_mem_read;
					end if;

				elsif (section = syscall_bus_mem_write) then
					if (fromMemoryPort_sync = true) then
						fromMemoryPort_notify <= false;

						bus_syscall_Port.loadedData <= fromMemoryPort.loadedData;
						bus_syscall_Port_notify <= true;

						memoryResponse.loadedData <= fromMemoryPort.loadedData;

						bus_isa_Port_notify <= false;
						isa_bus_Port_notify <= false;
						syscall_bus_Port_notify <= false;
						toMemoryPort_notify <= false;
						section <= syscall_bus_write;
					else
						bus_isa_Port_notify <= false;
						bus_syscall_Port_notify <= false;
						fromMemoryPort_notify <= true;
						isa_bus_Port_notify <= false;
						syscall_bus_Port_notify <= false;
						toMemoryPort_notify <= false;
						section <= syscall_bus_mem_write;
					end if;

				elsif (section = syscall_bus_write) then
					if (bus_syscall_Port_sync = true) then
						fromMemoryPort_notify <= false;
						bus_isa_Port_notify <= false;
						bus_syscall_Port_notify <= false;
						isa_bus_Port_notify <= true;
						syscall_bus_Port_notify <= false;
						toMemoryPort_notify <= false;
						section <= isa_bus_read;
					else
						bus_syscall_Port.loadedData <= memoryResponse.loadedData;
						bus_isa_Port_notify <= false;
						bus_syscall_Port_notify <= true;
						fromMemoryPort_notify <= false;
						isa_bus_Port_notify <= false;
						syscall_bus_Port_notify <= false;
						toMemoryPort_notify <= false;
						section <= syscall_bus_write;
					end if;

				end if;

			end if; -- RST
		end if; -- CLK
	end process;
end InnerBus_arch;