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

		MEtoCO_port_sig				: in  MEtoCU_IF;
		MEtoCO_port_sync		: in  boolean;
		MEtoCO_port_notify		: out boolean;

		COtoME_port_sig				: out CUtoME_IF;
		COtoME_port_sync		: in  boolean;
		COtoME_port_notify		: out boolean
);
end Core;


architecture Core_arch of Core is

	--====================================================
	--================ Inside Channels ===================
	--====================================================

	------------------ Inside Channels (ISA_REG) ------------------
	signal toRegsChannel					: RegfileWriteType;
	signal toRegsChannel_notify		: boolean;--flip at reg

	signal fromRegsChannel				: RegfileType;

	------------------ Inside Channels (ISA_BUS) ------------------
	signal isa_bus_Channel				: CUtoME_IF;
	signal isa_bus_Channel_sync		: boolean;--flip at bus
	signal isa_bus_Channel_notify		: boolean;--flip at bus

	signal bus_isa_Channel				: MEtoCU_IF;
	signal bus_isa_Channel_sync		: boolean;--flip at bus
	signal bus_isa_Channel_notify		: boolean;--flip at bus

	------------------ Inside Channels (ISA_MIP) ------------------
	signal mip_isa_Channel				: unsigned (31 downto 0);


	--====================================================
	--================ Channels ===================
	--====================================================

	------------------ (InnerCore_Bus) ------------------
		signal CPU_BUS_Port				: CUtoME_IF;
		signal CPU_BUS_Port_sync			: boolean;
		signal CPU_BUS_Port_notify		: boolean;

	------------------ (Bus_InnerCore) ------------------
		signal BUS_CPU_Port				: MEtoCU_IF;
		signal BUS_CPU_Port_sync			: boolean;
		signal BUS_CPU_Port_notify		: boolean;


	------------------ (Bus_CLINT) ------------------
		signal BUS_CLINT_Port				: CUtoME_IF;
		signal BUS_CLINT_Port_sync			: boolean;
		signal BUS_CLINT_Port_notify		: boolean;

	------------------ (CLINT_Bus) ------------------
		signal CLINT_BUS_Port				: MEtoCU_IF;
		signal CLINT_BUS_Port_sync			: boolean;
		signal CLINT_BUS_Port_notify		: boolean;


	------------------ (CLINT_MSIP) ------------------
		signal CLINT_MSIP_InnerCore			: boolean;
	------------------ (CLINT_MTIP) ------------------
		signal CLINT_MTIP_InnerCore			: boolean;

	--===================================================
	--======================= ISA =======================
	--===================================================
	component ISA is
	port(
	clk							: in std_logic;
	rst							: in std_logic;

	fromMemoryPort				: in MEtoCU_IF;
	fromMemoryPort_sync		: in boolean;
	fromMemoryPort_notify	: out boolean;

	fromRegsPort				: in RegfileType;

	mip_isa_Port				: in unsigned (31 downto 0);

	toMemoryPort				: out CUtoME_IF;
	toMemoryPort_sync			: in boolean;
	toMemoryPort_notify		: out boolean;

	toRegsPort					: out RegfileWriteType;
	toRegsPort_notify			: out boolean
	);
	end component;

	--===================================================
	--================== Register-File ==================
	--===================================================
	component Regs is
	port(
		clk							: in std_logic;
		rst							: in std_logic;

		toRegsPort					: in RegfileWriteType;
		toRegsPort_sync			: in boolean;
		fromRegsPort				: out RegfileType
	);
	end component;

	--===================================================
	--======================= Mip =======================
	--===================================================
	component Mip is
	port(
		clk						: in std_logic;
		rst						: in std_logic;

		MSIP_port				: in boolean;
		MTIP_port				: in boolean;
		mip_isa_Port			: out unsigned (31 downto 0)
	);
	end component;

	--===================================================
	--======================= CoreBus =======================
	--===================================================
	component CoreBus is
	port(
		clk							: in std_logic;
		rst							: in std_logic;

		--------------- CPU - Bus ---------------
    	--  blocking_in<CUtoME_IF> isa_bus_Port
    	isa_bus_Port			: in CUtoME_IF;
    	isa_bus_Port_sync		: in boolean;
    	isa_bus_Port_notify		: out boolean;

    	--  blocking_out<MEtoCP_IF> bus_isa_Port
    	bus_isa_Port			: out MEtoCU_IF;
    	bus_isa_Port_sync		: in boolean;
    	bus_isa_Port_notify		: out boolean;


    	--------------- Bus - Memory ---------------
    	--  blocking_out<CUtoME_IF> BUS_MEM_Port
    	BUStoMEM_port			: out CUtoME_IF;
    	BUStoMEM_port_sync		: in boolean;
    	BUStoMEM_port_notify		: out boolean;

    	--  blocking_in<MEtoCP_IF> BUS_MEM_Port
    	MEMtoBUS_port			: in MEtoCU_IF;
    	MEMtoBUS_port_sync		: in boolean;
    	MEMtoBUS_port_notify		: out boolean;


    	--------------- Bus - CLINT ---------------
    	--  blocking_out<CUtoME_IF> BUS_CLINT_Port
    	BUStoCLINT_port			: out CUtoME_IF;
    	BUStoCLINT_port_sync		: in boolean;
    	BUStoCLINT_port_notify	: out boolean;

    	--  blocking_in<MEtoCP_IF> BUS_CLINT_Port
    	CLINTtoBUS_port				: in MEtoCU_IF;
    	CLINTtoBUS_port_sync		: in boolean;
    	CLINTtoBUS_port_notify	: out boolean
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
		MEMtoCPU_port			: out MEtoCU_IF;
		MEMtoCPU_port_sync	: in  boolean;
		MEMtoCPU_port_notify	: out boolean;
		--slave_out<boolean> MSIP_port;
		MSIP_port				: out boolean;
		--slave_out<boolean> MTIP_port;
		MTIP_port				: out boolean
	);
	end component;


