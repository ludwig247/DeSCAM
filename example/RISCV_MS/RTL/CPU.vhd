--
-- Created by deutschmann on 14.02.18
--
-- Module: Central Processing Unit (CPU)
--
-- Top-Level Description combining Control-Path, Decoder, ALU and Register-File.
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity CPU is
port(    
    clk                  : in  std_logic;
    rst                  : in  std_logic;
    MemToCtl_port        : in  MEtoCU_IF;
    MemToCtl_port_sync   : in  bool;
    MemToCtl_port_notify : out bool;
    CtlToMem_port        : out CUtoME_IF;
    CtlToMem_port_sync   : in  bool;
    CtlToMem_port_notify : out bool);
end CPU;


architecture CPU_arch of CPU is

    -------------------- ALU --------------------
    component ALU is
        port(    
            clk                  : in  std_logic;
            rst                  : in  std_logic;
            CtlToALU_port        : in  CtlToALU_IF;
            CtlToALU_port_sync   : in  bool;
            ALUtoCtl_port        : out ALUtoCtl_IF
        );
    end component;

    --------------- Control-Path ----------------
    component Cpath is
        port(    
            clk                   : in  std_logic;
            rst                   : in  std_logic;

            CtlToALU_port         : out CtlToALU_IF;
            CtlToALU_port_notify  : out bool;
            ALUtoCtl_port         : in  ALUtoCtl_IF;

            CtlToRegs_port        : out CtlToRegs_IF;
            CtlToRegs_port_notify : out bool;
            RegsToCtl_port        : in  RegsToCtl_IF;

            CtlToDec_port         : out Unsigned (31 downto 0);
            CtlToDec_port_notify  : out bool;
            DecToCtl_port         : in  DecodedInstr;

            CtlToMem_port         : out CUtoME_IF;
            CtlToMem_port_sync    : in  bool;
            CtlToMem_port_notify  : out bool;
            MemToCtl_port         : in  MEtoCU_IF;
            MemToCtl_port_sync    : in  bool;
            MemToCtl_port_notify  : out bool
        );
    end component;

    ------------------ Decoder ------------------
    component Decoder is
        port(    
            clk                  : in  std_logic;
            rst                  : in  std_logic;
            CtlToDec_port        : in  Unsigned (31 downto 0);
            CtlToDec_port_sync   : in  bool;
            DecToCtl_port        : out DecodedInstr
        );
    end component;

    --------------- Register-File ---------------
    component Regs is
        port(    
            clk                   : in  std_logic;
            rst                   : in  std_logic;
            CtlToRegs_port        : in  CtlToRegs_IF;
            CtlToRegs_port_sync   : in  bool;
            RegsToCtl_port        : out RegsToCtl_IF
        );
    end component;

    ------------------ Signals ------------------
    signal CtlToALU_port         : CtlToALU_IF;
    signal CtlToALU_port_notify  : bool;
    signal ALUtoCtl_port         : ALUtoCtl_IF;
    signal CtlToRegs_port        : CtlToRegs_IF;
    signal CtlToRegs_port_notify : bool;
    signal RegsToCtl_port        : RegsToCtl_IF;
    signal CtlToDec_port         : Unsigned (31 downto 0);
    signal CtlToDec_port_notify  : bool;
    signal DecToCtl_port         : DecodedInstr;

begin

    IF_ALU: ALU
        port map (
            clk                  => clk,
            rst                  => rst,
            CtlToALU_port        => CtlToALU_port,
            CtlToALU_port_sync   => CtlToALU_port_notify,
            ALUtoCtl_port        => ALUtoCtl_port
        );

    IF_CPath: CPath
        port map (
            clk                   => clk,
            rst                   => rst,

            CtlToALU_port         => CtlToALU_port,
            CtlToALU_port_notify  => CtlToALU_port_notify,
            ALUtoCtl_port         => ALUtoCtl_port,

            CtlToRegs_port        => CtlToRegs_port,
            CtlToRegs_port_notify => CtlToRegs_port_notify,
            RegsToCtl_port        => RegsToCtl_port,

            CtlToDec_port         => CtlToDec_port,
            CtlToDec_port_notify  => CtlToDec_port_notify,
            DecToCtl_port         => DecToCtl_port,

            CtlToMem_port         => CtlToMem_port,
            CtlToMem_port_sync    => CtlToMem_port_sync,
            CtlToMem_port_notify  => CtlToMem_port_notify,
            MemToCtl_port         => MemToCtl_port,
            MemToCtl_port_sync    => MemToCtl_port_sync,
            MemToCtl_port_notify  => MemToCtl_port_notify
        );

    IF_Decoder: Decoder
        port map (
            clk                  => clk,
            rst                  => rst,
            CtlToDec_port        => CtlToDec_port,
            CtlToDec_port_sync   => CtlToDec_port_notify,
            DecToCtl_port        => DecToCtl_port
        );

    IF_Regs: Regs
        port map (
            clk                   => clk,
            rst                   => rst,
            CtlToRegs_port        => CtlToRegs_port,
            CtlToRegs_port_sync   => CtlToRegs_port_notify,
            RegsToCtl_port        => RegsToCtl_port
        );


end CPU_arch;









































