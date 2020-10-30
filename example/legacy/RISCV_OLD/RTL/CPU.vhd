--
-- Created by deutschmann on 14.02.18
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity CPU is
port(    
    clk                  : in  std_logic;
    rst                  : in  std_logic;
    MemToDec_port        : in  Unsigned (31 downto 0);
    MemToDec_port_sync   : in  bool;
    MemToDec_port_notify : out bool;
    MemToCtl_port        : in  Unsigned (31 downto 0);
    MemToCtl_port_sync   : in  bool;
    MemToCtl_port_notify : out bool;
    CtlToMem_port        : out MemoryAccess;
    CtlToMem_port_sync   : in  bool;
    CtlToMem_port_notify : out bool);
end CPU;


architecture CPU_arch of CPU is

    -------------------- ALU --------------------
    component ALU is
        port(    
            clk                  : in  std_logic;
            rst                  : in  std_logic;
            ALUtoCtl_port        : out ALUtoCtl_IF;
            ALUtoCtl_port_sync   : in  bool;
            ALUtoCtl_port_notify : out bool;
            CtlToALU_port        : in  CtlToALU_IF;
            CtlToALU_port_sync   : in  bool;
            CtlToALU_port_notify : out bool
        );
    end component;

    --------------- Control-Path ----------------
    component Cpath is
        port(    
            clk                   : in  std_logic;
            rst                   : in  std_logic;
            ALUtoCtl_port         : in  ALUtoCtl_IF;
            ALUtoCtl_port_sync    : in  bool;
            ALUtoCtl_port_notify  : out bool;
            CtlToALU_port         : out CtlToALU_IF;
            CtlToALU_port_sync    : in  bool;
            CtlToALU_port_notify  : out bool;
            CtlToRegs_port        : out CtlToRegs_IF;
            CtlToRegs_port_sync   : in  bool;
            CtlToRegs_port_notify : out bool;
            RegsToCtl_port        : in  RegsToCtl_IF;
            RegsToCtl_port_sync   : in  bool;
            RegsToCtl_port_notify : out bool;
            DecToCtl_port         : in  DecodedInstr;
            DecToCtl_port_sync    : in  bool;
            DecToCtl_port_notify  : out bool;
            MemToCtl_port         : in  Unsigned (31 downto 0);
            MemToCtl_port_sync    : in  bool;
            MemToCtl_port_notify  : out bool;
            CtlToMem_port         : out MemoryAccess;
            CtlToMem_port_sync    : in  bool;
            CtlToMem_port_notify  : out bool
        );
    end component;

    ------------------ Decoder ------------------
    component Decoder is
        port(    
            clk                  : in  std_logic;
            rst                  : in  std_logic;
            MemToDec_port        : in  Unsigned (31 downto 0);
            MemToDec_port_sync   : in  bool;
            MemToDec_port_notify : out bool;
            DecToCtl_port        : out DecodedInstr;
            DecToCtl_port_sync   : in  bool;
            DecToCtl_port_notify : out bool
        );
    end component;

    --------------- Register-File ---------------
    component Regs is
        port(    
            clk                   : in  std_logic;
            rst                   : in  std_logic;
            CtlToRegs_port        : in  CtlToRegs_IF;
            CtlToRegs_port_sync   : in  bool;
            CtlToRegs_port_notify : out bool;
            RegsToCtl_port        : out RegsToCtl_IF;
            RegsToCtl_port_sync   : in  bool;
            RegsToCtl_port_notify : out bool
        );
    end component;

    ------------------ Signals ------------------
    signal ALUtoCtl_port         : ALUtoCtl_IF;
    signal ALUtoCtl_port_sync    : bool;
    signal ALUtoCtl_port_notify  : bool;
    signal CtlToALU_port         : CtlToALU_IF;
    signal CtlToALU_port_sync    : bool;
    signal CtlToALU_port_notify  : bool;
    signal CtlToRegs_port        : CtlToRegs_IF;
    signal CtlToRegs_port_sync   : bool;
    signal CtlToRegs_port_notify : bool;
    signal RegsToCtl_port        : RegsToCtl_IF;
    signal RegsToCtl_port_sync   : bool;
    signal RegsToCtl_port_notify : bool;
    signal DecToCtl_port         : DecodedInstr;
    signal DecToCtl_port_sync    : bool;
    signal DecToCtl_port_notify  : bool;

begin

    IF_ALU: ALU
        port map (
            clk                  => clk,
            rst                  => rst,
            ALUtoCtl_port        => ALUtoCtl_port,
            ALUtoCtl_port_sync   => ALUtoCtl_port_sync,
            ALUtoCtl_port_notify => ALUtoCtl_port_notify,
            CtlToALU_port        => CtlToALU_port,
            CtlToALU_port_sync   => CtlToALU_port_notify,
            CtlToALU_port_notify => CtlToALU_port_sync
        );

    IF_CPath: CPath
        port map (
            clk                   => clk,
            rst                   => rst,
            ALUtoCtl_port         => ALUtoCtl_port,
            ALUtoCtl_port_sync    => ALUtoCtl_port_notify,
            ALUtoCtl_port_notify  => ALUtoCtl_port_sync,
            CtlToALU_port         => CtlToALU_port,
            CtlToALU_port_sync    => CtlToALU_port_sync,
            CtlToALU_port_notify  => CtlToALU_port_notify,
            CtlToRegs_port        => CtlToRegs_port,
            CtlToRegs_port_sync   => CtlToRegs_port_sync,
            CtlToRegs_port_notify => CtlToRegs_port_notify,
            RegsToCtl_port        => RegsToCtl_port,
            RegsToCtl_port_sync   => RegsToCtl_port_notify,
            RegsToCtl_port_notify => RegsToCtl_port_sync,
            DecToCtl_port         => DecToCtl_port,
            DecToCtl_port_sync    => DecToCtl_port_notify,
            DecToCtl_port_notify  => DecToCtl_port_sync,
            MemToCtl_port         => MemToCtl_port,
            MemToCtl_port_sync    => MemToCtl_port_sync,
            MemToCtl_port_notify  => MemToCtl_port_notify,
            CtlToMem_port         => CtlToMem_port,
            CtlToMem_port_sync    => CtlToMem_port_sync,
            CtlToMem_port_notify  => CtlToMem_port_notify
        );

    IF_Decoder: Decoder
        port map (
            clk                  => clk,
            rst                  => rst,
            MemToDec_port        => MemToDec_port,
            MemToDec_port_sync   => MemToDec_port_sync,
            MemToDec_port_notify => MemToDec_port_notify,
            DecToCtl_port        => DecToCtl_port,
            DecToCtl_port_sync   => DecToCtl_port_sync,
            DecToCtl_port_notify => DecToCtl_port_notify
        );

    IF_Regs: Regs
        port map (
            clk                   => clk,
            rst                   => rst,
            CtlToRegs_port        => CtlToRegs_port,
            CtlToRegs_port_sync   => CtlToRegs_port_notify,
            CtlToRegs_port_notify => CtlToRegs_port_sync,
            RegsToCtl_port        => RegsToCtl_port,
            RegsToCtl_port_sync   => RegsToCtl_port_sync,
            RegsToCtl_port_notify => RegsToCtl_port_notify
        );


end CPU_arch;









































