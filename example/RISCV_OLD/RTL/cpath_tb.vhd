--
-- Created by deutschmann on 25.01.18
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity cpath_tb is
end entity cpath_tb;

architecture sim of cpath_tb is
    component cpath is
        port (
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

    -- Input
    signal clk                  : std_logic := '0';
    signal rst                  : std_logic;
    signal ALUtoCtl_port        : ALUtoCtl_IF;
    signal ALUtoCtl_port_sync   : bool;
    signal CtlToALU_port_sync   : bool;
    signal CtlToRegs_port_sync  : bool;
    signal RegsToCtl_port       : RegsToCtl_IF;
    signal RegsToCtl_port_sync  : bool;
    signal DecToCtl_port        : DecodedInstr;
    signal DecToCtl_port_sync   : bool;
    signal MemToCtl_port        : Unsigned (31 downto 0);
    signal MemToCtl_port_sync   : bool;
    signal CtlToMem_port_sync   : bool;

    -- Output
    signal ALUtoCtl_port_notify  : bool;
    signal CtlToALU_port         : CtlToALU_IF;
    signal CtlToALU_port_notify  : bool;
    signal CtlToRegs_port        : CtlToRegs_IF;
    signal CtlToRegs_port_notify : bool;
    signal RegsToCtl_port_notify : bool;
    signal DecToCtl_port_notify  : bool;
    signal MemToCtl_port_notify  : bool;
    signal CtlToMem_port         : MemoryAccess;
    signal CtlToMem_port_notify  : bool;

begin

    -- Clock
    clk <= not clk  after  10 ns;

    -- Reset
    rst <= '1', '0' after  20 ns;

    dut: cpath
        port map (
            clk                   => clk,
            rst                   => rst,
            ALUtoCtl_port         => ALUtoCtl_port,
            ALUtoCtl_port_sync    => ALUtoCtl_port_sync,
            ALUtoCtl_port_notify  => ALUtoCtl_port_notify,
            CtlToALU_port         => CtlToALU_port,
            CtlToALU_port_sync    => CtlToALU_port_sync,
            CtlToALU_port_notify  => CtlToALU_port_notify,
            CtlToRegs_port        => CtlToRegs_port,
            CtlToRegs_port_sync   => CtlToRegs_port_sync,
            CtlToRegs_port_notify => CtlToRegs_port_notify,
            RegsToCtl_port        => RegsToCtl_port,
            RegsToCtl_port_sync   => RegsToCtl_port_sync,
            RegsToCtl_port_notify => RegsToCtl_port_notify,
            DecToCtl_port         => DecToCtl_port,
            DecToCtl_port_sync    => DecToCtl_port_sync,
            DecToCtl_port_notify  => DecToCtl_port_notify,
            MemToCtl_port         => MemToCtl_port,
            MemToCtl_port_sync    => MemToCtl_port_sync,
            MemToCtl_port_notify  => MemToCtl_port_notify,
            CtlToMem_port         => CtlToMem_port,
            CtlToMem_port_sync    => CtlToMem_port_sync,
            CtlToMem_port_notify  => CtlToMem_port_notify
        );


    stimuli: process
    begin

        -- Simulate "addi $5,$0,9" --------------------------------------------------------------------------------------------

        -- fetchAndDecode0
        wait until CtlToMem_port_notify = true;
        assert CtlToMem_port.addrIn = to_unsigned(0, 32) report "unexpected value for CtlToMem_port.addrIn" severity warning;
        assert CtlToMem_port.dataIn = to_unsigned(0, 32) report "unexpected value for CtlToMem_port.dataIn" severity warning;
        assert CtlToMem_port.mask   = MT_W               report "unexpected value for CtlToMem_port.mask"   severity warning;
        assert CtlToMem_port.req    = MEM_RD_I           report "unexpected value for CtlToMem_port.req"    severity warning;
        wait for 5 ns;
        CtlToMem_port_sync <= true;

        -- fetchAndDecode1
        wait until DecToCtl_port_notify = true;
        CtlToMem_port_sync <= false;
        wait for 5  ns;
        DecToCtl_port.encType   <= I;
        DecToCtl_port.imm       <= to_unsigned(9, 32);
        DecToCtl_port.instrType <= addI;
        DecToCtl_port.rd_addr   <= to_unsigned(5, 32);
        DecToCtl_port.rs1_addr  <= to_unsigned(0, 32);
        DecToCtl_port.rs2_addr  <= to_unsigned(0, 32);
        DecToCtl_port_sync      <= true;

        -- readRegisterFile0
        wait until CtlToRegs_port_notify = true;
        DecToCtl_port_sync <= false;
        assert CtlToRegs_port.dst      = to_unsigned(0, 32) report "unexpected value for CtlToRegs_port.dst"      severity warning;
        assert CtlToRegs_port.dst_data = to_unsigned(0, 32) report "unexpected value for CtlToRegs_port.dst_data" severity warning;
        assert CtlToRegs_port.req      = REG_RD             report "unexpected value for CtlToRegs_port.req"      severity warning;
        assert CtlToRegs_port.src1     = to_unsigned(0, 32) report "unexpected value for CtlToRegs_port.src1"     severity warning;
        assert CtlToRegs_port.src2     = to_unsigned(0, 32) report "unexpected value for CtlToRegs_port.src2"     severity warning;
        wait for 5 ns;
        CtlToRegs_port_sync <= true;

        -- readRegisterFile1
        wait until RegsToCtl_port_notify = true;
        CtlToRegs_port_sync <= false;
        wait for 5 ns;
        RegsToCtl_port.contents1 <= to_unsigned(0, 32);
        RegsToCtl_port.contents2 <= to_unsigned(0, 32);
        RegsToCtl_port_sync      <= true;

        -- executeALU0
        wait until CtlToALU_port_notify = true;
        RegsToCtl_port_sync <= false;
        assert CtlToALU_port.alu_fun       = ALU_ADD            report "unexpected value for CtlToALU_port.alu_fun"       severity warning;
        assert CtlToALU_port.imm           = to_unsigned(9, 32) report "unexpected value for CtlToALU_port.imm"           severity warning;
        assert CtlToALU_port.op1_sel       = OP_REG             report "unexpected value for CtlToALU_port.op1_sel"       severity warning;
        assert CtlToALU_port.op2_sel       = OP_IMM             report "unexpected value for CtlToALU_port.op2_sel"       severity warning;
        assert CtlToALU_port.pc_reg        = to_unsigned(0, 32) report "unexpected value for CtlToALU_port.pc_reg"        severity warning;
        assert CtlToALU_port.reg1_contents = to_unsigned(0, 32) report "unexpected value for CtlToALU_port.reg1_contents" severity warning;
        assert CtlToALU_port.reg2_contents = to_unsigned(0, 32) report "unexpected value for CtlToALU_port.reg2_contents" severity warning;
        wait for 5 ns;
        CtlToALU_port_sync <= true;

        -- executeALU1
        wait until ALUtoCtl_port_notify = true;
        CtlToALU_port_sync <= false;
        wait for 5 ns;
        ALUtoCtl_port.ALU_result <= to_unsigned(9, 32);
        ALUtoCtl_port_sync       <= true;

        -- writeBack
        wait until CtlToRegs_port_notify = true;
        ALUtoCtl_port_sync <= false;
        assert CtlToRegs_port.dst      = to_unsigned(5, 32) report "unexpected value for CtlToRegs_port.dst"      severity warning;
        assert CtlToRegs_port.dst_data = to_unsigned(9, 32) report "unexpected value for CtlToRegs_port.dst_data" severity warning;
        assert CtlToRegs_port.req      = REG_WR             report "unexpected value for CtlToRegs_port.req"      severity warning;
        assert CtlToRegs_port.src1     = to_unsigned(0, 32) report "unexpected value for CtlToRegs_port.src1"     severity warning;
        assert CtlToRegs_port.src2     = to_unsigned(0, 32) report "unexpected value for CtlToRegs_port.src2"     severity warning;
        wait for 5 ns;
        CtlToRegs_port_sync       <= true;
        
                
        
        -- Simulate "lw $4, 8($1)" --------------------------------------------------------------------------------------------
        -- Assume content of Register to_unsigned(1, 32) is 256
        -- Offset is 8
        -- Assume content of Memory-Address 264 is 5
        
        
        -- fetchAndDecode0
        wait until CtlToMem_port_notify = true;
        CtlToRegs_port_sync <= false;
        assert CtlToMem_port.addrIn = to_unsigned(4, 32) report "unexpected value for CtlToMem_port.addrIn" severity warning;
        assert CtlToMem_port.dataIn = to_unsigned(0, 32) report "unexpected value for CtlToMem_port.dataIn" severity warning;
        assert CtlToMem_port.mask   = MT_W               report "unexpected value for CtlToMem_port.mask"   severity warning;
        assert CtlToMem_port.req    = MEM_RD_I           report "unexpected value for CtlToMem_port.req"    severity warning;
        CtlToMem_port_sync <= true;
        
        -- fetchAndDecode1
        wait until DecToCtl_port_notify = true;
        CtlToMem_port_sync <= false;
        wait for 5  ns;
        DecToCtl_port.encType   <= I;
        DecToCtl_port.imm       <= to_unsigned(8, 32);
        DecToCtl_port.instrType <= lw;
        DecToCtl_port.rd_addr   <= to_unsigned(4, 32);
        DecToCtl_port.rs1_addr  <= to_unsigned(1, 32);
        DecToCtl_port.rs2_addr  <= to_unsigned(0, 32);
        DecToCtl_port_sync      <= true;

        -- readRegisterFile0
        wait until CtlToRegs_port_notify = true;
        DecToCtl_port_sync <= false;
        assert CtlToRegs_port.dst      = to_unsigned(5, 32) report "unexpected value for CtlToRegs_port.dst"      severity warning;
        assert CtlToRegs_port.dst_data = to_unsigned(9, 32) report "unexpected value for CtlToRegs_port.dst_data" severity warning;
        assert CtlToRegs_port.req      = REG_RD             report "unexpected value for CtlToRegs_port.req"      severity warning;
        assert CtlToRegs_port.src1     = to_unsigned(1, 32) report "unexpected value for CtlToRegs_port.src1"     severity warning;
        assert CtlToRegs_port.src2     = to_unsigned(0, 32) report "unexpected value for CtlToRegs_port.src2"     severity warning;
        wait for 5 ns;
        CtlToRegs_port_sync <= true;

        -- readRegisterFile1
        wait until RegsToCtl_port_notify = true;
        CtlToRegs_port_sync <= false;
        wait for 5 ns;
        RegsToCtl_port.contents1 <= to_unsigned(256, 32);
        RegsToCtl_port.contents2 <= to_unsigned(0, 32);
        RegsToCtl_port_sync      <= true;

        -- executeALU0
        wait until CtlToALU_port_notify = true;
        RegsToCtl_port_sync <= false;
        assert CtlToALU_port.alu_fun       = ALU_ADD              report "unexpected value for CtlToALU_port.alu_fun"       severity warning;
        assert CtlToALU_port.imm           = to_unsigned(8, 32)   report "unexpected value for CtlToALU_port.imm"           severity warning;
        assert CtlToALU_port.op1_sel       = OP_REG               report "unexpected value for CtlToALU_port.op1_sel"       severity warning;
        assert CtlToALU_port.op2_sel       = OP_IMM               report "unexpected value for CtlToALU_port.op2_sel"       severity warning;
        assert CtlToALU_port.pc_reg        = to_unsigned(4, 32)   report "unexpected value for CtlToALU_port.pc_reg"        severity warning;
        assert CtlToALU_port.reg1_contents = to_unsigned(256, 32) report "unexpected value for CtlToALU_port.reg1_contents" severity warning;
        assert CtlToALU_port.reg2_contents = to_unsigned(0, 32)   report "unexpected value for CtlToALU_port.reg2_contents" severity warning;
        wait for 5 ns;
        CtlToALU_port_sync <= true;

        -- executeALU1
        wait until ALUtoCtl_port_notify = true;
        CtlToALU_port_sync <= false;
        wait for 5 ns;
        ALUtoCtl_port.ALU_result <= to_unsigned(264, 32);
        ALUtoCtl_port_sync       <= true;

        
        -- memoryOperation0
        wait until CtlToMem_port_notify = true;
        ALUtoCtl_port_sync <= false;
        wait for 5 ns;
        assert CtlToMem_port.addrIn = to_unsigned(264, 32) report "unexpected value for CtlToMem_port.addrIn" severity warning;
        assert CtlToMem_port.dataIn = to_unsigned(0, 32)   report "unexpected value for CtlToMem_port.dataIn" severity warning;
        assert CtlToMem_port.mask   = MT_W                 report "unexpected value for CtlToMem_port.mask"   severity warning;
        assert CtlToMem_port.req    = MEM_LOAD             report "unexpected value for CtlToMem_port.req"    severity warning;
        CtlToMem_port_sync <= true;    
        
        
        -- memoryOperation1
        wait until MemToCtl_port_notify = true;
        CtlToMem_port_sync <= false;
        wait for 5 ns;
        MemToCtl_port     <= to_unsigned(5, 32);
        MemToCtl_port_sync <= true;
        

        -- writeBack
        wait until CtlToRegs_port_notify = true;
        MemToCtl_port_sync <= false;
        assert CtlToRegs_port.dst      = to_unsigned(4, 32) report "unexpected value for CtlToRegs_port.dst"      severity warning;
        assert CtlToRegs_port.dst_data = to_unsigned(5, 32) report "unexpected value for CtlToRegs_port.dst_data" severity warning;
        assert CtlToRegs_port.req      = REG_WR             report "unexpected value for CtlToRegs_port.req"      severity warning;
        assert CtlToRegs_port.src1     = to_unsigned(1, 32) report "unexpected value for CtlToRegs_port.src1"     severity warning;
        assert CtlToRegs_port.src2     = to_unsigned(0, 32) report "unexpected value for CtlToRegs_port.src2"     severity warning;
        wait for 5 ns;
        CtlToRegs_port_sync       <= true;

        
        
        -- Simulate "sub $3,$5,$4" --------------------------------------------------------------------------------------------
        -- Assume content of R5 is to_unsigned(9, 32) and content of R4 is 5
        
        
        -- fetchAndDecode0
        wait until CtlToMem_port_notify = true;
        CtlToRegs_port_sync <= false;
        assert CtlToMem_port.addrIn = to_unsigned(8, 32) report "unexpected value for CtlToMem_port.addrIn" severity warning;
        assert CtlToMem_port.dataIn = to_unsigned(0, 32) report "unexpected value for CtlToMem_port.dataIn" severity warning;
        assert CtlToMem_port.mask   = MT_W               report "unexpected value for CtlToMem_port.mask"   severity warning;
        assert CtlToMem_port.req    = MEM_RD_I           report "unexpected value for CtlToMem_port.req"    severity warning;
        CtlToMem_port_sync <= true;
        
        -- fetchAndDecode1
        wait until DecToCtl_port_notify = true;
        CtlToMem_port_sync <= false;
        wait for 5  ns;
        DecToCtl_port.encType   <= R;
        DecToCtl_port.imm       <= to_unsigned(0, 32);
        DecToCtl_port.instrType <= sub;
        DecToCtl_port.rd_addr   <= to_unsigned(3, 32);
        DecToCtl_port.rs1_addr  <= to_unsigned(5, 32);
        DecToCtl_port.rs2_addr  <= to_unsigned(4, 32);
        DecToCtl_port_sync      <= true;

        -- readRegisterFile0
        wait until CtlToRegs_port_notify = true;
        DecToCtl_port_sync <= false;
        assert CtlToRegs_port.dst      = to_unsigned(4, 32) report "unexpected value for CtlToRegs_port.dst"      severity warning;
        assert CtlToRegs_port.dst_data = to_unsigned(5, 32) report "unexpected value for CtlToRegs_port.dst_data" severity warning;
        assert CtlToRegs_port.req      = REG_RD             report "unexpected value for CtlToRegs_port.req"      severity warning;
        assert CtlToRegs_port.src1     = to_unsigned(5, 32) report "unexpected value for CtlToRegs_port.src1"     severity warning;
        assert CtlToRegs_port.src2     = to_unsigned(4, 32) report "unexpected value for CtlToRegs_port.src2"     severity warning;
        wait for 5 ns;
        CtlToRegs_port_sync <= true;

        -- readRegisterFile1
        wait until RegsToCtl_port_notify = true;
        CtlToRegs_port_sync <= false;
        wait for 5 ns;
        RegsToCtl_port.contents1 <= to_unsigned(9, 32);
        RegsToCtl_port.contents2 <= to_unsigned(5, 32);
        RegsToCtl_port_sync      <= true;

        -- executeALU0
        wait until CtlToALU_port_notify = true;
        RegsToCtl_port_sync <= false;
        assert CtlToALU_port.alu_fun       = ALU_SUB            report "unexpected value for CtlToALU_port.alu_fun"       severity warning;
        assert CtlToALU_port.imm           = to_unsigned(0, 32) report "unexpected value for CtlToALU_port.imm"           severity warning;
        assert CtlToALU_port.op1_sel       = OP_REG             report "unexpected value for CtlToALU_port.op1_sel"       severity warning;
        assert CtlToALU_port.op2_sel       = OP_REG             report "unexpected value for CtlToALU_port.op2_sel"       severity warning;
        assert CtlToALU_port.pc_reg        = to_unsigned(8, 32) report "unexpected value for CtlToALU_port.pc_reg"        severity warning;
        assert CtlToALU_port.reg1_contents = to_unsigned(9, 32) report "unexpected value for CtlToALU_port.reg1_contents" severity warning;
        assert CtlToALU_port.reg2_contents = to_unsigned(5, 32) report "unexpected value for CtlToALU_port.reg2_contents" severity warning;
        wait for 5 ns;
        CtlToALU_port_sync <= true;

        -- executeALU1
        wait until ALUtoCtl_port_notify = true;
        CtlToALU_port_sync <= false;
        wait for 5 ns;
        ALUtoCtl_port.ALU_result <= to_unsigned(4, 32);
        ALUtoCtl_port_sync       <= true;

        -- writeBack
        wait until CtlToRegs_port_notify = true;
        ALUtoCtl_port_sync <= false;
        assert CtlToRegs_port.dst      = to_unsigned(3, 32) report "unexpected value for CtlToRegs_port.dst"      severity warning;
        assert CtlToRegs_port.dst_data = to_unsigned(4, 32) report "unexpected value for CtlToRegs_port.dst_data" severity warning;
        assert CtlToRegs_port.req      = REG_WR             report "unexpected value for CtlToRegs_port.req"      severity warning;
        assert CtlToRegs_port.src1     = to_unsigned(5, 32) report "unexpected value for CtlToRegs_port.src1"     severity warning;
        assert CtlToRegs_port.src2     = to_unsigned(4, 32) report "unexpected value for CtlToRegs_port.src2"     severity warning;
        wait for 5 ns;
        CtlToRegs_port_sync       <= true;

        -- Simulate "sw $3, 12($1)" --------------------------------------------------------------------------------------------
        -- Assume content of Register to_unsigned(1, 32) is 256
        -- Offset is 12
        -- Assume content of Memory-Address 264 is 5        
        
        -- fetchAndDecode0
        wait until CtlToMem_port_notify = true;
        CtlToRegs_port_sync <= false;
        assert CtlToMem_port.addrIn = to_unsigned(12, 32) report "unexpected value for CtlToMem_port.addrIn" severity warning;
        assert CtlToMem_port.dataIn = to_unsigned(0, 32)  report "unexpected value for CtlToMem_port.dataIn" severity warning;
        assert CtlToMem_port.mask   = MT_W                report "unexpected value for CtlToMem_port.mask"   severity warning;
        assert CtlToMem_port.req    = MEM_RD_I            report "unexpected value for CtlToMem_port.req"    severity warning;
        CtlToMem_port_sync <= true;
        
        -- fetchAndDecode1
        wait until DecToCtl_port_notify = true;
        CtlToMem_port_sync <= false;
        wait for 5  ns;
        DecToCtl_port.encType   <= S;
        DecToCtl_port.imm       <= to_unsigned(12, 32);
        DecToCtl_port.instrType <= sw;
        DecToCtl_port.rd_addr   <= to_unsigned(0, 32);
        DecToCtl_port.rs1_addr  <= to_unsigned(1, 32);
        DecToCtl_port.rs2_addr  <= to_unsigned(3, 32);
        DecToCtl_port_sync      <= true;

        -- readRegisterFile0
        wait until CtlToRegs_port_notify = true;
        DecToCtl_port_sync <= false;
        assert CtlToRegs_port.dst      = to_unsigned(3, 32) report "unexpected value for CtlToRegs_port.dst"      severity warning;
        assert CtlToRegs_port.dst_data = to_unsigned(4, 32) report "unexpected value for CtlToRegs_port.dst_data" severity warning;
        assert CtlToRegs_port.req      = REG_RD             report "unexpected value for CtlToRegs_port.req"      severity warning;
        assert CtlToRegs_port.src1     = to_unsigned(1, 32) report "unexpected value for CtlToRegs_port.src1"     severity warning;
        assert CtlToRegs_port.src2     = to_unsigned(3, 32) report "unexpected value for CtlToRegs_port.src2"     severity warning;
        wait for 5 ns;
        CtlToRegs_port_sync <= true;

        -- readRegisterFile1
        wait until RegsToCtl_port_notify = true;
        CtlToRegs_port_sync <= false;
        wait for 5 ns;
        RegsToCtl_port.contents1 <= to_unsigned(256, 32);
        RegsToCtl_port.contents2 <= to_unsigned(4, 32);
        RegsToCtl_port_sync      <= true;

        -- executeALU0
        wait until CtlToALU_port_notify = true;
        RegsToCtl_port_sync <= false;
        assert CtlToALU_port.alu_fun       = ALU_ADD              report "unexpected value for CtlToALU_port.alu_fun"       severity warning;
        assert CtlToALU_port.imm           = to_unsigned(12, 32)  report "unexpected value for CtlToALU_port.imm"           severity warning;
        assert CtlToALU_port.op1_sel       = OP_REG               report "unexpected value for CtlToALU_port.op1_sel"       severity warning;
        assert CtlToALU_port.op2_sel       = OP_IMM               report "unexpected value for CtlToALU_port.op2_sel"       severity warning;
        assert CtlToALU_port.pc_reg        = to_unsigned(12, 32)  report "unexpected value for CtlToALU_port.pc_reg"        severity warning;
        assert CtlToALU_port.reg1_contents = to_unsigned(256, 32) report "unexpected value for CtlToALU_port.reg1_contents" severity warning;
        assert CtlToALU_port.reg2_contents = to_unsigned(4, 32)   report "unexpected value for CtlToALU_port.reg2_contents" severity warning;
        wait for 5 ns;
        CtlToALU_port_sync <= true;

        -- executeALU1
        wait until ALUtoCtl_port_notify = true;
        CtlToALU_port_sync <= false;
        wait for 5 ns;
        ALUtoCtl_port.ALU_result <= to_unsigned(268, 32);
        ALUtoCtl_port_sync       <= true;

        
        -- memoryOperation0
        wait until CtlToMem_port_notify = true;
        ALUtoCtl_port_sync <= false;
        wait for 5 ns;
        assert CtlToMem_port.addrIn = to_unsigned(268, 32) report "unexpected value for CtlToMem_port.addrIn" severity warning;
        assert CtlToMem_port.dataIn = to_unsigned(4, 32)   report "unexpected value for CtlToMem_port.dataIn" severity warning;
        assert CtlToMem_port.mask   = MT_W                 report "unexpected value for CtlToMem_port.mask"   severity warning;
        assert CtlToMem_port.req    = MEM_STORE            report "unexpected value for CtlToMem_port.req"    severity warning;
        CtlToMem_port_sync <= true;    
        
        
        -- memoryOperation1
        wait until MemToCtl_port_notify = true;
        CtlToMem_port_sync <= false;
        wait for 5 ns;
        MemToCtl_port     <= to_unsigned(0, 32);
        MemToCtl_port_sync <= true;

        
        -- Simulate "bne $4, $5, 12" --------------------------------------------------------------------------------------------
        -- Assume content of Register to_unsigned(4, 32) is 5
        -- Assume content of Register 5 is 9
        
        
        -- fetchAndDecode0
        wait until CtlToMem_port_notify = true;
        MemToCtl_port_sync <= false;
        assert CtlToMem_port.addrIn = to_unsigned(16, 32) report "unexpected value for CtlToMem_port.addrIn" severity warning;
        assert CtlToMem_port.dataIn = to_unsigned(0, 32)  report "unexpected value for CtlToMem_port.dataIn" severity warning;
        assert CtlToMem_port.mask   = MT_W                report "unexpected value for CtlToMem_port.mask"   severity warning;
        assert CtlToMem_port.req    = MEM_RD_I            report "unexpected value for CtlToMem_port.req"    severity warning;
        CtlToMem_port_sync <= true;
        
        -- fetchAndDecode1
        wait until DecToCtl_port_notify = true;
        CtlToMem_port_sync <= false;
        wait for 5  ns;
        DecToCtl_port.encType   <= B;
        DecToCtl_port.imm       <= to_unsigned(12, 32);
        DecToCtl_port.instrType <= bne;
        DecToCtl_port.rd_addr   <= to_unsigned(0, 32);
        DecToCtl_port.rs1_addr  <= to_unsigned(4, 32);
        DecToCtl_port.rs2_addr  <= to_unsigned(5, 32);
        DecToCtl_port_sync      <= true;

        -- readRegisterFile0
        wait until CtlToRegs_port_notify = true;
        DecToCtl_port_sync <= false;
        assert CtlToRegs_port.dst      = to_unsigned(3, 32) report "unexpected value for CtlToRegs_port.dst"      severity warning;
        assert CtlToRegs_port.dst_data = to_unsigned(4, 32) report "unexpected value for CtlToRegs_port.dst_data" severity warning;
        assert CtlToRegs_port.req      = REG_RD             report "unexpected value for CtlToRegs_port.req"      severity warning;
        assert CtlToRegs_port.src1     = to_unsigned(4, 32) report "unexpected value for CtlToRegs_port.src1"     severity warning;
        assert CtlToRegs_port.src2     = to_unsigned(5, 32) report "unexpected value for CtlToRegs_port.src2"     severity warning;
        wait for 5 ns;
        CtlToRegs_port_sync <= true;

        -- readRegisterFile1
        wait until RegsToCtl_port_notify = true;
        CtlToRegs_port_sync <= false;
        wait for 5 ns;
        RegsToCtl_port.contents1 <= to_unsigned(5, 32);
        RegsToCtl_port.contents2 <= to_unsigned(9, 32);
        RegsToCtl_port_sync      <= true;

        -- executeALU0
        wait until CtlToALU_port_notify = true;
        RegsToCtl_port_sync <= false;
        assert CtlToALU_port.alu_fun       = ALU_SUB             report "unexpected value for CtlToALU_port.alu_fun"       severity warning;
        assert CtlToALU_port.imm           = to_unsigned(12, 32) report "unexpected value for CtlToALU_port.imm"           severity warning;
        assert CtlToALU_port.op1_sel       = OP_REG              report "unexpected value for CtlToALU_port.op1_sel"       severity warning;
        assert CtlToALU_port.op2_sel       = OP_REG              report "unexpected value for CtlToALU_port.op2_sel"       severity warning;
        assert CtlToALU_port.pc_reg        = to_unsigned(16, 32) report "unexpected value for CtlToALU_port.pc_reg"        severity warning;
        assert CtlToALU_port.reg1_contents = to_unsigned(5, 32)  report "unexpected value for CtlToALU_port.reg1_contents" severity warning;
        assert CtlToALU_port.reg2_contents = to_unsigned(9, 32)  report "unexpected value for CtlToALU_port.reg2_contents" severity warning;
        wait for 5 ns;
        CtlToALU_port_sync <= true;

        -- executeALU1
        wait until ALUtoCtl_port_notify = true;
        CtlToALU_port_sync <= false;
        wait for 5 ns;
        ALUtoCtl_port.ALU_result <= "11111111111111111111111111111100"; -- -4
        ALUtoCtl_port_sync       <= true;

        
        
        -- Simulate "jal r1, 0" --------------------------------------------------------------------------------------------

        -- fetchAndDecode0
        wait until CtlToMem_port_notify = true;
        ALUtoCtl_port_sync <= false;
        assert CtlToMem_port.addrIn = to_unsigned(28, 32) report "unexpected value for CtlToMem_port.addrIn" severity warning;
        assert CtlToMem_port.dataIn = to_unsigned(0, 32)  report "unexpected value for CtlToMem_port.dataIn" severity warning;
        assert CtlToMem_port.mask   = MT_W                report "unexpected value for CtlToMem_port.mask"   severity warning;
        assert CtlToMem_port.req    = MEM_RD_I            report "unexpected value for CtlToMem_port.req"    severity warning;
        CtlToMem_port_sync <= true;
        
        -- fetchAndDecode1
        wait until DecToCtl_port_notify = true;
        CtlToMem_port_sync <= false;
        wait for 5  ns;
        DecToCtl_port.encType   <= J;
        DecToCtl_port.imm       <= "11111111111111111111111111101000"; -- -24 
        DecToCtl_port.instrType <= jal;
        DecToCtl_port.rd_addr   <= to_unsigned(1, 32);
        DecToCtl_port.rs1_addr  <= to_unsigned(0, 32);
        DecToCtl_port.rs2_addr  <= to_unsigned(0, 32);
        DecToCtl_port_sync      <= true;

        -- executeALU0
        wait until CtlToALU_port_notify = true;
        RegsToCtl_port_sync <= false;
        assert CtlToALU_port.alu_fun       = ALU_X                              report "unexpected value for CtlToALU_port.alu_fun"       severity warning;
        assert CtlToALU_port.imm           = "11111111111111111111111111101000" report "unexpected value for CtlToALU_port.imm"           severity warning;
        assert CtlToALU_port.op1_sel       = OP_X                               report "unexpected value for CtlToALU_port.op1_sel"       severity warning;
        assert CtlToALU_port.op2_sel       = OP_X                               report "unexpected value for CtlToALU_port.op2_sel"       severity warning;
        assert CtlToALU_port.pc_reg        = to_unsigned(28, 32)                report "unexpected value for CtlToALU_port.pc_reg"        severity warning;
        assert CtlToALU_port.reg1_contents = to_unsigned( 5, 32)                report "unexpected value for CtlToALU_port.reg1_contents" severity warning;
        assert CtlToALU_port.reg2_contents = to_unsigned( 9, 32)                report "unexpected value for CtlToALU_port.reg2_contents" severity warning;
        wait for 5 ns;
        CtlToALU_port_sync <= true;

        -- executeALU1
        wait until ALUtoCtl_port_notify = true;
        CtlToALU_port_sync <= false;
        wait for 5 ns;
        ALUtoCtl_port.ALU_result <= to_unsigned(0, 32);
        ALUtoCtl_port_sync       <= true;
        
        -- writeBack
        wait until CtlToRegs_port_notify = true;
        ALUtoCtl_port_sync <= false;
        assert CtlToRegs_port.dst      = to_unsigned(1, 32)  report "unexpected value for CtlToRegs_port.dst"      severity warning;
        assert CtlToRegs_port.dst_data = to_unsigned(32, 32) report "unexpected value for CtlToRegs_port.dst_data" severity warning;
        assert CtlToRegs_port.req      = REG_WR              report "unexpected value for CtlToRegs_port.req"      severity warning;
        assert CtlToRegs_port.src1     = to_unsigned(4, 32)  report "unexpected value for CtlToRegs_port.src1"     severity warning;
        assert CtlToRegs_port.src2     = to_unsigned(5, 32)  report "unexpected value for CtlToRegs_port.src2"     severity warning;
        wait for 5 ns;
        CtlToRegs_port_sync       <= true;        
        
        

        -- fetchAndDecode0
        wait until CtlToMem_port_notify = true;
        ALUtoCtl_port_sync <= false;
        assert CtlToMem_port.addrIn = to_unsigned(4, 32) report "unexpected value for CtlToMem_port.addrIn" severity warning;
        assert CtlToMem_port.dataIn = to_unsigned(0, 32) report "unexpected value for CtlToMem_port.dataIn" severity warning;
        assert CtlToMem_port.mask   = MT_W               report "unexpected value for CtlToMem_port.mask"   severity warning;
        assert CtlToMem_port.req    = MEM_RD_I           report "unexpected value for CtlToMem_port.req"    severity warning;
        CtlToMem_port_sync <= true;


        
        wait;

    end process stimuli;


end architecture;





















































