import top_level_types::*;
import isa_new_types::*;

module ISA_new (
	input logic clk,
	input logic rst,
	input MEtoCU_IF fromMemoryPort,
	input logic fromMemoryPort_sync,
	output logic fromMemoryPort_notify,
	input unsigned_32 fromRegsPort,
	output CUtoME_IF toMemoryPort,
	input logic toMemoryPort_sync,
	output logic toMemoryPort_notify,
	output RegfileWriteType toRegsPort,
	output logic toRegsPort_notify
	);
	
	bit[31:0] pcReg_signal;
	bit[31:0] encodedInstr;
	RegfileWriteType regfileWrite_signal;
	Phases phase;

	always_ff @(posedge clk, posedge rst) begin
		bit[31:0] encodedInstr;
		EncType opcode;
		logic[4:0] rs1;
		logic[4:0] rs2;
		logic[4:0] rd;
		logic[31:0] aluOp1;
		logic[31:0] aluOp2;
		logic[31:0] aluResult;
		InstrType instr;
		ALUfuncType aluFunct;
		
		if (rst) begin
			phase <= fetch_ph;
			pcReg_signal = 0;
			toRegsPort.dst <= 0;
			toRegsPort.dstdata <= 0;
			fromMemoryPort_notify <= 1'b0;
			toMemoryPort_notify <= 1'b1;
			toRegsPort_notify <= 1'b0;
			toMemoryPort.addrin <= 1'b0;
			toMemoryPort.datain <= 32'b0;
			toMemoryPort.mask <= mt_w;
			toMemoryPort.req <= me_rd;
			rs1 = 5'b0;
			rs2 = 5'b0;
			aluOp1 = 32'b0;
			aluOp2 = 32'b0;
			aluResult = 32'b0;
			instr = instr_add;
			aluFunct = alu_add;
		end 
		else begin
			if (phase == fetch_ph) begin
			
				toRegsPort_notify <= 1'b0;

				if (toMemoryPort_sync == 1'b1) begin
					toMemoryPort_notify <= 1'b0;
					fromMemoryPort_notify <= 1'b1;
					phase <= execute_ph;
				end
			end
			if (phase == execute_ph) begin
				if(fromMemoryPort_sync == 1'b1) begin
					encodedInstr = fromMemoryPort.loadeddata;
					opcode = get_enc_type(encodedInstr);
					rs1 = encodedInstr[19:15];
					rs2 = encodedInstr[24:20];
					rd  = encodedInstr[11:7];
			
					fromMemoryPort_notify <= 1'b0;

					if (opcode == enc_r) begin
						aluOp1 = fromRegsPort[rs1];
						aluOp2 = fromRegsPort[rs2];
						instr = get_instr_type(encodedInstr);
						aluFunct = get_alu_funct(instr);
						aluResult = get_alu_result(aluFunct, aluOp1, aluOp2);

						toRegsPort.dst <= rd;
						toRegsPort.dstdata <= aluResult;
						toRegsPort_notify <= 1'b1;

						pcReg_signal = pcReg_signal + 4;
						toMemoryPort.addrin <= pcReg_signal;
						toMemoryPort_notify <= 1'b1;

						phase <= fetch_ph;
					end
					else if (opcode == enc_b) begin
						aluOp1 = fromRegsPort[rs1];
						aluOp2 = fromRegsPort[rs2];
						instr = get_instr_type(encodedInstr);
						aluFunct = get_alu_funct(instr);
						aluResult = get_alu_result(aluFunct, aluOp1, aluOp2);

						pcReg_signal = branch_PC_calculation(encodedInstr, aluResult, pcReg_signal);
						toMemoryPort.addrin <= pcReg_signal;
						toMemoryPort_notify <= 1'b1;
					
						phase <= fetch_ph;	
					end	
					else if (opcode == enc_s) begin	
						aluOp1 = fromRegsPort[rs1];
						aluOp2 = get_immediate(encodedInstr);
						aluResult = get_alu_result(alu_add, aluOp1, aluOp2);
						instr = get_instr_type(encodedInstr);

						toMemoryPort.mask <= get_memory_mask(instr);
						toMemoryPort.req <= me_wr;
						toMemoryPort.addrin <= aluResult;
						toMemoryPort.datain <= aluOp2;
						toMemoryPort_notify <= 1'b1;

						phase <= Store;
					end
					else if (opcode == enc_u) begin
						toRegsPort.dst <= rd;
						toRegsPort.dstdata <= get_Enc_U_ALU_result(encodedInstr, pcReg_signal);
						toRegsPort_notify <= 1'b1;
	
						pcReg_signal = pcReg_signal + 4;
						
						toMemoryPort.addrin <= pcReg_signal;
						toMemoryPort_notify <= 1'b1;

						phase <= fetch_ph;
					end
					else if (opcode == enc_j) begin
						toRegsPort.dst <= rd;
						toRegsPort.dstdata <= pcReg_signal + 4;
						toRegsPort_notify <= 1'b1;

						pcReg_signal = pcReg_signal + get_immediate(encodedInstr);
		
						toMemoryPort.addrin <= pcReg_signal;
						toMemoryPort_notify <= 1'b1;
		
						phase <= fetch_ph;
					end
					else if (opcode == enc_i_i) begin
						aluOp1 = fromRegsPort[rs1];
						aluOp2 = fromRegsPort[rs2];
						instr = get_instr_type(encodedInstr);
						aluFunct = get_alu_funct(instr);
						aluResult = get_alu_result(aluFunct, aluOp1, aluOp2);

						toRegsPort.dst <= rd;
						toRegsPort.dstdata <= aluResult;
						toRegsPort_notify <= 1'b1;

						pcReg_signal = pcReg_signal + 4;
						toMemoryPort.addrin <= pcReg_signal;
						toMemoryPort_notify <= 1'b1;
					
						phase <= fetch_ph;
					end
					else if (opcode == enc_i_l) begin	
						aluOp1 = fromRegsPort[rs1];
						aluOp2 = get_immediate(encodedInstr);
						instr = get_instr_type(encodedInstr);
						aluResult = get_alu_result(alu_add, aluOp1, aluOp2);
				
						toMemoryPort.mask <= get_memory_mask(instr);
						toMemoryPort.req <= me_rd;
						toMemoryPort.addrin <= aluResult;
						toMemoryPort.datain <= 1'b0;
						toMemoryPort_notify <= 1'b1;
	
						toRegsPort.dst <= rd;

						phase <= Load_req;
					end
					else if (opcode == enc_i_j) begin
						toRegsPort.dst <= rd;
						toRegsPort.dstdata <= pcReg_signal + 4;
						
						aluOp1 = fromRegsPort[rs1];
						pcReg_signal = aluOp1 + get_immediate(encodedInstr);
		
						toMemoryPort.addrin <= pcReg_signal;
						toMemoryPort_notify <= 1'b1;
					
						phase <= fetch_ph;
					end
					else begin
						toMemoryPort_notify <= 1'b1;
					
						phase <= fetch_ph;
					end
				end
			end
			else if (phase == Store) begin
				if (toMemoryPort_sync == 1'b1) begin
					toMemoryPort_notify <= 1'b0;
					fromMemoryPort_notify <= 1'b1;
					
					phase <= Store_done;
				end
			end
			else if (phase == Store_done) begin
				if (fromMemoryPort_sync == 1'b1) begin
					fromMemoryPort_notify <= 1'b0;
				
					pcReg_signal = pcReg_signal + 4;

					toMemoryPort_notify <= 1'b1;
					toMemoryPort.addrin <= pcReg_signal;
					toMemoryPort.datain <= 32'b0;
					toMemoryPort.mask   <= mt_w;
					toMemoryPort.req    <= me_rd;
					
					phase <= fetch_ph;
				end
			end
			else if (phase == Load_req) begin
				if (toMemoryPort_sync == 1'b1) begin
					toMemoryPort_notify <= 1'b0;
					fromMemoryPort_notify <= 1'b1;
					
					phase <= Load_done;
				end
			end
			else if (phase == Load_done) begin
				if (fromMemoryPort_sync == 1'b1) begin
					fromMemoryPort_notify <= 1'b0;
	
					toRegsPort.dstdata <= fromMemoryPort.loadeddata;
					toRegsPort_notify  <= 1'b1;

					pcReg_signal = pcReg_signal + 4;

					toMemoryPort_notify <= 1'b1;
					toMemoryPort.addrin <= pcReg_signal;
					toMemoryPort.datain <= 32'b0;
					toMemoryPort.mask   <= mt_w;
					toMemoryPort.req    <= me_rd;
					
					phase <= fetch_ph;
				end
			end
		end
	end
endmodule