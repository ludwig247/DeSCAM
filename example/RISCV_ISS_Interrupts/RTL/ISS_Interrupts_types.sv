package iss_interrupts_types;

	import top_level_types::*;
	typedef enum logic [2:0]{
		execute,
		fetch,
		ecall_req,
		ecall_done,
		mem_req_ph,
		mem_done_ph
	} Phases;
	
	const bit[6:0] OPCODE_R	  	= 8'h33;  //0110011
	const bit[6:0] OPCODE_I_I 	= 8'h13;  //0010011
	const bit[6:0] OPCODE_I_L 	= 8'h03;  //0000011
	const bit[6:0] OPCODE_I_J 	= 8'h67;  //1100111
	const bit[6:0] OPCODE_S   	= 8'h23;  //0100011
	const bit[6:0] OPCODE_B   	= 8'h63;  //1100011
	const bit[6:0] OPCODE_U1  	= 8'h37;  //0110111
	const bit[6:0] OPCODE_U2  	= 8'h17;  //0010111
	const bit[6:0] OPCODE_J   	= 8'h6F;  //1101111
	const bit[6:0] OPCODE_I_M	= 8'h0F;  //0001111
	const bit[6:0] OPCODE_I_S	= 8'h73;  //1110011

	const bit[31:0] MCSR_MSTATUS	= 32'h300;
	const bit[31:0] MCSR_MIE	= 32'h304;
	const bit[31:0] MCSR_MTVEC	= 32'h305;
	const bit[31:0] MCSR_MEPC	= 32'h341;
	const bit[31:0] MCSR_MCAUSE	= 32'h342;
	const bit[31:0] MCSR_MIP	= 32'h344;

	const bit[31:0] PRIVCODE_ECALL  = 32'h000;
	const bit[31:0] PRIVCODE_EBREAK = 32'h001;
	const bit[31:0] PRIVCODE_MRET   = 32'h302;

	function logic[31:0] MSTATUS_MIE(logic[31:0] x);
		return ((x) & (32'h00000008));
	endfunction: MSTATUS_MIE;

	function logic[31:0] MTRAP_MEI(logic[31:0] x);
		return ((x) & (32'h00000800));
	endfunction: MTRAP_MEI;

	function logic[31:0] MTRAP_MSI(logic[31:0] x);
		return ((x) & (32'h00000008));
	endfunction: MTRAP_MSI;

	function logic[31:0] MTRAP_MTI (logic[31:0] x);
		return ((x) & (32'h00000080));
	endfunction: MTRAP_MTI;

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
		else if (opcode == OPCODE_I_M)  return enc_i_m;
		else if (opcode == OPCODE_I_S)  return enc_i_s;
		else return enc_err;
	endfunction: get_enc_type;

	function InstrType_Complete get_instr_type(bit[31:0] encodedInstr);
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
			else if (funct3 == 'h01) begin
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
		else if (opcode == OPCODE_I_M) begin
			if (funct3 == 'h00) begin
				return instr_fence;
			end
			else if (funct3 == 'h01) begin
				return instr_fencei;
			end
			else begin 
				return instr_unknown;
			end
		end
		else if (opcode == OPCODE_I_S) begin
			if (funct3 == 'h00) begin
				return instr_priv;
			end
			else if (funct3 == 'h01) begin
				return instr_csrrw;
			end
         		else if (funct3 == 'h02) begin
				return instr_csrrs;
			end
         		else if (funct3 == 'h04) begin
				return instr_csrrc;
			end
        		else if (funct3 == 'h05) begin
				return instr_csrrwi;
			end
			else if (funct3 == 'h06) begin
				return instr_csrrsi;
			end
			else if (funct3 == 'h07) begin
				return instr_csrrci;
			end
        		else begin
				return instr_unknown;
			end
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

	function ALUfuncType get_alu_funct(InstrType_Complete instr);
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
		if (opcode == OPCODE_I_I || opcode == OPCODE_I_L || opcode == OPCODE_I_J || opcode == OPCODE_I_M || opcode == OPCODE_I_S) begin
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
    

	function ME_MaskType get_memory_mask(InstrType_Complete instr);
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

	function PrivInstrType get_priv_instr_type(logic[31:0] encodedInstr);
		if(PRIVCODE_ECALL == {20'h00000, encodedInstr[31:20]}) begin
			return instr_ecall;
		end
		else if(PRIVCODE_EBREAK == {20'h00000, encodedInstr[31:20]}) begin
			return instr_ebreak;
		end
		else if(PRIVCODE_MRET == {20'h00000, encodedInstr[31:20]}) begin
			return instr_mret;
		end
		else return instr_priv_unknown;
	endfunction: get_priv_instr_type
	
	function logic[31:0] get_CSR(CSRfileType csrfile, logic[31:0] encodedInstr);
		if(MCSR_MSTATUS == {20'h00000, encodedInstr[31:20]}) begin
			return csrfile.mstatus;
		end
		else if(MCSR_MIE == {20'h00000, encodedInstr[31:20]}) begin
			return csrfile.mie;
		end
		else if(MCSR_MTVEC == {20'h00000, encodedInstr[31:20]}) begin
			return csrfile.mtvec;
		end
		else if(MCSR_MEPC == {20'h00000, encodedInstr[31:20]}) begin
			return csrfile.mepc;
		end
		else if(MCSR_MCAUSE == {20'h00000, encodedInstr[31:20]}) begin
			return csrfile.mcause;
		end
		else if(MCSR_MIP == {20'h00000, encodedInstr[31:20]}) begin
			return csrfile.mip;
		end
		else return 0;
	endfunction: get_CSR

	function logic[31:0] get_CSR_result(InstrType_Complete instr, logic[31:0] rs1, logic[31:0] csr);
		if (instr == instr_csrrw || instr == instr_csrrwi) 
			return rs1;
		else if (instr == instr_csrrs || instr == instr_csrrsi) 
			return csr | rs1;
     		else if (instr == instr_csrrc || instr == instr_csrrci) 
			return csr & ((-rs1) - 1);
     		else return 0;
	endfunction: get_CSR_result

	function logic[31:0] update_PC(logic[31:0] mstatus, logic[31:0] mie, logic[31:0] mip, logic[31:0] mcause, logic[31:0] mtvec, logic[31:0] pcReg);
		if (MSTATUS_MIE(mstatus) != 0) begin
			if ((MTRAP_MEI(mie) != 0) && (MTRAP_MEI(mip) != 0))
				return mtvec;
        		else if ((MTRAP_MSI(mie) != 0) && (MTRAP_MSI(mip) != 0)) 
				return mtvec;
         		else if ((MTRAP_MTI(mie) != 0) && (MTRAP_MTI(mip) != 0)) 
				return mtvec;
			else if (mcause != 0)
				return mtvec;
         		else 
				return pcReg;
		end
		else return pcReg;	
	endfunction: update_PC

	function logic[31:0] update_MCAUSE(logic[31:0] mstatus, logic[31:0] mie, logic[31:0] mip, logic[31:0] mcause);
		if (MSTATUS_MIE(mstatus) != 0) begin
			if ((MTRAP_MEI(mie) != 0) && (MTRAP_MEI(mip) != 0)) 
				return 32'h8000000B; 
         		else if ((MTRAP_MSI(mie) != 0) && (MTRAP_MSI(mip) != 0)) 
				return 32'h80000003; 
         		else if ((MTRAP_MTI(mie) != 0) && (MTRAP_MTI(mip) != 0)) 
				return 32'h80000007; 
        		else if (mcause != 0)  
				return mcause; 
         		else return mcause;	
		end
    		else return mcause;
	endfunction: update_MCAUSE

	function logic[31:0] update_MSTATUS(logic[31:0] mstatus, logic[31:0] mie, logic[31:0] mip, logic[31:0] mcause);
		if (MSTATUS_MIE(mstatus) != 0) begin
			if ((MTRAP_MEI(mie) != 0) && (MTRAP_MEI(mip) != 0)) 
				return mstatus & (unsigned'(32'hFFFFFFF7)); 
         		else if ((MTRAP_MSI(mie) != 0) && (MTRAP_MSI(mip) != 0)) 
				return mstatus & (unsigned'(32'hFFFFFFF7));
         		else if ((MTRAP_MTI(mie) != 0) && (MTRAP_MTI(mip) != 0)) 
				return mstatus & (unsigned'(32'hFFFFFFF7));
         		else if (mcause != 0) 
				return mstatus & (unsigned'(32'hFFFFFFF7));
         		else return mstatus;
		end
     		else return mstatus;
	endfunction: update_MSTATUS

	function logic[31:0] update_MEPC(logic[31:0] mstatus, logic[31:0] mie, logic[31:0] mip, logic[31:0] mcause, logic[31:0] mepc, logic[31:0] pcReg);
		if (MSTATUS_MIE(mstatus) != 0) begin
			if ((MTRAP_MEI(mie) != 0) && (MTRAP_MEI(mip) != 0)) 
				return pcReg; 
         		else if ((MTRAP_MSI(mie) != 0) && (MTRAP_MSI(mip) != 0)) 
				return pcReg; 
         		else if ((MTRAP_MTI(mie) != 0) && (MTRAP_MTI(mip) != 0)) 
				return pcReg; 
         		else if (mcause != 0)
				return mepc; 
         		else return mepc;
		end
     		else return mepc;
	endfunction: update_MEPC
endpackage