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

            -- Communication with ALU
            CtlToALU_port         : out CtlToALU_IF;
            CtlToALU_port_notify  : out bool;
            ALUtoCtl_port         : in  ALUtoCtl_IF;

            -- Communication with Register-File
            CtlToRegs_port        : out CtlToRegs_IF;
            CtlToRegs_port_notify : out bool;
            RegsToCtl_port        : in  RegsToCtl_IF;
         
            -- Communication with Decoder
            CtlToDec_port         : out Unsigned (31 downto 0);
            CtlToDec_port_notify  : out bool;
            DecToCtl_port         : in  DecodedInstr;

            -- Communication with Memory
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
    signal RegsToCtl_port       : RegsToCtl_IF;
    signal DecToCtl_port        : DecodedInstr;
    signal MemToCtl_port        : Unsigned (31 downto 0);
    signal MemToCtl_port_sync   : bool;
    signal CtlToMem_port_sync   : bool;

    -- Output
    signal CtlToALU_port         : CtlToALU_IF;
    signal CtlToALU_port_notify  : bool;
    signal CtlToRegs_port        : CtlToRegs_IF;
    signal CtlToRegs_port_notify : bool;
    signal CtlToDec_port         : Unsigned (31 downto 0);
    signal CtlToDec_port_notify  : bool;
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
            CtlToALU_port         => CtlToALU_port,
            CtlToALU_port_notify  => CtlToALU_port_notify,
            ALUtoCtl_port         => ALUtoCtl_port,
            CtlToRegs_port        => CtlToRegs_port,
            CtlToRegs_port_notify => CtlToRegs_port_notify,
            RegsToCtl_port        => RegsToCtl_port,
            CtlToDec_port         => CtlToDec_port,
            CtlToDec_port_notify  => CtlToDec_port_notify,
            DecToCtl_port         => DecToCtl_port,
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

        -- requestInstr
        wait for 25 ns;
        assert CtlToMem_port.addrIn = to_unsigned(0, 32) report "unexpected value for CtlToMem_port.addrIn" severity warning;
        assert CtlToMem_port.dataIn = to_unsigned(0, 32) report "unexpected value for CtlToMem_port.dataIn" severity warning;
        assert CtlToMem_port.mask   = MT_W               report "unexpected value for CtlToMem_port.mask"   severity warning;
        assert CtlToMem_port.req    = MEM_READ           report "unexpected value for CtlToMem_port.req"    severity warning;  
        CtlToMem_port_sync <= true;

        -- receiveInstr
        wait for 20 ns;
        CtlToMem_port_sync <= false;       
        MemToCtl_port <= "00000000100100000000001010010011";
        MemToCtl_port_sync <= true;

        -- decode
        wait for 20 ns;
        MemToCtl_port_sync <= false;
        assert CtlToDec_port = "00000000100100000000001010010011" report "unexpected value for CtlToDec_port" severity warning;
              
        -- setControl
        wait for 20 ns;      
        DecToCtl_port.encType   <= I;
        DecToCtl_port.imm       <= to_unsigned(9, 32);
        DecToCtl_port.instrType <= addI;
        DecToCtl_port.rd_addr   <= to_unsigned(5, 5);
        DecToCtl_port.rs1_addr  <= to_unsigned(0, 5);
        DecToCtl_port.rs2_addr  <= to_unsigned(0, 5);       

        -- readRegisterFile
        wait for 20 ns;       
        assert CtlToRegs_port.dst      = to_unsigned(0, 32) report "unexpected value for CtlToRegs_port.dst"      severity warning;
        assert CtlToRegs_port.dst_data = to_unsigned(0, 32) report "unexpected value for CtlToRegs_port.dst_data" severity warning;
        assert CtlToRegs_port.req      = REG_RD             report "unexpected value for CtlToRegs_port.req"      severity warning;
        assert CtlToRegs_port.src1     = to_unsigned(0, 32) report "unexpected value for CtlToRegs_port.src1"     severity warning;
        assert CtlToRegs_port.src2     = to_unsigned(0, 32) report "unexpected value for CtlToRegs_port.src2"     severity warning;
        
        -- requestALU
        wait for 20 ns;       
        RegsToCtl_port.contents1 <= to_unsigned(0, 32);
        RegsToCtl_port.contents2 <= to_unsigned(0, 32);

        -- executeALU
        wait for 20 ns;        
        assert CtlToALU_port.alu_fun       = ALU_ADD            report "unexpected value for CtlToALU_port.alu_fun"       severity warning;
        assert CtlToALU_port.imm           = to_unsigned(9, 32) report "unexpected value for CtlToALU_port.imm"           severity warning;
        assert CtlToALU_port.op1_sel       = OP_REG             report "unexpected value for CtlToALU_port.op1_sel"       severity warning;
        assert CtlToALU_port.op2_sel       = OP_IMM             report "unexpected value for CtlToALU_port.op2_sel"       severity warning;
        assert CtlToALU_port.pc_reg        = to_unsigned(0, 32) report "unexpected value for CtlToALU_port.pc_reg"        severity warning;
        assert CtlToALU_port.reg1_contents = to_unsigned(0, 32) report "unexpected value for CtlToALU_port.reg1_contents" severity warning;
        assert CtlToALU_port.reg2_contents = to_unsigned(0, 32) report "unexpected value for CtlToALU_port.reg2_contents" severity warning;
                
        -- evaluateALUresult
        wait for 20 ns;              
        ALUtoCtl_port.ALU_result <= to_unsigned(9, 32);

        -- writeBack
        wait for 20 ns;    
        assert CtlToRegs_port.dst      = to_unsigned(5, 32) report "unexpected value for CtlToRegs_port.dst"      severity warning;
        assert CtlToRegs_port.dst_data = to_unsigned(9, 32) report "unexpected value for CtlToRegs_port.dst_data" severity warning;
        assert CtlToRegs_port.req      = REG_WR             report "unexpected value for CtlToRegs_port.req"      severity warning;
        assert CtlToRegs_port.src1     = to_unsigned(0, 32) report "unexpected value for CtlToRegs_port.src1"     severity warning;
        assert CtlToRegs_port.src2     = to_unsigned(0, 32) report "unexpected value for CtlToRegs_port.src2"     severity warning;
        

        
                
        
        -- Simulate "lw $4, 8($1)" --------------------------------------------------------------------------------------------
        -- Assume content of Register to_unsigned(1, 32) is 256
        -- Offset is 8
        -- Assume content of Memory-Address 264 is 5
        
        
        -- requestInstr
        wait for 20 ns;
        
        assert CtlToMem_port.addrIn = to_unsigned(4, 32) report "unexpected value for CtlToMem_port.addrIn" severity warning;
        assert CtlToMem_port.dataIn = to_unsigned(0, 32) report "unexpected value for CtlToMem_port.dataIn" severity warning;
        assert CtlToMem_port.mask   = MT_W               report "unexpected value for CtlToMem_port.mask"   severity warning;
        assert CtlToMem_port.req    = MEM_READ           report "unexpected value for CtlToMem_port.req"    severity warning;
        CtlToMem_port_sync <= true;
        
        -- receiveInstr
        wait for 20 ns;
        CtlToMem_port_sync <= false;        
        MemToCtl_port <= "00000000100000001010001000000011";
        MemToCtl_port_sync <= true;

        -- decode
        wait for 20 ns;
        MemToCtl_port_sync <= false;
        assert CtlToDec_port = "00000000100000001010001000000011" report "unexpected value for CtlToDec_port" severity warning;
               
        -- setControl
        wait for 20 ns;
        DecToCtl_port.encType   <= I;
        DecToCtl_port.imm       <= to_unsigned(8, 32);
        DecToCtl_port.instrType <= lw;
        DecToCtl_port.rd_addr   <= to_unsigned(4, 5);
        DecToCtl_port.rs1_addr  <= to_unsigned(1, 5);
        DecToCtl_port.rs2_addr  <= to_unsigned(0, 5);        

        -- readRegisterFile
        wait for 20 ns;        
        assert CtlToRegs_port.dst      = to_unsigned(5, 32) report "unexpected value for CtlToRegs_port.dst"      severity warning;
        assert CtlToRegs_port.dst_data = to_unsigned(9, 32) report "unexpected value for CtlToRegs_port.dst_data" severity warning;
        assert CtlToRegs_port.req      = REG_RD             report "unexpected value for CtlToRegs_port.req"      severity warning;
        assert CtlToRegs_port.src1     = to_unsigned(1, 32) report "unexpected value for CtlToRegs_port.src1"     severity warning;
        assert CtlToRegs_port.src2     = to_unsigned(0, 32) report "unexpected value for CtlToRegs_port.src2"     severity warning;        
        
        -- requestALU
        wait for 20 ns;                
        RegsToCtl_port.contents1 <= to_unsigned(256, 32);
        RegsToCtl_port.contents2 <= to_unsigned(0, 32);

        -- executeALU
        wait for 20 ns;        
        assert CtlToALU_port.alu_fun       = ALU_ADD              report "unexpected value for CtlToALU_port.alu_fun"       severity warning;
        assert CtlToALU_port.imm           = to_unsigned(8, 32)   report "unexpected value for CtlToALU_port.imm"           severity warning;
        assert CtlToALU_port.op1_sel       = OP_REG               report "unexpected value for CtlToALU_port.op1_sel"       severity warning;
        assert CtlToALU_port.op2_sel       = OP_IMM               report "unexpected value for CtlToALU_port.op2_sel"       severity warning;
        assert CtlToALU_port.pc_reg        = to_unsigned(4, 32)   report "unexpected value for CtlToALU_port.pc_reg"        severity warning;
        assert CtlToALU_port.reg1_contents = to_unsigned(256, 32) report "unexpected value for CtlToALU_port.reg1_contents" severity warning;
        assert CtlToALU_port.reg2_contents = to_unsigned(0, 32)   report "unexpected value for CtlToALU_port.reg2_contents" severity warning;
                
        -- evaluateALUresult
        wait for 20 ns;
        ALUtoCtl_port.ALU_result <= to_unsigned(264, 32);

        -- writeMemory
        wait for 20 ns;
        assert CtlToMem_port.addrIn = to_unsigned(264, 32) report "unexpected value for CtlToMem_port.addrIn" severity warning;
        assert CtlToMem_port.dataIn = to_unsigned(0, 32)   report "unexpected value for CtlToMem_port.dataIn" severity warning;
        assert CtlToMem_port.mask   = MT_W                 report "unexpected value for CtlToMem_port.mask"   severity warning;
        assert CtlToMem_port.req    = MEM_READ             report "unexpected value for CtlToMem_port.req"    severity warning;
        CtlToMem_port_sync <= true;            
        
        -- readMemory
        wait for 20 ns;
        CtlToMem_port_sync <= false;        
        MemToCtl_port     <= to_unsigned(5, 32);
        MemToCtl_port_sync <= true;
        
        -- writeBack
        wait for 20 ns;
        MemToCtl_port_sync <= false;
        assert CtlToRegs_port.dst      = to_unsigned(4, 32) report "unexpected value for CtlToRegs_port.dst"      severity warning;
        assert CtlToRegs_port.dst_data = to_unsigned(5, 32) report "unexpected value for CtlToRegs_port.dst_data" severity warning;
        assert CtlToRegs_port.req      = REG_WR             report "unexpected value for CtlToRegs_port.req"      severity warning;
        assert CtlToRegs_port.src1     = to_unsigned(1, 32) report "unexpected value for CtlToRegs_port.src1"     severity warning;
        assert CtlToRegs_port.src2     = to_unsigned(0, 32) report "unexpected value for CtlToRegs_port.src2"     severity warning;
        


        
        -- Simulate "sub $3,$5,$4" --------------------------------------------------------------------------------------------
        -- Assume content of R5 is to_unsigned(9, 32) and content of R4 is 5
        
        
        -- requestInstr
        wait for 20 ns;        
        assert CtlToMem_port.addrIn = to_unsigned(8, 32) report "unexpected value for CtlToMem_port.addrIn" severity warning;
        assert CtlToMem_port.dataIn = to_unsigned(0, 32) report "unexpected value for CtlToMem_port.dataIn" severity warning;
        assert CtlToMem_port.mask   = MT_W               report "unexpected value for CtlToMem_port.mask"   severity warning;
        assert CtlToMem_port.req    = MEM_READ           report "unexpected value for CtlToMem_port.req"    severity warning;
        CtlToMem_port_sync <= true;
        
        -- receiveInstr
        wait for 20 ns;
        CtlToMem_port_sync <= false;        
        MemToCtl_port <= "01000000010000101000000110110011";
        MemToCtl_port_sync <= true;

        -- decode
        wait for 20 ns;
        MemToCtl_port_sync <= false;
        assert CtlToDec_port = "01000000010000101000000110110011" report "unexpected value for CtlToDec_port" severity warning;
                
        -- setControl
        wait for 20 ns;                
        DecToCtl_port.encType   <= R;
        DecToCtl_port.imm       <= to_unsigned(0, 32);
        DecToCtl_port.instrType <= sub;
        DecToCtl_port.rd_addr   <= to_unsigned(3, 5);
        DecToCtl_port.rs1_addr  <= to_unsigned(5, 5);
        DecToCtl_port.rs2_addr  <= to_unsigned(4, 5);
        
        -- readRegisterFile
        wait for 20 ns;        
        assert CtlToRegs_port.dst      = to_unsigned(4, 32) report "unexpected value for CtlToRegs_port.dst"      severity warning;
        assert CtlToRegs_port.dst_data = to_unsigned(5, 32) report "unexpected value for CtlToRegs_port.dst_data" severity warning;
        assert CtlToRegs_port.req      = REG_RD             report "unexpected value for CtlToRegs_port.req"      severity warning;
        assert CtlToRegs_port.src1     = to_unsigned(5, 32) report "unexpected value for CtlToRegs_port.src1"     severity warning;
        assert CtlToRegs_port.src2     = to_unsigned(4, 32) report "unexpected value for CtlToRegs_port.src2"     severity warning;
                
        -- requestALU
        wait for 20 ns;                
        RegsToCtl_port.contents1 <= to_unsigned(9, 32);
        RegsToCtl_port.contents2 <= to_unsigned(5, 32);

        -- executeALU
        wait for 20 ns;
        assert CtlToALU_port.alu_fun       = ALU_SUB            report "unexpected value for CtlToALU_port.alu_fun"       severity warning;
        assert CtlToALU_port.imm           = to_unsigned(0, 32) report "unexpected value for CtlToALU_port.imm"           severity warning;
        assert CtlToALU_port.op1_sel       = OP_REG             report "unexpected value for CtlToALU_port.op1_sel"       severity warning;
        assert CtlToALU_port.op2_sel       = OP_REG             report "unexpected value for CtlToALU_port.op2_sel"       severity warning;
        assert CtlToALU_port.pc_reg        = to_unsigned(8, 32) report "unexpected value for CtlToALU_port.pc_reg"        severity warning;
        assert CtlToALU_port.reg1_contents = to_unsigned(9, 32) report "unexpected value for CtlToALU_port.reg1_contents" severity warning;
        assert CtlToALU_port.reg2_contents = to_unsigned(5, 32) report "unexpected value for CtlToALU_port.reg2_contents" severity warning;
        
        -- evaluateALUresult
        wait for 20 ns;
        ALUtoCtl_port.ALU_result <= to_unsigned(4, 32);

        -- writeBack
        wait for 20 ns;
        assert CtlToRegs_port.dst      = to_unsigned(3, 32) report "unexpected value for CtlToRegs_port.dst"      severity warning;
        assert CtlToRegs_port.dst_data = to_unsigned(4, 32) report "unexpected value for CtlToRegs_port.dst_data" severity warning;
        assert CtlToRegs_port.req      = REG_WR             report "unexpected value for CtlToRegs_port.req"      severity warning;
        assert CtlToRegs_port.src1     = to_unsigned(5, 32) report "unexpected value for CtlToRegs_port.src1"     severity warning;
        assert CtlToRegs_port.src2     = to_unsigned(4, 32) report "unexpected value for CtlToRegs_port.src2"     severity warning;
        



        -- Simulate "sw $3, 12($1)" --------------------------------------------------------------------------------------------
        -- Assume content of Register to_unsigned(1, 32) is 256
        -- Offset is 12
        -- Assume content of Memory-Address 264 is 5        
        
        -- requestInstr
        wait for 20 ns;
        
        assert CtlToMem_port.addrIn = to_unsigned(12, 32) report "unexpected value for CtlToMem_port.addrIn" severity warning;
        assert CtlToMem_port.dataIn = to_unsigned(0, 32)  report "unexpected value for CtlToMem_port.dataIn" severity warning;
        assert CtlToMem_port.mask   = MT_W                report "unexpected value for CtlToMem_port.mask"   severity warning;
        assert CtlToMem_port.req    = MEM_READ            report "unexpected value for CtlToMem_port.req"    severity warning;
        CtlToMem_port_sync <= true;
        
        -- receiveInstr
        wait for 20 ns;
        CtlToMem_port_sync <= false;
        MemToCtl_port <= "00000000001100001010011000100011";
        MemToCtl_port_sync <= true;

        -- decode
        wait for 20 ns;
        MemToCtl_port_sync <= false;
        assert CtlToDec_port = "00000000001100001010011000100011" report "unexpected value for CtlToDec_port" severity warning;
        
        -- setControl
        wait for 20 ns;
        DecToCtl_port.encType   <= S;
        DecToCtl_port.imm       <= to_unsigned(12, 32);
        DecToCtl_port.instrType <= sw;
        DecToCtl_port.rd_addr   <= to_unsigned(0, 5);
        DecToCtl_port.rs1_addr  <= to_unsigned(1, 5);
        DecToCtl_port.rs2_addr  <= to_unsigned(3, 5);
        
        -- readRegisterFile
        wait for 20 ns;
        assert CtlToRegs_port.dst      = to_unsigned(3, 32) report "unexpected value for CtlToRegs_port.dst"      severity warning;
        assert CtlToRegs_port.dst_data = to_unsigned(4, 32) report "unexpected value for CtlToRegs_port.dst_data" severity warning;
        assert CtlToRegs_port.req      = REG_RD             report "unexpected value for CtlToRegs_port.req"      severity warning;
        assert CtlToRegs_port.src1     = to_unsigned(1, 32) report "unexpected value for CtlToRegs_port.src1"     severity warning;
        assert CtlToRegs_port.src2     = to_unsigned(3, 32) report "unexpected value for CtlToRegs_port.src2"     severity warning;
        
        -- requestALU
        wait for 20 ns;
        RegsToCtl_port.contents1 <= to_unsigned(256, 32);
        RegsToCtl_port.contents2 <= to_unsigned(4, 32);

        -- executeALU
        wait for 20 ns;
        assert CtlToALU_port.alu_fun       = ALU_ADD              report "unexpected value for CtlToALU_port.alu_fun"       severity warning;
        assert CtlToALU_port.imm           = to_unsigned(12, 32)  report "unexpected value for CtlToALU_port.imm"           severity warning;
        assert CtlToALU_port.op1_sel       = OP_REG               report "unexpected value for CtlToALU_port.op1_sel"       severity warning;
        assert CtlToALU_port.op2_sel       = OP_IMM               report "unexpected value for CtlToALU_port.op2_sel"       severity warning;
        assert CtlToALU_port.pc_reg        = to_unsigned(12, 32)  report "unexpected value for CtlToALU_port.pc_reg"        severity warning;
        assert CtlToALU_port.reg1_contents = to_unsigned(256, 32) report "unexpected value for CtlToALU_port.reg1_contents" severity warning;
        assert CtlToALU_port.reg2_contents = to_unsigned(4, 32)   report "unexpected value for CtlToALU_port.reg2_contents" severity warning;
        
        -- evaluateALUresult
        wait for 20 ns;
        ALUtoCtl_port.ALU_result <= to_unsigned(268, 32);

        -- writeMemory
        wait for 20 ns;
        assert CtlToMem_port.addrIn = to_unsigned(268, 32) report "unexpected value for CtlToMem_port.addrIn" severity warning;
        assert CtlToMem_port.dataIn = to_unsigned(4, 32)   report "unexpected value for CtlToMem_port.dataIn" severity warning;
        assert CtlToMem_port.mask   = MT_W                 report "unexpected value for CtlToMem_port.mask"   severity warning;
        assert CtlToMem_port.req    = MEM_WRITE            report "unexpected value for CtlToMem_port.req"    severity warning;
        CtlToMem_port_sync <= true;    
        
        -- readMemory
        wait for 20 ns;
        CtlToMem_port_sync <= false;
        MemToCtl_port     <= to_unsigned(0, 32);
        MemToCtl_port_sync <= true;

        
        -- Simulate "bne $4, $5, 12" --------------------------------------------------------------------------------------------
        -- Assume content of Register to_unsigned(4, 32) is 5
        -- Assume content of Register 5 is 9
        
        
        -- requestInstr
        wait for 20 ns;
        MemToCtl_port_sync <= false;
        assert CtlToMem_port.addrIn = to_unsigned(16, 32) report "unexpected value for CtlToMem_port.addrIn" severity warning;
        assert CtlToMem_port.dataIn = to_unsigned(0, 32)  report "unexpected value for CtlToMem_port.dataIn" severity warning;
        assert CtlToMem_port.mask   = MT_W                report "unexpected value for CtlToMem_port.mask"   severity warning;
        assert CtlToMem_port.req    = MEM_READ            report "unexpected value for CtlToMem_port.req"    severity warning;
        CtlToMem_port_sync <= true;
        
        -- receiveInstr
        wait for 20 ns;
        CtlToMem_port_sync <= false;
        MemToCtl_port <= "00000000010100100001011001100011";
        MemToCtl_port_sync <= true;

        -- decode
        wait for 20 ns;
        MemToCtl_port_sync <= false;
        assert CtlToDec_port = "00000000010100100001011001100011" report "unexpected value for CtlToDec_port" severity warning;
        
        -- setControl
        wait for 20 ns;
        DecToCtl_port.encType   <= B;
        DecToCtl_port.imm       <= to_unsigned(12, 32);
        DecToCtl_port.instrType <= bne;
        DecToCtl_port.rd_addr   <= to_unsigned(0, 5);
        DecToCtl_port.rs1_addr  <= to_unsigned(4, 5);
        DecToCtl_port.rs2_addr  <= to_unsigned(5, 5);
        
        -- readRegisterFile
        wait for 20 ns;
        assert CtlToRegs_port.dst      = to_unsigned(3, 32) report "unexpected value for CtlToRegs_port.dst"      severity warning;
        assert CtlToRegs_port.dst_data = to_unsigned(4, 32) report "unexpected value for CtlToRegs_port.dst_data" severity warning;
        assert CtlToRegs_port.req      = REG_RD             report "unexpected value for CtlToRegs_port.req"      severity warning;
        assert CtlToRegs_port.src1     = to_unsigned(4, 32) report "unexpected value for CtlToRegs_port.src1"     severity warning;
        assert CtlToRegs_port.src2     = to_unsigned(5, 32) report "unexpected value for CtlToRegs_port.src2"     severity warning;
        
        -- requestALU
        wait for 20 ns;
        RegsToCtl_port.contents1 <= to_unsigned(5, 32);
        RegsToCtl_port.contents2 <= to_unsigned(9, 32);

        -- executeALU
        wait for 20 ns;
        assert CtlToALU_port.alu_fun       = ALU_SUB             report "unexpected value for CtlToALU_port.alu_fun"       severity warning;
        assert CtlToALU_port.imm           = to_unsigned(12, 32) report "unexpected value for CtlToALU_port.imm"           severity warning;
        assert CtlToALU_port.op1_sel       = OP_REG              report "unexpected value for CtlToALU_port.op1_sel"       severity warning;
        assert CtlToALU_port.op2_sel       = OP_REG              report "unexpected value for CtlToALU_port.op2_sel"       severity warning;
        assert CtlToALU_port.pc_reg        = to_unsigned(16, 32) report "unexpected value for CtlToALU_port.pc_reg"        severity warning;
        assert CtlToALU_port.reg1_contents = to_unsigned(5, 32)  report "unexpected value for CtlToALU_port.reg1_contents" severity warning;
        assert CtlToALU_port.reg2_contents = to_unsigned(9, 32)  report "unexpected value for CtlToALU_port.reg2_contents" severity warning;
        
        -- evaluateALUresult
        wait for 20 ns;
        ALUtoCtl_port.ALU_result <= "11111111111111111111111111111100"; -- -4


        -- Simulate "jal r1, 0" --------------------------------------------------------------------------------------------

        -- requestInstr
        wait for 20 ns;
        assert CtlToMem_port.addrIn = to_unsigned(28, 32) report "unexpected value for CtlToMem_port.addrIn" severity warning;
        assert CtlToMem_port.dataIn = to_unsigned(0, 32)  report "unexpected value for CtlToMem_port.dataIn" severity warning;
        assert CtlToMem_port.mask   = MT_W                report "unexpected value for CtlToMem_port.mask"   severity warning;
        assert CtlToMem_port.req    = MEM_READ            report "unexpected value for CtlToMem_port.req"    severity warning;
        CtlToMem_port_sync <= true;
        
        -- receiveInstr
        wait for 20 ns;
        CtlToMem_port_sync <= false;
        MemToCtl_port <= "11111110100111111111000011101111";
        MemToCtl_port_sync <= true;

        -- decode
        wait for 20 ns;
        MemToCtl_port_sync <= false;
        assert CtlToDec_port = "11111110100111111111000011101111" report "unexpected value for CtlToDec_port" severity warning;
        
        -- setControl
        wait for 20 ns;
        DecToCtl_port.encType   <= J;
        DecToCtl_port.imm       <= "11111111111111111111111111101000"; -- -24 
        DecToCtl_port.instrType <= jal;
        DecToCtl_port.rd_addr   <= to_unsigned(1, 5);
        DecToCtl_port.rs1_addr  <= to_unsigned(0, 5);
        DecToCtl_port.rs2_addr  <= to_unsigned(0, 5);
        
        -- executeALU
        wait for 20 ns;
        assert CtlToALU_port.alu_fun       = ALU_X                              report "unexpected value for CtlToALU_port.alu_fun"       severity warning;
        assert CtlToALU_port.imm           = "11111111111111111111111111101000" report "unexpected value for CtlToALU_port.imm"           severity warning;
        assert CtlToALU_port.op1_sel       = OP_X                               report "unexpected value for CtlToALU_port.op1_sel"       severity warning;
        assert CtlToALU_port.op2_sel       = OP_X                               report "unexpected value for CtlToALU_port.op2_sel"       severity warning;
        assert CtlToALU_port.pc_reg        = to_unsigned(28, 32)                report "unexpected value for CtlToALU_port.pc_reg"        severity warning;
        assert CtlToALU_port.reg1_contents = to_unsigned( 5, 32)                report "unexpected value for CtlToALU_port.reg1_contents" severity warning;
        assert CtlToALU_port.reg2_contents = to_unsigned( 9, 32)                report "unexpected value for CtlToALU_port.reg2_contents" severity warning;
        
        -- evaluateALUresult
        wait for 20 ns;
        ALUtoCtl_port.ALU_result <= to_unsigned(0, 32);

        -- writeBack
        wait for 20 ns;
        assert CtlToRegs_port.dst      = to_unsigned(1, 32)  report "unexpected value for CtlToRegs_port.dst"      severity warning;
        assert CtlToRegs_port.dst_data = to_unsigned(32, 32) report "unexpected value for CtlToRegs_port.dst_data" severity warning;
        assert CtlToRegs_port.req      = REG_WR              report "unexpected value for CtlToRegs_port.req"      severity warning;
        assert CtlToRegs_port.src1     = to_unsigned(4, 32)  report "unexpected value for CtlToRegs_port.src1"     severity warning;
        assert CtlToRegs_port.src2     = to_unsigned(5, 32)  report "unexpected value for CtlToRegs_port.src2"     severity warning;
        
        -- requestInstr
        wait for 20 ns;
        assert CtlToMem_port.addrIn = to_unsigned(4, 32) report "unexpected value for CtlToMem_port.addrIn" severity warning;
        assert CtlToMem_port.dataIn = to_unsigned(0, 32) report "unexpected value for CtlToMem_port.dataIn" severity warning;
        assert CtlToMem_port.mask   = MT_W               report "unexpected value for CtlToMem_port.mask"   severity warning;
        assert CtlToMem_port.req    = MEM_READ           report "unexpected value for CtlToMem_port.req"    severity warning;
        CtlToMem_port_sync <= true;


        
        wait;

    end process stimuli;


end architecture;





















































