--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity CoreBus is
port(
	clk							: in std_logic;
	rst							: in std_logic;

	--------------- CPU to Peripherals ---------------
	--  blocking_in<CUtoME_IF> COtoBUS_port
	CPU_BUS_Port				: in CUtoME_IF;
	CPU_BUS_Port_sync			: in bool;
	CPU_BUS_Port_notify		: out bool;

	--  blocking_out<CUtoME_IF> BUS_MEM_Port
	BUS_MEM_Port				: out CUtoME_IF;
	BUS_MEM_Port_sync			: in bool;
	BUS_MEM_Port_notify		: out bool;

	--  blocking_out<CUtoME_IF> BUS_CLINT_Port
	BUS_CLINT_Port				: out CUtoME_IF;
	BUS_CLINT_Port_sync		: in bool;
	BUS_CLINT_Port_notify	: out bool;

	--  blocking_out<CUtoME_IF> BUS_PLIC_Port
	BUS_PLIC_Port				: out CUtoME_IF;
	BUS_PLIC_Port_sync		: in bool;
	BUS_PLIC_Port_notify		: out bool;


	--------------- Peripherals to CPU ---------------
	--  blocking_in<MEtoCP_IF> BUS_MEM_Port
	MEM_BUS_Port				: in MEtoCP_IF;
	MEM_BUS_Port_sync			: in bool;
	MEM_BUS_Port_notify		: out bool;

	--  blocking_in<MEtoCP_IF> BUS_CLINT_Port
	CLINT_BUS_Port				: in MEtoCP_IF;
	CLINT_BUS_Port_sync		: in bool;
	CLINT_BUS_Port_notify	: out bool;

	--  blocking_in<MEtoCP_IF> BUS_PLIC_Port
	PLIC_BUS_Port				: in MEtoCP_IF;
	PLIC_BUS_Port_sync		: in bool;
	PLIC_BUS_Port_notify		: out bool;

	--  blocking_out<MEtoCP_IF> BUStoCO_port
	BUS_CPU_Port				: out MEtoCP_IF;
	BUS_CPU_Port_sync			: in bool;
	BUS_CPU_Port_notify		: out bool
);
end CoreBus;

architecture CoreBus_arch of CoreBus is

-- Memory Management type and signal
type mem_sections_type is (read, write_mem, write_clint, write_plic, read_mem, read_clint, read_plic, write);
signal section : mem_sections_type;

