--
-- Created by deutschmann on 14.02.18
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

package SCAM_Model_types is

subtype bool is Boolean;
subtype int  is Integer;

type ALU_function   is (ALU_ADD,ALU_AND,ALU_COPY1,ALU_OR,ALU_SLL,ALU_SLT,ALU_SLTU,ALU_SRA,ALU_SRL,ALU_SUB,ALU_X,ALU_XOR);
type ALUopType      is (OP_IMM,OP_PC,OP_REG,OP_X);
type AccessType_Mem is (MEM_LOAD,MEM_RD_I,MEM_STORE);
type AccessType_Reg is (REG_RD,REG_WR);
type EncType        is (B,Error_Type,I,J,R,S,U);
type InstrType      is (And_Instr,Or_Instr,Unknown,Xor_Instr,add,addI,andI,auipc,beq,bge,bgeu,blt,bltu,bne,jal,jalr,lb,lbu,lh,lhu,lui,lw,orI,sb,sh,sllI,sll_Instr,slt,sltI,sltIu,sltu,sraI,sra_Instr,srlI,srl_Instr,sub,sw,xorI);
type MemMaskType    is (MT_B,MT_BU,MT_H,MT_HU,MT_W,MT_X);
type PCselType      is (PC_4,PC_BR,PC_EXC,PC_J,PC_JR);
type WBselType      is (WB_ALU,WB_MEM,WB_PC4,WB_X);

type     ALU_SECTIONS is (read, write);
type   Cpath_SECTIONS is (fetchAndDecode0, fetchAndDecode1, readRegisterFile0, readRegisterFile1, executeALU0, executeALU1, memoryOperation0, memoryOperation1, writeBack);
type Decoder_SECTIONS is (read, write);
type     Mem_SECTIONS is (read, writeDec, writeCtl);
type    Regs_SECTIONS is (read, write);


type ALUtoCtl_IF is record
    ALU_result : Unsigned (31 downto 0);
end record;

type CtlToALU_IF is record
    alu_fun       : ALU_function;
    imm           : Unsigned (31 downto 0);
    op1_sel       : ALUopType;
    op2_sel       : ALUopType;
    pc_reg        : Unsigned (31 downto 0);
    reg1_contents : Unsigned (31 downto 0);
    reg2_contents : Unsigned (31 downto 0);
end record;

type CtlToRegs_IF is record
    dst      : Unsigned (31 downto 0);
    dst_data : Unsigned (31 downto 0);
    req      : AccessType_Reg;
    src1     : Unsigned (31 downto 0);
    src2     : Unsigned (31 downto 0);
end record;

type DecodedInstr is record
    encType   : EncType;
    imm       : Unsigned (31 downto 0);
    instrType : InstrType;
    rd_addr   : Unsigned (31 downto 0);
    rs1_addr  : Unsigned (31 downto 0);
    rs2_addr  : Unsigned (31 downto 0);
end record;

type MemoryAccess is record
    addrIn : Unsigned (31 downto 0);
    dataIn : Unsigned (31 downto 0);
    mask   : MemMaskType;
    req    : AccessType_Mem;
end record;

type RegsToCtl_IF is record
    contents1 : Unsigned (31 downto 0);
    contents2 : Unsigned (31 downto 0);
end record;

type register_file is array (0 to 31) of Unsigned (31 downto 0);
type ram_type is array (0 to 511) of Unsigned (7 downto 0);

end package SCAM_Model_types;
