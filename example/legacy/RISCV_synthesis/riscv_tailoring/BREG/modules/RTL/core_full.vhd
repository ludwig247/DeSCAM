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
	signal ISAtoREG_channel					: RegfileWriteType;
	signal ISAtoREG_channel_notify		: boolean;--flip at reg

	signal REGtoISA_channel				: RegfileType;

	------------------ Inside Channels (SYSCALL_REG) ------------------
	signal syscall_reg_Channel			: RegfileWriteType;
	signal syscall_reg_Channel_notify: boolean;--flip at reg

	signal reg_syscall_Channel			: RegfileSyscallType;

	------------------ Inside Channels (ISA_SYSCALL) ------------------
	signal isa_syscall_Channel			: boolean;
	signal isa_syscall_Channel_sync	: boolean;--flip at syscall
	signal isa_syscall_Channel_notify: boolean;--flip at syscall

	signal syscall_isa_Channel			: boolean;
	signal syscall_isa_Channel_sync	: boolean;--flip at syscall
	signal syscall_isa_Channel_notify: boolean;--flip at syscall

	------------------ Inside Channels (ISA_BUS) ------------------
	signal isa_bus_Channel				: CUtoME_IF;
	signal isa_bus_Channel_sync		: boolean;--flip at bus
	signal isa_bus_Channel_notify		: boolean;--flip at bus

	signal bus_isa_Channel				: MEtoCU_IF;
	signal bus_isa_Channel_sync		: boolean;--flip at bus
	signal bus_isa_Channel_notify		: boolean;--flip at bus

	------------------ Inside Channels (SYSCALL_BUS) ------------------
	signal syscall_bus_Channel			: CUtoME_IF;
	signal syscall_bus_Channel_sync	: boolean;--flip at bus
	signal syscall_bus_Channel_notify: boolean;--flip at bus

	signal bus_syscall_Channel			: MEtoCU_IF;
	signal bus_syscall_Channel_sync	: boolean;--flip at bus
	signal bus_syscall_Channel_notify: boolean;--flip at bus

	------------------ Inside Channels (ISA_MIP) ------------------
	signal mip_isa_Channel				: unsigned (31 downto 0);


	--====================================================
	--================ Channels ===================
	--====================================================

	------------------ (InnerCore_Bus) ------------------
		signal CPU_BUS_port_sig				: CUtoME_IF;
		signal CPU_BUS_port_sync			: boolean;
		signal CPU_BUS_port_notify		: boolean;

	------------------ (Bus_InnerCore) ------------------
		signal BUS_CPU_port_sig				: MEtoCU_IF;
		signal BUS_CPU_port_sync			: boolean;
		signal BUS_CPU_port_notify		: boolean;


	------------------ (Bus_CLINT) ------------------
		signal BUS_CLINT_port_sig				: CUtoME_IF;
		signal BUS_CLINT_port_sync			: boolean;
		signal BUS_CLINT_port_notify		: boolean;

	------------------ (CLINT_Bus) ------------------
		signal CLINT_BUS_port_sig				: MEtoCU_IF;
		signal CLINT_BUS_port_sync			: boolean;
		signal CLINT_BUS_port_notify		: boolean;


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

	MEtoCO_port_sig				: in MEtoCU_IF;
	MEtoCO_port_sync		: in boolean;
	MEtoCO_port_notify	: out boolean;

	RFtoISA_port_sig				: in RegfileType;

	isa_syscall_port_sig			: out boolean;
	isa_syscall_port_sync	: in boolean;
	isa_syscall_port_notify	: out boolean;

	mip_isa_port_sig				: in unsigned (31 downto 0);

	syscall_isa_port_sig			: in boolean;
	syscall_isa_port_sync	: in boolean;
	syscall_isa_port_notify	: out boolean;

	COtoME_port_sig				: out CUtoME_IF;
	COtoME_port_sync			: in boolean;
	COtoME_port_notify		: out boolean;

	ISAtoRF_port_sig					: out RegfileWriteType;
	ISAtoRF_port_notify			: out boolean
	);
	end component;

	--===================================================
	--================== Register-File ==================
	--===================================================
	component Regs is
	port(
		clk							: in std_logic;
		rst							: in std_logic;

		ISAtoRF_port_sig					: in RegfileWriteType;
		ISAtoRF_port_sync			: in boolean;
		RFtoISA_port_sig				: out RegfileType;

		syscall_reg_port_sig			: in RegfileWriteType;
		syscall_reg_port_sync	: in boolean;
		reg_syscall_port_sig			: out RegfileSyscallType
	);
	end component;

	--===================================================
	--======================= Mip =======================
	--===================================================
	component Mip is
	port(
		clk						: in std_logic;
		rst						: in std_logic;

		MSIP_port_sig				: in boolean;
		MTIP_port_sig				: in boolean;
		mip_isa_port_sig			: out unsigned (31 downto 0)
	);
	end component;

	--===================================================
	--================== SYScallHandler =================
	--===================================================
	component SYScallHandler is
	port(
		clk							: in std_logic;
		rst							: in std_logic;

		MEtoCO_port_sig				: in MEtoCU_IF;
		MEtoCO_port_sync		: in boolean;
		MEtoCO_port_notify	: out boolean;

		COtoME_port_sig				: out CUtoME_IF;
		COtoME_port_sync			: in boolean;
		COtoME_port_notify		: out boolean;

		reg_syscall_port_sig			: in RegfileSyscallType;

		syscall_reg_port_sig			: out RegfileWriteType;
		syscall_reg_port_notify	: out boolean;

		isa_syscall_port_sig			: in boolean;
		isa_syscall_port_sync	: in boolean;
		isa_syscall_port_notify	: out boolean;

		syscall_isa_port_sig			: out boolean;
		syscall_isa_port_sync	: in boolean;
		syscall_isa_port_notify	: out boolean
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
    	--  blocking_in<CUtoME_IF> syscall_bus_port_sig
    	syscall_bus_port_sig		: in CUtoME_IF;
    	syscall_bus_port_sync	: in boolean;
    	syscall_bus_port_notify	: out boolean;

    	--  blocking_in<CUtoME_IF> isa_bus_port_sig
    	isa_bus_port_sig			: in CUtoME_IF;
    	isa_bus_port_sync		: in boolean;
    	isa_bus_port_notify		: out boolean;


    	--  blocking_out<MEtoCP_IF> bus_syscall_port_sig
    	bus_syscall_port_sig		: out MEtoCU_IF;
    	bus_syscall_port_sync	: in boolean;
    	bus_syscall_port_notify	: out boolean;

    	--  blocking_out<MEtoCP_IF> bus_isa_port_sig
    	bus_isa_port_sig			: out MEtoCU_IF;
    	bus_isa_port_sync		: in boolean;
    	bus_isa_port_notify		: out boolean;


    	--------------- Bus - Memory ---------------
    	--  blocking_out<CUtoME_IF> BUS_MEM_port_sig
    	BUStoMEM_port_sig			: out CUtoME_IF;
    	BUStoMEM_port_sync		: in boolean;
    	BUStoMEM_port_notify		: out boolean;

    	--  blocking_in<MEtoCP_IF> BUS_MEM_port_sig
    	MEMtoBUS_port_sig			: in MEtoCU_IF;
    	MEMtoBUS_port_sync		: in boolean;
    	MEMtoBUS_port_notify		: out boolean;


    	--------------- Bus - CLINT ---------------
    	--  blocking_out<CUtoME_IF> BUS_CLINT_port_sig
    	BUStoCLINT_port_sig			: out CUtoME_IF;
    	BUStoCLINT_port_sync		: in boolean;
    	BUStoCLINT_port_notify	: out boolean;

    	--  blocking_in<MEtoCP_IF> BUS_CLINT_port_sig
    	CLINTtoBUS_port_sig				: in MEtoCU_IF;
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
		CPUtoMEM_port_sig			: in  CUtoME_IF;
		CPUtoMEM_port_sync	: in  boolean;
		CPUtoMEM_port_notify	: out boolean;
		MEMtoCPU_port_sig			: out MEtoCU_IF;
		MEMtoCPU_port_sync	: in  boolean;
		MEMtoCPU_port_notify	: out boolean;
		--slave_out<boolean> MSIP_port_sig;
		MSIP_port_sig				: out boolean;
		--slave_out<boolean> MTIP_port_sig;
		MTIP_port_sig				: out boolean
	);
	end component;


