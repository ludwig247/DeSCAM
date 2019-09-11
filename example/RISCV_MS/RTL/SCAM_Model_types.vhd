--
-- Created by deutschmann on 14.02.18
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

package SCAM_Model_types is

-- Memory size in Byte
constant MEM_SIZE : integer := 65536;

subtype bool is Boolean;
subtype int  is Integer;

type ALUfuncType is (ALU_ADD,ALU_AND,ALU_COPY1,ALU_OR,ALU_SLL,ALU_SLT,ALU_SLTU,ALU_SRA,ALU_SRL,ALU_SUB,ALU_X,ALU_XOR);

type ALUopType      is (OP_IMM,OP_PC,OP_REG,OP_X);

type ME_AccessType is (ME_RD,ME_WR,ME_X);
type ME_MaskType    is (MT_B,MT_BU,MT_H,MT_HU,MT_W,MT_X);

type AccessType_Reg is (REG_RD,REG_WR);
type EncType        is (ENC_B,ENC_ERR,ENC_I_I,ENC_I_L,ENC_I_J,ENC_J,ENC_R,ENC_S,ENC_U);
type InstrType      is (INSTR_ADD,INSTR_ADDI,INSTR_AND,INSTR_ANDI,INSTR_AUIPC,INSTR_BEQ,INSTR_BGE,INSTR_BGEU,INSTR_BLT,INSTR_BLTU,INSTR_BNE,INSTR_JAL,INSTR_JALR,INSTR_LB,INSTR_LBU,INSTR_LH,INSTR_LHU,INSTR_LUI,INSTR_LW,INSTR_OR,INSTR_ORI,INSTR_SB,INSTR_SH,INSTR_SLL,INSTR_SLLI,INSTR_SLT,INSTR_SLTI,INSTR_SLTU,INSTR_SLTUI,INSTR_SRA,INSTR_SRAI,INSTR_SRL,INSTR_SRLI,INSTR_SUB,INSTR_SW,INSTR_UNKNOWN,INSTR_XOR,INSTR_XORI);

type PCselType      is (PC_4,PC_BR,PC_EXC,PC_J,PC_JR);
type WBselType      is (WB_ALU,WB_MEM,WB_PC4,WB_X);

type   Cpath_SECTIONS is (requestInstr, receiveInstr, decode, setControl, readRegisterFile, requestALU, executeALU, evaluateALUresult, writeMemory, readMemory, writeBack);
type     Mem_SECTIONS is (read, write);


type ALUtoCtl_IF is record
    ALU_result : Unsigned (31 downto 0);
end record;

type CtlToALU_IF is record
    alu_fun       : ALUfuncType;
    imm           : Unsigned (31 downto 0);
    op1_sel       : ALUopType;
    op2_sel       : ALUopType;
    pc_reg        : Unsigned (31 downto 0);
    reg1_contents : Unsigned (31 downto 0);
    reg2_contents : Unsigned (31 downto 0);
end record;

type CtlToRegs_IF is record
    dst      : Unsigned (4 downto 0);
    dst_data : Unsigned (31 downto 0);
    req      : AccessType_Reg;
    src1     : Unsigned (4 downto 0);
    src2     : Unsigned (4 downto 0);
end record;

type DecodedInstr is record
    encType   : EncType;
    imm       : Unsigned (31 downto 0);
    instrType : InstrType;
    rd_addr   : Unsigned (4 downto 0);
    rs1_addr  : Unsigned (4 downto 0);
    rs2_addr  : Unsigned (4 downto 0);
end record;

type CUtoME_IF is record
    addrIn : Unsigned (31 downto 0);
    dataIn : Unsigned (31 downto 0);
    mask   : ME_MaskType;
    req    : ME_AccessType;
end record;

type MEtoCU_IF is record
	loadedData: unsigned (31 downto 0);
end record;

type RegsToCtl_IF is record
    contents1 : Unsigned (31 downto 0);
    contents2 : Unsigned (31 downto 0);
end record;

type register_file is array (1 to 31) of Unsigned (31 downto 0);
type ram_type is array (0 to (MEM_SIZE-1)) of Unsigned (7 downto 0);

end package SCAM_Model_types;
