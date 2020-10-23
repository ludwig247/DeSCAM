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
		MEMtoCPU_port			: out MEtoCU_IF;
		MEMtoCPU_port_sync	: in  boolean;
		MEMtoCPU_port_notify	: out boolean;

		-- slave_in<bool> IntSig_1;
		IntSig_1				: in bool;
		IntSig_sync_1			: in bool;

		-- slave_in<bool> IntSig_2;
		IntSig_2				: in bool;
		IntSig_sync_2			: in bool;

		--slave_out<bool> MEIP_port;
		MEIP_port				: out bool
	);
end PLIC;

architecture PLIC_arch of PLIC is

	--====================================================
	--================ Channels ===================
	--====================================================

	-- MasterSlave<bool> IntReq_1;
	signal IntReq_1			: bool;
	signal IntReq_1_sync	: bool;

	-- MasterSlave<bool> IntReq_2;
	signal IntReq_2			: bool;
	signal IntReq_2_sync	: bool;

	-- MasterSlave<bool> Pending_1;
	signal Pending_1		: bool;
	signal Pending_1_sync	: bool;

	-- MasterSlave<bool> Pending_2;
	signal Pending_2		: bool;
	signal Pending_2_sync	: bool;

	-- MasterSlave<bool> MEtoCO_Priority_Int_1;
	signal MEtoCO_Priority_Int_1		: unsigned (31 downto 0);
	signal MEtoCO_Priority_Int_1_sync	: bool;

	-- MasterSlave<bool> MEtoCO_Priority_Int_2;
	signal MEtoCO_Priority_Int_2		: unsigned (31 downto 0);
	signal MEtoCO_Priority_Int_2_sync	: bool;

	-- MasterSlave<bool> MEtoCO_Enabled;
	signal MEtoCO_Enabled				: unsigned (31 downto 0);
	signal MEtoCO_Enabled_sync			: bool;

	-- MasterSlave<bool> MEtoCO_Threshold;
	signal MEtoCO_Threshold				: unsigned (31 downto 0);
	signal MEtoCO_Threshold_sync		: bool;

	-- MasterSlave<bool> MEtoCO_Claimed;
	signal MEtoCO_Claimed				: unsigned (31 downto 0);
	signal MEtoCO_Claimed_sync			: bool;

	-- MasterSlave<bool> MEtoCO_MaxID;
	signal MEtoCO_MaxID					: unsigned (31 downto 0);


	--===================================================
	--======================= PLIC_Memory =======================
	--===================================================
	component PLIC_Memory is
	port(
		clk						: in  std_logic;
		rst						: in  std_logic;

		COtoME_port			: in  CUtoME_IF;
		COtoME_port_sync	: in  boolean;
		COtoME_port_notify	: out boolean;

		MEtoCO_port			: out MEtoCU_IF;
		MEtoCO_port_sync	: in  boolean;
		MEtoCO_port_notify	: out boolean;

		toCore_Priority_Int_1			: out unsigned (31 downto 0);
		toCore_Priority_Int_1_notify	: out bool;

		toCore_Priority_Int_2			: out unsigned (31 downto 0);
		toCore_Priority_Int_2_notify	: out bool;

		toCore_Enabled					: out unsigned (31 downto 0);
		toCore_Enabled_notify			: out bool;

		toCore_Threshold				: out unsigned (31 downto 0);
		toCore_Threshold_notify			: out bool;

		toCore_Claimed					: out unsigned (31 downto 0);
		toCore_Claimed_notify			: out bool;

		toGatewayPending_1				: out bool;
		toGatewayPending_1_notify		: out bool;

		toGatewayPending_2				: out bool;
		toGatewayPending_2_notify		: out bool;

		-- fromCore_MaxPriority			: in unsigned (31 downto 0);
		fromCore_MaxID					: in unsigned (31 downto 0)
	);
	end component;


	--===================================================
	--======================= PLIC_Gateways =======================
	--===================================================
	component PLIC_Gateways is
	port(
		clk						: in  std_logic;
		rst						: in  std_logic;

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
	end component;


	--===================================================
	--======================= PLIC_Core =======================
	--===================================================
	component PLIC_Core is
	port(
		clk						: in  std_logic;
		rst						: in  std_logic;

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
	end component;


begin

	IF_PLIC_Memory : PLIC_Memory
	port map (
		clk => clk,
		rst => rst,

		COtoME_port	=> CPUtoMEM_port,
		COtoME_port_sync => CPUtoMEM_port_sync,
		COtoME_port_notify => CPUtoMEM_port_notify,

		MEtoCO_port => MEMtoCPU_port,
		MEtoCO_port_sync => MEMtoCPU_port_sync,
		MEtoCO_port_notify => MEMtoCPU_port_notify,

		toCore_Priority_Int_1 => MEtoCO_Priority_Int_1,
		toCore_Priority_Int_1_notify => MEtoCO_Priority_Int_1_sync,

		toCore_Priority_Int_2 => MEtoCO_Priority_Int_2,
		toCore_Priority_Int_2_notify => MEtoCO_Priority_Int_2_sync,

		toCore_Enabled => MEtoCO_Enabled,
		toCore_Enabled_notify => MEtoCO_Enabled_sync,

		toCore_Threshold => MEtoCO_Threshold,
		toCore_Threshold_notify => MEtoCO_Threshold_sync,

		toCore_Claimed => MEtoCO_Claimed,
		toCore_Claimed_notify => MEtoCO_Claimed_sync,

		toGatewayPending_1 => Pending_1,
		toGatewayPending_1_notify => Pending_1_sync,

		toGatewayPending_2 => Pending_2,
		toGatewayPending_2_notify => Pending_2_sync,

		-- fromCore_MaxPriority			: in unsigned (31 downto 0);
		fromCore_MaxID => MEtoCO_MaxID
	);



	IF_PLIC_Gateways : PLIC_Gateways
	port map (
		clk => clk,
		rst => rst,

		IntSig_1 => IntSig_1,
		IntSig_sync_1 => IntSig_sync_1,
		IntReq_1 => IntReq_1,
		IntReq_notify_1 => IntReq_1_sync,
		fromMemoryPending_1 => Pending_1,
		fromMemoryPending_sync_1 => Pending_1_sync,

		IntSig_2 => IntSig_2,
		IntSig_sync_2 => IntSig_sync_2,
		IntReq_2 => IntReq_2,
		IntReq_notify_2 => IntReq_2_sync,
		fromMemoryPending_2 => Pending_2,
		fromMemoryPending_sync_2 => Pending_2_sync
	);



	IF_PLIC_Core : PLIC_Core
	port map (
		clk => clk,
		rst => rst,

		fromGateway_Int1 => IntReq_1,
		fromGateway_Int1_sync => IntReq_1_sync,
		fromGateway_Int2 => IntReq_2,
		fromGateway_Int2_sync => IntReq_2_sync,

		fromMemory_Priority_Int_1 => MEtoCO_Priority_Int_1,
		fromMemory_Priority_Int_1_sync => MEtoCO_Priority_Int_1_sync,

		fromMemory_Priority_Int_2 => MEtoCO_Priority_Int_2,
		fromMemory_Priority_Int_2_sync => MEtoCO_Priority_Int_2_sync,

		fromMemory_Enabled => MEtoCO_Enabled,
		fromMemory_Enabled_sync => MEtoCO_Enabled_sync,

		fromMemory_Threshold => MEtoCO_Threshold,
		fromMemory_Threshold_sync => MEtoCO_Threshold_sync,

		fromMemory_Claimed => MEtoCO_Claimed,
		fromMemory_Claimed_sync => MEtoCO_Claimed_sync,

		toMemory_MaxID => MEtoCO_MaxID,

		MEIP_port => MEIP_port
	);

end PLIC_arch;