begin

    IF_ISA : ISA
		port map (
			clk => clk,
			rst => rst,

			fromMemoryPort => bus_isa_Channel,
			fromMemoryPort_sync => bus_isa_Channel_sync,
			fromMemoryPort_notify => bus_isa_Channel_notify,

			fromRegsPort => fromRegsChannel,

			mip_isa_Port => mip_isa_Channel,

			toMemoryPort => isa_bus_Channel,
			toMemoryPort_sync => isa_bus_Channel_sync,
			toMemoryPort_notify => isa_bus_Channel_notify,

			toRegsPort => toRegsChannel,
			toRegsPort_notify => toRegsChannel_notify
		);

	IF_Regs : Regs
		port map (
			clk => clk,
			rst => rst,

			toRegsPort => toRegsChannel,
			toRegsPort_sync => toRegsChannel_notify,
			fromRegsPort => fromRegsChannel
		);

	IF_Mip : Mip
		port map (
			clk => clk,
			rst => rst,

			MSIP_port => CLINT_MSIP_InnerCore,
			MTIP_port => CLINT_MTIP_InnerCore,
			mip_isa_Port => mip_isa_Channel
		);

	IF_CoreBus : CoreBus
	port map (
		clk => clk,
		rst => rst,

		--------------- CPU - Bus ---------------
    	--  blocking_in<CUtoME_IF> isa_bus_Port
		isa_bus_Port => isa_bus_Channel,
		isa_bus_Port_sync => isa_bus_Channel_notify,
		isa_bus_Port_notify => isa_bus_Channel_sync,

    	--  blocking_out<MEtoCP_IF> bus_isa_Port
		bus_isa_Port => bus_isa_Channel,
		bus_isa_Port_sync => bus_isa_Channel_notify,
		bus_isa_Port_notify => bus_isa_Channel_sync,


    	--------------- Bus - Memory ---------------
    	--  blocking_out<CUtoME_IF> BUS_MEM_Port
		BUStoMEM_port => COtoME_port_sig,
		BUStoMEM_port_sync => COtoME_port_sync,
		BUStoMEM_port_notify => COtoME_port_notify,

    	--  blocking_in<MEtoCP_IF> MEM_BUS_Port
		MEMtoBUS_port => MEtoCO_port_sig,
		MEMtoBUS_port_sync => MEtoCO_port_sync,
		MEMtoBUS_port_notify => MEtoCO_port_notify,


    	--------------- Bus - CLINT ---------------
    	--  blocking_out<CUtoME_IF> BUS_CLINT_Port
		BUStoCLINT_port => BUS_CLINT_Port,
		BUStoCLINT_port_sync => BUS_CLINT_Port_notify,
		BUStoCLINT_port_notify => BUS_CLINT_Port_sync,

    	--  blocking_in<MEtoCP_IF> CLINTtoBUS_port
		CLINTtoBUS_port => CLINT_BUS_Port,
		CLINTtoBUS_port_sync => CLINT_BUS_Port_notify,
		CLINTtoBUS_port_notify => CLINT_BUS_Port_sync
	);



	IF_CLINT : CLINT
	port map (
		clk => clk,
		rst => rst,

		CPUtoMEM_port => BUS_CLINT_Port,
		CPUtoMEM_port_sync => BUS_CLINT_Port_sync,
		CPUtoMEM_port_notify => BUS_CLINT_Port_notify,
		MEMtoCPU_port => CLINT_BUS_Port,
		MEMtoCPU_port_sync => CLINT_BUS_Port_sync,
		MEMtoCPU_port_notify => CLINT_BUS_Port_notify,
		MSIP_port => CLINT_MSIP_InnerCore,
		MTIP_port => CLINT_MTIP_InnerCore
	);

end Core_arch;
