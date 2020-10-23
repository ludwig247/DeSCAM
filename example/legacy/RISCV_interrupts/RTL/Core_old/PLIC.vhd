--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18
--
-- Module: Platform Level Interrupt Controller (PLIC)
--
-- Only for simulation purposes (has no effect at the moment). Not part of CPU.
-- Consists of 5 32-bit registers (Little Endian).
-- 	- priority_reg
-- 	- pending_reg
-- 	- interrupt_enables
-- 	- threshold
-- 	- claimComplete
-- Used to prioritizes and distributes global interrupts
--		if priority_reg pass threshold, an interrupt will be sent to the CPU
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity PLIC is
	port(
		clk						: in  std_logic;
		rst						: in  std_logic;
		CPUtoMEM_port			: in  CUtoME_IF;
		CPUtoMEM_port_sync	: in  boolean;
		CPUtoMEM_port_notify	: out boolean;
		MEMtoCPU_port			: out MEtoCP_IF;
		MEMtoCPU_port_sync	: in  boolean;
		MEMtoCPU_port_notify	: out boolean;
		--slave_out<bool> MEIP_port;
		MEIP_port				: out bool
	);
end PLIC;

architecture PLIC_arch of PLIC is
	-- Memory Management type and signal
	type mem_sections_type is (read, write);
	signal section : mem_sections_type;

	-- Memory Mapped registers
	signal priority_reg			: unsigned (31 downto 0);
	signal pending_reg			: unsigned (31 downto 0);
	signal interrupt_enables	: unsigned (31 downto 0);
	signal threshold				: unsigned (31 downto 0);
	signal claimComplete			: unsigned (31 downto 0);

begin

	run : process(clk)
		begin
			if(clk='1' and clk'event) then
				if rst = '1' then
					MEIP_port <= false;
				else
					if (priority_reg > threshold) then
						MEIP_port <= true;
					else
						MEIP_port <= false;
					end if;
			end if; -- RST
		end if; -- CLK
	end process run;


	manage_memory : process(clk)
		begin
			if(clk='1' and clk'event) then
				if rst = '1' then
					priority_reg <= (others => '0');
					pending_reg <= (others => '0');
					interrupt_enables <= (others => '0');
					threshold <= (others => '0');
					claimComplete <= (others => '0');
					section <= read;
					MEMtoCPU_port.loadedData <= (others => '0');
					CPUtoMEM_port_notify <= true;
					MEMtoCPU_port_notify <= false;
				else
					if section = read then
						if CPUtoMEM_port_sync = true then
							if (CPUtoMEM_port.req = ME_RD) and (CPUtoMEM_port.mask = MT_W) then -- READ
								
								if (CPUtoMEM_port.addrIn = PLIC_Priority_ADDR) then
									MEMtoCPU_port.loadedData <= priority_reg;
								
								elsif (CPUtoMEM_port.addrIn = PLIC_Pending_ADDR) then
									MEMtoCPU_port.loadedData <= pending_reg;
								
								elsif (CPUtoMEM_port.addrIn = PLIC_Interrupt_Enables_ADDR) then
									MEMtoCPU_port.loadedData <= interrupt_enables;
								
								elsif (CPUtoMEM_port.addrIn = PLIC_Threshold_ADDR) then
									MEMtoCPU_port.loadedData <= threshold;
								
								elsif (CPUtoMEM_port.addrIn = PLIC_Claim_Complete_ADDR) then
									MEMtoCPU_port.loadedData <= claimComplete;
								
								end if;
								-- write back to CPU
								CPUtoMEM_port_notify <= false;
								MEMtoCPU_port_notify <= true;
								section <= write;
							elsif (CPUtoMEM_port.req = ME_WR) and (CPUtoMEM_port.mask = MT_W) then -- WRITE
								
								if (CPUtoMEM_port.addrIn = PLIC_Priority_ADDR) then
									priority_reg <= CPUtoMEM_port.dataIn;
								
								elsif (CPUtoMEM_port.addrIn = PLIC_Pending_ADDR) then
									pending_reg <= CPUtoMEM_port.dataIn;
								
								elsif (CPUtoMEM_port.addrIn = PLIC_Interrupt_Enables_ADDR) then
									interrupt_enables <= CPUtoMEM_port.dataIn;
								
								elsif (CPUtoMEM_port.addrIn = PLIC_Threshold_ADDR) then
									threshold <= CPUtoMEM_port.dataIn;
								
								elsif (CPUtoMEM_port.addrIn = PLIC_Claim_Complete_ADDR) then
									claimComplete <= CPUtoMEM_port.dataIn;
								
								end if;
								-- wait for a new request from CPU
								CPUtoMEM_port_notify <= true;
								MEMtoCPU_port_notify <= false;
								section <= read;
							end if;
						end if;
					elsif section = write then
						if MEMtoCPU_port_sync = true then
							MEMtoCPU_port_notify <= false;
							CPUtoMEM_port_notify <= true;
							section <= read;
						end if;
					end if; -- SECTION
				end if; -- RST
			end if; -- CLK
	end process manage_memory;
end PLIC_arch;
