library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity ISA is
port(	
	CtlToDec_port_sig: out unsigned(31 downto 0);
	CtlToDec_port_notify: out boolean;
	CtlToMem_port_sig: out CUtoME_IF;
	CtlToMem_port_sync: in boolean;
	CtlToMem_port_notify: out boolean;
	CtlToRegs_port_sig: out CtlToRegs_IF;
	CtlToRegs_port_notify: out boolean;
	DecToCtl_port_sig: in DecodedInstr;
	MemToCtl_port_sig: in MEtoCU_IF;
	MemToCtl_port_sync: in boolean;
	MemToCtl_port_notify: out boolean;
	RegsToCtl_port_sig: in RegsToCtl_IF;
	clk: in std_logic;
	rst: in std_logic
);
end ISA;

architecture ISA_arch of ISA is
	-- Define internal data types
	type ISA_assign_t is (assign_0, assign_1, assign_2, assign_3, assign_4, assign_5, assign_6, assign_7, assign_8, assign_9, assign_10, assign_11, assign_12, assign_13, assign_14, assign_15, assign_16, assign_17, assign_18, assign_19, assign_20, assign_21, assign_22, assign_23, assign_24, assign_25, assign_26, assign_27, assign_28, assign_29, assign_30, assign_31, assign_32, assign_33, assign_34, assign_35, assign_36, assign_37, assign_38, assign_39, assign_40, assign_41, assign_42, assign_43, assign_44, assign_45, assign_46, assign_47, assign_48, assign_49, assign_50, assign_51, assign_52, assign_53, assign_54, assign_55, assign_56, assign_57, assign_58, assign_59, assign_60, assign_61, assign_62, assign_63, assign_64, assign_65, assign_66, assign_67, assign_68, assign_69, assign_70, assign_71, assign_72, assign_73, assign_74, assign_75, assign_76, assign_77, assign_78, assign_79, assign_80, assign_81, assign_82, assign_83, assign_84, assign_85, assign_86, assign_87, assign_88, assign_89, assign_90, assign_91, assign_92, assign_93, assign_94, assign_95, assign_96, assign_97, assign_98, assign_99, assign_100, assign_101, assign_102, assign_103, assign_104, assign_105, assign_106, assign_107, assign_108, assign_109, assign_110, assign_111, assign_112, assign_113, assign_114, assign_115, assign_116, assign_117, assign_118, assign_119, assign_120, assign_121, assign_122, assign_123, assign_124, assign_125, assign_126, assign_127, assign_128, assign_129, assign_130, assign_131, assign_132, assign_133, assign_134, assign_135, assign_136, assign_137, assign_138, assign_139, assign_140, assign_141, assign_142, assign_143, assign_144, assign_145, assign_146, assign_147, assign_148, assign_149, assign_150, assign_151, assign_152, assign_153, assign_154, assign_155, assign_156, assign_157, assign_158, assign_159, assign_160, assign_161, assign_162, assign_163, assign_164, assign_165, assign_166, assign_167, assign_168, assign_169, assign_170, assign_171, assign_172, assign_173, assign_174, assign_175, assign_176, assign_177, assign_178, assign_179, assign_180, assign_181, assign_182, assign_183, assign_184, assign_185, assign_186, assign_187, assign_188, assign_189, assign_190, assign_191, assign_192, assign_193, assign_194, assign_195, assign_196, assign_197, assign_198, assign_199, assign_200, assign_201, assign_202, assign_203, assign_204, assign_205, assign_206, assign_207, assign_208, assign_209, assign_210, assign_211, assign_212, assign_213, assign_214, assign_215, assign_216, assign_217, assign_218, assign_219, assign_220, assign_221, assign_222, assign_223, assign_224, assign_225, assign_226, assign_227, assign_228, assign_229, assign_230, assign_231, assign_232, assign_233, assign_234, assign_235, assign_236, assign_237, assign_238, assign_239, assign_240, assign_241, assign_242, assign_243, assign_244, assign_245);
	type ISA_state_t is (st_decode_1, st_decode_2, st_executeALU_4, st_executeALU_5, st_fetch_6, st_fetch_7, st_memoryOperation_8, st_memoryOperation_9, st_readRegisterFile_10, st_readRegisterFile_11, st_writeBack_13);
	type ALUtoCtl_IF is record
		ALU_result: unsigned(31 downto 0);
	end record;
	type ALU_function is (ALU_ADD, ALU_AND, ALU_COPY1, ALU_OR, ALU_SLL, ALU_SLT, ALU_SLTU, ALU_SRA, ALU_SRL, ALU_SUB, ALU_X, ALU_XOR);
	type ALUopType is (OP_IMM, OP_PC, OP_REG, OP_X);
	type CtlToALU_IF is record
		alu_fun: ALU_function;
		imm: unsigned(31 downto 0);
		op1_sel: ALUopType;
		op2_sel: ALUopType;
		pc_reg: unsigned(31 downto 0);
		reg1_contents: unsigned(31 downto 0);
		reg2_contents: unsigned(31 downto 0);
	end record;
	type WBselType is (WB_ALU, WB_MEM, WB_PC4, WB_X);

	-- Declare signals
	signal active_state: ISA_state_t;
	signal active_assignment: ISA_assign_t;
	signal ALUtoCtl_data: ALUtoCtl_IF;
	signal CtlToALU_data: CtlToALU_IF;
	signal CtlToRegs_data: CtlToRegs_IF;
	signal RegsToCtl_data: RegsToCtl_IF;
	signal br_en: boolean;
	signal decodedInstr: DecodedInstr;
	signal fromMemoryData: MEtoCU_IF;
	signal mem_en: boolean;
	signal memoryAccess: CUtoME_IF;
	signal pc_next: unsigned(31 downto 0);
	signal pc_reg: unsigned(31 downto 0);
	signal reg_rd_en: boolean;
	signal wb_en: boolean;
	signal wb_sel: WBselType;

	-- Declare state signals that are used by ITL properties for OneSpin
	signal decode_1: boolean;
	signal decode_2: boolean;
	signal executeALU_4: boolean;
	signal executeALU_5: boolean;
	signal fetch_6: boolean;
	signal fetch_7: boolean;
	signal memoryOperation_8: boolean;
	signal memoryOperation_9: boolean;
	signal readRegisterFile_10: boolean;
	signal readRegisterFile_11: boolean;
	signal writeBack_13: boolean;


