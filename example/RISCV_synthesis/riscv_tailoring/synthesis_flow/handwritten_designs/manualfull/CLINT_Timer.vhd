--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 30.11.18
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity CLINT_Timer is
	port(
		clk						: in  std_logic;
		rst						: in  std_logic;

		--  slave_out<unsigned int> toMemory
		toMemory			: out unsigned (63 downto 0);

		--  slave_out<unsigned int> toTimerStatus
		toTimerStatus		: out unsigned (63 downto 0)
	);
end CLINT_Timer;

architecture CLINT_Timer_arch of CLINT_Timer is

	signal mtime_reg	: unsigned (63 downto 0);

begin

	process(clk)

		begin
			if(clk='1' and clk'event) then
				if rst = '1' then

					mtime_reg <= (others => '0');
					toMemory <= (others => '0');
					toTimerStatus <= (others => '0');

				else

					toMemory <= mtime_reg;
					toTimerStatus <= mtime_reg;
					mtime_reg <= mtime_reg + 1;

				end if; -- RST
			end if; -- CLK
	end process;
end CLINT_Timer_arch;
