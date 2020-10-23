--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity Core is
port(
		clk						: in  std_logic;
		rst						: in  std_logic;

		MEtoCO_port				: in  MEtoCP_IF;
		MEtoCO_port_sync		: in  bool;
		MEtoCO_port_notify	: out bool;

		COtoME_port				: out CUtoME_IF;
		COtoME_port_sync		: in  bool;
		COtoME_port_notify	: out bool
);
end Core;


architecture Core_arch of Core is

	--====================================================
	--================ Channels ===================
	--====================================================

	------------------ (InnerCore_Bus) ------------------
		signal CPU_BUS_Port				: CUtoME_IF;
		signal CPU_BUS_Port_sync			: bool;
		signal CPU_BUS_Port_notify		: bool;

	------------------ (Bus_InnerCore) ------------------
		signal BUS_CPU_Port				: MEtoCP_IF;
		signal BUS_CPU_Port_sync			: bool;
		signal BUS_CPU_Port_notify		: bool;


	------------------ (Bus_Memory) ------------------
--		signal BUS_MEM_Port				: CUtoME_IF;
--		signal BUS_MEM_Port_sync			: bool;
--		signal BUS_MEM_Port_notify		: bool;

	------------------ (Memory_Bus) ------------------
--		signal MEM_BUS_Port				: MEtoCP_IF;
--		signal MEM_BUS_Port_sync			: bool;
--		signal MEM_BUS_Port_notify		: bool;


	------------------ (Bus_CLINT) ------------------
		signal BUS_CLINT_Port				: CUtoME_IF;
		signal BUS_CLINT_Port_sync			: bool;
		signal BUS_CLINT_Port_notify		: bool;

	------------------ (CLINT_Bus) ------------------
		signal CLINT_BUS_Port				: MEtoCP_IF;
		signal CLINT_BUS_Port_sync			: bool;
		signal CLINT_BUS_Port_notify		: bool;


	------------------ (Bus_PLIC) ------------------
		signal BUS_PLIC_Port				: CUtoME_IF;
		signal BUS_PLIC_Port_sync			: bool;
		signal BUS_PLIC_Port_notify		: bool;

	------------------ (PLIC_Bus) ------------------
		signal PLIC_BUS_Port				: MEtoCP_IF;
		signal PLIC_BUS_Port_sync			: bool;
		signal PLIC_BUS_Port_notify		: bool;

	------------------ (CLINT_MSIP) ------------------
		signal CLINT_MSIP_InnerCore			: bool;
	------------------ (CLINT_MTIP) ------------------
		signal CLINT_MTIP_InnerCore			: bool;
	------------------ (PLIC_MEIP) ------------------
		signal PLIC_MEIP_InnerCore			: bool;



	--===================================================
	--======================= InnerCore =======================
	--===================================================
	component InnerCore is
	port(
		clk						: in  std_logic;
		rst						: in  std_logic;

		MEtoCO_port				: in  MEtoCP_IF;
		MEtoCO_port_sync		: in  bool;
		MEtoCO_port_notify	: out bool;

		COtoME_port				: out CUtoME_IF;
		COtoME_port_sync		: in  bool;
		COtoME_port_notify	: out bool;

		mSip_mip_port			: in bool;
		mTip_mip_port			: in bool;
		mEip_mip_port			: in bool
	);
	end component;


	--===================================================
	--======================= CoreBus =======================
	--===================================================
	component CoreBus is
	port(
		clk							: in std_logic;
		rst							: in std_logic;

		--------------- CPU to Peripherals ---------------
		CPU_BUS_Port				: in CUtoME_IF;
		CPU_BUS_Port_sync			: in bool;
		CPU_BUS_Port_notify		: out bool;

		BUS_MEM_Port				: out CUtoME_IF;
		BUS_MEM_Port_sync			: in bool;
		BUS_MEM_Port_notify		: out bool;

		BUS_CLINT_Port				: out CUtoME_IF;
		BUS_CLINT_Port_sync		: in bool;
		BUS_CLINT_Port_notify	: out bool;

		BUS_PLIC_Port				: out CUtoME_IF;
		BUS_PLIC_Port_sync		: in bool;
		BUS_PLIC_Port_notify		: out bool;

		--------------- Peripherals to CPU ---------------
		MEM_BUS_Port				: in MEtoCP_IF;
		MEM_BUS_Port_sync			: in bool;
		MEM_BUS_Port_notify		: out bool;

		CLINT_BUS_Port				: in MEtoCP_IF;
		CLINT_BUS_Port_sync		: in bool;
		CLINT_BUS_Port_notify	: out bool;

		PLIC_BUS_Port				: in MEtoCP_IF;
		PLIC_BUS_Port_sync		: in bool;
		PLIC_BUS_Port_notify		: out bool;

		BUS_CPU_Port				: out MEtoCP_IF;
		BUS_CPU_Port_sync			: in bool;
		BUS_CPU_Port_notify		: out bool
	);
	end component;


	--===================================================
	--================== CLINT ==================
	--===================================================
	component CLINT is
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
	end component;

	--===================================================
	--===================== PLIC ====================
	--===================================================
	component PLIC is
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
	end component;

