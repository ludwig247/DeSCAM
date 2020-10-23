--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 30.11.18
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity CLINT_TimerStatus is
	port(
		clk						: in  std_logic;
		rst						: in  std_logic;

		--  master_in<unsigned int> fromTimer
		fromTimer			: in unsigned (63 downto 0);

		--  slave_in<unsigned int> fromMemory_timecmp_L
		fromMemory_timecmp_L		: in unsigned (31 downto 0);
		fromMemory_timecmp_L_sync	: in bool;

		--  slave_in<unsigned int> fromMemory_timecmp_H
		fromMemory_timecmp_H		: in unsigned (31 downto 0);
		fromMemory_timecmp_H_sync	: in bool;

		--  slave_out<bool> MSIP_port
		MTIP_port			: out bool
	);
end CLINT_TimerStatus;

architecture CLINT_TimerStatus_arch of CLINT_TimerStatus is

	signal mtime_reg	: unsigned (63 downto 0);
	signal mtimecmp_reg	: unsigned (63 downto 0);

begin

	process(clk)

		variable mtime		: unsigned (63 downto 0);
		variable mtimecmp	: unsigned (63 downto 0);

		begin
			if(clk='1' and clk'event) then
				if rst = '1' then
					mtime_reg <= (others => '0');
					mtimecmp_reg <= to_unsigned(2147483647,32) & to_unsigned(2147483647,32);
					MTIP_port <= false;

				else
					mtime := fromTimer;
					mtimecmp := mtimecmp_reg;

					if fromMemory_timecmp_L_sync = true then
						mtimecmp(31 downto 0) := fromMemory_timecmp_L;
					end if;

					if fromMemory_timecmp_H_sync = true then
                    	mtimecmp(63 downto 32) := fromMemory_timecmp_H;
					end if;

					if (mtime >= mtimecmp) then
						MTIP_port <= true;
					else
						MTIP_port <= false;
					end if;

					mtime_reg <= mtime;
					mtimecmp_reg <= mtimecmp;

				end if; -- RST
			end if; -- CLK
	end process;
end CLINT_TimerStatus_arch;
