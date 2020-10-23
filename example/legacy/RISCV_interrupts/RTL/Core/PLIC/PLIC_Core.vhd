--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 01.12.18
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity PLIC_Core is
port(
	clk							: in std_logic;
	rst							: in std_logic;

	fromGateway_Int1			: in bool;
	fromGateway_Int1_sync		: in bool;
	fromGateway_Int2			: in bool;
	fromGateway_Int2_sync		: in bool;

	fromMemory_Priority_Int_1		: in unsigned (31 downto 0);
	fromMemory_Priority_Int_1_sync	: in bool;

	fromMemory_Priority_Int_2		: in unsigned (31 downto 0);
	fromMemory_Priority_Int_2_sync	: in bool;

	fromMemory_Enabled				: in unsigned (31 downto 0);
	fromMemory_Enabled_sync			: in bool;

	fromMemory_Threshold			: in unsigned (31 downto 0);
	fromMemory_Threshold_sync		: in bool;

	fromMemory_Claimed				: in unsigned (31 downto 0);
	fromMemory_Claimed_sync			: in bool;

	toMemory_MaxID			: out unsigned (31 downto 0);

	MEIP_port		: out bool
);
end PLIC_Core;



architecture PLIC_Core_arch of PLIC_Core is

	signal pending_Int_1	: bool;
	signal pending_Int_2	: bool;
	signal priority_Int_1	: unsigned (31 downto 0);
	signal priority_Int_2	: unsigned (31 downto 0);
	signal enabled			: unsigned (31 downto 0);
	signal threshold		: unsigned (31 downto 0);
	signal claimed			: unsigned (31 downto 0);
	signal max_id			: unsigned (31 downto 0);

begin

	process(clk)

	variable pending_Int_1_temp	: bool;
	variable pending_Int_2_temp	: bool;
	variable priority_Int_1_temp: unsigned (31 downto 0);
	variable priority_Int_2_temp: unsigned (31 downto 0);
	variable enabled_temp		: unsigned (31 downto 0);
	variable threshold_temp		: unsigned (31 downto 0);
	variable claimed_temp		: unsigned (31 downto 0);
	variable max_id_temp		: unsigned (31 downto 0);
	variable traversing_priority: unsigned (31 downto 0);
	variable traversing_id		: unsigned (31 downto 0);

	begin
		if(clk='1' and clk'event) then
			if rst = '1' then
				pending_Int_1 <= false;
				pending_Int_2 <= false;
				priority_Int_1 <= (others => '0');
				priority_Int_2 <= (others => '0');
				enabled <= (others => '0');
				threshold <= (others => '0');
				claimed <= (others => '0');
				max_id <= (others => '0');
			else
				pending_Int_1_temp := pending_Int_1;
				pending_Int_2_temp := pending_Int_2;
				priority_Int_1_temp := priority_Int_1;
				priority_Int_2_temp := priority_Int_2;
				enabled_temp := enabled;
				threshold_temp := threshold;
				claimed_temp := claimed;
				max_id_temp := max_id;

				if(fromGateway_Int1_sync = true) then
					pending_Int_1_temp := fromGateway_Int1;
				end if;

				if(fromGateway_Int2_sync = true) then
					pending_Int_2_temp := fromGateway_Int2;
				end if;

				if(fromMemory_Priority_Int_1_sync = true) then
					priority_Int_1_temp := fromMemory_Priority_Int_1;
				end if;

				if(fromMemory_Priority_Int_2_sync = true) then
					priority_Int_2_temp := fromMemory_Priority_Int_2;
				end if;

				if(fromMemory_Enabled_sync = true) then
					enabled_temp := fromMemory_Enabled;
				end if;

				if(fromMemory_Threshold_sync = true) then
					threshold_temp := fromMemory_Threshold;
				end if;


				-- clear a pending interrupt if it has been claimed by target
				if(fromMemory_Claimed_sync = true) then
					claimed_temp := fromMemory_Claimed;
					if ( claimed_temp = to_unsigned(1,32) ) then
						pending_Int_1_temp := false;
					elsif ( claimed_temp = to_unsigned(2,32) ) then
						pending_Int_2_temp := false;
					end if;
				end if;


				-- reset traversing variables to start a new round
				traversing_priority := to_unsigned(0,32);
				traversing_id := to_unsigned(0,32);

				-- process interrupt 1
				if ( (pending_Int_1_temp = true) and (enabled_temp(0) = '1') ) then
					traversing_priority := priority_Int_1_temp;
					traversing_id := to_unsigned(1,32);
				end if;

				-- process interrupt 2
				if ( (pending_Int_2_temp = true) and (enabled_temp(1) = '1') ) then
					traversing_priority := priority_Int_2_temp;
					traversing_id := to_unsigned(2,32);
				end if;


				-- process final decision
				if (to_integer(traversing_priority) > to_integer(threshold_temp) ) then
					max_id_temp := traversing_priority;
					MEIP_port <= true;
				else
					MEIP_port <= false;
				end if;


				pending_Int_1 <= pending_Int_1_temp;
				pending_Int_2 <= pending_Int_2_temp;
				priority_Int_1 <= priority_Int_1_temp;
				priority_Int_2 <= priority_Int_2_temp;
				enabled <= enabled_temp;
				threshold <= threshold_temp;
				claimed <= claimed_temp;
				max_id <= max_id_temp;
				toMemory_MaxID <= max_id_temp;

			end if; -- RST
		end if; -- CLK
	end process;
end PLIC_Core_arch;