--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18
--
-- Module: Core Local Interruptor (CLINT)
--
-- Only for simulation purposes. Not part of CPU.
-- Consists of 1 32-bit and 2 64-bit registers (Little Endian).
-- 	- msip_reg
-- 	- mtime_reg
-- 	- mtimecmp_reg
-- Used to generate Software and Timer Interrupts.
--		- The msip memory mapped CSR can be used to generate Machine Software Interrupts.
--			This register can be accessed by remote harts to provide machine-mode interprocessor interrupt.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity CLINT is
	port(
		clk						: in  std_logic;
		rst						: in  std_logic;
		CPUtoMEM_port			: in  CUtoME_IF;
		CPUtoMEM_port_sync		: in  boolean;
		CPUtoMEM_port_notify	: out boolean;
		MEMtoCPU_port			: out MEtoCU_IF;
		MEMtoCPU_port_sync		: in  boolean;
		MEMtoCPU_port_notify	: out boolean;
		--slave_out<bool> MSIP_port;
		MSIP_port				: out bool;
		--slave_out<bool> MTIP_port;
		MTIP_port				: out bool
	);
end CLINT;

architecture CLINT_arch of CLINT is


	--====================================================
	--================ Channels ===================
	--====================================================

	-- MasterSlave<unsigned int> Memory_SIP_Channel;
	signal Memory_SIP_Channel			: unsigned (31 downto 0);
	signal Memory_SIP_Channel_sync		: bool;

	-- MasterSlave<unsigned int> Memory_Status_L_Channel;
	signal Memory_Status_L_Channel		: unsigned (31 downto 0);
	signal Memory_Status_L_Channel_sync	: bool;

	-- MasterSlave<unsigned int> Memory_Status_H_Channel;
	signal Memory_Status_H_Channel		: unsigned (31 downto 0);
	signal Memory_Status_H_Channel_sync	: bool;


	-- MasterSlave<unsigned int> Timer_Memory_Channel;
	-- MasterSlave<unsigned int> Timer_Status_Channel;
	signal Timer_Memory_Channel		: unsigned (63 downto 0);
	signal Timer_Status_Channel		: unsigned (63 downto 0);




	--===================================================
	--======================= CLINT_Memory =======================
	--===================================================
	component CLINT_Memory is
	port(
		clk						: in  std_logic;
		rst						: in  std_logic;

		COtoME_port			: in  CUtoME_IF;
		COtoME_port_sync	: in  boolean;
		COtoME_port_notify	: out boolean;

		MEtoCO_port			: out MEtoCU_IF;
		MEtoCO_port_sync	: in  boolean;
		MEtoCO_port_notify	: out boolean;

		toSipStatus			: out unsigned (31 downto 0);
		toSipStatus_notify	: out bool;

		fromTimer			: in unsigned (63 downto 0);

		toTimerStatus_L			: out unsigned (31 downto 0);
		toTimerStatus_L_notify	: out bool;

		toTimerStatus_H			: out unsigned (31 downto 0);
		toTimerStatus_H_notify	: out bool
	);
	end component;


	--===================================================
	--======================= CLINT_Timer =======================
	--===================================================
	component CLINT_Timer is
	port(
		clk					: in  std_logic;
		rst					: in  std_logic;

		toMemory			: out unsigned (63 downto 0);
		toTimerStatus		: out unsigned (63 downto 0)
	);
	end component;


	--===================================================
	--======================= CLINT_TimerStatus =======================
	--===================================================
	component CLINT_TimerStatus is
	port(
		clk					: in  std_logic;
		rst					: in  std_logic;

		fromTimer			: in unsigned (63 downto 0);

		fromMemory_timecmp_L		: in unsigned (31 downto 0);
		fromMemory_timecmp_L_sync	: in bool;

		fromMemory_timecmp_H		: in unsigned (31 downto 0);
		fromMemory_timecmp_H_sync	: in bool;

		MTIP_port			: out bool
	);
	end component;


	--===================================================
	--======================= CLINT_SipStatus =======================
	--===================================================
	component CLINT_SipStatus is
	port(
		clk					: in  std_logic;
		rst					: in  std_logic;

		fromMemory_sip		: in unsigned (31 downto 0);
		fromMemory_sip_sync	: in bool;

		MSIP_port			: out bool
	);
	end component;




begin


	IF_CLINT_Memory : CLINT_Memory
	port map (
		clk => clk,
		rst => rst,

		COtoME_port	=> CPUtoMEM_port,
		COtoME_port_sync => CPUtoMEM_port_sync,
		COtoME_port_notify => CPUtoMEM_port_notify,

		MEtoCO_port => MEMtoCPU_port,
		MEtoCO_port_sync => MEMtoCPU_port_sync,
		MEtoCO_port_notify => MEMtoCPU_port_notify,

		toSipStatus => Memory_SIP_Channel,
		toSipStatus_notify => Memory_SIP_Channel_sync,

		fromTimer => Timer_Memory_Channel,

		toTimerStatus_L => Memory_Status_L_Channel,
		toTimerStatus_L_notify => Memory_Status_L_Channel_sync,

		toTimerStatus_H => Memory_Status_H_Channel,
		toTimerStatus_H_notify => Memory_Status_H_Channel_sync
	);


	IF_CLINT_Timer : CLINT_Timer
	port map (
		clk => clk,
		rst => rst,

		toMemory => Timer_Memory_Channel,
		toTimerStatus => Timer_Status_Channel
	);


	IF_CLINT_TimerStatus : CLINT_TimerStatus
	port map (
		clk => clk,
		rst => rst,

		fromTimer => Timer_Status_Channel,

		fromMemory_timecmp_L => Memory_Status_L_Channel,
		fromMemory_timecmp_L_sync => Memory_Status_L_Channel_sync,

		fromMemory_timecmp_H => Memory_Status_H_Channel,
		fromMemory_timecmp_H_sync => Memory_Status_H_Channel_sync,

		MTIP_port => MTIP_port
	);


	IF_CLINT_SipStatus : CLINT_SipStatus
	port map (
		clk => clk,
		rst => rst,

		fromMemory_sip => Memory_SIP_Channel,
		fromMemory_sip_sync => Memory_SIP_Channel_sync,

		MSIP_port => MSIP_port
	);

end CLINT_arch;
