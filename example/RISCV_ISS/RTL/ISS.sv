import top_level_types::*;
import iss_types::*;

module ISS (
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
	Phases phase;
	bit[31:0] encodedInstr;
	EncType opcode;

	always_ff @(posedge clk, posedge rst) begin
		logic[31:0] aluOp1;
		logic[31:0] aluOp2;
		logic[31:0] aluResult;
		
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
		end 
		else begin
			case (phase)
				fetch_ph: begin
			
					toRegsPort_notify <= 1'b0;

					if (toMemoryPort_sync == 1'b1) begin
						toMemoryPort_notify <= 1'b0;
						fromMemoryPort_notify <= 1'b1;
						phase <= execute_ph;
					end
				end
				execute_ph: begin
					if(fromMemoryPort_sync == 1'b1) begin
						fromMemoryPort_notify <= 1'b0;
						toMemoryPort_notify <= 1'b1;

						encodedInstr = fromMemoryPort.loadeddata;
						opcode = get_enc_type(encodedInstr);
						aluOp1 = fromRegsPort[encodedInstr[19:15]]; //rs1 = encodedInstr[19:15]
						aluOp2 = fromRegsPort[encodedInstr[24:20]]; //rs2 = encodedInstr[24:20]
						aluResult = get_alu_result(get_alu_funct(get_instr_type(encodedInstr)), aluOp1, aluOp2);

						if (opcode == enc_r || opcode == enc_i_i) begin
							toRegsPort.dstdata <= aluResult;
							phase <= fetch_ph;
						end
						else if (opcode == enc_b) begin
							pcReg_signal = branch_PC_calculation(encodedInstr, aluResult, pcReg_signal);
							phase <= fetch_ph;	
						end	
						else if (opcode == enc_s || opcode == enc_i_l) begin	
							aluOp2 = get_immediate(encodedInstr);
							aluResult = get_alu_result(alu_add, aluOp1, aluOp2);
							toMemoryPort.mask <= get_memory_mask(get_instr_type(encodedInstr));
							toMemoryPort.addrin <= aluResult;
							phase <= mem_req_ph;

							if(opcode == enc_s) begin
								toMemoryPort.req <= me_wr;
								toMemoryPort.datain <= aluOp2;
							end
							else begin	
								toMemoryPort.datain <= 1'b0;
								toMemoryPort.req <= me_rd;
							end
						end
						else if (opcode == enc_u) begin
							toRegsPort.dstdata <= get_Enc_U_ALU_result(encodedInstr, pcReg_signal);		
							phase <= fetch_ph;
						end
						else if (opcode == enc_j || opcode == enc_i_j) begin
							toRegsPort.dstdata <= pcReg_signal + 4;
							if(opcode == enc_i_j) pcReg_signal = aluOp1 + get_immediate(encodedInstr);
							else pcReg_signal += get_immediate(encodedInstr);
							phase <= fetch_ph;
						end
						else phase <= fetch_ph;
						if (opcode == enc_r || opcode == enc_i_i || opcode == enc_u) pcReg_signal = pcReg_signal + 4;
						if (opcode != enc_s && opcode !== enc_i_l) toMemoryPort.addrin <= pcReg_signal;
						if (opcode == enc_r || opcode == enc_i_i || opcode == enc_u || opcode == enc_i_l || opcode == enc_j || opcode == enc_i_j) 
							toRegsPort.dst <= encodedInstr[11:7]; //rd = encodedInstr[11:7]
						if (opcode == enc_r || opcode == enc_i_i || opcode == enc_u || opcode == enc_j || opcode == enc_i_j)
							toRegsPort_notify <= 1'b1;				
					end
				end
				mem_req_ph: begin
					if (toMemoryPort_sync == 1'b1) begin
						toMemoryPort_notify <= 1'b0;
						fromMemoryPort_notify <= 1'b1;
						phase <= mem_done_ph;
					end
				end
				mem_done_ph: begin
					if (fromMemoryPort_sync == 1'b1) begin
						fromMemoryPort_notify <= 1'b0;
				
						pcReg_signal = pcReg_signal + 4;

						toMemoryPort_notify <= 1'b1;
						toMemoryPort.addrin <= pcReg_signal;
						toMemoryPort.datain <= 32'b0;
						toMemoryPort.mask   <= mt_w;
						toMemoryPort.req    <= me_rd;
					
						phase <= fetch_ph;

						if (opcode == enc_i_l) begin
							toRegsPort.dstdata <= fromMemoryPort.loadeddata;
							toRegsPort_notify  <= 1'b1;
						end
					end
				end
			endcase
		end
	end
endmodule