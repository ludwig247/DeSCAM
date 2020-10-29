--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18
--
-- Module: Core Local Interruptor (CLINT)
--
-- Only for simulation purposes. Not part of CPU.
-- Consists of 1 32-bit and 2 64-bit registers (Little Endian).
-- 	- msip_reg
-- 	- mtime_reg
-- 	- mtimecmp_reg
-- Used to generate Software and Timer Interrupts.
--		- The msip memory mapped CSR can be used to generate Machine Software Interrupts.
--			This register can be accessed by remote harts to provide machine-mode interprocessor interrupt.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity CLINT is
	port(
		clk						: in  std_logic;
		rst						: in  std_logic;
		CPUtoMEM_port			: in  CUtoME_IF;
		CPUtoMEM_port_sync	: in  boolean;
		CPUtoMEM_port_notify	: out boolean;
		MEMtoCPU_port			: out MEtoCP_IF;
		MEMtoCPU_port_sync	: in  boolean;
		MEMtoCPU_port_notify	: out boolean;
		--slave_out<bool> MSIP_port;
		MSIP_port				: out bool;
		--slave_out<bool> MTIP_port;
		MTIP_port				: out bool
	);
end CLINT;

architecture CLINT_arch of CLINT is
	-- Memory Management type and signal
	type mem_sections_type is (read, write);
	signal section : mem_sections_type;

	-- Memory Mapped registers
	signal msip_reg		: unsigned (31 downto 0);
	signal mtime_reg		: unsigned (63 downto 0);
	signal mtimecmp_reg	: unsigned (63 downto 0);

begin

	run_msip : process(clk)
		begin
			if(clk='1' and clk'event) then
				if rst = '1' then
					MSIP_port <= false;
				else
					if (msip_reg > to_unsigned(0, 32)) then
						MSIP_port <= true;
					else
						MSIP_port <= false;
					end if;
			end if; -- RST
		end if; -- CLK
	end process run_msip;

	run_mtip : process(clk)
		begin
			if(clk='1' and clk'event) then
				if rst = '1' then
					MTIP_port <= false;
				else
					if (mtime_reg > mtimecmp_reg) then
						MTIP_port <= true;
					else
						MTIP_port <= false;
					end if;
			end if; -- RST
		end if; -- CLK
	end process run_mtip;


	manage_memory : process(clk)
		begin
			if(clk='1' and clk'event) then
				if rst = '1' then
					-- Specify Program to be loaded into Memory
					msip_reg <= (others => '0');
					mtime_reg <= (others => '0');
					mtimecmp_reg <= (others => '0');
					section <= read;
					MEMtoCPU_port.loadedData <= (others => '0');
					CPUtoMEM_port_notify <= true;
					MEMtoCPU_port_notify <= false;
				else
					if section = read then
						if CPUtoMEM_port_sync = true then
							if (CPUtoMEM_port.req = ME_RD) and (CPUtoMEM_port.mask = MT_W) then -- READ
								
								if (CPUtoMEM_port.addrIn = CLINT_msip_ADDR) then
									MEMtoCPU_port.loadedData <= msip_reg;
								
								elsif (CPUtoMEM_port.addrIn = CLINT_mtimecmp_ADDR) then
									MEMtoCPU_port.loadedData <= mtimecmp_reg(31 downto 0);
								
								elsif (CPUtoMEM_port.addrIn = CLINT_mtimecmp_ADDR + 4) then
									MEMtoCPU_port.loadedData <= mtimecmp_reg(63 downto 32);
								
								elsif (CPUtoMEM_port.addrIn = CLINT_mtime_ADDR) then
									MEMtoCPU_port.loadedData <= mtime_reg(31 downto 0);
								
								elsif (CPUtoMEM_port.addrIn = CLINT_mtime_ADDR + 4) then
									MEMtoCPU_port.loadedData <= mtime_reg(63 downto 32);
								
								end if;
								-- write back to CPU
								CPUtoMEM_port_notify <= false;
								MEMtoCPU_port_notify <= true;
								section <= write;
								mtime_reg <= mtime_reg + 1;

							elsif (CPUtoMEM_port.req = ME_WR) and (CPUtoMEM_port.mask = MT_W) then -- WRITE

								if (CPUtoMEM_port.addrIn = CLINT_msip_ADDR) then
									msip_reg <= CPUtoMEM_port.dataIn;
									mtime_reg <= mtime_reg + 1;

								elsif (CPUtoMEM_port.addrIn = CLINT_mtimecmp_ADDR) then
									mtimecmp_reg(31 downto 0) <= CPUtoMEM_port.dataIn;
									mtime_reg <= mtime_reg + 1;

								elsif (CPUtoMEM_port.addrIn = CLINT_mtimecmp_ADDR + 4) then
									mtimecmp_reg(63 downto 32) <= CPUtoMEM_port.dataIn;
									mtime_reg <= mtime_reg + 1;

								elsif (CPUtoMEM_port.addrIn = CLINT_mtime_ADDR) then
									mtime_reg(31 downto 0) <= CPUtoMEM_port.dataIn;
									--mtime_reg <= mtime_reg + 1;

								elsif (CPUtoMEM_port.addrIn = CLINT_mtime_ADDR + 4) then
									mtime_reg(63 downto 32) <= CPUtoMEM_port.dataIn;
									--mtime_reg <= mtime_reg + 1;

								end if;
								-- wait for a new request from CPU
								CPUtoMEM_port_notify <= true;
								MEMtoCPU_port_notify <= false;
								section <= read;
							end if;
						else
							mtime_reg <= mtime_reg + 1;
						end if;
					elsif section = write then
						if MEMtoCPU_port_sync = true then
							MEMtoCPU_port_notify <= false;
							CPUtoMEM_port_notify <= true;
							section <= read;
						end if;
						mtime_reg <= mtime_reg + 1;
					end if; -- SECTION

				end if; -- RST
			end if; -- CLK
	end process manage_memory;
end CLINT_arch;
