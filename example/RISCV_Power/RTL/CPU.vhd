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
--use work.SCAM_Model_types.all;

entity CPU is
port(    
    clk                  : in  std_logic;
    rst                  : in  std_logic;
    MemToCtl_port        : in  Unsigned (31 downto 0);
    MemToCtl_port_sync   : in  std_logic;
    MemToCtl_port_notify : out std_logic;
    CtlToMem_port_addrIn : out Unsigned (31 downto 0);
    CtlToMem_port_dataIn : out Unsigned (31 downto 0);
    CtlToMem_port_mask   : out Unsigned ( 2 downto 0);
    CtlToMem_port_req    : out std_logic;
    CtlToMem_port_sync   : in  std_logic;
    CtlToMem_port_notify : out std_logic);
end CPU;


architecture CPU_arch of CPU is

    -------------------- ALU --------------------
    component ALU is
        port(    
    clk : in  std_logic;
    rst : in  std_logic;
    ALUtoCtl_port : out Unsigned (31 downto 0);
    CtlToALU_port_alu_fun       : in Unsigned ( 3 downto 0);
    CtlToALU_port_imm           : in Unsigned (31 downto 0);
    CtlToALU_port_op1_sel       : in Unsigned ( 1 downto 0);
    CtlToALU_port_op2_sel       : in Unsigned ( 1 downto 0);
    CtlToALU_port_pc_reg        : in Unsigned (31 downto 0);
    CtlToALU_port_reg1_contents : in Unsigned (31 downto 0);
    CtlToALU_port_reg2_contents : in Unsigned (31 downto 0);
    CtlToALU_port_sync          : in std_logic
        );
    end component;

    --------------- Control-Path ----------------
    component Cpath is
        port(    
        -- Clock
        clk                   : in  std_logic;

        -- Synchronous Reset
        rst                   : in  std_logic;

        -- Communication with ALU
        CtlToALU_port_alu_fun       : out Unsigned ( 3 downto 0);
        CtlToALU_port_imm           : out Unsigned (31 downto 0);
        CtlToALU_port_op1_sel       : out Unsigned ( 1 downto 0);
        CtlToALU_port_op2_sel       : out Unsigned ( 1 downto 0);
        CtlToALU_port_pc_reg        : out Unsigned (31 downto 0);
        CtlToALU_port_reg1_contents : out Unsigned (31 downto 0);
        CtlToALU_port_reg2_contents : out Unsigned (31 downto 0);
        CtlToALU_port_notify        : out std_logic;
        ALUtoCtl_port               : in  Unsigned (31 downto 0);

        -- Communication with Register-File
        CtlToRegs_port_dst       : out Unsigned ( 4 downto 0);
        CtlToRegs_port_dst_data  : out Unsigned (31 downto 0);
        CtlToRegs_port_req       : out std_logic;
        CtlToRegs_port_src1      : out Unsigned ( 4 downto 0);
        CtlToRegs_port_src2      : out Unsigned ( 4 downto 0);
        CtlToRegs_port_notify    : out std_logic;
        RegsToCtl_port_contents1 : in  Unsigned (31 downto 0);
        RegsToCtl_port_contents2 : in  Unsigned (31 downto 0);
         
        -- Communication with Decoder
        CtlToDec_port           : out Unsigned (31 downto 0);
        CtlToDec_port_notify    : out std_logic;
        DecToCtl_port_encType   : in  Unsigned ( 2 downto 0);
        DecToCtl_port_imm       : in  Unsigned (31 downto 0);
        DecToCtl_port_instrType : in  Unsigned ( 5 downto 0);
        DecToCtl_port_rd_addr   : in  Unsigned ( 4 downto 0);
        DecToCtl_port_rs1_addr  : in  Unsigned ( 4 downto 0);
        DecToCtl_port_rs2_addr  : in  Unsigned ( 4 downto 0);

        -- Communication with Memory
        MemToCtl_port        : in  Unsigned (31 downto 0);
        MemToCtl_port_sync   : in  std_logic;
        MemToCtl_port_notify : out std_logic;
        CtlToMem_port_addrIn : out Unsigned (31 downto 0);
        CtlToMem_port_dataIn : out Unsigned (31 downto 0);
        CtlToMem_port_mask   : out Unsigned ( 2 downto 0);
        CtlToMem_port_req    : out std_logic;
        CtlToMem_port_sync   : in  std_logic;
        CtlToMem_port_notify : out std_logic
        );
    end component;

    ------------------ Decoder ------------------
    component Decoder is
        port(    
    clk                  : in  std_logic;
    rst                  : in  std_logic;
    CtlToDec_port        : in  Unsigned (31 downto 0);
    CtlToDec_port_sync   : in  std_logic;
    DecToCtl_port_encType   : out Unsigned ( 2 downto 0);
    DecToCtl_port_imm       : out Unsigned (31 downto 0);
    DecToCtl_port_instrType : out Unsigned ( 5 downto 0);
    DecToCtl_port_rd_addr   : out Unsigned ( 4 downto 0);
    DecToCtl_port_rs1_addr  : out Unsigned ( 4 downto 0);
    DecToCtl_port_rs2_addr  : out Unsigned ( 4 downto 0)
        );
    end component;

    --------------- Register-File ---------------
    component Regs is
        port(    
    clk                      : in  std_logic;
    rst                      : in  std_logic;
    CtlToRegs_port_dst       : in  Unsigned ( 4 downto 0);
    CtlToRegs_port_dst_data  : in  Unsigned (31 downto 0);
    CtlToRegs_port_req       : in  std_logic;
    CtlToRegs_port_src1      : in  Unsigned ( 4 downto 0);
    CtlToRegs_port_src2      : in  Unsigned ( 4 downto 0);
    CtlToRegs_port_sync      : in  std_logic;
    RegsToCtl_port_contents1 : out Unsigned (31 downto 0);
    RegsToCtl_port_contents2 : out Unsigned (31 downto 0)
        );
    end component;

    ------------------ Signals ------------------
    signal CtlToALU_port_alu_fun       : Unsigned ( 3 downto 0);
    signal CtlToALU_port_imm           : Unsigned (31 downto 0);
    signal CtlToALU_port_op1_sel       : Unsigned ( 1 downto 0);
    signal CtlToALU_port_op2_sel       : Unsigned ( 1 downto 0);
    signal CtlToALU_port_pc_reg        : Unsigned (31 downto 0);
    signal CtlToALU_port_reg1_contents : Unsigned (31 downto 0);
    signal CtlToALU_port_reg2_contents : Unsigned (31 downto 0);
    signal CtlToALU_port_notify  : std_logic;
    signal ALUtoCtl_port         : Unsigned (31 downto 0);
    signal CtlToRegs_port_dst      : Unsigned ( 4 downto 0);
    signal CtlToRegs_port_dst_data : Unsigned (31 downto 0);
    signal CtlToRegs_port_req      : std_logic;
    signal CtlToRegs_port_src1     : Unsigned ( 4 downto 0);
    signal CtlToRegs_port_src2     : Unsigned ( 4 downto 0);
    signal CtlToRegs_port_notify : std_logic;
    signal RegsToCtl_port_contents1 : Unsigned (31 downto 0);
    signal RegsToCtl_port_contents2 : Unsigned (31 downto 0);
    signal CtlToDec_port         : Unsigned (31 downto 0);
    signal CtlToDec_port_notify  : std_logic;
    signal DecToCtl_port_encType   : Unsigned ( 2 downto 0);
    signal DecToCtl_port_imm       : Unsigned (31 downto 0);
    signal DecToCtl_port_instrType : Unsigned ( 5 downto 0);
    signal DecToCtl_port_rd_addr   : Unsigned ( 4 downto 0);
    signal DecToCtl_port_rs1_addr  : Unsigned ( 4 downto 0);
    signal DecToCtl_port_rs2_addr  : Unsigned ( 4 downto 0);

