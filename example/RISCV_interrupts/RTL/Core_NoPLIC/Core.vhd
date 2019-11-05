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

		MEtoCO_port				: in  MEtoCU_IF;
		MEtoCO_port_sync		: in  bool;
		MEtoCO_port_notify		: out bool;

		COtoME_port				: out CUtoME_IF;
		COtoME_port_sync		: in  bool;
		COtoME_port_notify		: out bool
);
end Core;


architecture Core_arch of Core is

	--====================================================
	--================ Inside Channels ===================
	--====================================================

	------------------ Inside Channels (ISA_REG) ------------------
	signal toRegsChannel					: RegfileWriteType;
	signal toRegsChannel_notify		: bool;--flip at reg

	signal fromRegsChannel				: RegfileType;

	------------------ Inside Channels (SYSCALL_REG) ------------------
	signal syscall_reg_Channel			: RegfileWriteType;
	signal syscall_reg_Channel_notify: bool;--flip at reg

	signal reg_syscall_Channel			: RegfileSyscallType;

	------------------ Inside Channels (ISA_SYSCALL) ------------------
	signal isa_syscall_Channel			: bool;
	signal isa_syscall_Channel_sync	: bool;--flip at syscall
	signal isa_syscall_Channel_notify: bool;--flip at syscall

	signal syscall_isa_Channel			: bool;
	signal syscall_isa_Channel_sync	: bool;--flip at syscall
	signal syscall_isa_Channel_notify: bool;--flip at syscall

	------------------ Inside Channels (ISA_BUS) ------------------
	signal isa_bus_Channel				: CUtoME_IF;
	signal isa_bus_Channel_sync		: bool;--flip at bus
	signal isa_bus_Channel_notify		: bool;--flip at bus

	signal bus_isa_Channel				: MEtoCU_IF;
	signal bus_isa_Channel_sync		: bool;--flip at bus
	signal bus_isa_Channel_notify		: bool;--flip at bus

	------------------ Inside Channels (SYSCALL_BUS) ------------------
	signal syscall_bus_Channel			: CUtoME_IF;
	signal syscall_bus_Channel_sync	: bool;--flip at bus
	signal syscall_bus_Channel_notify: bool;--flip at bus

	signal bus_syscall_Channel			: MEtoCU_IF;
	signal bus_syscall_Channel_sync	: bool;--flip at bus
	signal bus_syscall_Channel_notify: bool;--flip at bus

	------------------ Inside Channels (ISA_MIP) ------------------
	signal mip_isa_Channel				: unsigned (31 downto 0);


	--====================================================
	--================ Channels ===================
	--====================================================

	------------------ (InnerCore_Bus) ------------------
		signal CPU_BUS_Port				: CUtoME_IF;
		signal CPU_BUS_Port_sync			: bool;
		signal CPU_BUS_Port_notify		: bool;

	------------------ (Bus_InnerCore) ------------------
		signal BUS_CPU_Port				: MEtoCU_IF;
		signal BUS_CPU_Port_sync			: bool;
		signal BUS_CPU_Port_notify		: bool;


	------------------ (Bus_CLINT) ------------------
		signal BUS_CLINT_Port				: CUtoME_IF;
		signal BUS_CLINT_Port_sync			: bool;
		signal BUS_CLINT_Port_notify		: bool;

	------------------ (CLINT_Bus) ------------------
		signal CLINT_BUS_Port				: MEtoCU_IF;
		signal CLINT_BUS_Port_sync			: bool;
		signal CLINT_BUS_Port_notify		: bool;


	------------------ (CLINT_MSIP) ------------------
		signal CLINT_MSIP_InnerCore			: bool;
	------------------ (CLINT_MTIP) ------------------
		signal CLINT_MTIP_InnerCore			: bool;

	--===================================================
	--======================= ISA =======================
	--===================================================
	component ISA is
	port(
	clk							: in std_logic;
	rst							: in std_logic;

	fromMemoryPort				: in MEtoCU_IF;
	fromMemoryPort_sync		: in bool;
	fromMemoryPort_notify	: out bool;

	fromRegsPort				: in RegfileType;

	isa_syscall_Port			: out bool;
	isa_syscall_Port_sync	: in bool;
	isa_syscall_Port_notify	: out bool;

	mip_isa_Port				: in unsigned (31 downto 0);

	syscall_isa_Port			: in bool;
	syscall_isa_Port_sync	: in bool;
	syscall_isa_Port_notify	: out bool;

	toMemoryPort				: out CUtoME_IF;
	toMemoryPort_sync			: in bool;
	toMemoryPort_notify		: out bool;

	toRegsPort					: out RegfileWriteType;
	toRegsPort_notify			: out bool
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
		toRegsPort_sync			: in bool;
		fromRegsPort				: out RegfileType;

		syscall_reg_Port			: in RegfileWriteType;
		syscall_reg_Port_sync	: in bool;
		reg_syscall_Port			: out RegfileSyscallType
	);
	end component;

	--===================================================
	--======================= Mip =======================
	--===================================================
	component Mip is
	port(
		clk						: in std_logic;
		rst						: in std_logic;

		MSIP_port				: in bool;
		MTIP_port				: in bool;
		mip_isa_Port			: out unsigned (31 downto 0)
	);
	end component;

	--===================================================
	--================== SYScallHandler =================
	--===================================================
	component SYScallHandler is
	port(
		clk							: in std_logic;
		rst							: in std_logic;

		fromMemoryPort				: in MEtoCU_IF;
		fromMemoryPort_sync		: in bool;
		fromMemoryPort_notify	: out bool;

		toMemoryPort				: out CUtoME_IF;
		toMemoryPort_sync			: in bool;
		toMemoryPort_notify		: out bool;

		reg_syscall_Port			: in RegfileSyscallType;

		syscall_reg_Port			: out RegfileWriteType;
		syscall_reg_Port_notify	: out bool;

		isa_syscall_Port			: in bool;
		isa_syscall_Port_sync	: in bool;
		isa_syscall_Port_notify	: out bool;

		syscall_isa_Port			: out bool;
		syscall_isa_Port_sync	: in bool;
		syscall_isa_Port_notify	: out bool
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
    	--  blocking_in<CUtoME_IF> syscall_bus_Port
    	syscall_bus_Port		: in CUtoME_IF;
    	syscall_bus_Port_sync	: in bool;
    	syscall_bus_Port_notify	: out bool;

    	--  blocking_in<CUtoME_IF> isa_bus_Port
    	isa_bus_Port			: in CUtoME_IF;
    	isa_bus_Port_sync		: in bool;
    	isa_bus_Port_notify		: out bool;


    	--  blocking_out<MEtoCP_IF> bus_syscall_Port
    	bus_syscall_Port		: out MEtoCU_IF;
    	bus_syscall_Port_sync	: in bool;
    	bus_syscall_Port_notify	: out bool;

    	--  blocking_out<MEtoCP_IF> bus_isa_Port
    	bus_isa_Port			: out MEtoCU_IF;
    	bus_isa_Port_sync		: in bool;
    	bus_isa_Port_notify		: out bool;


    	--------------- Bus - Memory ---------------
    	--  blocking_out<CUtoME_IF> BUS_MEM_Port
    	BUStoMEM_port			: out CUtoME_IF;
    	BUStoMEM_port_sync		: in bool;
    	BUStoMEM_port_notify		: out bool;

    	--  blocking_in<MEtoCP_IF> BUS_MEM_Port
    	MEMtoBUS_port			: in MEtoCU_IF;
    	MEMtoBUS_port_sync		: in bool;
    	MEMtoBUS_port_notify		: out bool;


    	--------------- Bus - CLINT ---------------
    	--  blocking_out<CUtoME_IF> BUS_CLINT_Port
    	BUStoCLINT_port			: out CUtoME_IF;
    	BUStoCLINT_port_sync		: in bool;
    	BUStoCLINT_port_notify	: out bool;

    	--  blocking_in<MEtoCP_IF> BUS_CLINT_Port
    	CLINTtoBUS_port				: in MEtoCU_IF;
    	CLINTtoBUS_port_sync		: in bool;
    	CLINTtoBUS_port_notify	: out bool
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
		--slave_out<bool> MSIP_port;
		MSIP_port				: out bool;
		--slave_out<bool> MTIP_port;
		MTIP_port				: out bool
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

			isa_syscall_Port => isa_syscall_Channel,
			isa_syscall_Port_sync => isa_syscall_Channel_sync,
			isa_syscall_Port_notify => isa_syscall_Channel_notify,

			mip_isa_Port => mip_isa_Channel,

			syscall_isa_Port => syscall_isa_Channel,
			syscall_isa_Port_sync => syscall_isa_Channel_sync,
			syscall_isa_Port_notify => syscall_isa_Channel_notify,

			toMemoryPort => isa_bus_Channel,
			toMemoryPort_sync => isa_bus_Channel_sync,
			toMemoryPort_notify => isa_bus_Channel_notify,

			toRegsPort => toRegsChannel,
			toRegsPort_notify => toRegsChannel_notify
		);

	IF_SYScallHandler : SYScallHandler
		port map (
			clk => clk,
			rst => rst,

			fromMemoryPort => bus_syscall_Channel,
			fromMemoryPort_sync => bus_syscall_Channel_sync,
			fromMemoryPort_notify => bus_syscall_Channel_notify,

			toMemoryPort => syscall_bus_Channel,
			toMemoryPort_sync => syscall_bus_Channel_sync,
			toMemoryPort_notify => syscall_bus_Channel_notify,

			reg_syscall_Port => reg_syscall_Channel,

			syscall_reg_Port => syscall_reg_Channel,
			syscall_reg_Port_notify => syscall_reg_Channel_notify,

			isa_syscall_Port => isa_syscall_Channel,
			isa_syscall_Port_sync => isa_syscall_Channel_notify,
			isa_syscall_Port_notify => isa_syscall_Channel_sync,

			syscall_isa_Port => syscall_isa_Channel,
			syscall_isa_Port_sync => syscall_isa_Channel_notify,
			syscall_isa_Port_notify => syscall_isa_Channel_sync
		);

	IF_Regs : Regs
		port map (
			clk => clk,
			rst => rst,

			toRegsPort => toRegsChannel,
			toRegsPort_sync => toRegsChannel_notify,
			fromRegsPort => fromRegsChannel,

			syscall_reg_Port => syscall_reg_Channel,
			syscall_reg_Port_sync => syscall_reg_Channel_notify,
			reg_syscall_Port => reg_syscall_Channel
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
    	--  blocking_in<CUtoME_IF> syscall_bus_Port
		syscall_bus_Port => syscall_bus_Channel,
		syscall_bus_Port_sync => syscall_bus_Channel_notify,
		syscall_bus_Port_notify => syscall_bus_Channel_sync,

    	--  blocking_in<CUtoME_IF> isa_bus_Port
		isa_bus_Port => isa_bus_Channel,
		isa_bus_Port_sync => isa_bus_Channel_notify,
		isa_bus_Port_notify => isa_bus_Channel_sync,

    	--  blocking_out<MEtoCP_IF> bus_syscall_Port
		bus_syscall_Port => bus_syscall_Channel,
		bus_syscall_Port_sync => bus_syscall_Channel_notify,
		bus_syscall_Port_notify => bus_syscall_Channel_sync,

    	--  blocking_out<MEtoCP_IF> bus_isa_Port
		bus_isa_Port => bus_isa_Channel,
		bus_isa_Port_sync => bus_isa_Channel_notify,
		bus_isa_Port_notify => bus_isa_Channel_sync,


    	--------------- Bus - Memory ---------------
    	--  blocking_out<CUtoME_IF> BUS_MEM_Port
		BUStoMEM_port => COtoME_port,
		BUStoMEM_port_sync => COtoME_port_sync,
		BUStoMEM_port_notify => COtoME_port_notify,

    	--  blocking_in<MEtoCP_IF> MEM_BUS_Port
		MEMtoBUS_port => MEtoCO_port,
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