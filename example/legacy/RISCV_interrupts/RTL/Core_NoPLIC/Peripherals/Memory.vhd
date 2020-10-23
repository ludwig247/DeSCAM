--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18
--
-- Module: Memory
--
-- Only for simulation purposes. Not part of CPU. Consists of "MEM_DEPTH" 8-bit cells. Little Endian.
-- A .hex file can be specified to be pre-loaded into Memory.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.SCAM_Model_types.all;

entity Memory is
	port(    
		clk						: in  std_logic;
		rst						: in  std_logic;
		CPUtoMEM_port			: in  CUtoME_IF;
		CPUtoMEM_port_sync	: in  bool;
		CPUtoMEM_port_notify	: out bool;
		MEMtoCPU_port			: out MEtoCU_IF;
		MEMtoCPU_port_sync	: in  bool;
		MEMtoCPU_port_notify	: out bool
	);
end Memory;

architecture Memory_arch of Memory is
	-- Define types
	type ram_type is array (0 to MEM_DEPTH) of Unsigned (7 downto 0);
	type mem_sections_type is (read, write);

	-- Define signals
	signal section : mem_sections_type;
	signal ram     : ram_type;

impure function InitMemFromFile (MemFileName: in string) return ram_type is
	file MemFile : text is in MemFileName;
	variable MemFileLine : line;
	variable ram : ram_type;
	variable temp : std_logic_vector (31 downto 0);
	variable j : integer;
	begin
		-- Function for reading .hex file and storing it into Memory (starting at Address 0)
		for i in ram_type'range loop
			j := i mod 4;
			if (j = 0) and not endfile(MemFile) then
				readline(MemFile, MemFileLine);
				hread(MemFileLine, temp);
			elsif (j = 0) then
				temp := (others => '0');
			end if;
			ram(i) := unsigned(temp (j*8+7 downto j*8));
		end loop;
		return ram;
end function;

