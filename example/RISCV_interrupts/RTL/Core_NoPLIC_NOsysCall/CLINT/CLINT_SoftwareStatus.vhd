--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 30.11.18
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity CLINT_SipStatus is
	port(
		clk						: in  std_logic;
		rst						: in  std_logic;

		--  slave_in<unsigned int> fromMemory_sip
		fromMemory_sip		: in unsigned (31 downto 0);
		fromMemory_sip_sync	: in bool;

		--  slave_out<bool> MSIP_port
		MSIP_port			: out bool
	);
end CLINT_SipStatus;

architecture CLINT_SipStatus_arch of CLINT_SipStatus is

	signal msip_reg		: unsigned (31 downto 0);

begin

	process(clk)
		begin
			if(clk='1' and clk'event) then
				if rst = '1' then
					msip_reg <= (others => '0');
					MSIP_port <= false;

				else
					if fromMemory_sip_sync = true then
							msip_reg <= fromMemory_sip;
							if (fromMemory_sip /= to_unsigned(0,32) ) then
								MSIP_port <= true;
							else
								MSIP_port <= false;
							end if;

					else
							if (msip_reg /= to_unsigned(0,32) ) then
								MSIP_port <= true;
							else
								MSIP_port <= false;
							end if;
					end if;

				end if; -- RST
			end if; -- CLK
	end process;
end CLINT_SipStatus_arch;
