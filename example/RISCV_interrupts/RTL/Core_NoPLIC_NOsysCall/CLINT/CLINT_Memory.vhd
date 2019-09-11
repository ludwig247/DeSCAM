--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 30.11.18
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity CLINT_Memory is
	port(
		clk						: in  std_logic;
		rst						: in  std_logic;

		-- blocking_in<CUtoME_IF> COtoME_port;
		COtoME_port			: in  CUtoME_IF;
		COtoME_port_sync	: in  boolean;
		COtoME_port_notify	: out boolean;

		-- blocking_out<MEtoCU_IF> MEtoCO_port
		MEtoCO_port			: out MEtoCU_IF;
		MEtoCO_port_sync	: in  boolean;
		MEtoCO_port_notify	: out boolean;

		--  master_out<unsigned int> toSipStatus
		toSipStatus			: out unsigned (31 downto 0);
		toSipStatus_notify	: out bool;

		--  master_in<unsigned int> fromTimer
		fromTimer			: in unsigned (63 downto 0);
--		--  master_in<unsigned int> fromTimer_L
--		fromTimer_L			: in unsigned (31 downto 0);
--		--  master_in<unsigned int> fromTimer_H
--		fromTimer_H			: in unsigned (31 downto 0);

		--  master_out<unsigned int> toTimerStatus_L
		toTimerStatus_L			: out unsigned (31 downto 0);
		toTimerStatus_L_notify	: out bool;
		--  master_out<unsigned int> toTimerStatus_H
		toTimerStatus_H			: out unsigned (31 downto 0);
		toTimerStatus_H_notify	: out bool
	);
end CLINT_Memory;

architecture CLINT_Memory_arch of CLINT_Memory is
	-- Memory Management type and signal
	type mem_sections_type is (read, write_msip, write_mtimecmp_L, write_mtimecmp_H, write_mtime_L, write_mtime_H);
	signal section : mem_sections_type;

	signal memoryRequest : CUtoME_IF;
	signal memoryResponse : MEtoCU_IF;

	-- Memory Mapped registers
	signal msip_reg		: unsigned (31 downto 0);
	signal mtimecmp_reg	: unsigned (63 downto 0);

begin

	process(clk)

		variable COtoME_port_n : bool;
		variable MEtoCO_port_n : bool;
		variable toSipStatus_n : bool;
		variable toTimerStatus_H_n : bool;
		variable toTimerStatus_L_n : bool;

		begin
			if(clk='1' and clk'event) then
				if rst = '1' then
					memoryResponse.loadedData <= (others => '0');
					msip_reg <= (others => '0');
					mtimecmp_reg <= to_unsigned(2147483647,32) & to_unsigned(2147483647,32);
					COtoME_port_notify <= true;
					MEtoCO_port_notify <= false;
					toSipStatus_notify <= false;
					toTimerStatus_H_notify <= false;
					toTimerStatus_L_notify <= false;
					section <= read;
				else

					COtoME_port_n := false;
					MEtoCO_port_n := false;
					toSipStatus_n := false;
					toTimerStatus_H_n := false;
					toTimerStatus_L_n := false;

					if section = read then
						if COtoME_port_sync = true then
							if (COtoME_port.req = ME_RD) then -- READ

								if (COtoME_port.addrIn = CLINT_msip_ADDR) then
									memoryResponse.loadedData <= msip_reg;
									MEtoCO_port.loadedData <= msip_reg;
									MEtoCO_port_n := true;
									section <= write_msip;

								elsif (COtoME_port.addrIn = CLINT_mtimecmp_ADDR) then
									memoryResponse.loadedData <= mtimecmp_reg(31 downto 0);
									MEtoCO_port.loadedData <= mtimecmp_reg(31 downto 0);
									MEtoCO_port_n := true;
									section <= write_mtimecmp_L;

								elsif (COtoME_port.addrIn = CLINT_mtimecmp_ADDR + 4) then
									memoryResponse.loadedData <= mtimecmp_reg(63 downto 32);
									MEtoCO_port.loadedData <= mtimecmp_reg(63 downto 32);
									MEtoCO_port_n := true;
									section <= write_mtimecmp_H;

								elsif (COtoME_port.addrIn = CLINT_mtime_ADDR) then
									memoryResponse.loadedData <= fromTimer(31 downto 0);
									MEtoCO_port.loadedData <= fromTimer(31 downto 0);
									--memoryResponse.loadedData <= fromTimer_L;
									--MEtoCO_port.loadedData <= fromTimer_L;
									MEtoCO_port_n := true;
									section <= write_mtime_L;

								elsif (COtoME_port.addrIn = CLINT_mtime_ADDR + 4) then
									memoryResponse.loadedData <= fromTimer(63 downto 32);
									MEtoCO_port.loadedData <= fromTimer(63 downto 32);
									--memoryResponse.loadedData <= fromTimer_H;
									--MEtoCO_port.loadedData <= fromTimer_H;
									MEtoCO_port_n := true;
									section <= write_mtime_H;

								else
									memoryResponse.loadedData <= (others => '0');
									COtoME_port_n := true;
									section <= read;

								end if;


							elsif (COtoME_port.req = ME_WR) then -- WRITE
								memoryResponse.loadedData <= (others => '0');

								if (COtoME_port.addrIn = CLINT_msip_ADDR) then
									msip_reg <= COtoME_port.dataIn;
									toSipStatus <= COtoME_port.dataIn;
									toSipStatus_n := true;

								elsif (COtoME_port.addrIn = CLINT_mtimecmp_ADDR) then
									mtimecmp_reg(31 downto 0) <= COtoME_port.dataIn;
									toTimerStatus_L <= COtoME_port.dataIn;
									toTimerStatus_L_n := true;

								elsif (COtoME_port.addrIn = CLINT_mtimecmp_ADDR + 4) then
									mtimecmp_reg(63 downto 32) <= COtoME_port.dataIn;
									toTimerStatus_H <= COtoME_port.dataIn;
									toTimerStatus_H_n := true;

								else
									memoryResponse.loadedData <= (others => '0');

								end if;

								COtoME_port_n := true;
								section <= read;

							else
								memoryResponse.loadedData <= (others => '0');
								COtoME_port_n := true;
								section <= read;
							end if;

						else
							COtoME_port_n := true;
						end if;

					elsif ( (section = write_msip) or
							(section = write_mtimecmp_L) or (section = write_mtimecmp_H) or
							(section = write_mtime_L) or (section = write_mtime_H) ) then
						if MEtoCO_port_sync = true then
							memoryResponse.loadedData <= (others => '0');
							MEtoCO_port_n := false;
							COtoME_port_n := true;
							section <= read;
						else
							MEtoCO_port_n := true;
						end if;

					end if; -- SECTION

					COtoME_port_notify <= COtoME_port_n;
					MEtoCO_port_notify <= MEtoCO_port_n;
					toSipStatus_notify <= toSipStatus_n;
					toTimerStatus_H_notify <= toTimerStatus_H_n;
					toTimerStatus_L_notify <= toTimerStatus_L_n;

				end if; -- RST
			end if; -- CLK
	end process;
end CLINT_Memory_arch;
