--
-- Created by deutschmann on 09.10.18
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity CPU is
port(    
    clk                      : in  std_logic;
    rst                   : in  std_logic;
    fromMemoryPort        : in  MEtoCU_IF;
    fromMemoryPort_sync   : in  bool;
    fromMemoryPort_notify : out bool;
    toMemoryPort          : out CUtoME_IF;
    toMemoryPort_sync     : in  bool;
    toMemoryPort_notify   : out bool);
end CPU;


architecture CPU_arch of CPU is


    --------------- ISA ----------------
    component ISA is
        port(    
            clk                   : in  std_logic;
            rst                   : in  std_logic;

            toRegsPort            : out RegfileWriteType;
            toRegsPort_notify     : out bool;
            fromRegsPort          : in  RegfileType;

            toMemoryPort          : out CUtoME_IF;
            toMemoryPort_sync     : in  bool;
            toMemoryPort_notify   : out bool;
            fromMemoryPort        : in  MEtoCU_IF;
            fromMemoryPort_sync   : in  bool;
            fromMemoryPort_notify : out bool
        );
    end component;

    --------------- Register-File ---------------
    component Regs is
        port(    
            clk                 : in  std_logic;
            rst                 : in  std_logic;
            CtlToRegs_port      : in  RegfileWriteType;
            CtlToRegs_port_sync : in  bool;
            RegsToCtl_port      : out RegfileType
        );
    end component;

    ------------------ Signals ------------------
    signal toRegsPort        : RegfileWriteType;
    signal toRegsPort_notify : bool;
    signal fromRegsPort      : RegfileType;

begin

    IF_ISA: ISA
        port map (
            clk                   => clk,
            rst                   => rst,

            toRegsPort            => toRegsPort,
            toRegsPort_notify     => toRegsPort_notify,
            fromRegsPort          => fromRegsPort,

            toMemoryPort          => toMemoryPort,
            toMemoryPort_sync     => toMemoryPort_sync,
            toMemoryPort_notify   => toMemoryPort_notify,
            fromMemoryPort        => fromMemoryPort,
            fromMemoryPort_sync   => fromMemoryPort_sync,
            fromMemoryPort_notify => fromMemoryPort_notify
        );

    IF_Regs: Regs
        port map (
            clk                   => clk,
            rst                   => rst,
            CtlToRegs_port        => toRegsPort,
            CtlToRegs_port_sync   => toRegsPort_notify,
            RegsToCtl_port        => fromRegsPort
        );


end CPU_arch;









































