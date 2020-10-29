--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity InnerCore is
port(
	clk						: in  std_logic;
	rst						: in  std_logic;

	-- blocking_in<MEtoCP_IF> MEtoCO_port;
	MEtoCO_port				: in  MEtoCP_IF;
	MEtoCO_port_sync		: in  bool;
	MEtoCO_port_notify	: out bool;

	--	blocking_out<CUtoME_IF> COtoME_port;
	COtoME_port				: out CUtoME_IF;
	COtoME_port_sync		: in  bool;
	COtoME_port_notify	: out bool;
	
	-- master_in<bool> mSip_mip_port;
	mSip_mip_port			: in bool;

	-- master_in<bool> mTip_mip_port;
	mTip_mip_port			: in bool;

	-- master_in<bool> mEip_mip_port;
	mEip_mip_port			: in bool
);
end InnerCore;


architecture InnerCore_arch of InnerCore is

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

	signal bus_isa_Channel				: MEtoCP_IF;
	signal bus_isa_Channel_sync		: bool;--flip at bus
	signal bus_isa_Channel_notify		: bool;--flip at bus
	
	------------------ Inside Channels (SYSCALL_BUS) ------------------
	signal syscall_bus_Channel			: CUtoME_IF;
	signal syscall_bus_Channel_sync	: bool;--flip at bus
	signal syscall_bus_Channel_notify: bool;--flip at bus

	signal bus_syscall_Channel			: MEtoCP_IF;
	signal bus_syscall_Channel_sync	: bool;--flip at bus
	signal bus_syscall_Channel_notify: bool;--flip at bus

	------------------ Inside Channels (ISA_MIP) ------------------
	signal mip_isa_Channel				: unsigned (31 downto 0);




	--===================================================
	--======================= ISA =======================
	--===================================================
	component ISA is
	port(
	clk							: in std_logic;
	rst							: in std_logic;

	fromMemoryPort				: in MEtoCP_IF;
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
	--===================== InnerBus ====================
	--===================================================
	component InnerBus is
	port(
		clk							: in std_logic;
		rst							: in std_logic;

		fromMemoryPort				: in MEtoCP_IF;
		fromMemoryPort_sync		: in bool;
		fromMemoryPort_notify	: out bool;

		isa_bus_Port				: in CUtoME_IF;
		isa_bus_Port_sync			: in bool;
		isa_bus_Port_notify		: out bool;

		syscall_bus_Port			: in CUtoME_IF;
		syscall_bus_Port_sync	: in bool;
		syscall_bus_Port_notify	: out bool;

		toMemoryPort				: out CUtoME_IF;
		toMemoryPort_sync			: in bool;
		toMemoryPort_notify		: out bool;

		bus_syscall_Port			: out MEtoCP_IF;
		bus_syscall_Port_sync	: in bool;
		bus_syscall_Port_notify	: out bool;

		bus_isa_Port				: out MEtoCP_IF;
		bus_isa_Port_sync			: in bool;
		bus_isa_Port_notify		: out bool
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
		MEIP_port				: in bool;
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

		fromMemoryPort				: in MEtoCP_IF;
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

			MSIP_port => mSip_mip_port,
			MTIP_port => mTip_mip_port,
			MEIP_port => mEip_mip_port,
			mip_isa_Port => mip_isa_Channel
		);

	IF_InnerBus : InnerBus
		port map (
			clk => clk,
			rst => rst,

			fromMemoryPort => MEtoCO_port,
			fromMemoryPort_sync => MEtoCO_port_sync,
			fromMemoryPort_notify => MEtoCO_port_notify,

			isa_bus_Port => isa_bus_Channel,
			isa_bus_Port_sync => isa_bus_Channel_notify,
			isa_bus_Port_notify => isa_bus_Channel_sync,

			syscall_bus_Port => syscall_bus_Channel,
			syscall_bus_Port_sync => syscall_bus_Channel_notify,
			syscall_bus_Port_notify => syscall_bus_Channel_sync,

			toMemoryPort => COtoME_port,
			toMemoryPort_sync => COtoME_port_sync,
			toMemoryPort_notify => COtoME_port_notify,

			bus_syscall_Port => bus_syscall_Channel,
			bus_syscall_Port_sync => bus_syscall_Channel_notify,
			bus_syscall_Port_notify => bus_syscall_Channel_sync,

			bus_isa_Port => bus_isa_Channel,
			bus_isa_Port_sync => bus_isa_Channel_notify,
			bus_isa_Port_notify => bus_isa_Channel_sync
		);


end InnerCore_arch;