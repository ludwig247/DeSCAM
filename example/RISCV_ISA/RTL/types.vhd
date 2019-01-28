--
-- Created by deutschmann on 08.10.18
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

package SCAM_Model_types is

constant MEM_SIZE : integer := 65536;

subtype bool is Boolean;
subtype int is Integer;
type ALUfuncType is (ALU_ADD,ALU_AND,ALU_COPY1,ALU_OR,ALU_SLL,ALU_SLT,ALU_SLTU,ALU_SRA,ALU_SRL,ALU_SUB,ALU_X,ALU_XOR);
type EncType is (ENC_B,ENC_ERR,ENC_I_I,ENC_I_J,ENC_I_L,ENC_J,ENC_R,ENC_S,ENC_U);
type ISA_SECTIONS is (fetch, execute, store1, store2, load1, load2);
type InstrType is (INSTR_ADD,INSTR_ADDI,INSTR_AND,INSTR_ANDI,INSTR_AUIPC,INSTR_BEQ,INSTR_BGE,INSTR_BGEU,INSTR_BLT,INSTR_BLTU,INSTR_BNE,INSTR_JAL,INSTR_JALR,INSTR_LB,INSTR_LBU,INSTR_LH,INSTR_LHU,INSTR_LUI,INSTR_LW,INSTR_OR,INSTR_ORI,INSTR_SB,INSTR_SH,INSTR_SLL,INSTR_SLLI,INSTR_SLT,INSTR_SLTI,INSTR_SLTU,INSTR_SLTUI,INSTR_SRA,INSTR_SRAI,INSTR_SRL,INSTR_SRLI,INSTR_SUB,INSTR_SW,INSTR_UNKNOWN,INSTR_XOR,INSTR_XORI);
type ME_AccessType is (ME_RD,ME_WR,ME_X);
type ME_MaskType is (MT_B,MT_BU,MT_H,MT_HU,MT_W,MT_X);
type CUtoME_IF is record
	addrIn: unsigned (31 downto 0);
	dataIn: unsigned (31 downto 0);
	mask: ME_MaskType;
	req: ME_AccessType;
end record;
type MEtoCU_IF is record
	loadedData: unsigned (31 downto 0);
end record;
type RegfileType is record
	reg_file_01: unsigned (31 downto 0);
	reg_file_02: unsigned (31 downto 0);
	reg_file_03: unsigned (31 downto 0);
	reg_file_04: unsigned (31 downto 0);
	reg_file_05: unsigned (31 downto 0);
	reg_file_06: unsigned (31 downto 0);
	reg_file_07: unsigned (31 downto 0);
	reg_file_08: unsigned (31 downto 0);
	reg_file_09: unsigned (31 downto 0);
	reg_file_10: unsigned (31 downto 0);
	reg_file_11: unsigned (31 downto 0);
	reg_file_12: unsigned (31 downto 0);
	reg_file_13: unsigned (31 downto 0);
	reg_file_14: unsigned (31 downto 0);
	reg_file_15: unsigned (31 downto 0);
	reg_file_16: unsigned (31 downto 0);
	reg_file_17: unsigned (31 downto 0);
	reg_file_18: unsigned (31 downto 0);
	reg_file_19: unsigned (31 downto 0);
	reg_file_20: unsigned (31 downto 0);
	reg_file_21: unsigned (31 downto 0);
	reg_file_22: unsigned (31 downto 0);
	reg_file_23: unsigned (31 downto 0);
	reg_file_24: unsigned (31 downto 0);
	reg_file_25: unsigned (31 downto 0);
	reg_file_26: unsigned (31 downto 0);
	reg_file_27: unsigned (31 downto 0);
	reg_file_28: unsigned (31 downto 0);
	reg_file_29: unsigned (31 downto 0);
	reg_file_30: unsigned (31 downto 0);
	reg_file_31: unsigned (31 downto 0);
end record;
type RegfileWriteType is record
	dst: unsigned (4 downto 0);
	dstData: unsigned (31 downto 0);
end record;

type MEM_SECTIONS is (read, write);
type ram_type is array (0 to (MEM_SIZE-1)) of Unsigned (7 downto 0);

end package SCAM_Model_types;