begin

    IF_ISA : ISA
		port map (
			clk => clk,
			rst => rst,

			MEtoCO_port_sig => bus_isa_Channel,
			MEtoCO_port_sync => bus_isa_Channel_sync,
			MEtoCO_port_notify => bus_isa_Channel_notify,

			RFtoISA_port_sig => REGtoISA_channel,

			isa_syscall_port_sig => isa_syscall_Channel,
			isa_syscall_port_sync => isa_syscall_Channel_sync,
			isa_syscall_port_notify => isa_syscall_Channel_notify,

			mip_isa_port_sig => mip_isa_Channel,

			syscall_isa_port_sig => syscall_isa_Channel,
			syscall_isa_port_sync => syscall_isa_Channel_sync,
			syscall_isa_port_notify => syscall_isa_Channel_notify,

			COtoME_port_sig => isa_bus_Channel,
			COtoME_port_sync => isa_bus_Channel_sync,
			COtoME_port_notify => isa_bus_Channel_notify,

			ISAtoRF_port_sig => ISAtoREG_channel,
			ISAtoRF_port_notify => ISAtoREG_channel_notify
		);

	IF_SYScallHandler : SYScallHandler
		port map (
			clk => clk,
			rst => rst,

			MEtoCO_port_sig => bus_syscall_Channel,
			MEtoCO_port_sync => bus_syscall_Channel_sync,
			MEtoCO_port_notify => bus_syscall_Channel_notify,

			COtoME_port_sig => syscall_bus_Channel,
			COtoME_port_sync => syscall_bus_Channel_sync,
			COtoME_port_notify => syscall_bus_Channel_notify,

			reg_syscall_port_sig => reg_syscall_Channel,

			syscall_reg_port_sig => syscall_reg_Channel,
			syscall_reg_port_notify => syscall_reg_Channel_notify,

			isa_syscall_port_sig => isa_syscall_Channel,
			isa_syscall_port_sync => isa_syscall_Channel_notify,
			isa_syscall_port_notify => isa_syscall_Channel_sync,

			syscall_isa_port_sig => syscall_isa_Channel,
			syscall_isa_port_sync => syscall_isa_Channel_notify,
			syscall_isa_port_notify => syscall_isa_Channel_sync
		);

	IF_Regs : Regs
		port map (
			clk => clk,
			rst => rst,

			ISAtoRF_port_sig => ISAtoREG_channel,
			ISAtoRF_port_sync => ISAtoREG_channel_notify,
			RFtoISA_port_sig => REGtoISA_channel,

			syscall_reg_port_sig => syscall_reg_Channel,
			syscall_reg_port_sync => syscall_reg_Channel_notify,
			reg_syscall_port_sig => reg_syscall_Channel
		);

	IF_Mip : Mip
		port map (
			clk => clk,
			rst => rst,

			MSIP_port_sig => CLINT_MSIP_InnerCore,
			MTIP_port_sig => CLINT_MTIP_InnerCore,
			mip_isa_port_sig => mip_isa_Channel
		);

	IF_CoreBus : CoreBus
	port map (
		clk => clk,
		rst => rst,

		--------------- CPU - Bus ---------------
    	--  blocking_in<CUtoME_IF> syscall_bus_port_sig
		syscall_bus_port_sig => syscall_bus_Channel,
		syscall_bus_port_sync => syscall_bus_Channel_notify,
		syscall_bus_port_notify => syscall_bus_Channel_sync,

    	--  blocking_in<CUtoME_IF> isa_bus_port_sig
		isa_bus_port_sig => isa_bus_Channel,
		isa_bus_port_sync => isa_bus_Channel_notify,
		isa_bus_port_notify => isa_bus_Channel_sync,

    	--  blocking_out<MEtoCP_IF> bus_syscall_port_sig
		bus_syscall_port_sig => bus_syscall_Channel,
		bus_syscall_port_sync => bus_syscall_Channel_notify,
		bus_syscall_port_notify => bus_syscall_Channel_sync,

    	--  blocking_out<MEtoCP_IF> bus_isa_port_sig
		bus_isa_port_sig => bus_isa_Channel,
		bus_isa_port_sync => bus_isa_Channel_notify,
		bus_isa_port_notify => bus_isa_Channel_sync,


    	--------------- Bus - Memory ---------------
    	--  blocking_out<CUtoME_IF> BUS_MEM_port_sig
		BUStoMEM_port_sig => COtoME_port_sig,
		BUStoMEM_port_sync => COtoME_port_sync,
		BUStoMEM_port_notify => COtoME_port_notify,

    	--  blocking_in<MEtoCP_IF> MEM_BUS_port_sig
		MEMtoBUS_port_sig => MEtoCO_port_sig,
		MEMtoBUS_port_sync => MEtoCO_port_sync,
		MEMtoBUS_port_notify => MEtoCO_port_notify,


    	--------------- Bus - CLINT ---------------
    	--  blocking_out<CUtoME_IF> BUS_CLINT_port_sig
		BUStoCLINT_port_sig => BUS_CLINT_port_sig,
		BUStoCLINT_port_sync => BUS_CLINT_port_notify,
		BUStoCLINT_port_notify => BUS_CLINT_port_sync,

    	--  blocking_in<MEtoCP_IF> CLINTtoBUS_port_sig
		CLINTtoBUS_port_sig => CLINT_BUS_port_sig,
		CLINTtoBUS_port_sync => CLINT_BUS_port_notify,
		CLINTtoBUS_port_notify => CLINT_BUS_port_sync
	);



	IF_CLINT : CLINT
	port map (
		clk => clk,
		rst => rst,

		CPUtoMEM_port_sig => BUS_CLINT_port_sig,
		CPUtoMEM_port_sync => BUS_CLINT_port_sync,
		CPUtoMEM_port_notify => BUS_CLINT_port_notify,
		MEMtoCPU_port_sig => CLINT_BUS_port_sig,
		MEMtoCPU_port_sync => CLINT_BUS_port_sync,
		MEMtoCPU_port_notify => CLINT_BUS_port_notify,
		MSIP_port_sig => CLINT_MSIP_InnerCore,
		MTIP_port_sig => CLINT_MTIP_InnerCore
	);

end Core_arch;