signal memoryRequest : CUtoME_IF;
signal memoryResponse : MEtoCP_IF;

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
				BUS_CLINT_Port_notify <= false;
				BUS_CPU_Port_notify <= false;
				BUS_MEM_Port_notify <= false;
				BUS_PLIC_Port_notify <= false;
				CLINT_BUS_Port_notify <= false;
				CPU_BUS_Port_notify <= true;
				MEM_BUS_Port_notify <= false;
				PLIC_BUS_Port_notify <= false;
				section <= read;
			else
				
				if section = read then
					if CPU_BUS_Port_sync = true then

						memoryRequest.addrIn <= CPU_BUS_Port.addrIn;
						memoryRequest.dataIn <= CPU_BUS_Port.dataIn;
						memoryRequest.mask <= CPU_BUS_Port.mask;
						memoryRequest.req <= CPU_BUS_Port.req;

						if ( (CPU_BUS_Port.addrIn >= MEM_START_ADDR) and (CPU_BUS_Port.addrIn < MEM_END_ADDR) ) then
							CPU_BUS_Port_notify <= false;

							BUS_MEM_Port.addrIn <= CPU_BUS_Port.addrIn;
							BUS_MEM_Port.dataIn <= CPU_BUS_Port.dataIn;
							BUS_MEM_Port.mask <= CPU_BUS_Port.mask;
							BUS_MEM_Port.req <= CPU_BUS_Port.req;
							BUS_MEM_Port_notify <= true;
							BUS_CLINT_Port_notify <= false;
							BUS_PLIC_Port_notify <= false;
							section <= write_mem;

						elsif ( (CPU_BUS_Port.addrIn >= CLINT_START_ADDR) and (CPU_BUS_Port.addrIn < CLINT_END_ADDR) ) then
							CPU_BUS_Port_notify <= false;

							BUS_CLINT_Port.addrIn <= CPU_BUS_Port.addrIn;
							BUS_CLINT_Port.dataIn <= CPU_BUS_Port.dataIn;
							BUS_CLINT_Port.mask <= CPU_BUS_Port.mask;
							BUS_CLINT_Port.req <= CPU_BUS_Port.req;
							BUS_MEM_Port_notify <= false;
							BUS_CLINT_Port_notify <= true;
							BUS_PLIC_Port_notify <= false;
							section <= write_clint;

						elsif ( (CPU_BUS_Port.addrIn >= PLIC_START_ADDR) and (CPU_BUS_Port.addrIn < PLIC_END_ADDR) ) then
							CPU_BUS_Port_notify <= false;

							BUS_PLIC_Port.addrIn <= CPU_BUS_Port.addrIn;
							BUS_PLIC_Port.dataIn <= CPU_BUS_Port.dataIn;
							BUS_PLIC_Port.mask <= CPU_BUS_Port.mask;
							BUS_PLIC_Port.req <= CPU_BUS_Port.req;
							BUS_MEM_Port_notify <= false;
							BUS_CLINT_Port_notify <= false;
							BUS_PLIC_Port_notify <= true;
							section <= write_plic;

						else -- not a valid address => go back to reading a new CPU request
							CPU_BUS_Port_notify <= true;
							section <= read;
						end if;
					else
						CPU_BUS_Port_notify <= true;
						section <= read;
					end if;

				elsif section = write_mem then
					if BUS_MEM_Port_sync = true then
						BUS_MEM_Port_notify <= false;

						if ( memoryRequest.req = ME_RD ) then
							MEM_BUS_Port_notify <= true;
							section <= read_mem;
						else
							CPU_BUS_Port_notify <= true;
							section <= read;
						end if;
					else
						BUS_MEM_Port_notify <= true;
						section <= write_mem;
					end if;

				elsif section = write_clint then
					if BUS_CLINT_Port_sync = true then
						BUS_CLINT_Port_notify <= false;

						if ( memoryRequest.req = ME_RD ) then
							CLINT_BUS_Port_notify <= true;
							section <= read_clint;
						else
							CPU_BUS_Port_notify <= true;
							section <= read;
						end if;
					else
						BUS_CLINT_Port_notify <= true;
						section <= write_clint;
					end if;

				elsif section = write_plic then
					if BUS_PLIC_Port_sync = true then
						BUS_PLIC_Port_notify <= false;

						if ( memoryRequest.req = ME_RD ) then
							PLIC_BUS_Port_notify <= true;
							section <= read_plic;
						else
							CPU_BUS_Port_notify <= true;
							section <= read;
						end if;
					else
						BUS_PLIC_Port_notify <= true;
						section <= write_plic;
					end if;


				elsif section = read_mem then
					if MEM_BUS_Port_sync = true then
						MEM_BUS_Port_notify <= false;

						BUS_CPU_Port <= MEM_BUS_Port;
						memoryResponse <= MEM_BUS_Port;
						BUS_CPU_Port_notify <= true;
						section <= write;
					else
						MEM_BUS_Port_notify <= true;
						section <= read_mem;
					end if;

				elsif section = read_clint then
					if CLINT_BUS_Port_sync = true then
						CLINT_BUS_Port_notify <= false;

						BUS_CPU_Port <= CLINT_BUS_Port;
						memoryResponse <= CLINT_BUS_Port;
						BUS_CPU_Port_notify <= true;
						section <= write;
					else
						CLINT_BUS_Port_notify <= true;
						section <= read_clint;
					end if;

				elsif section = read_plic then
					if PLIC_BUS_Port_sync = true then
						PLIC_BUS_Port_notify <= false;

						BUS_CPU_Port <= PLIC_BUS_Port;
						memoryResponse <= PLIC_BUS_Port;
						BUS_CPU_Port_notify <= true;
						section <= write;
					else
						PLIC_BUS_Port_notify <= true;
						section <= read_plic;
					end if;


				elsif section = write then
					if BUS_CPU_Port_sync = true then
						BUS_CPU_Port_notify <= false;

						CPU_BUS_Port_notify <= true;
						section <= read;
					else
						BUS_CPU_Port_notify <= true;
						section <= write;
					end if;

				end if; -- SECTION
			end if; -- RST
		end if; -- CLK
	end process;
end CoreBus_arch;