begin
	process(clk)
		variable temp_byte : unsigned (7 downto 0);
		begin
			if(clk='1' and clk'event) then
				if rst = '1' then
					-- Specify Program to be loaded into Memory 
					-- ram <= InitMemFromFile("/import/lab/users/altaleb/SCAM/example/RISCV_Test_ELF/Programs/Fibonacci_c/Fibonacci.hex");
					-- ram <= InitMemFromFile("/import/lab/users/altaleb/SCAM/example/RISCV_Test_ELF/Programs/BubbleSort_c/BubbleSort.hex");
					-- ram <= InitMemFromFile("/import/lab/users/altaleb/SCAM/example/RISCV_Test_ELF/Programs/Prime_c/Prime.hex");

					-- ram <= InitMemFromFile("/import/lab/users/altaleb/SCAM/example/RISCV_Test_ELF/Programs/fibonacci.hex");

					-- ram <= InitMemFromFile("/import/lab/users/altaleb/SCAM/example/RISCV_interrupts/Examples/PrintMessage/PrintMessage.hex");
					ram <= InitMemFromFile("/import/lab/users/altaleb/SCAM/example/RISCV_interrupts/Examples/Timer/Timer.hex");
					-- ram <= InitMemFromFile("/import/lab/users/altaleb/SCAM/example/RISCV_interrupts/Examples/Externals/Externals.hex");
					-- ram <= InitMemFromFile("/import/lab/users/altaleb/SCAM/example/RISCV_interrupts/Examples/FreeRTOS/Demo/riscv-spike/riscv-spike.hex");
					-- ram <= InitMemFromFile("/import/lab/users/altaleb/Work/test_FreeRTOS/FreeRTOS_5000.hex");

					section <= read;
					MEMtoCPU_port.loadedData <= (others => '0');
					CPUtoMEM_port_notify <= true;
					MEMtoCPU_port_notify <= false;
					temp_byte := (others => '0');
				else
					if section = read then
						if CPUtoMEM_port_sync = true then
							if CPUtoMEM_port.req = ME_RD then -- READ								
								-- Read Byte
								if    (CPUtoMEM_port.addrIn < MEM_DEPTH) and (CPUtoMEM_port.mask = MT_BU) then
									MEMtoCPU_port.loadedData <= X"000000" & ram(to_integer(CPUtoMEM_port.addrIn));

								elsif    (CPUtoMEM_port.addrIn < MEM_DEPTH) and (CPUtoMEM_port.mask = MT_B) then
									temp_byte := ram(to_integer(CPUtoMEM_port.addrIn));
									-- Sign-Extend
									if (temp_byte(7) = '1') then
										MEMtoCPU_port.loadedData <= X"FFFFFF" & ram(to_integer(CPUtoMEM_port.addrIn));
									else
										MEMtoCPU_port.loadedData <= X"000000" & ram(to_integer(CPUtoMEM_port.addrIn));
									end if;


								-- Read Halfword
								elsif (CPUtoMEM_port.addrIn < MEM_DEPTH-1) and (CPUtoMEM_port.mask = MT_HU) then
									MEMtoCPU_port.loadedData <= X"0000" 
																		& ram(to_integer(CPUtoMEM_port.addrIn) + 1)
																		& ram(to_integer(CPUtoMEM_port.addrIn));

								-- Read Halfword
								elsif (CPUtoMEM_port.addrIn < MEM_DEPTH-1) and (CPUtoMEM_port.mask = MT_H) then
									temp_byte := ram(to_integer(CPUtoMEM_port.addrIn) + 1);
									-- Sign-Extend
									if (temp_byte(7) = '1') then
										MEMtoCPU_port.loadedData <= X"FFFF"
																	& ram(to_integer(CPUtoMEM_port.addrIn) + 1)
																	& ram(to_integer(CPUtoMEM_port.addrIn));
									else
										MEMtoCPU_port.loadedData <= X"0000"
																	& ram(to_integer(CPUtoMEM_port.addrIn) + 1)
																	& ram(to_integer(CPUtoMEM_port.addrIn));
									end if;


								-- Read Word
								elsif (CPUtoMEM_port.addrIn < MEM_DEPTH-3) and (CPUtoMEM_port.mask = MT_W) then
									MEMtoCPU_port.loadedData <= ram(to_integer(CPUtoMEM_port.addrIn) + 3)
																		& ram(to_integer(CPUtoMEM_port.addrIn) + 2)
																		& ram(to_integer(CPUtoMEM_port.addrIn) + 1)
																		& ram(to_integer(CPUtoMEM_port.addrIn));

								end if;
								-- write back to CPU
								CPUtoMEM_port_notify <= false;
								MEMtoCPU_port_notify <= true;
								section <= write;
							elsif CPUtoMEM_port.req = ME_WR then
								-- WRITE
								if (CPUtoMEM_port.addrIn < MEM_DEPTH) and (CPUtoMEM_port.mask = MT_B) then
									-- Write Byte
									ram(to_integer(CPUtoMEM_port.addrIn)) <= CPUtoMEM_port.dataIn (7 downto 0);
								elsif (CPUtoMEM_port.addrIn < MEM_DEPTH-1) and (CPUtoMEM_port.mask = MT_H) then
									-- Write Halfword
									ram(to_integer(CPUtoMEM_port.addrIn) + 1) <= CPUtoMEM_port.dataIn (15 downto 8);
									ram(to_integer(CPUtoMEM_port.addrIn))     <= CPUtoMEM_port.dataIn ( 7 downto 0);
								elsif (CPUtoMEM_port.addrIn < MEM_DEPTH-3) and (CPUtoMEM_port.mask = MT_W) then
									-- Write Word
									ram(to_integer(CPUtoMEM_port.addrIn) + 3) <= CPUtoMEM_port.dataIn (31 downto 24);
									ram(to_integer(CPUtoMEM_port.addrIn) + 2) <= CPUtoMEM_port.dataIn (23 downto 16);
									ram(to_integer(CPUtoMEM_port.addrIn) + 1) <= CPUtoMEM_port.dataIn (15 downto  8);
									ram(to_integer(CPUtoMEM_port.addrIn))     <= CPUtoMEM_port.dataIn ( 7 downto  0);
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
	end process;
end Memory_arch;