begin

	IF_CoreBus : CoreBus
	port map (
		clk => clk,
		rst => rst,

		--------------- CPU to Peripherals ---------------
		CPU_BUS_Port => CPU_BUS_Port,
		CPU_BUS_Port_sync => CPU_BUS_Port_sync,
		CPU_BUS_Port_notify => CPU_BUS_Port_notify,

		BUS_MEM_Port => COtoME_port,
		BUS_MEM_Port_sync => COtoME_port_sync,
		BUS_MEM_Port_notify => COtoME_port_notify,

		BUS_CLINT_Port => BUS_CLINT_Port,
		BUS_CLINT_Port_sync => BUS_CLINT_Port_sync,
		BUS_CLINT_Port_notify => BUS_CLINT_Port_notify,

		BUS_PLIC_Port => BUS_PLIC_Port,
		BUS_PLIC_Port_sync => BUS_PLIC_Port_sync,
		BUS_PLIC_Port_notify => BUS_PLIC_Port_notify,

		--------------- Peripherals to CPU ---------------
		MEM_BUS_Port => MEtoCO_port,
		MEM_BUS_Port_sync => MEtoCO_port_sync,
		MEM_BUS_Port_notify => MEtoCO_port_notify,

		CLINT_BUS_Port => CLINT_BUS_Port,
		CLINT_BUS_Port_sync => CLINT_BUS_Port_sync,
		CLINT_BUS_Port_notify => CLINT_BUS_Port_notify,

		PLIC_BUS_Port => PLIC_BUS_Port,
		PLIC_BUS_Port_sync => PLIC_BUS_Port_sync,
		PLIC_BUS_Port_notify => PLIC_BUS_Port_notify,

		BUS_CPU_Port => BUS_CPU_Port,
		BUS_CPU_Port_sync => BUS_CPU_Port_sync,
		BUS_CPU_Port_notify => BUS_CPU_Port_notify
	);


	IF_InnerCore : InnerCore
	port map (
		clk => clk,
		rst => rst,

		MEtoCO_port => BUS_CPU_Port,
		MEtoCO_port_sync => BUS_CPU_Port_notify,
		MEtoCO_port_notify => BUS_CPU_Port_sync,

		COtoME_port => CPU_BUS_Port,
		COtoME_port_sync => CPU_BUS_Port_notify,
		COtoME_port_notify => CPU_BUS_Port_sync,

		mSip_mip_port => CLINT_MSIP_InnerCore,
		mTip_mip_port => CLINT_MTIP_InnerCore,
		mEip_mip_port => PLIC_MEIP_InnerCore
	);


	IF_CLINT : CLINT
	port map (
		clk => clk,
		rst => rst,

		CPUtoMEM_port => BUS_CLINT_Port,
		CPUtoMEM_port_sync => BUS_CLINT_Port_notify,
		CPUtoMEM_port_notify => BUS_CLINT_Port_sync,
		MEMtoCPU_port => CLINT_BUS_Port,
		MEMtoCPU_port_sync => CLINT_BUS_Port_notify,
		MEMtoCPU_port_notify => CLINT_BUS_Port_sync,
		MSIP_port => CLINT_MSIP_InnerCore,
		MTIP_port => CLINT_MTIP_InnerCore
	);


	IF_PLIC : PLIC
	port map (
		clk => clk,
		rst => rst,

		CPUtoMEM_port => BUS_PLIC_Port,
		CPUtoMEM_port_sync => BUS_PLIC_Port_notify,
		CPUtoMEM_port_notify => BUS_PLIC_Port_sync,
		MEMtoCPU_port => PLIC_BUS_Port,
		MEMtoCPU_port_sync => PLIC_BUS_Port_notify,
		MEMtoCPU_port_notify => PLIC_BUS_Port_sync,
		MEIP_port => PLIC_MEIP_InnerCore
	);

end Core_arch;