package top_level_types;

	 import top_level_types::*;
	typedef enum logic [3:0] {
		alu_add,
		alu_and,
		alu_copy1,
		alu_or,
		alu_sll,
		alu_slt,
		alu_sltu,
		alu_sra,
		alu_srl,
		alu_sub,
		alu_x,
		alu_xor
	} ALUfuncType;

	typedef enum logic [3:0] {
		enc_b,
		enc_err,
		enc_i_i,
		enc_i_j,
		enc_i_l,
		enc_i_m,
		enc_i_s,
		enc_j,
		enc_r,
		enc_s,
		enc_u
	} EncType;

	typedef enum logic [5:0] {
		instr_add,
		instr_addi,
		instr_and,
		instr_andi,
		instr_auipc,
		instr_beq,
		instr_bge,
		instr_bgeu,
		instr_blt,
		instr_bltu,
		instr_bne,
		instr_csrrc,
		instr_csrrci,
		instr_csrrs,
		instr_csrrsi,
		instr_csrrw,
		instr_csrrwi,
		instr_fence,
		instr_fencei,
		instr_jal,
		instr_jalr,
		instr_lb,
		instr_lbu,
		instr_lh,
		instr_lhu,
		instr_lui,
		instr_lw,
		instr_or,
		instr_ori,
		instr_priv,
		instr_sb,
		instr_sh,
		instr_sll,
		instr_slli,
		instr_slt,
		instr_slti,
		instr_sltu,
		instr_sltui,
		instr_sra,
		instr_srai,
		instr_srl,
		instr_srli,
		instr_sub,
		instr_sw,
		instr_unknown,
		instr_xor,
		instr_xori
	} InstrType_Complete;

	typedef enum logic [1:0] {
		me_rd,
		me_wr,
		me_x
	} ME_AccessType;

	typedef enum logic [2:0] {
		mt_b,
		mt_bu,
		mt_h,
		mt_hu,
		mt_w,
		mt_x
	} ME_MaskType;

	typedef enum logic [1:0] {
		instr_ebreak,
		instr_ecall,
		instr_mret,
		instr_priv_unknown
	} PrivInstrType;

	typedef struct {
		bit[31:0] mcause;
		bit[31:0] mepc;
		bit[31:0] mie;
		bit[31:0] mip;
		bit[31:0] mstatus;
		bit[31:0] mtvec;
	} CSRfileType;

	typedef struct {
		bit[31:0] addrin;
		bit[31:0] datain;
		ME_MaskType mask;
		ME_AccessType req;
	} CUtoME_IF;

	typedef struct {
		bit[31:0] loadeddata;
	} MEtoCU_IF;

	typedef struct {
		bit[31:0] dst;
		bit[31:0] dstdata;
	} RegfileWriteType;

	typedef bit[31:0] unsigned_32 [0:31];

endpackage