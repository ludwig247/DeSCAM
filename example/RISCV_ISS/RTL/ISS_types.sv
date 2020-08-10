package iss_types;

	import top_level_types::*;
	typedef enum logic [1:0]{
		execute_ph,
		fetch_ph,
		mem_req_ph,
		mem_done_ph
	} Phases;
	
	const bit[6:0] OPCODE_R	  = 8'h33;  //0110011
	const bit[6:0] OPCODE_I_I = 8'h13;  //0010011
	const bit[6:0] OPCODE_I_L = 8'h03;  //0000011
	const bit[6:0] OPCODE_I_J = 8'h67;  //1100111
	const bit[6:0] OPCODE_S   = 8'h23;  //0100011
	const bit[6:0] OPCODE_B   = 8'h63;  //1100011
	const bit[6:0] OPCODE_U1  = 8'h37;  //0110111
	const bit[6:0] OPCODE_U2  = 8'h17;  //0010111
	const bit[6:0] OPCODE_J   = 8'h6F;  //1101111

	function EncType get_enc_type(bit[31:0] encodedInstr);
		bit[6:0] opcode; 
		opcode = encodedInstr[6:0];
		if (opcode == OPCODE_R) 	return enc_r;
		else if (opcode == OPCODE_I_I)  return enc_i_i;
		else if (opcode == OPCODE_I_L)  return enc_i_l;
		else if (opcode == OPCODE_I_J)  return enc_i_j;
		else if (opcode == OPCODE_S)    return enc_s;
		else if (opcode == OPCODE_B)    return enc_b;
		else if (opcode == OPCODE_U1 || opcode == OPCODE_U2)  return enc_u;
		else if (opcode == OPCODE_J)    return enc_j;
		else return enc_err;
	endfunction: get_enc_type;

	function InstrType get_instr_type(bit[31:0] encodedInstr);
		bit[6:0] opcode;
		bit [2:0] funct3;
		bit [6:0] funct7; 
		funct3 = encodedInstr[14:12];
                funct7 = encodedInstr[31:25];
		opcode = encodedInstr[6:0];
		if (opcode == OPCODE_R) begin
			if (funct3 == 'h00) begin
				if (funct7 == 'h00) begin
					return instr_add;
				end
				else if (funct7 =='h20) begin
					return instr_sub;
				end
				else begin
					return instr_unknown;
				end
			end
			else if (funct3 == 'h01) begin
				return instr_sll;
			end
			else if (funct3 == 'h02) begin
				return instr_slt;
			end
			else if (funct3 == 'h03) begin
				return instr_sltu;
			end
			else if (funct3 == 'h04) begin
				return instr_xor;
			end
			else if (funct3 == 'h05) begin
				if (funct7 == 'h00) begin
					return instr_srl;
				end
				else if (funct7 == 'h20) begin
					return instr_sra;
				end
				else begin
					return instr_unknown;
				end
			end
			else if (funct3 == 'h06) begin
				return instr_or;
			end
			else if (funct3 == 'h07) begin
				return instr_and;
			end
			else begin
				return instr_unknown;
			end
		end
		else if (opcode == OPCODE_I_I) begin
			if (funct3 == 'h00) begin
				return instr_addi;
			end
			else if (funct3 == 3'h01) begin
				return instr_slli;
			end
			else if (funct3 == 'h02) begin
				return instr_slti;
			end
			else if (funct3 == 'h03) begin
				return instr_sltui;
			end
			else if (funct3 == 'h04) begin
				return instr_xori;
			end
			else if (funct3 == 'h05) begin
				if (funct7 == 'h00) begin
					return instr_srli;
				end
				else if (funct7 == 'h20) begin
					return instr_srai;
				end
				else begin
					return instr_unknown;
				end
			end
			else if (funct3 == 'h06) begin
				return instr_ori;
			end
			else if (funct3 == 'h07) begin
				return instr_andi;
			end
			else begin
				return instr_unknown;
			end
		end
		else if (opcode == OPCODE_I_L) begin
			if (funct3 == 'h00) begin
				return instr_lb;
			end
			else if (funct3 == 'h01) begin
				return instr_lh;
			end
         		else if (funct3 == 'h02) begin
				return instr_lw;
			end
         		else if (funct3 == 'h04) begin
				return instr_lbu;
			end
        		else if (funct3 == 'h05) begin
				return instr_lhu;
			end
        		else begin
				return instr_unknown;
			end
		end
    		else if (opcode == OPCODE_I_J) begin
			return instr_jalr;
		end
    		else if (opcode == OPCODE_S) begin
			if (funct3 == 'h00) begin
				return instr_sb;
			end
         		else if (funct3 == 'h01) begin
				return instr_sh;
			end
         		else if (funct3 == 'h02) begin
				return instr_sw;
			end
         		else begin
				return instr_unknown;
			end
		end
     		else if (opcode == OPCODE_B) begin
			if (funct3 == 'h00) begin
				return instr_beq;
			end
        		else if (funct3 == 'h01) begin
				return instr_bne;
			end
        		else if (funct3 == 'h04) begin
				return instr_blt;
			end
         		else if (funct3 == 'h05) begin
				return instr_bge;
			end
        		else if (funct3 == 'h06) begin
				return instr_bltu;
			end
         		else if (funct3 == 'h07) begin
				return instr_bgeu;
			end
        		else begin
				return instr_unknown;
			end
		end
     		else if (opcode == OPCODE_U1) begin
			return instr_lui;
		end
     		else if (opcode == OPCODE_U2) begin
			return instr_auipc;
		end
     		else if (opcode == OPCODE_J) begin
			return instr_jal;
		end
     		else begin
			return instr_unknown;
		end
	endfunction: get_instr_type;

	function ALUfuncType get_alu_funct(InstrType instr);
		if(instr == instr_add || instr == instr_addi || instr == instr_lb || instr == instr_lh || instr == instr_lw || instr == instr_lbu || instr == instr_lhu || instr == instr_sb|| instr == instr_sh || instr == instr_sw || instr == instr_auipc) 
			return alu_add;
		else if (instr == instr_sub || instr == instr_beq|| instr == instr_bne) 
			return alu_sub;
		else if (instr == instr_sll || instr == instr_slli) 
			return alu_sll;
		else if (instr == instr_slt || instr == instr_slti || instr == instr_blt || instr == instr_bge) 
			return alu_slt;
		else if (instr == instr_sltu || instr == instr_sltui || instr == instr_bltu || instr == instr_bgeu) 
			return alu_sltu;
		else if (instr == instr_xor || instr == instr_xori) 
			return alu_xor;
		else if (instr == instr_srl || instr == instr_srli) 
			return alu_srl;
		else if (instr == instr_sra || instr == instr_srai) 
			return alu_sra;
		else if (instr == instr_or || instr == instr_ori) 
			return alu_or;
		else if (instr == instr_and || instr == instr_andi) 
			return alu_and;
		else if (instr == instr_jalr || instr == instr_jal) 
			return alu_x;
		else if (instr == instr_lui) 
			return alu_copy1;
		else return alu_x;
	endfunction: get_alu_funct;

	function logic[31:0] get_alu_result(ALUfuncType alu_function, logic[31:0] aluOp1, logic[31:0] aluOp2);
		if (alu_function == alu_add) 
			return (aluOp1 + aluOp2);
     		else if (alu_function == alu_sub) 
			return (aluOp1 + (-aluOp2));
     		else if (alu_function == alu_and) 
			return (aluOp1 & aluOp2);
     		else if (alu_function == alu_or) 
			return (aluOp1 | aluOp2);
     		else if (alu_function == alu_xor) 
			return (aluOp1 ^ aluOp2);
     		else if (alu_function == alu_slt) begin
			if (signed'(32'(aluOp1)) < signed'(32'(aluOp2))) 
				return 1;
         		else 
				return 0;
		end
     		else if (alu_function == alu_sltu) begin
			if (aluOp1 < aluOp2) 
				return 1;
         		else 
				return 0;
		end
    		else if (alu_function == alu_sll) 
			return (aluOp1 << (aluOp2 & 'h1F));
     		else if (alu_function == alu_sra) 
			return (unsigned'(32'(signed'(32'(aluOp1)) >> signed'(32'(aluOp2 & 'h1F)))));
     		else if (alu_function == alu_srl) 
			return (aluOp1 >> (aluOp2 & 'h1F));
     		else if (alu_function == alu_copy1) 
			return aluOp1;
     		else 
			return 0;
	endfunction: get_alu_result;

	function logic[31:0] get_immediate(logic[31:0] encodedInstr);
		logic[6:0] opcode;
		opcode = encodedInstr[6:0];
		if (opcode == OPCODE_I_I || opcode == OPCODE_I_L || opcode == OPCODE_I_J) begin
			if (encodedInstr[31] == 0)
				return ({20'h00000, encodedInstr[31:20]});
			else
				return ({20'hFFFFF, encodedInstr[31:20]});
		end
     		else if (opcode == OPCODE_S) begin
			if (encodedInstr[31] == 0)
				return ({20'h00000, encodedInstr[31:25], encodedInstr[11:7]});
			else
				return ({20'hFFFFF, encodedInstr[31:25], encodedInstr[11:7]});
		end
     		else if (opcode == OPCODE_B) begin
			if (encodedInstr[31] == 0)
				return ({20'h00000, encodedInstr[7], encodedInstr[30:25], encodedInstr[11:8], 1'b0});
			else
				return ({20'hFFFFF, encodedInstr[7], encodedInstr[30:25], encodedInstr[11:8], 1'b0});
		end
     		else if (opcode == OPCODE_U1 || opcode == OPCODE_U2) begin
				return ({encodedInstr[31:12],12'h000});
		end
     		else if (opcode == OPCODE_J) begin
			if (encodedInstr[31] == 0)
				return ({12'h000, encodedInstr[19:12], encodedInstr[20], encodedInstr[30:21], 1'b0});
			else
				return ({12'hFFF, encodedInstr[19:12], encodedInstr[20], encodedInstr[30:21], 1'b0});
		end
     		else 
			return 0;
	endfunction: get_immediate;
    

	function ME_MaskType get_memory_mask(InstrType instr);
		if (instr == instr_lb || instr == instr_sb) 
			return mt_b;
     		else if (instr == instr_lh || instr == instr_sh) 
			return mt_h;
    		else if (instr == instr_lw || instr == instr_sw) 
			return mt_w;
     		else if (instr == instr_lbu) 
			return mt_bu;
     		else if (instr == instr_lhu) 
			return mt_hu;
     		else 
			return mt_x;
	endfunction: get_memory_mask;

	function logic[31:0] branch_PC_calculation(logic[31:0] encodedInstr, logic[31:0] aluResult, logic[31:0] pcReg);
		if (get_instr_type(encodedInstr) == instr_beq && aluResult == 0) 
			return pcReg + get_immediate(encodedInstr);
		else if (get_instr_type(encodedInstr) == instr_bne && aluResult != 0) 
			return pcReg + get_immediate(encodedInstr);
		else if (get_instr_type(encodedInstr) == instr_blt && aluResult == 1) 
			return pcReg + get_immediate(encodedInstr);
		else if (get_instr_type(encodedInstr) == instr_bge && aluResult == 0) 
			return pcReg + get_immediate(encodedInstr);
		else if (get_instr_type(encodedInstr) == instr_bltu && aluResult == 1) 
			return pcReg + get_immediate(encodedInstr);
		else if (get_instr_type(encodedInstr) == instr_bgeu && aluResult == 0) 
			return pcReg + get_immediate(encodedInstr);
		else 
			return pcReg + 4;
	endfunction: branch_PC_calculation;


	function logic[31:0] get_Enc_U_ALU_result(logic[31:0] encodedInstr, logic[31:0] pcReg);
		if (get_instr_type(encodedInstr) == instr_lui) 
			return get_alu_result(alu_copy1, get_immediate(encodedInstr), 0);
     		else 
			return get_alu_result(alu_add, pcReg, get_immediate(encodedInstr));
	endfunction: get_Enc_U_ALU_result
endpackage