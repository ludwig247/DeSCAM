package top_level_types;

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
	} InstrType;

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
		bit[31:0] reg_file_01;
		bit[31:0] reg_file_02;
		bit[31:0] reg_file_03;
		bit[31:0] reg_file_04;
		bit[31:0] reg_file_05;
		bit[31:0] reg_file_06;
		bit[31:0] reg_file_07;
		bit[31:0] reg_file_08;
		bit[31:0] reg_file_09;
		bit[31:0] reg_file_10;
		bit[31:0] reg_file_11;
		bit[31:0] reg_file_12;
		bit[31:0] reg_file_13;
		bit[31:0] reg_file_14;
		bit[31:0] reg_file_15;
		bit[31:0] reg_file_16;
		bit[31:0] reg_file_17;
		bit[31:0] reg_file_18;
		bit[31:0] reg_file_19;
		bit[31:0] reg_file_20;
		bit[31:0] reg_file_21;
		bit[31:0] reg_file_22;
		bit[31:0] reg_file_23;
		bit[31:0] reg_file_24;
		bit[31:0] reg_file_25;
		bit[31:0] reg_file_26;
		bit[31:0] reg_file_27;
		bit[31:0] reg_file_28;
		bit[31:0] reg_file_29;
		bit[31:0] reg_file_30;
		bit[31:0] reg_file_31;
	} RegfileType;

	typedef struct {
		bit[31:0] dst;
		bit[31:0] dstdata;
	} RegfileWriteType;

endpackage