begin
	-- Combinational logic that selects current operation
	process (active_state, CtlToMem_port_sync, MemToCtl_port_sync, RegsToCtl_port_sig.contents1, RegsToCtl_port_sig.contents2, DecToCtl_port_sig.encType, DecToCtl_port_sig.imm, DecToCtl_port_sig.instrType, pc_reg, ALUtoCtl_data.ALU_result, reg_rd_en, wb_en, CtlToALU_data.op2_sel, decodedInstr.instrType, decodedInstr.rd_addr, CtlToALU_data.alu_fun, mem_en, CtlToALU_data.op1_sel, decodedInstr.imm, wb_sel, RegsToCtl_data.contents1, RegsToCtl_data.contents2, br_en)
	begin
		case active_state is
		when st_decode_1 =>
			--if (true) then 
				-- Operation: op_decode_1_read_0;
				active_assignment <= assign_0;
			--end if;
		when st_decode_2 =>
			if ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_1;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_2;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_3;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_4;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_5;
				active_assignment <= assign_2;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_6;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_7;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_8;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_9;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_10;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_11;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_12;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_13;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_14;
				active_assignment <= assign_3;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_15;
				active_assignment <= assign_4;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_16;
				active_assignment <= assign_5;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_17;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_18;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_19;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_20;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_21;
				active_assignment <= assign_2;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_22;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_23;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_24;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_25;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_26;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_27;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_28;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_29;
				active_assignment <= assign_6;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_30;
				active_assignment <= assign_7;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_31;
				active_assignment <= assign_8;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_32;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_33;
				active_assignment <= assign_10;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_34;
				active_assignment <= assign_11;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_35;
				active_assignment <= assign_12;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_36;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_37;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_38;
				active_assignment <= assign_13;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_39;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_40;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_41;
				active_assignment <= assign_3;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_42;
				active_assignment <= assign_4;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_43;
				active_assignment <= assign_5;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_44;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_45;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_46;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_47;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_48;
				active_assignment <= assign_2;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_49;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_50;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_51;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_52;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_53;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_54;
				active_assignment <= assign_14;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_55;
				active_assignment <= assign_15;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_56;
				active_assignment <= assign_16;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_57;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_58;
				active_assignment <= assign_17;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_59;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_60;
				active_assignment <= assign_18;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_61;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_62;
				active_assignment <= assign_20;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_63;
				active_assignment <= assign_18;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_64;
				active_assignment <= assign_21;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_65;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_66;
				active_assignment <= assign_6;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_67;
				active_assignment <= assign_7;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_68;
				active_assignment <= assign_8;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_69;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_70;
				active_assignment <= assign_10;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_71;
				active_assignment <= assign_11;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_72;
				active_assignment <= assign_12;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_73;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_74;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_75;
				active_assignment <= assign_13;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_76;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_77;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_78;
				active_assignment <= assign_3;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_79;
				active_assignment <= assign_4;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_80;
				active_assignment <= assign_5;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_81;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_82;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_83;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_84;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_85;
				active_assignment <= assign_22;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_86;
				active_assignment <= assign_23;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_87;
				active_assignment <= assign_24;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_88;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_89;
				active_assignment <= assign_25;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_90;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_91;
				active_assignment <= assign_26;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_92;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_93;
				active_assignment <= assign_27;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_94;
				active_assignment <= assign_28;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_95;
				active_assignment <= assign_29;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_96;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_97;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_98;
				active_assignment <= assign_31;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_99;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_100;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_101;
				active_assignment <= assign_14;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_102;
				active_assignment <= assign_15;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_103;
				active_assignment <= assign_16;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_104;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_105;
				active_assignment <= assign_17;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_106;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_107;
				active_assignment <= assign_18;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_108;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_109;
				active_assignment <= assign_20;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_110;
				active_assignment <= assign_18;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_111;
				active_assignment <= assign_21;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_112;
				active_assignment <= assign_19;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_113;
				active_assignment <= assign_6;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_114;
				active_assignment <= assign_7;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_115;
				active_assignment <= assign_8;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_116;
				active_assignment <= assign_9;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_117;
				active_assignment <= assign_10;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_118;
				active_assignment <= assign_11;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_119;
				active_assignment <= assign_12;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_120;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_121;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_122;
				active_assignment <= assign_13;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_123;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_124;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_data.contents2 <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_125;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_126;
				active_assignment <= assign_32;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_127;
				active_assignment <= assign_33;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_128;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_129;
				active_assignment <= assign_34;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_130;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_131;
				active_assignment <= assign_35;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_132;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_133;
				active_assignment <= assign_36;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_134;
				active_assignment <= assign_35;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_135;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_136;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_137;
				active_assignment <= assign_13;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_138;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_139;
				active_assignment <= assign_37;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_140;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_141;
				active_assignment <= assign_22;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_142;
				active_assignment <= assign_23;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_143;
				active_assignment <= assign_24;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_144;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_145;
				active_assignment <= assign_25;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_146;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_147;
				active_assignment <= assign_26;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_148;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_149;
				active_assignment <= assign_27;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_150;
				active_assignment <= assign_28;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_151;
				active_assignment <= assign_29;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_152;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_153;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_154;
				active_assignment <= assign_31;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_155;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_156;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_157;
				active_assignment <= assign_14;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_158;
				active_assignment <= assign_15;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_159;
				active_assignment <= assign_16;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_160;
				active_assignment <= assign_9;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_161;
				active_assignment <= assign_17;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_162;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_163;
				active_assignment <= assign_18;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_164;
				active_assignment <= assign_19;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_165;
				active_assignment <= assign_20;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_166;
				active_assignment <= assign_18;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_167;
				active_assignment <= assign_21;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_168;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_data.contents2 <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_169;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_data.contents2 <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_170;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and (DecToCtl_port_sig.imm <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_171;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_172;
				active_assignment <= assign_39;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_173;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_data.contents2 <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_174;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_175;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_176;
				active_assignment <= assign_40;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_177;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_178;
				active_assignment <= assign_41;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_179;
				active_assignment <= assign_40;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_180;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_181;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_182;
				active_assignment <= assign_13;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_183;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_184;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_185;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_data.contents2 <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_186;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_187;
				active_assignment <= assign_32;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_188;
				active_assignment <= assign_33;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_189;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_190;
				active_assignment <= assign_34;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_191;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_192;
				active_assignment <= assign_35;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_193;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_194;
				active_assignment <= assign_36;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_195;
				active_assignment <= assign_35;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_196;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_197;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_198;
				active_assignment <= assign_13;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_199;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_200;
				active_assignment <= assign_37;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_201;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_202;
				active_assignment <= assign_22;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_203;
				active_assignment <= assign_23;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_204;
				active_assignment <= assign_24;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_205;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_206;
				active_assignment <= assign_25;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_207;
				active_assignment <= assign_19;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_208;
				active_assignment <= assign_26;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_209;
				active_assignment <= assign_19;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_210;
				active_assignment <= assign_27;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_211;
				active_assignment <= assign_28;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_212;
				active_assignment <= assign_29;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_213;
				active_assignment <= assign_30;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_214;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_215;
				active_assignment <= assign_31;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_216;
				active_assignment <= assign_30;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_217;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_data.contents2 <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_218;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_219;
				active_assignment <= assign_42;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and not(DecToCtl_port_sig.imm <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_220;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and (DecToCtl_port_sig.imm <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_221;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and (pc_reg <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_222;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_223;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_data.contents2 <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_224;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_data.contents2 <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_225;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_226;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_227;
				active_assignment <= assign_43;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_228;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_data.contents2 <= pc_reg)) then 
				-- Operation: op_decode_2_read_229;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_230;
				active_assignment <= assign_43;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_231;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_232;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_data.contents2 = x"00000000")) then 
				-- Operation: op_decode_2_read_233;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_234;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_235;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_236;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_data.contents2 <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_237;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_data.contents2 <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_238;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and (DecToCtl_port_sig.imm <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_239;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_240;
				active_assignment <= assign_39;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_241;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_data.contents2 <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_242;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_243;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_244;
				active_assignment <= assign_40;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_245;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_246;
				active_assignment <= assign_41;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_247;
				active_assignment <= assign_40;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_248;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_249;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_250;
				active_assignment <= assign_13;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_251;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_252;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_253;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_254;
				active_assignment <= assign_44;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_data.contents2 <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_255;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_256;
				active_assignment <= assign_32;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_257;
				active_assignment <= assign_33;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_258;
				active_assignment <= assign_9;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_259;
				active_assignment <= assign_34;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_260;
				active_assignment <= assign_19;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_261;
				active_assignment <= assign_35;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_262;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_263;
				active_assignment <= assign_36;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_264;
				active_assignment <= assign_35;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_265;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_266;
				active_assignment <= assign_30;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_267;
				active_assignment <= assign_13;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_268;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_269;
				active_assignment <= assign_37;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_270;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_271;
				active_assignment <= assign_45;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(DecToCtl_port_sig.imm <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_272;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_273;
				active_assignment <= assign_46;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and not(pc_reg <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_274;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and (pc_reg <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_275;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_276;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_data.contents2 <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_277;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_278;
				active_assignment <= assign_47;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_279;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and (pc_reg <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_280;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_281;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_data.contents2 <= pc_reg)) then 
				-- Operation: op_decode_2_read_282;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_data.contents2 <= pc_reg)) then 
				-- Operation: op_decode_2_read_283;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and (DecToCtl_port_sig.imm <= pc_reg)) then 
				-- Operation: op_decode_2_read_284;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_285;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_286;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_data.contents2 = x"00000000")) then 
				-- Operation: op_decode_2_read_287;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_data.contents2 = x"00000000")) then 
				-- Operation: op_decode_2_read_288;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and (DecToCtl_port_sig.imm = x"00000000")) then 
				-- Operation: op_decode_2_read_289;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_290;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_291;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_data.contents2 <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_292;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_293;
				active_assignment <= assign_42;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and not(DecToCtl_port_sig.imm <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_294;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and (DecToCtl_port_sig.imm <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_295;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and (pc_reg <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_296;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_297;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_data.contents2 <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_298;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_data.contents2 <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_299;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_300;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_301;
				active_assignment <= assign_43;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_302;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_data.contents2 <= pc_reg)) then 
				-- Operation: op_decode_2_read_303;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_304;
				active_assignment <= assign_43;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_305;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_306;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_data.contents2 = x"00000000")) then 
				-- Operation: op_decode_2_read_307;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_308;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_309;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_310;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_311;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_312;
				active_assignment <= assign_44;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_data.contents2 <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_313;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_data.contents2 <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_314;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and (DecToCtl_port_sig.imm <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_315;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_316;
				active_assignment <= assign_39;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_317;
				active_assignment <= assign_9;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_data.contents2 <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_318;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_319;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_320;
				active_assignment <= assign_40;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_321;
				active_assignment <= assign_19;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_322;
				active_assignment <= assign_41;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_323;
				active_assignment <= assign_40;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_324;
				active_assignment <= assign_30;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_325;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_326;
				active_assignment <= assign_13;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_327;
				active_assignment <= assign_19;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_328;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_329;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_330;
				active_assignment <= assign_45;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_331;
				active_assignment <= assign_48;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(pc_reg <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_332;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_333;
				active_assignment <= assign_49;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_334;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_335;
				active_assignment <= assign_50;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_336;
				active_assignment <= assign_51;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and not(pc_reg <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_337;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and (pc_reg <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_338;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_339;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_data.contents2 <= pc_reg)) then 
				-- Operation: op_decode_2_read_340;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_341;
				active_assignment <= assign_52;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and not(DecToCtl_port_sig.imm <= pc_reg)) then 
				-- Operation: op_decode_2_read_342;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and (DecToCtl_port_sig.imm <= pc_reg)) then 
				-- Operation: op_decode_2_read_343;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_344;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_345;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_data.contents2 = x"00000000")) then 
				-- Operation: op_decode_2_read_346;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_347;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and not(DecToCtl_port_sig.imm = x"00000000")) then 
				-- Operation: op_decode_2_read_348;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and (DecToCtl_port_sig.imm = x"00000000")) then 
				-- Operation: op_decode_2_read_349;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and (pc_reg = x"00000000")) then 
				-- Operation: op_decode_2_read_350;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_351;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_352;
				active_assignment <= assign_45;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(DecToCtl_port_sig.imm <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_353;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_354;
				active_assignment <= assign_46;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and not(pc_reg <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_355;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and (pc_reg <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_356;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_357;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_data.contents2 <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_358;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_359;
				active_assignment <= assign_47;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_360;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and (pc_reg <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_361;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_362;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_data.contents2 <= pc_reg)) then 
				-- Operation: op_decode_2_read_363;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_data.contents2 <= pc_reg)) then 
				-- Operation: op_decode_2_read_364;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and (DecToCtl_port_sig.imm <= pc_reg)) then 
				-- Operation: op_decode_2_read_365;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_366;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_367;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_data.contents2 = x"00000000")) then 
				-- Operation: op_decode_2_read_368;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_data.contents2 = x"00000000")) then 
				-- Operation: op_decode_2_read_369;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and (DecToCtl_port_sig.imm = x"00000000")) then 
				-- Operation: op_decode_2_read_370;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_371;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_372;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_373;
				active_assignment <= assign_53;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_374;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_375;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_376;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_377;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_378;
				active_assignment <= assign_44;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_data.contents2 <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_379;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_380;
				active_assignment <= assign_42;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and not(DecToCtl_port_sig.imm <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_381;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and (DecToCtl_port_sig.imm <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_382;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and (pc_reg <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_383;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_384;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_data.contents2 <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_385;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_data.contents2 <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_386;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_387;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_388;
				active_assignment <= assign_43;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_389;
				active_assignment <= assign_19;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_data.contents2 <= pc_reg)) then 
				-- Operation: op_decode_2_read_390;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_391;
				active_assignment <= assign_43;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_392;
				active_assignment <= assign_30;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_393;
				active_assignment <= assign_30;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_data.contents2 = x"00000000")) then 
				-- Operation: op_decode_2_read_394;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_395;
				active_assignment <= assign_19;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_396;
				active_assignment <= assign_30;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_397;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_398;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_399;
				active_assignment <= assign_48;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_400;
				active_assignment <= assign_54;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_401;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_402;
				active_assignment <= assign_50;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_403;
				active_assignment <= assign_55;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(pc_reg <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_404;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_405;
				active_assignment <= assign_56;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_406;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_407;
				active_assignment <= assign_57;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(DecToCtl_port_sig.imm <= pc_reg)) then 
				-- Operation: op_decode_2_read_408;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_409;
				active_assignment <= assign_58;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_410;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_411;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_412;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(DecToCtl_port_sig.imm = x"00000000")) then 
				-- Operation: op_decode_2_read_413;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_414;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and not(pc_reg = x"00000000")) then 
				-- Operation: op_decode_2_read_415;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and (pc_reg = x"00000000")) then 
				-- Operation: op_decode_2_read_416;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_417;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_418;
				active_assignment <= assign_45;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_419;
				active_assignment <= assign_48;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(pc_reg <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_420;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_421;
				active_assignment <= assign_49;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_422;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_423;
				active_assignment <= assign_50;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_424;
				active_assignment <= assign_51;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and not(pc_reg <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_425;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and (pc_reg <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_426;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_427;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_data.contents2 <= pc_reg)) then 
				-- Operation: op_decode_2_read_428;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_429;
				active_assignment <= assign_52;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and not(DecToCtl_port_sig.imm <= pc_reg)) then 
				-- Operation: op_decode_2_read_430;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and (DecToCtl_port_sig.imm <= pc_reg)) then 
				-- Operation: op_decode_2_read_431;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_432;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_433;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_data.contents2 = x"00000000")) then 
				-- Operation: op_decode_2_read_434;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_435;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and not(DecToCtl_port_sig.imm = x"00000000")) then 
				-- Operation: op_decode_2_read_436;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and (DecToCtl_port_sig.imm = x"00000000")) then 
				-- Operation: op_decode_2_read_437;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and (pc_reg = x"00000000")) then 
				-- Operation: op_decode_2_read_438;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_439;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_440;
				active_assignment <= assign_59;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_441;
				active_assignment <= assign_60;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_442;
				active_assignment <= assign_61;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_443;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_444;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_445;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_446;
				active_assignment <= assign_44;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_447;
				active_assignment <= assign_45;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(DecToCtl_port_sig.imm <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_448;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_449;
				active_assignment <= assign_46;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and not(pc_reg <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_450;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and (pc_reg <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_451;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_452;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_data.contents2 <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_453;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_454;
				active_assignment <= assign_47;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_455;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and (pc_reg <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_456;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_457;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_data.contents2 <= pc_reg)) then 
				-- Operation: op_decode_2_read_458;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_data.contents2 <= pc_reg)) then 
				-- Operation: op_decode_2_read_459;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and (DecToCtl_port_sig.imm <= pc_reg)) then 
				-- Operation: op_decode_2_read_460;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_461;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_462;
				active_assignment <= assign_30;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_data.contents2 = x"00000000")) then 
				-- Operation: op_decode_2_read_463;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_data.contents2 = x"00000000")) then 
				-- Operation: op_decode_2_read_464;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and (DecToCtl_port_sig.imm = x"00000000")) then 
				-- Operation: op_decode_2_read_465;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_466;
				active_assignment <= assign_30;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_467;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_468;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_469;
				active_assignment <= assign_54;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_470;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_471;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_472;
				active_assignment <= assign_55;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_473;
				active_assignment <= assign_62;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_474;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_475;
				active_assignment <= assign_57;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_476;
				active_assignment <= assign_63;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_477;
				active_assignment <= assign_64;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_478;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_479;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_480;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(pc_reg = x"00000000")) then 
				-- Operation: op_decode_2_read_481;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_482;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_483;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and (DecToCtl_port_sig.instrType = jal)) then 
				-- Operation: op_decode_2_read_484;
				active_assignment <= assign_65;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_485;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_486;
				active_assignment <= assign_48;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_487;
				active_assignment <= assign_54;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_488;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_489;
				active_assignment <= assign_50;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_490;
				active_assignment <= assign_55;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(pc_reg <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_491;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_492;
				active_assignment <= assign_56;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_493;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_494;
				active_assignment <= assign_57;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(DecToCtl_port_sig.imm <= pc_reg)) then 
				-- Operation: op_decode_2_read_495;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_496;
				active_assignment <= assign_58;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_497;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_498;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_499;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(DecToCtl_port_sig.imm = x"00000000")) then 
				-- Operation: op_decode_2_read_500;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_501;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and not(pc_reg = x"00000000")) then 
				-- Operation: op_decode_2_read_502;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and (pc_reg = x"00000000")) then 
				-- Operation: op_decode_2_read_503;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_504;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_505;
				active_assignment <= assign_66;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_506;
				active_assignment <= assign_67;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_507;
				active_assignment <= assign_68;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_508;
				active_assignment <= assign_69;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_509;
				active_assignment <= assign_70;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_510;
				active_assignment <= assign_71;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_511;
				active_assignment <= assign_72;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_512;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_513;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_514;
				active_assignment <= assign_73;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_515;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_decode_2_read_516;
				active_assignment <= assign_44;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_517;
				active_assignment <= assign_45;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_518;
				active_assignment <= assign_48;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(pc_reg <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_519;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_520;
				active_assignment <= assign_49;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_521;
				active_assignment <= assign_9;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_522;
				active_assignment <= assign_50;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_523;
				active_assignment <= assign_51;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and not(pc_reg <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_524;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and (pc_reg <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_525;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_526;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_data.contents2 <= pc_reg)) then 
				-- Operation: op_decode_2_read_527;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_528;
				active_assignment <= assign_52;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and not(DecToCtl_port_sig.imm <= pc_reg)) then 
				-- Operation: op_decode_2_read_529;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and (DecToCtl_port_sig.imm <= pc_reg)) then 
				-- Operation: op_decode_2_read_530;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_531;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_532;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_data.contents2 = x"00000000")) then 
				-- Operation: op_decode_2_read_533;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_534;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and not(DecToCtl_port_sig.imm = x"00000000")) then 
				-- Operation: op_decode_2_read_535;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and (DecToCtl_port_sig.imm = x"00000000")) then 
				-- Operation: op_decode_2_read_536;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and (pc_reg = x"00000000")) then 
				-- Operation: op_decode_2_read_537;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_538;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_539;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_540;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_541;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_542;
				active_assignment <= assign_62;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_543;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_544;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_545;
				active_assignment <= assign_63;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_546;
				active_assignment <= assign_74;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_547;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_548;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_549;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_550;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_551;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_552;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_553;
				active_assignment <= assign_54;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_554;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_555;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_556;
				active_assignment <= assign_55;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_557;
				active_assignment <= assign_62;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_558;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_559;
				active_assignment <= assign_57;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_560;
				active_assignment <= assign_63;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_561;
				active_assignment <= assign_64;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_562;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_563;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_564;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(pc_reg = x"00000000")) then 
				-- Operation: op_decode_2_read_565;
				active_assignment <= assign_38;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_566;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_567;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_568;
				active_assignment <= assign_75;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_569;
				active_assignment <= assign_76;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_570;
				active_assignment <= assign_77;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_571;
				active_assignment <= assign_69;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_572;
				active_assignment <= assign_78;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_573;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_574;
				active_assignment <= assign_79;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_575;
				active_assignment <= assign_80;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_576;
				active_assignment <= assign_81;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_577;
				active_assignment <= assign_79;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_578;
				active_assignment <= assign_82;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_579;
				active_assignment <= assign_80;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_580;
				active_assignment <= assign_9;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_581;
				active_assignment <= assign_48;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_582;
				active_assignment <= assign_54;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_583;
				active_assignment <= assign_9;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_584;
				active_assignment <= assign_50;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_585;
				active_assignment <= assign_55;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(pc_reg <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_586;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_587;
				active_assignment <= assign_56;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_588;
				active_assignment <= assign_19;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_589;
				active_assignment <= assign_57;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(DecToCtl_port_sig.imm <= pc_reg)) then 
				-- Operation: op_decode_2_read_590;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_591;
				active_assignment <= assign_58;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_592;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_593;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_594;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(DecToCtl_port_sig.imm = x"00000000")) then 
				-- Operation: op_decode_2_read_595;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_596;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and not(pc_reg = x"00000000")) then 
				-- Operation: op_decode_2_read_597;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and (pc_reg = x"00000000")) then 
				-- Operation: op_decode_2_read_598;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_599;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_600;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_601;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_602;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_603;
				active_assignment <= assign_74;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_604;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_605;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_606;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_607;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_608;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_609;
				active_assignment <= assign_9;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_610;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_611;
				active_assignment <= assign_62;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_612;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_613;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_614;
				active_assignment <= assign_63;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_615;
				active_assignment <= assign_74;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_616;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_617;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_618;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_619;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_620;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_621;
				active_assignment <= assign_83;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_622;
				active_assignment <= assign_84;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_623;
				active_assignment <= assign_85;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_624;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_625;
				active_assignment <= assign_86;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_626;
				active_assignment <= assign_80;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_627;
				active_assignment <= assign_87;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_628;
				active_assignment <= assign_80;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_629;
				active_assignment <= assign_88;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_630;
				active_assignment <= assign_89;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_631;
				active_assignment <= assign_90;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_632;
				active_assignment <= assign_91;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_633;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_634;
				active_assignment <= assign_92;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_635;
				active_assignment <= assign_91;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_decode_2_read_636;
				active_assignment <= assign_44;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_637;
				active_assignment <= assign_9;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_638;
				active_assignment <= assign_54;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_639;
				active_assignment <= assign_9;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_640;
				active_assignment <= assign_19;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_641;
				active_assignment <= assign_55;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_642;
				active_assignment <= assign_62;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_643;
				active_assignment <= assign_19;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_644;
				active_assignment <= assign_57;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_645;
				active_assignment <= assign_63;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_646;
				active_assignment <= assign_64;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_647;
				active_assignment <= assign_30;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_648;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_649;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(pc_reg = x"00000000")) then 
				-- Operation: op_decode_2_read_650;
				active_assignment <= assign_38;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_651;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_652;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_653;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_654;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_655;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_656;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_657;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_658;
				active_assignment <= assign_19;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_659;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_660;
				active_assignment <= assign_74;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_661;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_662;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_663;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_664;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_data.contents2 <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_665;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_666;
				active_assignment <= assign_93;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_667;
				active_assignment <= assign_94;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_668;
				active_assignment <= assign_69;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_669;
				active_assignment <= assign_95;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_670;
				active_assignment <= assign_80;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_671;
				active_assignment <= assign_96;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_672;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_673;
				active_assignment <= assign_97;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_674;
				active_assignment <= assign_96;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_675;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_676;
				active_assignment <= assign_91;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_677;
				active_assignment <= assign_73;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_678;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_679;
				active_assignment <= assign_98;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_decode_2_read_680;
				active_assignment <= assign_44;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_681;
				active_assignment <= assign_9;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_682;
				active_assignment <= assign_9;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_683;
				active_assignment <= assign_19;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_684;
				active_assignment <= assign_62;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_685;
				active_assignment <= assign_19;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_686;
				active_assignment <= assign_30;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_687;
				active_assignment <= assign_63;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_688;
				active_assignment <= assign_74;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_689;
				active_assignment <= assign_30;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_690;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_691;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_692;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_693;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_694;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_695;
				active_assignment <= assign_30;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_696;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_697;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = U) and (DecToCtl_port_sig.instrType = auipc)) then 
				-- Operation: op_decode_2_read_698;
				active_assignment <= assign_99;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_data.contents2 <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_699;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_data.contents2 <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_700;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and (DecToCtl_port_sig.imm <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_701;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_702;
				active_assignment <= assign_101;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_703;
				active_assignment <= assign_69;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_data.contents2 <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_704;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_705;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_706;
				active_assignment <= assign_102;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_707;
				active_assignment <= assign_80;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_708;
				active_assignment <= assign_103;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_709;
				active_assignment <= assign_102;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_710;
				active_assignment <= assign_91;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_711;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_712;
				active_assignment <= assign_73;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_713;
				active_assignment <= assign_80;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_714;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_decode_2_read_715;
				active_assignment <= assign_44;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_716;
				active_assignment <= assign_19;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_717;
				active_assignment <= assign_19;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_718;
				active_assignment <= assign_30;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_719;
				active_assignment <= assign_74;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_720;
				active_assignment <= assign_30;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_721;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_722;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_723;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_data.contents2 <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_724;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_725;
				active_assignment <= assign_104;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and not(DecToCtl_port_sig.imm <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_726;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and (DecToCtl_port_sig.imm <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_727;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and (pc_reg <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_728;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_729;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_data.contents2 <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_730;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_data.contents2 <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_731;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_732;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_733;
				active_assignment <= assign_105;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_734;
				active_assignment <= assign_80;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_data.contents2 <= pc_reg)) then 
				-- Operation: op_decode_2_read_735;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_736;
				active_assignment <= assign_105;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_737;
				active_assignment <= assign_91;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_738;
				active_assignment <= assign_91;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_data.contents2 = x"00000000")) then 
				-- Operation: op_decode_2_read_739;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_740;
				active_assignment <= assign_80;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_741;
				active_assignment <= assign_91;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_decode_2_read_742;
				active_assignment <= assign_44;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_743;
				active_assignment <= assign_30;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_744;
				active_assignment <= assign_30;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_745;
				active_assignment <= assign_1;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and not(reg_rd_en) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_746;
				active_assignment <= assign_1;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_747;
				active_assignment <= assign_106;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(DecToCtl_port_sig.imm <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_748;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_749;
				active_assignment <= assign_107;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and not(pc_reg <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_750;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and (pc_reg <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_751;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_752;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_data.contents2 <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_753;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_754;
				active_assignment <= assign_108;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_755;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and (pc_reg <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_756;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_757;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_data.contents2 <= pc_reg)) then 
				-- Operation: op_decode_2_read_758;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_data.contents2 <= pc_reg)) then 
				-- Operation: op_decode_2_read_759;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and (DecToCtl_port_sig.imm <= pc_reg)) then 
				-- Operation: op_decode_2_read_760;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_761;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_762;
				active_assignment <= assign_91;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_data.contents2 = x"00000000")) then 
				-- Operation: op_decode_2_read_763;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_data.contents2 = x"00000000")) then 
				-- Operation: op_decode_2_read_764;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and (DecToCtl_port_sig.imm = x"00000000")) then 
				-- Operation: op_decode_2_read_765;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_766;
				active_assignment <= assign_91;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_decode_2_read_767;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_768;
				active_assignment <= assign_106;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_769;
				active_assignment <= assign_109;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(pc_reg <= RegsToCtl_data.contents1)) then 
				-- Operation: op_decode_2_read_770;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_771;
				active_assignment <= assign_110;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_772;
				active_assignment <= assign_69;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_773;
				active_assignment <= assign_111;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_774;
				active_assignment <= assign_112;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and not(pc_reg <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_775;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and (pc_reg <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_776;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_777;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_data.contents2 <= pc_reg)) then 
				-- Operation: op_decode_2_read_778;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_779;
				active_assignment <= assign_113;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and not(DecToCtl_port_sig.imm <= pc_reg)) then 
				-- Operation: op_decode_2_read_780;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and (DecToCtl_port_sig.imm <= pc_reg)) then 
				-- Operation: op_decode_2_read_781;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_782;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_783;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_data.contents2 = x"00000000")) then 
				-- Operation: op_decode_2_read_784;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_785;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and not(DecToCtl_port_sig.imm = x"00000000")) then 
				-- Operation: op_decode_2_read_786;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and (DecToCtl_port_sig.imm = x"00000000")) then 
				-- Operation: op_decode_2_read_787;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and (pc_reg = x"00000000")) then 
				-- Operation: op_decode_2_read_788;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_decode_2_read_789;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_790;
				active_assignment <= assign_69;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_791;
				active_assignment <= assign_109;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_792;
				active_assignment <= assign_114;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_793;
				active_assignment <= assign_69;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_794;
				active_assignment <= assign_111;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_795;
				active_assignment <= assign_115;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(pc_reg <= DecToCtl_port_sig.imm)) then 
				-- Operation: op_decode_2_read_796;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_797;
				active_assignment <= assign_116;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_798;
				active_assignment <= assign_80;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_799;
				active_assignment <= assign_117;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(DecToCtl_port_sig.imm <= pc_reg)) then 
				-- Operation: op_decode_2_read_800;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_801;
				active_assignment <= assign_118;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_802;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_803;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_804;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(DecToCtl_port_sig.imm = x"00000000")) then 
				-- Operation: op_decode_2_read_805;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_806;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and not(pc_reg = x"00000000")) then 
				-- Operation: op_decode_2_read_807;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and (pc_reg = x"00000000")) then 
				-- Operation: op_decode_2_read_808;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_decode_2_read_809;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_810;
				active_assignment <= assign_69;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_811;
				active_assignment <= assign_114;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_812;
				active_assignment <= assign_69;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_813;
				active_assignment <= assign_80;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_814;
				active_assignment <= assign_115;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_815;
				active_assignment <= assign_119;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_816;
				active_assignment <= assign_80;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_817;
				active_assignment <= assign_117;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_818;
				active_assignment <= assign_120;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_819;
				active_assignment <= assign_121;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_820;
				active_assignment <= assign_91;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_821;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_822;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(pc_reg = x"00000000")) then 
				-- Operation: op_decode_2_read_823;
				active_assignment <= assign_100;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_824;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_decode_2_read_825;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_826;
				active_assignment <= assign_69;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_827;
				active_assignment <= assign_69;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_828;
				active_assignment <= assign_80;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_829;
				active_assignment <= assign_119;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_830;
				active_assignment <= assign_80;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_831;
				active_assignment <= assign_91;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_832;
				active_assignment <= assign_120;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_833;
				active_assignment <= assign_122;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_834;
				active_assignment <= assign_91;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_835;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_836;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_837;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_decode_2_read_838;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_839;
				active_assignment <= assign_80;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_840;
				active_assignment <= assign_80;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_841;
				active_assignment <= assign_91;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_842;
				active_assignment <= assign_122;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_843;
				active_assignment <= assign_91;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_844;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_845;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_decode_2_read_846;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_847;
				active_assignment <= assign_91;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and (CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_848;
				active_assignment <= assign_91;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_849;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and not(DecToCtl_port_sig.instrType = lui) and not(DecToCtl_port_sig.instrType = auipc) and not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_decode_2_read_850;
				active_assignment <= assign_44;
			elsif ((DecToCtl_port_sig.encType = U) and (DecToCtl_port_sig.instrType = lui)) then 
				-- Operation: op_decode_2_read_851;
				active_assignment <= assign_123;
			elsif ((DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.instrType = addI) and not(DecToCtl_port_sig.instrType = sltI) and not(DecToCtl_port_sig.instrType = sltIu) and not(DecToCtl_port_sig.instrType = xorI) and not(DecToCtl_port_sig.instrType = orI) and not(DecToCtl_port_sig.instrType = andI) and not(DecToCtl_port_sig.instrType = sllI) and not(DecToCtl_port_sig.instrType = srlI) and not(DecToCtl_port_sig.instrType = sraI) and not(DecToCtl_port_sig.instrType = lb) and not(DecToCtl_port_sig.instrType = lh) and not(DecToCtl_port_sig.instrType = lw) and not(DecToCtl_port_sig.instrType = lbu) and not(DecToCtl_port_sig.instrType = lhu) and not(DecToCtl_port_sig.instrType = jalr) and reg_rd_en) then 
				-- Operation: op_decode_2_read_852;
				active_assignment <= assign_124;
			elsif ((DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.instrType = jal) and reg_rd_en) then 
				-- Operation: op_decode_2_read_853;
				active_assignment <= assign_124;
			elsif (not(DecToCtl_port_sig.encType = I) and not(DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.encType = J) and not(DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.encType = U) and reg_rd_en) then 
				-- Operation: op_decode_2_read_854;
				active_assignment <= assign_124;
			elsif ((DecToCtl_port_sig.encType = I) and (DecToCtl_port_sig.instrType = addI)) then 
				-- Operation: op_decode_2_read_855;
				active_assignment <= assign_125;
			elsif ((DecToCtl_port_sig.encType = R) and (DecToCtl_port_sig.instrType = add)) then 
				-- Operation: op_decode_2_read_856;
				active_assignment <= assign_126;
			elsif ((DecToCtl_port_sig.encType = I) and (DecToCtl_port_sig.instrType = sltI)) then 
				-- Operation: op_decode_2_read_857;
				active_assignment <= assign_127;
			elsif ((DecToCtl_port_sig.encType = I) and (DecToCtl_port_sig.instrType = jalr)) then 
				-- Operation: op_decode_2_read_858;
				active_assignment <= assign_128;
			elsif ((DecToCtl_port_sig.encType = R) and (DecToCtl_port_sig.instrType = sub)) then 
				-- Operation: op_decode_2_read_859;
				active_assignment <= assign_129;
			elsif ((DecToCtl_port_sig.encType = B) and (DecToCtl_port_sig.instrType = beq)) then 
				-- Operation: op_decode_2_read_860;
				active_assignment <= assign_130;
			elsif ((DecToCtl_port_sig.encType = I) and (DecToCtl_port_sig.instrType = sltIu)) then 
				-- Operation: op_decode_2_read_861;
				active_assignment <= assign_131;
			elsif ((DecToCtl_port_sig.encType = R) and (DecToCtl_port_sig.instrType = sll_Instr)) then 
				-- Operation: op_decode_2_read_862;
				active_assignment <= assign_132;
			elsif ((DecToCtl_port_sig.encType = B) and (DecToCtl_port_sig.instrType = bne)) then 
				-- Operation: op_decode_2_read_863;
				active_assignment <= assign_130;
			elsif ((DecToCtl_port_sig.encType = I) and (DecToCtl_port_sig.instrType = xorI)) then 
				-- Operation: op_decode_2_read_864;
				active_assignment <= assign_133;
			elsif ((DecToCtl_port_sig.encType = I) and (DecToCtl_port_sig.instrType = lb)) then 
				-- Operation: op_decode_2_read_865;
				active_assignment <= assign_134;
			elsif ((DecToCtl_port_sig.encType = R) and (DecToCtl_port_sig.instrType = slt)) then 
				-- Operation: op_decode_2_read_866;
				active_assignment <= assign_135;
			elsif ((DecToCtl_port_sig.encType = B) and (DecToCtl_port_sig.instrType = blt)) then 
				-- Operation: op_decode_2_read_867;
				active_assignment <= assign_136;
			elsif ((DecToCtl_port_sig.encType = I) and (DecToCtl_port_sig.instrType = orI)) then 
				-- Operation: op_decode_2_read_868;
				active_assignment <= assign_137;
			elsif ((DecToCtl_port_sig.encType = I) and (DecToCtl_port_sig.instrType = lh)) then 
				-- Operation: op_decode_2_read_869;
				active_assignment <= assign_138;
			elsif ((DecToCtl_port_sig.encType = R) and (DecToCtl_port_sig.instrType = sltu)) then 
				-- Operation: op_decode_2_read_870;
				active_assignment <= assign_139;
			elsif ((DecToCtl_port_sig.encType = B) and (DecToCtl_port_sig.instrType = bge)) then 
				-- Operation: op_decode_2_read_871;
				active_assignment <= assign_136;
			elsif ((DecToCtl_port_sig.encType = I) and (DecToCtl_port_sig.instrType = andI)) then 
				-- Operation: op_decode_2_read_872;
				active_assignment <= assign_140;
			elsif ((DecToCtl_port_sig.encType = I) and (DecToCtl_port_sig.instrType = lw)) then 
				-- Operation: op_decode_2_read_873;
				active_assignment <= assign_141;
			elsif ((DecToCtl_port_sig.encType = R) and (DecToCtl_port_sig.instrType = Xor_Instr)) then 
				-- Operation: op_decode_2_read_874;
				active_assignment <= assign_142;
			elsif ((DecToCtl_port_sig.encType = B) and (DecToCtl_port_sig.instrType = bltu)) then 
				-- Operation: op_decode_2_read_875;
				active_assignment <= assign_143;
			elsif ((DecToCtl_port_sig.encType = B) and not(DecToCtl_port_sig.instrType = beq) and not(DecToCtl_port_sig.instrType = bne) and not(DecToCtl_port_sig.instrType = blt) and not(DecToCtl_port_sig.instrType = bge) and not(DecToCtl_port_sig.instrType = bltu) and not(DecToCtl_port_sig.instrType = bgeu)) then 
				-- Operation: op_decode_2_read_876;
				active_assignment <= assign_144;
			elsif ((DecToCtl_port_sig.encType = S) and (DecToCtl_port_sig.instrType = sb)) then 
				-- Operation: op_decode_2_read_877;
				active_assignment <= assign_145;
			elsif ((DecToCtl_port_sig.encType = I) and (DecToCtl_port_sig.instrType = sllI)) then 
				-- Operation: op_decode_2_read_878;
				active_assignment <= assign_146;
			elsif ((DecToCtl_port_sig.encType = I) and (DecToCtl_port_sig.instrType = lbu)) then 
				-- Operation: op_decode_2_read_879;
				active_assignment <= assign_147;
			elsif ((DecToCtl_port_sig.encType = R) and (DecToCtl_port_sig.instrType = srl_Instr)) then 
				-- Operation: op_decode_2_read_880;
				active_assignment <= assign_148;
			elsif ((DecToCtl_port_sig.encType = B) and (DecToCtl_port_sig.instrType = bgeu)) then 
				-- Operation: op_decode_2_read_881;
				active_assignment <= assign_143;
			elsif ((DecToCtl_port_sig.encType = S) and (DecToCtl_port_sig.instrType = sh)) then 
				-- Operation: op_decode_2_read_882;
				active_assignment <= assign_149;
			elsif ((DecToCtl_port_sig.encType = S) and not(DecToCtl_port_sig.instrType = sb) and not(DecToCtl_port_sig.instrType = sh) and not(DecToCtl_port_sig.instrType = sw)) then 
				-- Operation: op_decode_2_read_883;
				active_assignment <= assign_150;
			elsif ((DecToCtl_port_sig.encType = I) and (DecToCtl_port_sig.instrType = srlI)) then 
				-- Operation: op_decode_2_read_884;
				active_assignment <= assign_151;
			elsif ((DecToCtl_port_sig.encType = I) and (DecToCtl_port_sig.instrType = lhu)) then 
				-- Operation: op_decode_2_read_885;
				active_assignment <= assign_152;
			elsif ((DecToCtl_port_sig.encType = R) and (DecToCtl_port_sig.instrType = sra_Instr)) then 
				-- Operation: op_decode_2_read_886;
				active_assignment <= assign_153;
			elsif ((DecToCtl_port_sig.encType = S) and (DecToCtl_port_sig.instrType = sw)) then 
				-- Operation: op_decode_2_read_887;
				active_assignment <= assign_154;
			elsif ((DecToCtl_port_sig.encType = I) and (DecToCtl_port_sig.instrType = sraI)) then 
				-- Operation: op_decode_2_read_888;
				active_assignment <= assign_155;
			elsif ((DecToCtl_port_sig.encType = R) and (DecToCtl_port_sig.instrType = Or_Instr)) then 
				-- Operation: op_decode_2_read_889;
				active_assignment <= assign_156;
			elsif ((DecToCtl_port_sig.encType = R) and not(DecToCtl_port_sig.instrType = add) and not(DecToCtl_port_sig.instrType = sub) and not(DecToCtl_port_sig.instrType = sll_Instr) and not(DecToCtl_port_sig.instrType = slt) and not(DecToCtl_port_sig.instrType = sltu) and not(DecToCtl_port_sig.instrType = Xor_Instr) and not(DecToCtl_port_sig.instrType = srl_Instr) and not(DecToCtl_port_sig.instrType = sra_Instr) and not(DecToCtl_port_sig.instrType = Or_Instr) and not(DecToCtl_port_sig.instrType = And_Instr)) then 
				-- Operation: op_decode_2_read_890;
				active_assignment <= assign_157;
			else--if((DecToCtl_port_sig.encType = R) and (DecToCtl_port_sig.instrType = And_Instr)) then 
				-- Operation: op_decode_2_read_891;
				active_assignment <= assign_158;
			end if;
		when st_executeALU_4 =>
			--if (true) then 
				-- Operation: op_executeALU_4_read_892;
				active_assignment <= assign_159;
			--end if;
		when st_executeALU_5 =>
			if (not(br_en) and not(decodedInstr.instrType = jal) and not(decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_ALU) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_893;
				active_assignment <= assign_160;
			elsif (not(br_en) and not(decodedInstr.instrType = jal) and not(decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_MEM) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_894;
				active_assignment <= assign_160;
			elsif (not(br_en) and not(decodedInstr.instrType = jal) and not(decodedInstr.instrType = jalr) and not(mem_en) and not(wb_sel = WB_ALU) and not(wb_sel = WB_MEM) and not(wb_sel = WB_PC4)) then 
				-- Operation: op_executeALU_5_read_895;
				active_assignment <= assign_160;
			elsif (not(br_en) and (decodedInstr.instrType = jal) and not(mem_en) and (wb_sel = WB_ALU) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_896;
				active_assignment <= assign_161;
			elsif (not(br_en) and not(decodedInstr.instrType = jal) and not(decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_PC4) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_897;
				active_assignment <= assign_160;
			elsif (br_en and (decodedInstr.instrType = beq) and not(mem_en) and (wb_sel = WB_ALU) and not(wb_en and not(decodedInstr.rd_addr = x"00000000")) and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_898;
				active_assignment <= assign_161;
			elsif (not(br_en) and (decodedInstr.instrType = jal) and not(mem_en) and (wb_sel = WB_MEM) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_899;
				active_assignment <= assign_161;
			elsif (not(br_en) and (decodedInstr.instrType = jal) and not(mem_en) and not(wb_sel = WB_ALU) and not(wb_sel = WB_MEM) and not(wb_sel = WB_PC4)) then 
				-- Operation: op_executeALU_5_read_900;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = beq) and not(mem_en) and (wb_sel = WB_MEM) and not(wb_en and not(decodedInstr.rd_addr = x"00000000")) and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_901;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = beq) and not(mem_en) and not(wb_sel = WB_ALU) and not(wb_sel = WB_MEM) and not(wb_sel = WB_PC4) and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_902;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = bne) and not(ALUtoCtl_data.ALU_result = x"00000000") and not(mem_en) and (wb_sel = WB_ALU) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_903;
				active_assignment <= assign_161;
			elsif (not(br_en) and (decodedInstr.instrType = jal) and not(mem_en) and (wb_sel = WB_PC4) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_904;
				active_assignment <= assign_161;
			elsif (not(br_en) and (decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_ALU) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_905;
				active_assignment <= assign_162;
			elsif (br_en and (decodedInstr.instrType = beq) and not(mem_en) and (wb_sel = WB_PC4) and not(wb_en and not(decodedInstr.rd_addr = x"00000000")) and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_906;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = bne) and not(ALUtoCtl_data.ALU_result = x"00000000") and not(mem_en) and (wb_sel = WB_MEM) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_907;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = bne) and not(ALUtoCtl_data.ALU_result = x"00000000") and not(mem_en) and not(wb_sel = WB_ALU) and not(wb_sel = WB_MEM) and not(wb_sel = WB_PC4)) then 
				-- Operation: op_executeALU_5_read_908;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = blt) and not(mem_en) and (wb_sel = WB_ALU) and not(wb_en and not(decodedInstr.rd_addr = x"00000000")) and (ALUtoCtl_data.ALU_result = x"00000001")) then 
				-- Operation: op_executeALU_5_read_909;
				active_assignment <= assign_161;
			elsif (not(br_en) and (decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_MEM) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_910;
				active_assignment <= assign_162;
			elsif (not(br_en) and (decodedInstr.instrType = jalr) and not(mem_en) and not(wb_sel = WB_ALU) and not(wb_sel = WB_MEM) and not(wb_sel = WB_PC4)) then 
				-- Operation: op_executeALU_5_read_911;
				active_assignment <= assign_162;
			elsif (br_en and (decodedInstr.instrType = bne) and not(ALUtoCtl_data.ALU_result = x"00000000") and not(mem_en) and (wb_sel = WB_PC4) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_912;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = blt) and not(mem_en) and (wb_sel = WB_MEM) and not(wb_en and not(decodedInstr.rd_addr = x"00000000")) and (ALUtoCtl_data.ALU_result = x"00000001")) then 
				-- Operation: op_executeALU_5_read_913;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = blt) and not(mem_en) and not(wb_sel = WB_ALU) and not(wb_sel = WB_MEM) and not(wb_sel = WB_PC4) and (ALUtoCtl_data.ALU_result = x"00000001")) then 
				-- Operation: op_executeALU_5_read_914;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = bge) and not(mem_en) and (wb_sel = WB_ALU) and not(wb_en and not(decodedInstr.rd_addr = x"00000000")) and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_915;
				active_assignment <= assign_161;
			elsif (br_en and not((decodedInstr.instrType = beq) and (ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = bne) and not(ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = blt) and (ALUtoCtl_data.ALU_result = x"00000001")) and not((decodedInstr.instrType = bge) and (ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = bltu) and (ALUtoCtl_data.ALU_result = x"00000001")) and not((decodedInstr.instrType = bgeu) and (ALUtoCtl_data.ALU_result = x"00000000")) and not(decodedInstr.instrType = jal) and not(decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_ALU) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_916;
				active_assignment <= assign_160;
			elsif (not(br_en) and (decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_PC4) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_917;
				active_assignment <= assign_162;
			elsif (br_en and (decodedInstr.instrType = blt) and not(mem_en) and (wb_sel = WB_PC4) and not(wb_en and not(decodedInstr.rd_addr = x"00000000")) and (ALUtoCtl_data.ALU_result = x"00000001")) then 
				-- Operation: op_executeALU_5_read_918;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = bge) and not(mem_en) and (wb_sel = WB_MEM) and not(wb_en and not(decodedInstr.rd_addr = x"00000000")) and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_919;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = bge) and not(mem_en) and not(wb_sel = WB_ALU) and not(wb_sel = WB_MEM) and not(wb_sel = WB_PC4) and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_920;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = bltu) and not(mem_en) and (wb_sel = WB_ALU) and not(wb_en and not(decodedInstr.rd_addr = x"00000000")) and (ALUtoCtl_data.ALU_result = x"00000001")) then 
				-- Operation: op_executeALU_5_read_921;
				active_assignment <= assign_161;
			elsif (br_en and not((decodedInstr.instrType = beq) and (ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = bne) and not(ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = blt) and (ALUtoCtl_data.ALU_result = x"00000001")) and not((decodedInstr.instrType = bge) and (ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = bltu) and (ALUtoCtl_data.ALU_result = x"00000001")) and not((decodedInstr.instrType = bgeu) and (ALUtoCtl_data.ALU_result = x"00000000")) and not(decodedInstr.instrType = jal) and not(decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_MEM) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_922;
				active_assignment <= assign_160;
			elsif (br_en and not((decodedInstr.instrType = beq) and (ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = bne) and not(ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = blt) and (ALUtoCtl_data.ALU_result = x"00000001")) and not((decodedInstr.instrType = bge) and (ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = bltu) and (ALUtoCtl_data.ALU_result = x"00000001")) and not((decodedInstr.instrType = bgeu) and (ALUtoCtl_data.ALU_result = x"00000000")) and not(decodedInstr.instrType = jal) and not(decodedInstr.instrType = jalr) and not(mem_en) and not(wb_sel = WB_ALU) and not(wb_sel = WB_MEM) and not(wb_sel = WB_PC4)) then 
				-- Operation: op_executeALU_5_read_923;
				active_assignment <= assign_160;
			elsif (br_en and (decodedInstr.instrType = bge) and not(mem_en) and (wb_sel = WB_PC4) and not(wb_en and not(decodedInstr.rd_addr = x"00000000")) and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_924;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = bltu) and not(mem_en) and (wb_sel = WB_MEM) and not(wb_en and not(decodedInstr.rd_addr = x"00000000")) and (ALUtoCtl_data.ALU_result = x"00000001")) then 
				-- Operation: op_executeALU_5_read_925;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = bltu) and not(mem_en) and not(wb_sel = WB_ALU) and not(wb_sel = WB_MEM) and not(wb_sel = WB_PC4) and (ALUtoCtl_data.ALU_result = x"00000001")) then 
				-- Operation: op_executeALU_5_read_926;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = bgeu) and not(mem_en) and (wb_sel = WB_ALU) and not(wb_en and not(decodedInstr.rd_addr = x"00000000")) and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_927;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = jal) and not(mem_en) and (wb_sel = WB_ALU) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_928;
				active_assignment <= assign_161;
			elsif (br_en and not((decodedInstr.instrType = beq) and (ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = bne) and not(ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = blt) and (ALUtoCtl_data.ALU_result = x"00000001")) and not((decodedInstr.instrType = bge) and (ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = bltu) and (ALUtoCtl_data.ALU_result = x"00000001")) and not((decodedInstr.instrType = bgeu) and (ALUtoCtl_data.ALU_result = x"00000000")) and not(decodedInstr.instrType = jal) and not(decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_PC4) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_929;
				active_assignment <= assign_160;
			elsif (br_en and (decodedInstr.instrType = bltu) and not(mem_en) and (wb_sel = WB_PC4) and not(wb_en and not(decodedInstr.rd_addr = x"00000000")) and (ALUtoCtl_data.ALU_result = x"00000001")) then 
				-- Operation: op_executeALU_5_read_930;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = bgeu) and not(mem_en) and (wb_sel = WB_MEM) and not(wb_en and not(decodedInstr.rd_addr = x"00000000")) and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_931;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = bgeu) and not(mem_en) and not(wb_sel = WB_ALU) and not(wb_sel = WB_MEM) and not(wb_sel = WB_PC4) and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_932;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = jal) and not(mem_en) and (wb_sel = WB_MEM) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_933;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = jal) and not(mem_en) and not(wb_sel = WB_ALU) and not(wb_sel = WB_MEM) and not(wb_sel = WB_PC4)) then 
				-- Operation: op_executeALU_5_read_934;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = bgeu) and not(mem_en) and (wb_sel = WB_PC4) and not(wb_en and not(decodedInstr.rd_addr = x"00000000")) and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_935;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = jal) and not(mem_en) and (wb_sel = WB_PC4) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_936;
				active_assignment <= assign_161;
			elsif (br_en and (decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_ALU) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_937;
				active_assignment <= assign_162;
			elsif (br_en and (decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_MEM) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_938;
				active_assignment <= assign_162;
			elsif (br_en and (decodedInstr.instrType = jalr) and not(mem_en) and not(wb_sel = WB_ALU) and not(wb_sel = WB_MEM) and not(wb_sel = WB_PC4)) then 
				-- Operation: op_executeALU_5_read_939;
				active_assignment <= assign_162;
			elsif (br_en and (decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_PC4) and not(wb_en and not(decodedInstr.rd_addr = x"00000000"))) then 
				-- Operation: op_executeALU_5_read_940;
				active_assignment <= assign_162;
			elsif (not(br_en) and not(decodedInstr.instrType = jal) and not(decodedInstr.instrType = jalr) and mem_en) then 
				-- Operation: op_executeALU_5_read_941;
				active_assignment <= assign_163;
			elsif (not(br_en) and (decodedInstr.instrType = jal) and mem_en) then 
				-- Operation: op_executeALU_5_read_942;
				active_assignment <= assign_164;
			elsif (br_en and (decodedInstr.instrType = beq) and mem_en and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_943;
				active_assignment <= assign_164;
			elsif (br_en and (decodedInstr.instrType = bne) and not(ALUtoCtl_data.ALU_result = x"00000000") and mem_en) then 
				-- Operation: op_executeALU_5_read_944;
				active_assignment <= assign_164;
			elsif (not(br_en) and (decodedInstr.instrType = jalr) and mem_en) then 
				-- Operation: op_executeALU_5_read_945;
				active_assignment <= assign_165;
			elsif (br_en and (decodedInstr.instrType = blt) and mem_en and (ALUtoCtl_data.ALU_result = x"00000001")) then 
				-- Operation: op_executeALU_5_read_946;
				active_assignment <= assign_164;
			elsif (br_en and (decodedInstr.instrType = bge) and mem_en and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_947;
				active_assignment <= assign_164;
			elsif (br_en and not((decodedInstr.instrType = beq) and (ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = bne) and not(ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = blt) and (ALUtoCtl_data.ALU_result = x"00000001")) and not((decodedInstr.instrType = bge) and (ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = bltu) and (ALUtoCtl_data.ALU_result = x"00000001")) and not((decodedInstr.instrType = bgeu) and (ALUtoCtl_data.ALU_result = x"00000000")) and not(decodedInstr.instrType = jal) and not(decodedInstr.instrType = jalr) and mem_en) then 
				-- Operation: op_executeALU_5_read_948;
				active_assignment <= assign_163;
			elsif (br_en and (decodedInstr.instrType = bltu) and mem_en and (ALUtoCtl_data.ALU_result = x"00000001")) then 
				-- Operation: op_executeALU_5_read_949;
				active_assignment <= assign_164;
			elsif (br_en and (decodedInstr.instrType = bgeu) and mem_en and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_950;
				active_assignment <= assign_164;
			elsif (br_en and (decodedInstr.instrType = jal) and mem_en) then 
				-- Operation: op_executeALU_5_read_951;
				active_assignment <= assign_164;
			elsif (br_en and (decodedInstr.instrType = jalr) and mem_en) then 
				-- Operation: op_executeALU_5_read_952;
				active_assignment <= assign_165;
			elsif (not(br_en) and not(decodedInstr.instrType = jal) and not(decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_ALU) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_953;
				active_assignment <= assign_166;
			elsif (not(br_en) and not(decodedInstr.instrType = jal) and not(decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_MEM) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_954;
				active_assignment <= assign_167;
			elsif (not(br_en) and (decodedInstr.instrType = jal) and not(mem_en) and (wb_sel = WB_ALU) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_955;
				active_assignment <= assign_168;
			elsif (not(br_en) and not(decodedInstr.instrType = jal) and not(decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_PC4) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_956;
				active_assignment <= assign_169;
			elsif (br_en and (decodedInstr.instrType = beq) and not(mem_en) and (wb_sel = WB_ALU) and wb_en and not(decodedInstr.rd_addr = x"00000000") and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_957;
				active_assignment <= assign_168;
			elsif (not(br_en) and (decodedInstr.instrType = jal) and not(mem_en) and (wb_sel = WB_MEM) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_958;
				active_assignment <= assign_170;
			elsif (br_en and (decodedInstr.instrType = beq) and not(mem_en) and (wb_sel = WB_MEM) and wb_en and not(decodedInstr.rd_addr = x"00000000") and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_959;
				active_assignment <= assign_170;
			elsif (br_en and (decodedInstr.instrType = bne) and not(ALUtoCtl_data.ALU_result = x"00000000") and not(mem_en) and (wb_sel = WB_ALU) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_960;
				active_assignment <= assign_168;
			elsif (not(br_en) and (decodedInstr.instrType = jal) and not(mem_en) and (wb_sel = WB_PC4) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_961;
				active_assignment <= assign_171;
			elsif (not(br_en) and (decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_ALU) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_962;
				active_assignment <= assign_172;
			elsif (br_en and (decodedInstr.instrType = beq) and not(mem_en) and (wb_sel = WB_PC4) and wb_en and not(decodedInstr.rd_addr = x"00000000") and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_963;
				active_assignment <= assign_171;
			elsif (br_en and (decodedInstr.instrType = bne) and not(ALUtoCtl_data.ALU_result = x"00000000") and not(mem_en) and (wb_sel = WB_MEM) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_964;
				active_assignment <= assign_170;
			elsif (br_en and (decodedInstr.instrType = blt) and not(mem_en) and (wb_sel = WB_ALU) and wb_en and not(decodedInstr.rd_addr = x"00000000") and (ALUtoCtl_data.ALU_result = x"00000001")) then 
				-- Operation: op_executeALU_5_read_965;
				active_assignment <= assign_168;
			elsif (not(br_en) and (decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_MEM) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_966;
				active_assignment <= assign_173;
			elsif (br_en and (decodedInstr.instrType = bne) and not(ALUtoCtl_data.ALU_result = x"00000000") and not(mem_en) and (wb_sel = WB_PC4) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_967;
				active_assignment <= assign_171;
			elsif (br_en and (decodedInstr.instrType = blt) and not(mem_en) and (wb_sel = WB_MEM) and wb_en and not(decodedInstr.rd_addr = x"00000000") and (ALUtoCtl_data.ALU_result = x"00000001")) then 
				-- Operation: op_executeALU_5_read_968;
				active_assignment <= assign_170;
			elsif (br_en and (decodedInstr.instrType = bge) and not(mem_en) and (wb_sel = WB_ALU) and wb_en and not(decodedInstr.rd_addr = x"00000000") and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_969;
				active_assignment <= assign_168;
			elsif (br_en and not((decodedInstr.instrType = beq) and (ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = bne) and not(ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = blt) and (ALUtoCtl_data.ALU_result = x"00000001")) and not((decodedInstr.instrType = bge) and (ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = bltu) and (ALUtoCtl_data.ALU_result = x"00000001")) and not((decodedInstr.instrType = bgeu) and (ALUtoCtl_data.ALU_result = x"00000000")) and not(decodedInstr.instrType = jal) and not(decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_ALU) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_970;
				active_assignment <= assign_166;
			elsif (not(br_en) and (decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_PC4) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_971;
				active_assignment <= assign_174;
			elsif (br_en and (decodedInstr.instrType = blt) and not(mem_en) and (wb_sel = WB_PC4) and wb_en and not(decodedInstr.rd_addr = x"00000000") and (ALUtoCtl_data.ALU_result = x"00000001")) then 
				-- Operation: op_executeALU_5_read_972;
				active_assignment <= assign_171;
			elsif (br_en and (decodedInstr.instrType = bge) and not(mem_en) and (wb_sel = WB_MEM) and wb_en and not(decodedInstr.rd_addr = x"00000000") and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_973;
				active_assignment <= assign_170;
			elsif (br_en and (decodedInstr.instrType = bltu) and not(mem_en) and (wb_sel = WB_ALU) and wb_en and not(decodedInstr.rd_addr = x"00000000") and (ALUtoCtl_data.ALU_result = x"00000001")) then 
				-- Operation: op_executeALU_5_read_974;
				active_assignment <= assign_168;
			elsif (br_en and not((decodedInstr.instrType = beq) and (ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = bne) and not(ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = blt) and (ALUtoCtl_data.ALU_result = x"00000001")) and not((decodedInstr.instrType = bge) and (ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = bltu) and (ALUtoCtl_data.ALU_result = x"00000001")) and not((decodedInstr.instrType = bgeu) and (ALUtoCtl_data.ALU_result = x"00000000")) and not(decodedInstr.instrType = jal) and not(decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_MEM) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_975;
				active_assignment <= assign_167;
			elsif (br_en and (decodedInstr.instrType = bge) and not(mem_en) and (wb_sel = WB_PC4) and wb_en and not(decodedInstr.rd_addr = x"00000000") and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_976;
				active_assignment <= assign_171;
			elsif (br_en and (decodedInstr.instrType = bltu) and not(mem_en) and (wb_sel = WB_MEM) and wb_en and not(decodedInstr.rd_addr = x"00000000") and (ALUtoCtl_data.ALU_result = x"00000001")) then 
				-- Operation: op_executeALU_5_read_977;
				active_assignment <= assign_170;
			elsif (br_en and (decodedInstr.instrType = bgeu) and not(mem_en) and (wb_sel = WB_ALU) and wb_en and not(decodedInstr.rd_addr = x"00000000") and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_978;
				active_assignment <= assign_168;
			elsif (br_en and (decodedInstr.instrType = jal) and not(mem_en) and (wb_sel = WB_ALU) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_979;
				active_assignment <= assign_168;
			elsif (br_en and not((decodedInstr.instrType = beq) and (ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = bne) and not(ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = blt) and (ALUtoCtl_data.ALU_result = x"00000001")) and not((decodedInstr.instrType = bge) and (ALUtoCtl_data.ALU_result = x"00000000")) and not((decodedInstr.instrType = bltu) and (ALUtoCtl_data.ALU_result = x"00000001")) and not((decodedInstr.instrType = bgeu) and (ALUtoCtl_data.ALU_result = x"00000000")) and not(decodedInstr.instrType = jal) and not(decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_PC4) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_980;
				active_assignment <= assign_169;
			elsif (br_en and (decodedInstr.instrType = bltu) and not(mem_en) and (wb_sel = WB_PC4) and wb_en and not(decodedInstr.rd_addr = x"00000000") and (ALUtoCtl_data.ALU_result = x"00000001")) then 
				-- Operation: op_executeALU_5_read_981;
				active_assignment <= assign_171;
			elsif (br_en and (decodedInstr.instrType = bgeu) and not(mem_en) and (wb_sel = WB_MEM) and wb_en and not(decodedInstr.rd_addr = x"00000000") and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_982;
				active_assignment <= assign_170;
			elsif (br_en and (decodedInstr.instrType = jal) and not(mem_en) and (wb_sel = WB_MEM) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_983;
				active_assignment <= assign_170;
			elsif (br_en and (decodedInstr.instrType = bgeu) and not(mem_en) and (wb_sel = WB_PC4) and wb_en and not(decodedInstr.rd_addr = x"00000000") and (ALUtoCtl_data.ALU_result = x"00000000")) then 
				-- Operation: op_executeALU_5_read_984;
				active_assignment <= assign_171;
			elsif (br_en and (decodedInstr.instrType = jal) and not(mem_en) and (wb_sel = WB_PC4) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_985;
				active_assignment <= assign_171;
			elsif (br_en and (decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_ALU) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_986;
				active_assignment <= assign_172;
			elsif (br_en and (decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_MEM) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_987;
				active_assignment <= assign_173;
			else--if(br_en and (decodedInstr.instrType = jalr) and not(mem_en) and (wb_sel = WB_PC4) and wb_en and not(decodedInstr.rd_addr = x"00000000")) then 
				-- Operation: op_executeALU_5_read_988;
				active_assignment <= assign_174;
			end if;
		when st_fetch_6 =>
			if (not(CtlToMem_port_sync)) then 
				-- Operation: op_wait_fetch_6;
				active_assignment <= assign_175;
			else--if(CtlToMem_port_sync) then 
				-- Operation: op_fetch_6_write_989;
				active_assignment <= assign_176;
			end if;
		when st_fetch_7 =>
			if (not(MemToCtl_port_sync)) then 
				-- Operation: op_wait_fetch_7;
				active_assignment <= assign_176;
			else--if(MemToCtl_port_sync) then 
				-- Operation: op_fetch_7_read_990;
				active_assignment <= assign_177;
			end if;
		when st_memoryOperation_8 =>
			if (not(CtlToMem_port_sync)) then 
				-- Operation: op_wait_memoryOperation_8;
				active_assignment <= assign_178;
			else--if(CtlToMem_port_sync) then 
				-- Operation: op_memoryOperation_8_write_991;
				active_assignment <= assign_179;
			end if;
		when st_memoryOperation_9 =>
			if ((wb_sel = WB_ALU) and not(wb_en and not(decodedInstr.rd_addr = x"00000000")) and MemToCtl_port_sync) then 
				-- Operation: op_memoryOperation_9_read_992;
				active_assignment <= assign_180;
			elsif ((wb_sel = WB_MEM) and not(wb_en and not(decodedInstr.rd_addr = x"00000000")) and MemToCtl_port_sync) then 
				-- Operation: op_memoryOperation_9_read_993;
				active_assignment <= assign_180;
			elsif (not(wb_sel = WB_ALU) and not(wb_sel = WB_MEM) and not(wb_sel = WB_PC4) and MemToCtl_port_sync) then 
				-- Operation: op_memoryOperation_9_read_994;
				active_assignment <= assign_180;
			elsif ((wb_sel = WB_PC4) and not(wb_en and not(decodedInstr.rd_addr = x"00000000")) and MemToCtl_port_sync) then 
				-- Operation: op_memoryOperation_9_read_995;
				active_assignment <= assign_180;
			elsif (not(MemToCtl_port_sync)) then 
				-- Operation: op_wait_memoryOperation_9;
				active_assignment <= assign_179;
			elsif ((wb_sel = WB_ALU) and wb_en and not(decodedInstr.rd_addr = x"00000000") and MemToCtl_port_sync) then 
				-- Operation: op_memoryOperation_9_read_996;
				active_assignment <= assign_181;
			elsif ((wb_sel = WB_MEM) and wb_en and not(decodedInstr.rd_addr = x"00000000") and MemToCtl_port_sync) then 
				-- Operation: op_memoryOperation_9_read_997;
				active_assignment <= assign_182;
			else--if((wb_sel = WB_PC4) and wb_en and not(decodedInstr.rd_addr = x"00000000") and MemToCtl_port_sync) then 
				-- Operation: op_memoryOperation_9_read_998;
				active_assignment <= assign_183;
			end if;
		when st_readRegisterFile_10 =>
			--if (true) then 
				-- Operation: op_readRegisterFile_10_write_999;
				active_assignment <= assign_184;
			--end if;
		when st_readRegisterFile_11 =>
			if ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_readRegisterFile_11_read_1000;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_readRegisterFile_11_read_1001;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_readRegisterFile_11_read_1002;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_readRegisterFile_11_read_1003;
				active_assignment <= assign_186;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_readRegisterFile_11_read_1004;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_readRegisterFile_11_read_1005;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_readRegisterFile_11_read_1006;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_readRegisterFile_11_read_1007;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_readRegisterFile_11_read_1008;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_readRegisterFile_11_read_1009;
				active_assignment <= assign_187;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_readRegisterFile_11_read_1010;
				active_assignment <= assign_188;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_readRegisterFile_11_read_1011;
				active_assignment <= assign_189;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_readRegisterFile_11_read_1012;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_readRegisterFile_11_read_1013;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_readRegisterFile_11_read_1014;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_readRegisterFile_11_read_1015;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_readRegisterFile_11_read_1016;
				active_assignment <= assign_190;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_readRegisterFile_11_read_1017;
				active_assignment <= assign_191;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_readRegisterFile_11_read_1018;
				active_assignment <= assign_192;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_readRegisterFile_11_read_1019;
				active_assignment <= assign_193;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_readRegisterFile_11_read_1020;
				active_assignment <= assign_194;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_readRegisterFile_11_read_1021;
				active_assignment <= assign_195;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_readRegisterFile_11_read_1022;
				active_assignment <= assign_196;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_readRegisterFile_11_read_1023;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_readRegisterFile_11_read_1024;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_readRegisterFile_11_read_1025;
				active_assignment <= assign_197;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_readRegisterFile_11_read_1026;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_X)) then 
				-- Operation: op_readRegisterFile_11_read_1027;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_readRegisterFile_11_read_1028;
				active_assignment <= assign_198;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_readRegisterFile_11_read_1029;
				active_assignment <= assign_199;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_readRegisterFile_11_read_1030;
				active_assignment <= assign_200;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_readRegisterFile_11_read_1031;
				active_assignment <= assign_193;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_readRegisterFile_11_read_1032;
				active_assignment <= assign_201;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_readRegisterFile_11_read_1033;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_readRegisterFile_11_read_1034;
				active_assignment <= assign_202;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_readRegisterFile_11_read_1035;
				active_assignment <= assign_203;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_readRegisterFile_11_read_1036;
				active_assignment <= assign_204;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_readRegisterFile_11_read_1037;
				active_assignment <= assign_202;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_readRegisterFile_11_read_1038;
				active_assignment <= assign_205;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_readRegisterFile_11_read_1039;
				active_assignment <= assign_203;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_readRegisterFile_11_read_1040;
				active_assignment <= assign_206;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_readRegisterFile_11_read_1041;
				active_assignment <= assign_207;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_readRegisterFile_11_read_1042;
				active_assignment <= assign_208;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_readRegisterFile_11_read_1043;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_readRegisterFile_11_read_1044;
				active_assignment <= assign_209;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_readRegisterFile_11_read_1045;
				active_assignment <= assign_203;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_readRegisterFile_11_read_1046;
				active_assignment <= assign_210;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_readRegisterFile_11_read_1047;
				active_assignment <= assign_203;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_readRegisterFile_11_read_1048;
				active_assignment <= assign_211;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_readRegisterFile_11_read_1049;
				active_assignment <= assign_212;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_readRegisterFile_11_read_1050;
				active_assignment <= assign_213;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_readRegisterFile_11_read_1051;
				active_assignment <= assign_214;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_readRegisterFile_11_read_1052;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_readRegisterFile_11_read_1053;
				active_assignment <= assign_215;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_readRegisterFile_11_read_1054;
				active_assignment <= assign_214;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_ADD)) then 
				-- Operation: op_readRegisterFile_11_read_1055;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_port_sig.contents2 <= RegsToCtl_port_sig.contents1)) then 
				-- Operation: op_readRegisterFile_11_read_1056;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_readRegisterFile_11_read_1057;
				active_assignment <= assign_216;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_readRegisterFile_11_read_1058;
				active_assignment <= assign_217;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_readRegisterFile_11_read_1059;
				active_assignment <= assign_193;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_readRegisterFile_11_read_1060;
				active_assignment <= assign_218;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_readRegisterFile_11_read_1061;
				active_assignment <= assign_203;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_readRegisterFile_11_read_1062;
				active_assignment <= assign_219;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_readRegisterFile_11_read_1063;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_readRegisterFile_11_read_1064;
				active_assignment <= assign_220;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_readRegisterFile_11_read_1065;
				active_assignment <= assign_219;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_readRegisterFile_11_read_1066;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_readRegisterFile_11_read_1067;
				active_assignment <= assign_214;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_readRegisterFile_11_read_1068;
				active_assignment <= assign_197;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_readRegisterFile_11_read_1069;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_readRegisterFile_11_read_1070;
				active_assignment <= assign_221;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SUB)) then 
				-- Operation: op_readRegisterFile_11_read_1071;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_port_sig.contents2 <= RegsToCtl_port_sig.contents1)) then 
				-- Operation: op_readRegisterFile_11_read_1072;
				active_assignment <= assign_222;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_port_sig.contents2 <= RegsToCtl_port_sig.contents1)) then 
				-- Operation: op_readRegisterFile_11_read_1073;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and (decodedInstr.imm <= RegsToCtl_port_sig.contents1)) then 
				-- Operation: op_readRegisterFile_11_read_1074;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_readRegisterFile_11_read_1075;
				active_assignment <= assign_223;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_readRegisterFile_11_read_1076;
				active_assignment <= assign_193;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_port_sig.contents2 <= decodedInstr.imm)) then 
				-- Operation: op_readRegisterFile_11_read_1077;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_readRegisterFile_11_read_1078;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_readRegisterFile_11_read_1079;
				active_assignment <= assign_224;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_readRegisterFile_11_read_1080;
				active_assignment <= assign_203;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_readRegisterFile_11_read_1081;
				active_assignment <= assign_225;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_readRegisterFile_11_read_1082;
				active_assignment <= assign_224;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_readRegisterFile_11_read_1083;
				active_assignment <= assign_214;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_readRegisterFile_11_read_1084;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_readRegisterFile_11_read_1085;
				active_assignment <= assign_197;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_readRegisterFile_11_read_1086;
				active_assignment <= assign_203;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_readRegisterFile_11_read_1087;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_AND)) then 
				-- Operation: op_readRegisterFile_11_read_1088;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_port_sig.contents2 <= RegsToCtl_port_sig.contents1)) then 
				-- Operation: op_readRegisterFile_11_read_1089;
				active_assignment <= assign_222;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_readRegisterFile_11_read_1090;
				active_assignment <= assign_226;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and not(decodedInstr.imm <= RegsToCtl_port_sig.contents1)) then 
				-- Operation: op_readRegisterFile_11_read_1091;
				active_assignment <= assign_222;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and (decodedInstr.imm <= RegsToCtl_port_sig.contents1)) then 
				-- Operation: op_readRegisterFile_11_read_1092;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and (pc_reg <= RegsToCtl_port_sig.contents1)) then 
				-- Operation: op_readRegisterFile_11_read_1093;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_readRegisterFile_11_read_1094;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_port_sig.contents2 <= decodedInstr.imm)) then 
				-- Operation: op_readRegisterFile_11_read_1095;
				active_assignment <= assign_222;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_port_sig.contents2 <= decodedInstr.imm)) then 
				-- Operation: op_readRegisterFile_11_read_1096;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_readRegisterFile_11_read_1097;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_readRegisterFile_11_read_1098;
				active_assignment <= assign_227;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_readRegisterFile_11_read_1099;
				active_assignment <= assign_203;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_port_sig.contents2 <= pc_reg)) then 
				-- Operation: op_readRegisterFile_11_read_1100;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_readRegisterFile_11_read_1101;
				active_assignment <= assign_227;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_readRegisterFile_11_read_1102;
				active_assignment <= assign_214;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_readRegisterFile_11_read_1103;
				active_assignment <= assign_214;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and (RegsToCtl_port_sig.contents2 = x"00000000")) then 
				-- Operation: op_readRegisterFile_11_read_1104;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_readRegisterFile_11_read_1105;
				active_assignment <= assign_203;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_readRegisterFile_11_read_1106;
				active_assignment <= assign_214;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_OR)) then 
				-- Operation: op_readRegisterFile_11_read_1107;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_readRegisterFile_11_read_1108;
				active_assignment <= assign_228;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(decodedInstr.imm <= RegsToCtl_port_sig.contents1)) then 
				-- Operation: op_readRegisterFile_11_read_1109;
				active_assignment <= assign_222;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_readRegisterFile_11_read_1110;
				active_assignment <= assign_229;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and not(pc_reg <= RegsToCtl_port_sig.contents1)) then 
				-- Operation: op_readRegisterFile_11_read_1111;
				active_assignment <= assign_222;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and (pc_reg <= RegsToCtl_port_sig.contents1)) then 
				-- Operation: op_readRegisterFile_11_read_1112;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_readRegisterFile_11_read_1113;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_port_sig.contents2 <= decodedInstr.imm)) then 
				-- Operation: op_readRegisterFile_11_read_1114;
				active_assignment <= assign_222;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_readRegisterFile_11_read_1115;
				active_assignment <= assign_230;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_readRegisterFile_11_read_1116;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and (pc_reg <= decodedInstr.imm)) then 
				-- Operation: op_readRegisterFile_11_read_1117;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_readRegisterFile_11_read_1118;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_port_sig.contents2 <= pc_reg)) then 
				-- Operation: op_readRegisterFile_11_read_1119;
				active_assignment <= assign_222;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_port_sig.contents2 <= pc_reg)) then 
				-- Operation: op_readRegisterFile_11_read_1120;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and (decodedInstr.imm <= pc_reg)) then 
				-- Operation: op_readRegisterFile_11_read_1121;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_readRegisterFile_11_read_1122;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_readRegisterFile_11_read_1123;
				active_assignment <= assign_214;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLT) and not(RegsToCtl_port_sig.contents2 = x"00000000")) then 
				-- Operation: op_readRegisterFile_11_read_1124;
				active_assignment <= assign_222;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and (RegsToCtl_port_sig.contents2 = x"00000000")) then 
				-- Operation: op_readRegisterFile_11_read_1125;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and (decodedInstr.imm = x"00000000")) then 
				-- Operation: op_readRegisterFile_11_read_1126;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_readRegisterFile_11_read_1127;
				active_assignment <= assign_214;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_XOR)) then 
				-- Operation: op_readRegisterFile_11_read_1128;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_readRegisterFile_11_read_1129;
				active_assignment <= assign_228;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_readRegisterFile_11_read_1130;
				active_assignment <= assign_231;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(pc_reg <= RegsToCtl_port_sig.contents1)) then 
				-- Operation: op_readRegisterFile_11_read_1131;
				active_assignment <= assign_222;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_readRegisterFile_11_read_1132;
				active_assignment <= assign_232;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_readRegisterFile_11_read_1133;
				active_assignment <= assign_193;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_readRegisterFile_11_read_1134;
				active_assignment <= assign_233;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_readRegisterFile_11_read_1135;
				active_assignment <= assign_234;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and not(pc_reg <= decodedInstr.imm)) then 
				-- Operation: op_readRegisterFile_11_read_1136;
				active_assignment <= assign_222;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and (pc_reg <= decodedInstr.imm)) then 
				-- Operation: op_readRegisterFile_11_read_1137;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_readRegisterFile_11_read_1138;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_port_sig.contents2 <= pc_reg)) then 
				-- Operation: op_readRegisterFile_11_read_1139;
				active_assignment <= assign_222;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_readRegisterFile_11_read_1140;
				active_assignment <= assign_235;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and not(decodedInstr.imm <= pc_reg)) then 
				-- Operation: op_readRegisterFile_11_read_1141;
				active_assignment <= assign_222;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and (decodedInstr.imm <= pc_reg)) then 
				-- Operation: op_readRegisterFile_11_read_1142;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_readRegisterFile_11_read_1143;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_readRegisterFile_11_read_1144;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(RegsToCtl_port_sig.contents2 = x"00000000")) then 
				-- Operation: op_readRegisterFile_11_read_1145;
				active_assignment <= assign_222;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_readRegisterFile_11_read_1146;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLT) and not(decodedInstr.imm = x"00000000")) then 
				-- Operation: op_readRegisterFile_11_read_1147;
				active_assignment <= assign_222;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and (decodedInstr.imm = x"00000000")) then 
				-- Operation: op_readRegisterFile_11_read_1148;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and (pc_reg = x"00000000")) then 
				-- Operation: op_readRegisterFile_11_read_1149;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT)) then 
				-- Operation: op_readRegisterFile_11_read_1150;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_readRegisterFile_11_read_1151;
				active_assignment <= assign_193;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_readRegisterFile_11_read_1152;
				active_assignment <= assign_231;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_readRegisterFile_11_read_1153;
				active_assignment <= assign_236;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_readRegisterFile_11_read_1154;
				active_assignment <= assign_193;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_readRegisterFile_11_read_1155;
				active_assignment <= assign_233;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_readRegisterFile_11_read_1156;
				active_assignment <= assign_237;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(pc_reg <= decodedInstr.imm)) then 
				-- Operation: op_readRegisterFile_11_read_1157;
				active_assignment <= assign_222;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_readRegisterFile_11_read_1158;
				active_assignment <= assign_238;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_readRegisterFile_11_read_1159;
				active_assignment <= assign_203;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_readRegisterFile_11_read_1160;
				active_assignment <= assign_239;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(decodedInstr.imm <= pc_reg)) then 
				-- Operation: op_readRegisterFile_11_read_1161;
				active_assignment <= assign_222;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_readRegisterFile_11_read_1162;
				active_assignment <= assign_240;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_readRegisterFile_11_read_1163;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_readRegisterFile_11_read_1164;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_readRegisterFile_11_read_1165;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(decodedInstr.imm = x"00000000")) then 
				-- Operation: op_readRegisterFile_11_read_1166;
				active_assignment <= assign_222;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_readRegisterFile_11_read_1167;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLT) and not(pc_reg = x"00000000")) then 
				-- Operation: op_readRegisterFile_11_read_1168;
				active_assignment <= assign_222;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and (pc_reg = x"00000000")) then 
				-- Operation: op_readRegisterFile_11_read_1169;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU)) then 
				-- Operation: op_readRegisterFile_11_read_1170;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_readRegisterFile_11_read_1171;
				active_assignment <= assign_193;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_readRegisterFile_11_read_1172;
				active_assignment <= assign_236;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_readRegisterFile_11_read_1173;
				active_assignment <= assign_193;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_readRegisterFile_11_read_1174;
				active_assignment <= assign_203;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_readRegisterFile_11_read_1175;
				active_assignment <= assign_237;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_readRegisterFile_11_read_1176;
				active_assignment <= assign_241;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_readRegisterFile_11_read_1177;
				active_assignment <= assign_203;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_readRegisterFile_11_read_1178;
				active_assignment <= assign_239;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_readRegisterFile_11_read_1179;
				active_assignment <= assign_242;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_readRegisterFile_11_read_1180;
				active_assignment <= assign_243;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_readRegisterFile_11_read_1181;
				active_assignment <= assign_214;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_readRegisterFile_11_read_1182;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_readRegisterFile_11_read_1183;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLTU) and not(pc_reg = x"00000000")) then 
				-- Operation: op_readRegisterFile_11_read_1184;
				active_assignment <= assign_222;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_readRegisterFile_11_read_1185;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SLL)) then 
				-- Operation: op_readRegisterFile_11_read_1186;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_readRegisterFile_11_read_1187;
				active_assignment <= assign_193;
			elsif ((CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_readRegisterFile_11_read_1188;
				active_assignment <= assign_193;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_readRegisterFile_11_read_1189;
				active_assignment <= assign_203;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_readRegisterFile_11_read_1190;
				active_assignment <= assign_241;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_readRegisterFile_11_read_1191;
				active_assignment <= assign_203;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_readRegisterFile_11_read_1192;
				active_assignment <= assign_214;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_readRegisterFile_11_read_1193;
				active_assignment <= assign_242;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_readRegisterFile_11_read_1194;
				active_assignment <= assign_244;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_readRegisterFile_11_read_1195;
				active_assignment <= assign_214;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_REG) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_readRegisterFile_11_read_1196;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_readRegisterFile_11_read_1197;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_readRegisterFile_11_read_1198;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRA)) then 
				-- Operation: op_readRegisterFile_11_read_1199;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_readRegisterFile_11_read_1200;
				active_assignment <= assign_203;
			elsif ((CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_readRegisterFile_11_read_1201;
				active_assignment <= assign_203;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_readRegisterFile_11_read_1202;
				active_assignment <= assign_214;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_readRegisterFile_11_read_1203;
				active_assignment <= assign_244;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_readRegisterFile_11_read_1204;
				active_assignment <= assign_214;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_IMM) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_readRegisterFile_11_read_1205;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_readRegisterFile_11_read_1206;
				active_assignment <= assign_185;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_SRL)) then 
				-- Operation: op_readRegisterFile_11_read_1207;
				active_assignment <= assign_185;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_readRegisterFile_11_read_1208;
				active_assignment <= assign_214;
			elsif ((CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_readRegisterFile_11_read_1209;
				active_assignment <= assign_214;
			elsif (not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and (CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_readRegisterFile_11_read_1210;
				active_assignment <= assign_185;
			else--if(not(CtlToALU_data.op1_sel = OP_REG) and not(CtlToALU_data.op1_sel = OP_IMM) and not(CtlToALU_data.op1_sel = OP_PC) and not(CtlToALU_data.op2_sel = OP_REG) and not(CtlToALU_data.op2_sel = OP_IMM) and not(CtlToALU_data.op2_sel = OP_PC) and (CtlToALU_data.alu_fun = ALU_COPY1)) then 
				-- Operation: op_readRegisterFile_11_read_1211;
				active_assignment <= assign_185;
			end if;
		when st_writeBack_13 =>
			--if (true) then 
				-- Operation: op_writeBack_13_write_1212;
				active_assignment <= assign_245;
			--end if;
		end case;
	end process;

	-- Main process
	process (clk, rst)
	begin
		if (rst = '1') then
			CtlToMem_port_notify <= true;
			wb_sel <= WB_ALU;
			CtlToMem_port_sig.req <= ME_RD;
			CtlToRegs_port_notify <= false;
			reg_rd_en <= false;
			CtlToMem_port_sig.addrIn <= x"00000000";
			wb_en <= false;
			CtlToALU_data.alu_fun <= ALU_ADD;
			fromMemoryData.loadedData <= x"00000000";
			pc_reg <= x"00000000";
			CtlToRegs_data.dst_data <= x"00000000";
			MemToCtl_port_notify <= false;
			memoryAccess.dataIn <= x"00000000";
			memoryAccess.req <= ME_RD;
			decodedInstr.rd_addr <= x"00000000";
			CtlToRegs_data.src2 <= x"00000000";
			CtlToDec_port_notify <= false;
			CtlToALU_data.op1_sel <= OP_IMM;
			CtlToALU_data.op2_sel <= OP_IMM;
			CtlToRegs_data.dst <= x"00000000";
			CtlToMem_port_sig.mask <= MT_W;
			ALUtoCtl_data.ALU_result <= x"00000000";
			RegsToCtl_data.contents1 <= x"00000000";
			br_en <= false;
			decodedInstr.imm <= x"00000000";
			RegsToCtl_data.contents2 <= x"00000000";
			memoryAccess.addrIn <= x"00000000";
			decodedInstr.instrType <= And_Instr;
			active_state <= st_fetch_6;
			CtlToRegs_data.src1 <= x"00000000";
			memoryAccess.mask <= MT_W;
			mem_en <= false;
			CtlToMem_port_sig.dataIn <= x"00000000";
			pc_next <= x"00000000";
		elsif (clk = '1' and clk'event) then
			case active_assignment is
			when assign_0 =>
				CtlToRegs_port_notify <= false;
				active_state <= st_decode_2;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
			when assign_1 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= x"00000000";
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_2 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 + RegsToCtl_data.contents2;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_3 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 - RegsToCtl_data.contents2;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_4 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 + DecToCtl_port_sig.imm;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_5 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm + RegsToCtl_data.contents2;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_6 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 and RegsToCtl_data.contents2;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_7 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 - DecToCtl_port_sig.imm;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_8 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 + pc_reg;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_9 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_10 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm - RegsToCtl_data.contents2;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_11 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm + DecToCtl_port_sig.imm;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_12 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= pc_reg + RegsToCtl_data.contents2;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_13 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents2;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_14 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 or RegsToCtl_data.contents2;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_15 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 and DecToCtl_port_sig.imm;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_16 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 - pc_reg;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_17 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm and RegsToCtl_data.contents2;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_18 =>
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm + pc_reg;
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_19 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_20 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				ALUtoCtl_data.ALU_result <= pc_reg - RegsToCtl_data.contents2;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_21 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= not(RegsToCtl_data.contents2) + 1;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_22 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 xor RegsToCtl_data.contents2;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_23 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 or DecToCtl_port_sig.imm;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_24 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 and pc_reg;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_25 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm or RegsToCtl_data.contents2;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_26 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm - pc_reg;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_27 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				ALUtoCtl_data.ALU_result <= pc_reg and RegsToCtl_data.contents2;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_28 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				ALUtoCtl_data.ALU_result <= pc_reg - DecToCtl_port_sig.imm;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_29 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				ALUtoCtl_data.ALU_result <= pc_reg + pc_reg;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_30 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				ALUtoCtl_data.ALU_result <= pc_reg;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_31 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				ALUtoCtl_data.ALU_result <= not(DecToCtl_port_sig.imm) + 1;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_32 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 xor DecToCtl_port_sig.imm;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_33 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 or pc_reg;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_34 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm xor RegsToCtl_data.contents2;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_35 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm and pc_reg;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_36 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= pc_reg or RegsToCtl_data.contents2;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_37 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				ALUtoCtl_data.ALU_result <= not(pc_reg) + 1;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_38 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				ALUtoCtl_data.ALU_result <= x"00000001";
			when assign_39 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 xor pc_reg;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_40 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm or pc_reg;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_41 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= pc_reg xor RegsToCtl_data.contents2;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_42 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(RegsToCtl_data.contents1, to_integer(RegsToCtl_data.contents2 and to_unsigned(31, 32)));
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_43 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm xor pc_reg;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_44 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= x"00000000";
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_45 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				ALUtoCtl_data.ALU_result <= shift_right(RegsToCtl_data.contents1, to_integer(RegsToCtl_data.contents2 and to_unsigned(31, 32)));
			when assign_46 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(RegsToCtl_data.contents1, to_integer(DecToCtl_port_sig.imm and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_47 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(DecToCtl_port_sig.imm, to_integer(RegsToCtl_data.contents2 and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_48 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(RegsToCtl_data.contents1, to_integer(DecToCtl_port_sig.imm and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_49 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(RegsToCtl_data.contents1, to_integer(pc_reg and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_50 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(DecToCtl_port_sig.imm, to_integer(RegsToCtl_data.contents2 and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_51 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(DecToCtl_port_sig.imm, to_integer(DecToCtl_port_sig.imm and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_52 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(pc_reg, to_integer(RegsToCtl_data.contents2 and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_53 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 + RegsToCtl_data.contents2;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_54 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(RegsToCtl_data.contents1, to_integer(pc_reg and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_55 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(DecToCtl_port_sig.imm, to_integer(DecToCtl_port_sig.imm and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_56 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(DecToCtl_port_sig.imm, to_integer(pc_reg and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_57 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(pc_reg, to_integer(RegsToCtl_data.contents2 and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_58 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(pc_reg, to_integer(DecToCtl_port_sig.imm and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_59 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 - RegsToCtl_data.contents2;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_60 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 + DecToCtl_port_sig.imm;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_61 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm + RegsToCtl_data.contents2;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_62 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(DecToCtl_port_sig.imm, to_integer(pc_reg and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_63 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(pc_reg, to_integer(DecToCtl_port_sig.imm and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_64 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(pc_reg, to_integer(pc_reg and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_65 =>
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				wb_sel <= WB_PC4;
				CtlToALU_data.alu_fun <= ALU_X;
				CtlToALU_data.op2_sel <= OP_X;
				CtlToALU_data.op1_sel <= OP_X;
				ALUtoCtl_data.ALU_result <= x"00000000";
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_66 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 and RegsToCtl_data.contents2;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_67 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 - DecToCtl_port_sig.imm;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_68 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 + pc_reg;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_69 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_70 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm - RegsToCtl_data.contents2;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_71 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm + DecToCtl_port_sig.imm;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_72 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= pc_reg + RegsToCtl_data.contents2;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_73 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents2;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_74 =>
				CtlToRegs_port_notify <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(pc_reg, to_integer(pc_reg and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_75 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 or RegsToCtl_data.contents2;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_76 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 and DecToCtl_port_sig.imm;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_77 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 - pc_reg;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_78 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm and RegsToCtl_data.contents2;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_79 =>
				wb_sel <= WB_ALU;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm + pc_reg;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_80 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_81 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				ALUtoCtl_data.ALU_result <= pc_reg - RegsToCtl_data.contents2;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_82 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= not(RegsToCtl_data.contents2) + 1;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_83 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 xor RegsToCtl_data.contents2;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_84 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 or DecToCtl_port_sig.imm;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_85 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 and pc_reg;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_86 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm or RegsToCtl_data.contents2;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_87 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm - pc_reg;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_88 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				ALUtoCtl_data.ALU_result <= pc_reg and RegsToCtl_data.contents2;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_89 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				ALUtoCtl_data.ALU_result <= pc_reg - DecToCtl_port_sig.imm;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_90 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				ALUtoCtl_data.ALU_result <= pc_reg + pc_reg;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_91 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				ALUtoCtl_data.ALU_result <= pc_reg;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_92 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				ALUtoCtl_data.ALU_result <= not(DecToCtl_port_sig.imm) + 1;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_93 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 xor DecToCtl_port_sig.imm;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_94 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 or pc_reg;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_95 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm xor RegsToCtl_data.contents2;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_96 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm and pc_reg;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_97 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= pc_reg or RegsToCtl_data.contents2;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_98 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				ALUtoCtl_data.ALU_result <= not(pc_reg) + 1;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_99 =>
				wb_sel <= WB_ALU;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm + pc_reg;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				CtlToALU_data.alu_fun <= ALU_ADD;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToALU_data.op2_sel <= OP_IMM;
				CtlToALU_data.op1_sel <= OP_PC;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_100 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
				ALUtoCtl_data.ALU_result <= x"00000001";
			when assign_101 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_data.contents1 xor pc_reg;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_102 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm or pc_reg;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_103 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= pc_reg xor RegsToCtl_data.contents2;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_104 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(RegsToCtl_data.contents1, to_integer(RegsToCtl_data.contents2 and to_unsigned(31, 32)));
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_105 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm xor pc_reg;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_106 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
				ALUtoCtl_data.ALU_result <= shift_right(RegsToCtl_data.contents1, to_integer(RegsToCtl_data.contents2 and to_unsigned(31, 32)));
			when assign_107 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(RegsToCtl_data.contents1, to_integer(DecToCtl_port_sig.imm and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_108 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(DecToCtl_port_sig.imm, to_integer(RegsToCtl_data.contents2 and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_109 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(RegsToCtl_data.contents1, to_integer(DecToCtl_port_sig.imm and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_110 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(RegsToCtl_data.contents1, to_integer(pc_reg and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_111 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(DecToCtl_port_sig.imm, to_integer(RegsToCtl_data.contents2 and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_112 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(DecToCtl_port_sig.imm, to_integer(DecToCtl_port_sig.imm and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_113 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(pc_reg, to_integer(RegsToCtl_data.contents2 and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_114 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(RegsToCtl_data.contents1, to_integer(pc_reg and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_115 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(DecToCtl_port_sig.imm, to_integer(DecToCtl_port_sig.imm and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_116 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(DecToCtl_port_sig.imm, to_integer(pc_reg and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_117 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(pc_reg, to_integer(RegsToCtl_data.contents2 and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_118 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(pc_reg, to_integer(DecToCtl_port_sig.imm and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_119 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(DecToCtl_port_sig.imm, to_integer(pc_reg and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_120 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(pc_reg, to_integer(DecToCtl_port_sig.imm and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_121 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(pc_reg, to_integer(pc_reg and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_122 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(pc_reg, to_integer(pc_reg and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_123 =>
				wb_sel <= WB_ALU;
				CtlToRegs_port_notify <= false;
				reg_rd_en <= false;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToALU_data.op1_sel <= OP_IMM;
				CtlToALU_data.alu_fun <= ALU_COPY1;
				CtlToALU_data.op2_sel <= OP_X;
				ALUtoCtl_data.ALU_result <= DecToCtl_port_sig.imm;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				active_state <= st_executeALU_4;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_124 =>
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_125 =>
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				CtlToALU_data.alu_fun <= ALU_ADD;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToALU_data.op2_sel <= OP_IMM;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_126 =>
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				CtlToALU_data.alu_fun <= ALU_ADD;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToALU_data.op2_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_127 =>
				CtlToALU_data.alu_fun <= ALU_SLT;
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToALU_data.op2_sel <= OP_IMM;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_128 =>
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				active_state <= st_readRegisterFile_10;
				wb_sel <= WB_PC4;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.alu_fun <= ALU_X;
				CtlToALU_data.op2_sel <= OP_X;
				CtlToALU_data.op1_sel <= OP_X;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_129 =>
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToALU_data.op2_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
				CtlToALU_data.alu_fun <= ALU_SUB;
			when assign_130 =>
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToALU_data.op2_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				br_en <= true;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				reg_rd_en <= true;
				wb_sel <= WB_X;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
				CtlToALU_data.alu_fun <= ALU_SUB;
			when assign_131 =>
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToALU_data.alu_fun <= ALU_SLTU;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToALU_data.op2_sel <= OP_IMM;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_132 =>
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToALU_data.alu_fun <= ALU_SLL;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToALU_data.op2_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_133 =>
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToALU_data.op2_sel <= OP_IMM;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				CtlToALU_data.alu_fun <= ALU_XOR;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_134 =>
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				CtlToALU_data.alu_fun <= ALU_ADD;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				memoryAccess.req <= ME_RD;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				mem_en <= true;
				CtlToALU_data.op2_sel <= OP_IMM;
				memoryAccess.mask <= MT_B;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				wb_sel <= WB_MEM;
			when assign_135 =>
				CtlToALU_data.alu_fun <= ALU_SLT;
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToALU_data.op2_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_136 =>
				CtlToALU_data.alu_fun <= ALU_SLT;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToALU_data.op2_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				br_en <= true;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				reg_rd_en <= true;
				wb_sel <= WB_X;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_137 =>
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToALU_data.alu_fun <= ALU_OR;
				CtlToALU_data.op2_sel <= OP_IMM;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_138 =>
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				CtlToALU_data.alu_fun <= ALU_ADD;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				memoryAccess.req <= ME_RD;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				mem_en <= true;
				CtlToALU_data.op2_sel <= OP_IMM;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				memoryAccess.mask <= MT_H;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				wb_sel <= WB_MEM;
			when assign_139 =>
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToALU_data.alu_fun <= ALU_SLTU;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToALU_data.op2_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_140 =>
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToALU_data.op2_sel <= OP_IMM;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				CtlToALU_data.alu_fun <= ALU_AND;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_141 =>
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				CtlToALU_data.alu_fun <= ALU_ADD;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				memoryAccess.req <= ME_RD;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				mem_en <= true;
				CtlToALU_data.op2_sel <= OP_IMM;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				wb_sel <= WB_MEM;
				memoryAccess.mask <= MT_W;
			when assign_142 =>
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToALU_data.op2_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				CtlToALU_data.alu_fun <= ALU_XOR;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_143 =>
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= false;
				MemToCtl_port_notify <= false;
				CtlToALU_data.alu_fun <= ALU_SLTU;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToALU_data.op2_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				br_en <= true;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				reg_rd_en <= true;
				wb_sel <= WB_X;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_144 =>
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToALU_data.op2_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				br_en <= true;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				reg_rd_en <= true;
				wb_sel <= WB_X;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_145 =>
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= false;
				CtlToALU_data.alu_fun <= ALU_ADD;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				mem_en <= true;
				CtlToALU_data.op2_sel <= OP_IMM;
				memoryAccess.mask <= MT_B;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				memoryAccess.req <= ME_WR;
				reg_rd_en <= true;
				wb_sel <= WB_X;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_146 =>
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToALU_data.op2_sel <= OP_IMM;
				CtlToALU_data.alu_fun <= ALU_SLL;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_147 =>
				memoryAccess.mask <= MT_BU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				CtlToALU_data.alu_fun <= ALU_ADD;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				memoryAccess.req <= ME_RD;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				mem_en <= true;
				CtlToALU_data.op2_sel <= OP_IMM;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				wb_sel <= WB_MEM;
			when assign_148 =>
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToALU_data.alu_fun <= ALU_SRL;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToALU_data.op2_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_149 =>
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= false;
				CtlToALU_data.alu_fun <= ALU_ADD;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				mem_en <= true;
				CtlToALU_data.op2_sel <= OP_IMM;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				memoryAccess.mask <= MT_H;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				memoryAccess.req <= ME_WR;
				reg_rd_en <= true;
				wb_sel <= WB_X;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_150 =>
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= false;
				CtlToALU_data.alu_fun <= ALU_ADD;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				mem_en <= true;
				CtlToALU_data.op2_sel <= OP_IMM;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				memoryAccess.req <= ME_WR;
				reg_rd_en <= true;
				wb_sel <= WB_X;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
			when assign_151 =>
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToALU_data.alu_fun <= ALU_SRL;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToALU_data.op2_sel <= OP_IMM;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_152 =>
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				CtlToALU_data.alu_fun <= ALU_ADD;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				memoryAccess.req <= ME_RD;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				mem_en <= true;
				CtlToALU_data.op2_sel <= OP_IMM;
				memoryAccess.mask <= MT_HU;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				wb_sel <= WB_MEM;
			when assign_153 =>
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToALU_data.alu_fun <= ALU_SRA;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToALU_data.op2_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_154 =>
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= false;
				CtlToALU_data.alu_fun <= ALU_ADD;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				mem_en <= true;
				CtlToALU_data.op2_sel <= OP_IMM;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				memoryAccess.req <= ME_WR;
				reg_rd_en <= true;
				wb_sel <= WB_X;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				memoryAccess.mask <= MT_W;
			when assign_155 =>
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToALU_data.alu_fun <= ALU_SRA;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToALU_data.op2_sel <= OP_IMM;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_156 =>
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToALU_data.alu_fun <= ALU_OR;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToALU_data.op2_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_157 =>
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToALU_data.op2_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_158 =>
				wb_sel <= WB_ALU;
				decodedInstr.instrType <= DecToCtl_port_sig.instrType;
				wb_en <= true;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.src2 <= DecToCtl_port_sig.rs2_addr;
				active_state <= st_readRegisterFile_10;
				CtlToRegs_data.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToRegs_data.src2 <= DecToCtl_port_sig.rs2_addr;
				CtlToRegs_port_sig.dst <= CtlToRegs_data.dst;
				CtlToRegs_port_sig.dst_data <= CtlToRegs_data.dst_data;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.req <= REG_RD;
				CtlToRegs_port_sig.src1 <= DecToCtl_port_sig.rs1_addr;
				CtlToALU_data.op1_sel <= OP_REG;
				CtlToALU_data.op2_sel <= OP_REG;
				CtlToMem_port_notify <= false;
				CtlToALU_data.alu_fun <= ALU_AND;
				decodedInstr.rd_addr <= DecToCtl_port_sig.rd_addr;
				br_en <= false;
				reg_rd_en <= true;
				decodedInstr.imm <= DecToCtl_port_sig.imm;
				mem_en <= false;
			when assign_159 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				active_state <= st_executeALU_5;
				CtlToMem_port_notify <= false;
			when assign_160 =>
				CtlToMem_port_notify <= true;
				CtlToMem_port_sig.req <= ME_RD;
				CtlToRegs_port_notify <= false;
				pc_reg <= x"00000004" + pc_reg;
				CtlToMem_port_sig.dataIn <= memoryAccess.dataIn;
				MemToCtl_port_notify <= false;
				memoryAccess.req <= ME_RD;
				CtlToDec_port_notify <= false;
				memoryAccess.addrIn <= x"00000004" + pc_reg;
				CtlToMem_port_sig.mask <= MT_W;
				active_state <= st_fetch_6;
				CtlToMem_port_sig.addrIn <= x"00000004" + pc_reg;
				pc_next <= x"00000004" + pc_reg;
				memoryAccess.mask <= MT_W;
			when assign_161 =>
				CtlToMem_port_notify <= true;
				CtlToMem_port_sig.req <= ME_RD;
				CtlToRegs_port_notify <= false;
				pc_reg <= pc_reg + decodedInstr.imm;
				CtlToMem_port_sig.dataIn <= memoryAccess.dataIn;
				pc_next <= pc_reg + decodedInstr.imm;
				MemToCtl_port_notify <= false;
				memoryAccess.req <= ME_RD;
				CtlToDec_port_notify <= false;
				CtlToMem_port_sig.addrIn <= pc_reg + decodedInstr.imm;
				CtlToMem_port_sig.mask <= MT_W;
				memoryAccess.addrIn <= pc_reg + decodedInstr.imm;
				active_state <= st_fetch_6;
				memoryAccess.mask <= MT_W;
			when assign_162 =>
				CtlToMem_port_notify <= true;
				pc_next <= RegsToCtl_data.contents1 + decodedInstr.imm;
				CtlToMem_port_sig.req <= ME_RD;
				CtlToRegs_port_notify <= false;
				CtlToMem_port_sig.dataIn <= memoryAccess.dataIn;
				MemToCtl_port_notify <= false;
				memoryAccess.req <= ME_RD;
				CtlToDec_port_notify <= false;
				memoryAccess.addrIn <= RegsToCtl_data.contents1 + decodedInstr.imm;
				CtlToMem_port_sig.addrIn <= RegsToCtl_data.contents1 + decodedInstr.imm;
				CtlToMem_port_sig.mask <= MT_W;
				pc_reg <= RegsToCtl_data.contents1 + decodedInstr.imm;
				active_state <= st_fetch_6;
				memoryAccess.mask <= MT_W;
			when assign_163 =>
				CtlToMem_port_notify <= true;
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_sig.req <= memoryAccess.req;
				CtlToMem_port_sig.dataIn <= RegsToCtl_data.contents2;
				active_state <= st_memoryOperation_8;
				memoryAccess.dataIn <= RegsToCtl_data.contents2;
				CtlToMem_port_sig.mask <= memoryAccess.mask;
				CtlToMem_port_sig.addrIn <= ALUtoCtl_data.ALU_result;
				pc_next <= x"00000004" + pc_reg;
				memoryAccess.addrIn <= ALUtoCtl_data.ALU_result;
			when assign_164 =>
				CtlToMem_port_notify <= true;
				CtlToRegs_port_notify <= false;
				pc_next <= pc_reg + decodedInstr.imm;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_sig.req <= memoryAccess.req;
				CtlToMem_port_sig.dataIn <= RegsToCtl_data.contents2;
				active_state <= st_memoryOperation_8;
				memoryAccess.dataIn <= RegsToCtl_data.contents2;
				CtlToMem_port_sig.mask <= memoryAccess.mask;
				CtlToMem_port_sig.addrIn <= ALUtoCtl_data.ALU_result;
				memoryAccess.addrIn <= ALUtoCtl_data.ALU_result;
			when assign_165 =>
				CtlToMem_port_notify <= true;
				pc_next <= RegsToCtl_data.contents1 + decodedInstr.imm;
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_sig.req <= memoryAccess.req;
				CtlToMem_port_sig.dataIn <= RegsToCtl_data.contents2;
				active_state <= st_memoryOperation_8;
				memoryAccess.dataIn <= RegsToCtl_data.contents2;
				CtlToMem_port_sig.mask <= memoryAccess.mask;
				CtlToMem_port_sig.addrIn <= ALUtoCtl_data.ALU_result;
				memoryAccess.addrIn <= ALUtoCtl_data.ALU_result;
			when assign_166 =>
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.req <= REG_WR;
				CtlToRegs_port_sig.src1 <= CtlToRegs_data.src1;
				CtlToRegs_port_sig.src2 <= CtlToRegs_data.src2;
				active_state <= st_writeBack_13;
				CtlToRegs_port_notify <= true;
				CtlToRegs_data.dst_data <= ALUtoCtl_data.ALU_result;
				CtlToRegs_port_sig.dst <= decodedInstr.rd_addr;
				CtlToRegs_port_sig.dst_data <= ALUtoCtl_data.ALU_result;
				CtlToMem_port_notify <= false;
				CtlToRegs_data.dst <= decodedInstr.rd_addr;
				pc_next <= x"00000004" + pc_reg;
			when assign_167 =>
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.req <= REG_WR;
				CtlToRegs_port_sig.src1 <= CtlToRegs_data.src1;
				CtlToRegs_port_sig.src2 <= CtlToRegs_data.src2;
				CtlToRegs_data.dst_data <= fromMemoryData.loadedData;
				active_state <= st_writeBack_13;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.dst <= decodedInstr.rd_addr;
				CtlToRegs_port_sig.dst_data <= fromMemoryData.loadedData;
				CtlToMem_port_notify <= false;
				CtlToRegs_data.dst <= decodedInstr.rd_addr;
				pc_next <= x"00000004" + pc_reg;
			when assign_168 =>
				pc_next <= pc_reg + decodedInstr.imm;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.req <= REG_WR;
				CtlToRegs_port_sig.src1 <= CtlToRegs_data.src1;
				CtlToRegs_port_sig.src2 <= CtlToRegs_data.src2;
				active_state <= st_writeBack_13;
				CtlToRegs_port_notify <= true;
				CtlToRegs_data.dst_data <= ALUtoCtl_data.ALU_result;
				CtlToRegs_port_sig.dst <= decodedInstr.rd_addr;
				CtlToRegs_port_sig.dst_data <= ALUtoCtl_data.ALU_result;
				CtlToMem_port_notify <= false;
				CtlToRegs_data.dst <= decodedInstr.rd_addr;
			when assign_169 =>
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.req <= REG_WR;
				CtlToRegs_port_sig.src1 <= CtlToRegs_data.src1;
				CtlToRegs_port_sig.src2 <= CtlToRegs_data.src2;
				active_state <= st_writeBack_13;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.dst <= decodedInstr.rd_addr;
				CtlToRegs_data.dst_data <= x"00000004" + pc_reg;
				CtlToRegs_port_sig.dst_data <= x"00000004" + pc_reg;
				CtlToMem_port_notify <= false;
				CtlToRegs_data.dst <= decodedInstr.rd_addr;
				pc_next <= x"00000004" + pc_reg;
			when assign_170 =>
				pc_next <= pc_reg + decodedInstr.imm;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.req <= REG_WR;
				CtlToRegs_port_sig.src1 <= CtlToRegs_data.src1;
				CtlToRegs_port_sig.src2 <= CtlToRegs_data.src2;
				CtlToRegs_data.dst_data <= fromMemoryData.loadedData;
				active_state <= st_writeBack_13;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.dst <= decodedInstr.rd_addr;
				CtlToRegs_port_sig.dst_data <= fromMemoryData.loadedData;
				CtlToMem_port_notify <= false;
				CtlToRegs_data.dst <= decodedInstr.rd_addr;
			when assign_171 =>
				pc_next <= pc_reg + decodedInstr.imm;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.req <= REG_WR;
				CtlToRegs_port_sig.src1 <= CtlToRegs_data.src1;
				CtlToRegs_port_sig.src2 <= CtlToRegs_data.src2;
				active_state <= st_writeBack_13;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.dst <= decodedInstr.rd_addr;
				CtlToRegs_data.dst_data <= x"00000004" + pc_reg;
				CtlToRegs_port_sig.dst_data <= x"00000004" + pc_reg;
				CtlToMem_port_notify <= false;
				CtlToRegs_data.dst <= decodedInstr.rd_addr;
			when assign_172 =>
				pc_next <= RegsToCtl_data.contents1 + decodedInstr.imm;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.req <= REG_WR;
				CtlToRegs_port_sig.src1 <= CtlToRegs_data.src1;
				CtlToRegs_port_sig.src2 <= CtlToRegs_data.src2;
				active_state <= st_writeBack_13;
				CtlToRegs_port_notify <= true;
				CtlToRegs_data.dst_data <= ALUtoCtl_data.ALU_result;
				CtlToRegs_port_sig.dst <= decodedInstr.rd_addr;
				CtlToRegs_port_sig.dst_data <= ALUtoCtl_data.ALU_result;
				CtlToMem_port_notify <= false;
				CtlToRegs_data.dst <= decodedInstr.rd_addr;
			when assign_173 =>
				pc_next <= RegsToCtl_data.contents1 + decodedInstr.imm;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.req <= REG_WR;
				CtlToRegs_port_sig.src1 <= CtlToRegs_data.src1;
				CtlToRegs_port_sig.src2 <= CtlToRegs_data.src2;
				CtlToRegs_data.dst_data <= fromMemoryData.loadedData;
				active_state <= st_writeBack_13;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.dst <= decodedInstr.rd_addr;
				CtlToRegs_port_sig.dst_data <= fromMemoryData.loadedData;
				CtlToMem_port_notify <= false;
				CtlToRegs_data.dst <= decodedInstr.rd_addr;
			when assign_174 =>
				pc_next <= RegsToCtl_data.contents1 + decodedInstr.imm;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.req <= REG_WR;
				CtlToRegs_port_sig.src1 <= CtlToRegs_data.src1;
				CtlToRegs_port_sig.src2 <= CtlToRegs_data.src2;
				active_state <= st_writeBack_13;
				CtlToRegs_port_notify <= true;
				CtlToRegs_port_sig.dst <= decodedInstr.rd_addr;
				CtlToRegs_data.dst_data <= x"00000004" + pc_reg;
				CtlToRegs_port_sig.dst_data <= x"00000004" + pc_reg;
				CtlToMem_port_notify <= false;
				CtlToRegs_data.dst <= decodedInstr.rd_addr;
			when assign_175 =>
				CtlToMem_port_notify <= true;
				CtlToRegs_port_notify <= false;
				CtlToMem_port_sig.dataIn <= memoryAccess.dataIn;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_sig.req <= memoryAccess.req;
				CtlToMem_port_sig.addrIn <= memoryAccess.addrIn;
				CtlToMem_port_sig.mask <= memoryAccess.mask;
				active_state <= st_fetch_6;
			when assign_176 =>
				CtlToRegs_port_notify <= false;
				CtlToDec_port_notify <= false;
				active_state <= st_fetch_7;
				MemToCtl_port_notify <= true;
				CtlToMem_port_notify <= false;
			when assign_177 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				active_state <= st_decode_1;
				CtlToDec_port_notify <= true;
				CtlToDec_port_sig <= MemToCtl_port_sig.loadedData;
				CtlToMem_port_notify <= false;
			when assign_178 =>
				CtlToMem_port_notify <= true;
				CtlToRegs_port_notify <= false;
				CtlToMem_port_sig.dataIn <= memoryAccess.dataIn;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToMem_port_sig.req <= memoryAccess.req;
				active_state <= st_memoryOperation_8;
				CtlToMem_port_sig.addrIn <= memoryAccess.addrIn;
				CtlToMem_port_sig.mask <= memoryAccess.mask;
			when assign_179 =>
				CtlToRegs_port_notify <= false;
				CtlToDec_port_notify <= false;
				MemToCtl_port_notify <= true;
				active_state <= st_memoryOperation_9;
				CtlToMem_port_notify <= false;
			when assign_180 =>
				CtlToMem_port_notify <= true;
				CtlToMem_port_sig.req <= ME_RD;
				CtlToRegs_port_notify <= false;
				CtlToMem_port_sig.dataIn <= memoryAccess.dataIn;
				MemToCtl_port_notify <= false;
				memoryAccess.req <= ME_RD;
				CtlToDec_port_notify <= false;
				CtlToMem_port_sig.mask <= MT_W;
				pc_reg <= pc_next;
				fromMemoryData.loadedData <= MemToCtl_port_sig.loadedData;
				CtlToMem_port_sig.addrIn <= pc_next;
				memoryAccess.addrIn <= pc_next;
				active_state <= st_fetch_6;
				memoryAccess.mask <= MT_W;
			when assign_181 =>
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.req <= REG_WR;
				CtlToRegs_port_sig.src1 <= CtlToRegs_data.src1;
				CtlToRegs_port_sig.src2 <= CtlToRegs_data.src2;
				active_state <= st_writeBack_13;
				CtlToRegs_port_notify <= true;
				fromMemoryData.loadedData <= MemToCtl_port_sig.loadedData;
				CtlToRegs_data.dst_data <= ALUtoCtl_data.ALU_result;
				CtlToRegs_port_sig.dst <= decodedInstr.rd_addr;
				CtlToRegs_port_sig.dst_data <= ALUtoCtl_data.ALU_result;
				CtlToMem_port_notify <= false;
				CtlToRegs_data.dst <= decodedInstr.rd_addr;
			when assign_182 =>
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.req <= REG_WR;
				CtlToRegs_port_sig.src1 <= CtlToRegs_data.src1;
				CtlToRegs_port_sig.src2 <= CtlToRegs_data.src2;
				active_state <= st_writeBack_13;
				CtlToRegs_port_sig.dst_data <= MemToCtl_port_sig.loadedData;
				CtlToRegs_data.dst_data <= MemToCtl_port_sig.loadedData;
				CtlToRegs_port_notify <= true;
				fromMemoryData.loadedData <= MemToCtl_port_sig.loadedData;
				CtlToRegs_port_sig.dst <= decodedInstr.rd_addr;
				CtlToMem_port_notify <= false;
				CtlToRegs_data.dst <= decodedInstr.rd_addr;
			when assign_183 =>
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				CtlToRegs_port_sig.req <= REG_WR;
				CtlToRegs_port_sig.src1 <= CtlToRegs_data.src1;
				CtlToRegs_port_sig.src2 <= CtlToRegs_data.src2;
				active_state <= st_writeBack_13;
				CtlToRegs_port_notify <= true;
				fromMemoryData.loadedData <= MemToCtl_port_sig.loadedData;
				CtlToRegs_port_sig.dst <= decodedInstr.rd_addr;
				CtlToRegs_data.dst_data <= x"00000004" + pc_reg;
				CtlToRegs_port_sig.dst_data <= x"00000004" + pc_reg;
				CtlToMem_port_notify <= false;
				CtlToRegs_data.dst <= decodedInstr.rd_addr;
			when assign_184 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				active_state <= st_readRegisterFile_11;
				CtlToMem_port_notify <= false;
			when assign_185 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= x"00000000";
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_186 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_port_sig.contents1 + RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_187 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_port_sig.contents1 - RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_188 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_port_sig.contents1 + decodedInstr.imm;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_189 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= decodedInstr.imm + RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_190 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_port_sig.contents1 and RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_191 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_port_sig.contents1 - decodedInstr.imm;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_192 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_port_sig.contents1 + pc_reg;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_193 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_port_sig.contents1;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_194 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= decodedInstr.imm - RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_195 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= decodedInstr.imm + decodedInstr.imm;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_196 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= pc_reg + RegsToCtl_port_sig.contents2;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_197 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= RegsToCtl_port_sig.contents2;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_198 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= RegsToCtl_port_sig.contents1 or RegsToCtl_port_sig.contents2;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_199 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= RegsToCtl_port_sig.contents1 and decodedInstr.imm;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_200 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= RegsToCtl_port_sig.contents1 - pc_reg;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_201 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= decodedInstr.imm and RegsToCtl_port_sig.contents2;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_202 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= pc_reg + decodedInstr.imm;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_203 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= decodedInstr.imm;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_204 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= pc_reg - RegsToCtl_port_sig.contents2;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_205 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= not(RegsToCtl_port_sig.contents2) + 1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_206 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= RegsToCtl_port_sig.contents1 xor RegsToCtl_port_sig.contents2;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_207 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= RegsToCtl_port_sig.contents1 or decodedInstr.imm;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_208 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= RegsToCtl_port_sig.contents1 and pc_reg;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_209 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= decodedInstr.imm or RegsToCtl_port_sig.contents2;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_210 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= decodedInstr.imm - pc_reg;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_211 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= pc_reg and RegsToCtl_port_sig.contents2;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_212 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= pc_reg - decodedInstr.imm;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_213 =>
				CtlToRegs_port_notify <= false;
				ALUtoCtl_data.ALU_result <= pc_reg + pc_reg;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_214 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				ALUtoCtl_data.ALU_result <= pc_reg;
				active_state <= st_executeALU_4;
			when assign_215 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				ALUtoCtl_data.ALU_result <= not(decodedInstr.imm) + 1;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_216 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				ALUtoCtl_data.ALU_result <= RegsToCtl_port_sig.contents1 xor decodedInstr.imm;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_217 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				ALUtoCtl_data.ALU_result <= RegsToCtl_port_sig.contents1 or pc_reg;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_218 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				ALUtoCtl_data.ALU_result <= decodedInstr.imm xor RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_219 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				ALUtoCtl_data.ALU_result <= decodedInstr.imm and pc_reg;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_220 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				ALUtoCtl_data.ALU_result <= pc_reg or RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_221 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				ALUtoCtl_data.ALU_result <= not(pc_reg) + 1;
				active_state <= st_executeALU_4;
			when assign_222 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= x"00000001";
			when assign_223 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= RegsToCtl_port_sig.contents1 xor pc_reg;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_224 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= decodedInstr.imm or pc_reg;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_225 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= pc_reg xor RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_226 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(RegsToCtl_port_sig.contents1, to_integer(RegsToCtl_port_sig.contents2 and to_unsigned(31, 32)));
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_227 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= decodedInstr.imm xor pc_reg;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_228 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(RegsToCtl_port_sig.contents1, to_integer(RegsToCtl_port_sig.contents2 and to_unsigned(31, 32)));
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_229 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				ALUtoCtl_data.ALU_result <= shift_left(RegsToCtl_port_sig.contents1, to_integer(decodedInstr.imm and to_unsigned(31, 32)));
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_230 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				ALUtoCtl_data.ALU_result <= shift_left(decodedInstr.imm, to_integer(RegsToCtl_port_sig.contents2 and to_unsigned(31, 32)));
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_231 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				ALUtoCtl_data.ALU_result <= shift_right(RegsToCtl_port_sig.contents1, to_integer(decodedInstr.imm and to_unsigned(31, 32)));
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_232 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= shift_left(RegsToCtl_port_sig.contents1, to_integer(pc_reg and to_unsigned(31, 32)));
			when assign_233 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(decodedInstr.imm, to_integer(RegsToCtl_port_sig.contents2 and to_unsigned(31, 32)));
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_234 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(decodedInstr.imm, to_integer(decodedInstr.imm and to_unsigned(31, 32)));
				active_state <= st_executeALU_4;
			when assign_235 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= shift_left(pc_reg, to_integer(RegsToCtl_port_sig.contents2 and to_unsigned(31, 32)));
			when assign_236 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(RegsToCtl_port_sig.contents1, to_integer(pc_reg and to_unsigned(31, 32)));
				active_state <= st_executeALU_4;
			when assign_237 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_right(decodedInstr.imm, to_integer(decodedInstr.imm and to_unsigned(31, 32)));
				active_state <= st_executeALU_4;
			when assign_238 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= shift_left(decodedInstr.imm, to_integer(pc_reg and to_unsigned(31, 32)));
			when assign_239 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
				ALUtoCtl_data.ALU_result <= shift_right(pc_reg, to_integer(RegsToCtl_port_sig.contents2 and to_unsigned(31, 32)));
			when assign_240 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				ALUtoCtl_data.ALU_result <= shift_left(pc_reg, to_integer(decodedInstr.imm and to_unsigned(31, 32)));
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_241 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				ALUtoCtl_data.ALU_result <= shift_right(decodedInstr.imm, to_integer(pc_reg and to_unsigned(31, 32)));
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_242 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				ALUtoCtl_data.ALU_result <= shift_right(pc_reg, to_integer(decodedInstr.imm and to_unsigned(31, 32)));
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_243 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				ALUtoCtl_data.ALU_result <= shift_left(pc_reg, to_integer(pc_reg and to_unsigned(31, 32)));
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_244 =>
				CtlToRegs_port_notify <= false;
				MemToCtl_port_notify <= false;
				CtlToDec_port_notify <= false;
				RegsToCtl_data.contents2 <= RegsToCtl_port_sig.contents2;
				ALUtoCtl_data.ALU_result <= shift_right(pc_reg, to_integer(pc_reg and to_unsigned(31, 32)));
				RegsToCtl_data.contents1 <= RegsToCtl_port_sig.contents1;
				CtlToMem_port_notify <= false;
				active_state <= st_executeALU_4;
			when assign_245 =>
				CtlToMem_port_notify <= true;
				CtlToMem_port_sig.req <= ME_RD;
				CtlToRegs_port_notify <= false;
				CtlToMem_port_sig.dataIn <= memoryAccess.dataIn;
				MemToCtl_port_notify <= false;
				memoryAccess.req <= ME_RD;
				CtlToDec_port_notify <= false;
				CtlToMem_port_sig.mask <= MT_W;
				pc_reg <= pc_next;
				CtlToMem_port_sig.addrIn <= pc_next;
				memoryAccess.addrIn <= pc_next;
				active_state <= st_fetch_6;
				memoryAccess.mask <= MT_W;
			end case;
		end if;
	end process;

	-- Assigning state signals that are used by ITL properties for OneSpin
	decode_1 <= active_state = st_decode_1;
	decode_2 <= active_state = st_decode_2;
	executeALU_4 <= active_state = st_executeALU_4;
	executeALU_5 <= active_state = st_executeALU_5;
	fetch_6 <= active_state = st_fetch_6;
	fetch_7 <= active_state = st_fetch_7;
	memoryOperation_8 <= active_state = st_memoryOperation_8;
	memoryOperation_9 <= active_state = st_memoryOperation_9;
	readRegisterFile_10 <= active_state = st_readRegisterFile_10;
	readRegisterFile_11 <= active_state = st_readRegisterFile_11;
	writeBack_13 <= active_state = st_writeBack_13;

end ISA_arch;

