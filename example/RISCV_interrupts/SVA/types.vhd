--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 30.11.18
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

package SCAM_Model_types is
subtype bool is Boolean;
subtype int is Integer;
type ALUfuncType is (ALU_ADD,ALU_AND,ALU_COPY1,ALU_OR,ALU_SLL,ALU_SLT,ALU_SLTU,ALU_SRA,ALU_SRL,ALU_SUB,ALU_X,ALU_XOR);
type EncType is (ENC_B,ENC_ERR,ENC_I_I,ENC_I_J,ENC_I_L,ENC_I_M,ENC_I_S,ENC_J,ENC_R,ENC_S,ENC_U);

type ISA_SECTIONS is (fetch, execute, store, load1, load2, syscall1, syscall2);
-- type ISA_SECTIONS_SMALL is (fetch, execute, store, load1, load2);

-- constants for SyscallHandler
constant SYS_exit  : unsigned (31 downto 0) := to_unsigned(93,32);
constant SYS_write  : unsigned (31 downto 0) := to_unsigned(64,32);
-- constants for Memory Mapping
constant CLINT_START_ADDR	: unsigned (31 downto 0) := X"02000000";
constant CLINT_END_ADDR		: unsigned (31 downto 0) := X"0200FFFF";
        constant CLINT_msip_ADDR			: unsigned (31 downto 0) := X"02000000";
        constant CLINT_mtimecmp_ADDR	: unsigned (31 downto 0) := X"02004000";
        constant CLINT_mtime_ADDR		: unsigned (31 downto 0) := X"0200BFF8";

constant PLIC_START_ADDR	: unsigned (31 downto 0) := X"0C000000";
constant PLIC_END_ADDR		: unsigned (31 downto 0) := X"0C200008";
        constant PLIC_Priority_ADDR					: unsigned (31 downto 0) := X"0C000000";
        constant PLIC_Pending_ADDR					: unsigned (31 downto 0) := X"0C001000";
        constant PLIC_Interrupt_Enables_ADDR		: unsigned (31 downto 0) := X"0C002000";
        constant PLIC_Threshold_ADDR				: unsigned (31 downto 0) := X"0C200000";
        constant PLIC_Claim_Complete_ADDR			: unsigned (31 downto 0) := X"0C200004";

constant MEM_DEPTH	: integer := 1024*256;-- 256 KB ram -- 1024*1024*32;
constant MEM_START_ADDR	: unsigned (31 downto 0) := X"00000000";
constant MEM_END_ADDR	: unsigned (31 downto 0) := MEM_START_ADDR + to_unsigned(MEM_DEPTH, 32);



type InstrType_Complete is (INSTR_ADD,INSTR_ADDI,INSTR_AND,INSTR_ANDI,INSTR_AUIPC,INSTR_BEQ,INSTR_BGE,INSTR_BGEU,INSTR_BLT,INSTR_BLTU,INSTR_BNE,INSTR_JAL,INSTR_JALR,INSTR_FENCE,INSTR_FENCEI,INSTR_PRIV,INSTR_CSRRW,INSTR_CSRRS,INSTR_CSRRC,INSTR_CSRRWI,INSTR_CSRRSI,INSTR_CSRRCI,INSTR_LB,INSTR_LBU,INSTR_LH,INSTR_LHU,INSTR_LUI,INSTR_LW,INSTR_OR,INSTR_ORI,INSTR_SB,INSTR_SH,INSTR_SLL,INSTR_SLLI,INSTR_SLT,INSTR_SLTI,INSTR_SLTU,INSTR_SLTUI,INSTR_SRA,INSTR_SRAI,INSTR_SRL,INSTR_SRLI,INSTR_SUB,INSTR_SW,INSTR_UNKNOWN,INSTR_XOR,INSTR_XORI);
type ME_AccessType is (ME_RD,ME_WR,ME_X);
type ME_MaskType is (MT_B,MT_BU,MT_H,MT_HU,MT_W,MT_X);
type PrivInstrType is (INSTR_PRIV_UNKNOWN, INSTR_ECALL, INSTR_EBREAK, INSTR_MRET, INSTR_WFI, INSTR_SFENCEVMA);

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

type RegfileSyscallType is record
	reg_file_10: unsigned (31 downto 0);
	reg_file_11: unsigned (31 downto 0);
	reg_file_12: unsigned (31 downto 0);
	reg_file_17: unsigned (31 downto 0);
end record;

type CSRfileType is record
	mstatus:    unsigned (31 downto 0);
	mie:        unsigned (31 downto 0);
	mtvec:      unsigned (31 downto 0);
	mepc:       unsigned (31 downto 0);
	mcause:     unsigned (31 downto 0);
	mip:        unsigned (31 downto 0);
	mvendorid:  unsigned (31 downto 0);
	marchid:    unsigned (31 downto 0);
	mimpid:     unsigned (31 downto 0);
	mhartid:    unsigned (31 downto 0);
end record;

type RegfileWriteType is record
	dst: unsigned (31 downto 0);
	dstData: unsigned (31 downto 0);
end record;

end package SCAM_Model_types;