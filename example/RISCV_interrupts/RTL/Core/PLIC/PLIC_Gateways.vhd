--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity PLIC_Gateways is
	port(
		clk							: in  std_logic;
		rst							: in  std_logic;

		IntSig_1					: in bool;
		IntSig_sync_1				: in bool;
		IntReq_1					: out bool;
		IntReq_notify_1				: out bool;
		fromMemoryPending_1			: in bool;
		fromMemoryPending_sync_1	: in bool;

		IntSig_2					: in bool;
		IntSig_sync_2				: in bool;
		IntReq_2					: out bool;
		IntReq_notify_2				: out bool;
		fromMemoryPending_2			: in bool;
		fromMemoryPending_sync_2	: in bool
	);
end PLIC_Gateways;

architecture PLIC_Gateways_arch of PLIC_Gateways is


	--===================================================
	--======================= PLIC_Gateway =======================
	--===================================================
	component PLIC_Gateway is
	port(
		clk						: in  std_logic;
		rst						: in  std_logic;

		IntSig		: in bool;
		IntSig_sync	: in bool;

		IntReq			: out bool;
		IntReq_notify	: out bool;

		fromMemoryPending		: in bool;
		fromMemoryPending_sync	: in bool
	);
	end component;


begin


	IF_PLIC_Gateway_1 : PLIC_Gateway
	port map (
		clk => clk,
		rst => rst,

		IntSig => IntSig_1,
		IntSig_sync => IntSig_sync_1,
		IntReq => IntReq_1,
		IntReq_notify => IntReq_notify_1,
		fromMemoryPending => fromMemoryPending_1,
		fromMemoryPending_sync => fromMemoryPending_sync_1
	);


	IF_PLIC_Gateway_2 : PLIC_Gateway
	port map (
		clk => clk,
		rst => rst,

		IntSig => IntSig_2,
		IntSig_sync => IntSig_sync_2,
		IntReq => IntReq_2,
		IntReq_notify => IntReq_notify_2,
		fromMemoryPending => fromMemoryPending_2,
		fromMemoryPending_sync => fromMemoryPending_sync_2
	);

end PLIC_Gateways_arch;