begin

    IF_ALU: ALU
        port map (
            clk                  => clk,
            rst                  => rst,
            CtlToALU_port_alu_fun       => CtlToALU_port_alu_fun,
            CtlToALU_port_imm           => CtlToALU_port_imm,
            CtlToALU_port_op1_sel       => CtlToALU_port_op1_sel,
            CtlToALU_port_op2_sel       => CtlToALU_port_op2_sel,
            CtlToALU_port_pc_reg        => CtlToALU_port_pc_reg,
            CtlToALU_port_reg1_contents => CtlToALU_port_reg1_contents,
            CtlToALU_port_reg2_contents => CtlToALU_port_reg2_contents,
            CtlToALU_port_sync          => CtlToALU_port_notify,
            ALUtoCtl_port => ALUtoCtl_port
        );

    IF_CPath: CPath
        port map (
            clk                   => clk,
            rst                   => rst,

            CtlToALU_port_alu_fun       => CtlToALU_port_alu_fun,
            CtlToALU_port_imm           => CtlToALU_port_imm,
            CtlToALU_port_op1_sel       => CtlToALU_port_op1_sel,
            CtlToALU_port_op2_sel       => CtlToALU_port_op2_sel,
            CtlToALU_port_pc_reg        => CtlToALU_port_pc_reg,
            CtlToALU_port_reg1_contents => CtlToALU_port_reg1_contents,
            CtlToALU_port_reg2_contents => CtlToALU_port_reg2_contents,
            CtlToALU_port_notify  => CtlToALU_port_notify,
            ALUtoCtl_port         => ALUtoCtl_port,

            CtlToRegs_port_dst      => CtlToRegs_port_dst,
            CtlToRegs_port_dst_data => CtlToRegs_port_dst_data,
            CtlToRegs_port_req      => CtlToRegs_port_req,
            CtlToRegs_port_src1     => CtlToRegs_port_src1,
            CtlToRegs_port_src2     => CtlToRegs_port_src2,
            CtlToRegs_port_notify => CtlToRegs_port_notify,
            RegsToCtl_port_contents1 => RegsToCtl_port_contents1,
            RegsToCtl_port_contents2 => RegsToCtl_port_contents2,

            CtlToDec_port         => CtlToDec_port,
            CtlToDec_port_notify  => CtlToDec_port_notify,
            DecToCtl_port_encType   => DecToCtl_port_encType,
            DecToCtl_port_imm       => DecToCtl_port_imm,
            DecToCtl_port_instrType => DecToCtl_port_instrType,
            DecToCtl_port_rd_addr   => DecToCtl_port_rd_addr,
            DecToCtl_port_rs1_addr  => DecToCtl_port_rs1_addr,
            DecToCtl_port_rs2_addr  => DecToCtl_port_rs2_addr,

            CtlToMem_port_addrIn => CtlToMem_port_addrIn,
            CtlToMem_port_dataIn => CtlToMem_port_dataIn,
            CtlToMem_port_mask   => CtlToMem_port_mask,
            CtlToMem_port_req    => CtlToMem_port_req,
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
            DecToCtl_port_encType   => DecToCtl_port_encType,
            DecToCtl_port_imm       => DecToCtl_port_imm,
            DecToCtl_port_instrType => DecToCtl_port_instrType,
            DecToCtl_port_rd_addr   => DecToCtl_port_rd_addr,
            DecToCtl_port_rs1_addr  => DecToCtl_port_rs1_addr,
            DecToCtl_port_rs2_addr  => DecToCtl_port_rs2_addr
        );

    IF_Regs: Regs
        port map (
            clk                   => clk,
            rst                   => rst,
            CtlToRegs_port_dst      => CtlToRegs_port_dst,
            CtlToRegs_port_dst_data => CtlToRegs_port_dst_data,
            CtlToRegs_port_req      => CtlToRegs_port_req,
            CtlToRegs_port_src1     => CtlToRegs_port_src1,
            CtlToRegs_port_src2     => CtlToRegs_port_src2,
            CtlToRegs_port_sync     => CtlToRegs_port_notify,
            RegsToCtl_port_contents1 => RegsToCtl_port_contents1,
            RegsToCtl_port_contents2 => RegsToCtl_port_contents2
        );


end CPU_arch;









































