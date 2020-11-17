//Created by Luis Rivas on 15/06/2020
//RTL implementation of a RISCV ISA


import top_level_types::*;
import iss_interrupts_types::*;

module ISS_Interrupts (
	input logic clk,
	input logic rst,
	output logic isa_ecall_Port,			
	input logic isa_ecall_Port_sync,	
	output logic isa_ecall_Port_notify,	
	input logic ecall_isa_Port,		
	input logic ecall_isa_Port_sync,	
	output logic ecall_isa_Port_notify,	
	input logic[31:0] mip_isa_Port,
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
	EncType opcode;
	bit[31:0] encodedInstr;
	CSRfileType csrfile;
	bit sysRES;
	always_ff @(posedge clk, posedge rst) begin
		logic[31:0] aluOp1;
		logic[31:0] aluOp2;
		logic[31:0] aluResult;
		Phases next_phase;
		if (rst) begin
			csrfile.mcause = 1'b0;
			csrfile.mepc = 1'b0;
			csrfile.mie = 1'b0;
			csrfile.mip = 1'b0;
			csrfile.mstatus = 1'b0;
			csrfile.mtvec = 1'b0;
			next_phase = fetch;
			phase <= fetch;
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
			isa_ecall_Port_notify <= 1'b0;
			ecall_isa_Port_notify <= 1'b0;
			sysRES <= 1'b1;
		end 
		else begin
			case (phase)
				fetch: begin
					toRegsPort_notify <= 1'b0;
					isa_ecall_Port_notify <= 1'b0;
					ecall_isa_Port_notify <= 1'b0;
					if (toMemoryPort_sync == 1'b1) begin
						toMemoryPort_notify <= 1'b0;
						fromMemoryPort_notify <= 1'b1;
						next_phase = execute;
					end
				end
				execute: begin
					if(fromMemoryPort_sync == 1'b1) begin
						fromMemoryPort_notify <= 1'b0;
						toMemoryPort_notify <= 1'b1;
						encodedInstr = fromMemoryPort.loadeddata;
						opcode = get_enc_type(encodedInstr);
						aluOp1 = fromRegsPort[encodedInstr[19:15]]; //rs1 = encodedInstr[19:15]
						if (opcode == enc_i_i || opcode == enc_s || opcode == enc_i_l) aluOp2 = get_immediate(encodedInstr);
						else aluOp2 = fromRegsPort[encodedInstr[24:20]]; //rs2 = encodedInstr[24:20]
						aluResult = get_alu_result(get_alu_funct(get_instr_type(encodedInstr)), aluOp1, aluOp2);

						if (opcode == enc_r || opcode == enc_i_i) begin
							toRegsPort.dstdata <= aluResult;
							next_phase = fetch;
						end
						else if (opcode == enc_b) begin
							pcReg_signal = branch_PC_calculation(encodedInstr, aluResult, pcReg_signal);
							next_phase = fetch;
						end	
						else if (opcode == enc_s || opcode == enc_i_l) begin	
							aluResult = get_alu_result(alu_add, aluOp1, aluOp2);
							toMemoryPort.mask <= get_memory_mask(get_instr_type(encodedInstr));
							toMemoryPort.addrin <= aluResult;
							next_phase = mem_req_ph;

							if(opcode == enc_s) begin
								toMemoryPort.req <= me_wr;
								toMemoryPort.datain <= fromRegsPort[encodedInstr[24:20]];
							end
							else begin
								toRegsPort.dst <= encodedInstr[11:7];
								toMemoryPort.datain <= 0;
								toMemoryPort.req <= me_rd;
							end
						end
						else if (opcode == enc_u) begin
							toRegsPort.dstdata <= get_Enc_U_ALU_result(encodedInstr, pcReg_signal);	
							next_phase = fetch;
						end
						else if (opcode == enc_j || opcode == enc_i_j) begin
							toRegsPort.dstdata <= pcReg_signal + 4;
							if(opcode == enc_i_j) pcReg_signal = aluOp1 + get_immediate(encodedInstr);
							else pcReg_signal += get_immediate(encodedInstr);
							next_phase = fetch;
						end
						else if (opcode == enc_i_s) begin
							if (get_instr_type(encodedInstr) == instr_csrrw || get_instr_type(encodedInstr) == instr_csrrs || get_instr_type(encodedInstr) == instr_csrrc || get_instr_type(encodedInstr) == instr_csrrci || get_instr_type(encodedInstr) == instr_csrrsi ||  get_instr_type(encodedInstr) == instr_csrrwi) begin

								toRegsPort.dst <= encodedInstr[11:7];
								toRegsPort_notify <= 1'b1;
								aluOp2 = get_CSR(csrfile, encodedInstr);
								toRegsPort.dstdata <= aluOp2;

								if (get_instr_type(encodedInstr) == instr_csrrci || get_instr_type(encodedInstr) == instr_csrrsi || get_instr_type(encodedInstr) == instr_csrrwi) begin
									aluOp1 = encodedInstr[19:15];
								end
								
								aluResult = get_CSR_result(get_instr_type(encodedInstr), aluOp1, aluOp2);
								if (get_immediate(encodedInstr) == MCSR_MSTATUS) csrfile.mstatus = aluResult;
								else if (get_immediate(encodedInstr) == MCSR_MIE) csrfile.mie = aluResult;
								else if (get_immediate(encodedInstr) == MCSR_MTVEC) csrfile.mtvec = aluResult;
								else if (get_immediate(encodedInstr) == MCSR_MEPC) csrfile.mepc = aluResult;
								else if (get_immediate(encodedInstr) == MCSR_MCAUSE) csrfile.mcause = aluResult;
								else if (get_immediate(encodedInstr) == MCSR_MIP) csrfile.mip = aluResult;
		
								next_phase = fetch;
							end
							else if (get_instr_type(encodedInstr) == instr_priv) begin
								if (get_priv_instr_type(encodedInstr) == instr_ecall) begin
									isa_ecall_Port <= 1'b1;
									isa_ecall_Port_notify <= 1'b1;
									toMemoryPort_notify <=1'b0;
									toRegsPort_notify <= 1'b0;
									next_phase = ecall_req;
								end
								else if (get_priv_instr_type(encodedInstr) == instr_ebreak) begin
									sysRES <= 1'b0;
									next_phase = fetch;
								end
								else if (get_priv_instr_type(encodedInstr) == instr_mret) begin
									csrfile.mstatus = csrfile.mstatus | 'h00000008; 
									csrfile.mcause = 0;
									pcReg_signal = csrfile.mepc;
									next_phase = fetch;
								end
								else begin
								next_phase = fetch;
									end
							end
							else begin 
								next_phase = fetch;
								toRegsPort_notify <= 1'b0;
							end
						end
						else next_phase = fetch;
					end
				end
				mem_req_ph: begin
					if (toMemoryPort_sync == 1'b1) begin
						if (opcode == enc_s) next_phase = fetch;
						else begin
							toMemoryPort_notify <= 1'b0;
							fromMemoryPort_notify <= 1'b1;
							next_phase = mem_done_ph;
						end
					end
				end
				mem_done_ph: begin
					if (fromMemoryPort_sync == 1'b1) begin
						fromMemoryPort_notify <= 1'b0;
						next_phase = fetch;
						toRegsPort.dstdata <= fromMemoryPort.loadeddata;
						toRegsPort_notify  <= 1'b1;
					end
				end
				ecall_req: begin
					if (isa_ecall_Port_sync == 1'b1) begin
						isa_ecall_Port_notify <= 1'b0;
						ecall_isa_Port_notify <= 1'b1;
						next_phase = ecall_done;
					end
				end
				ecall_done: begin
					if (ecall_isa_Port_sync == 1'b1) begin
						sysRES <= ecall_isa_Port;
						isa_ecall_Port_notify <= 1'b0;
						ecall_isa_Port_notify <= 1'b0;
						next_phase = fetch;
					end
				end
			endcase
			if (next_phase == fetch && phase != fetch) begin
				if (opcode == enc_r || opcode == enc_i_i || opcode == enc_u || opcode == enc_i_l || opcode == enc_j || opcode == enc_i_j) 
					toRegsPort.dst <= encodedInstr[11:7]; //rd = encodedInstr[11:7]
				if (opcode == enc_r || opcode == enc_i_i || opcode == enc_u || opcode == enc_j || opcode == enc_i_j)
					toRegsPort_notify <= 1'b1;
				if (opcode != enc_b || opcode != enc_i_j || opcode != enc_j || (opcode == enc_i_s && get_priv_instr_type(encodedInstr) != instr_mret)) 
					pcReg_signal += 4;
				csrfile.mip = mip_isa_Port;
				csrfile.mcause = update_MCAUSE(csrfile.mstatus, csrfile.mie, csrfile.mip, csrfile.mcause);
				csrfile.mepc = update_MEPC(csrfile.mstatus, csrfile.mie, csrfile.mip, csrfile.mcause, csrfile.mepc, pcReg_signal);
				pcReg_signal = update_PC(csrfile.mstatus, csrfile.mie, csrfile.mip, csrfile.mcause, csrfile.mtvec, pcReg_signal);
				csrfile.mstatus = update_MSTATUS(csrfile.mstatus, csrfile.mie, csrfile.mip, csrfile.mcause); 
				toMemoryPort_notify <= 1'b1;
				toMemoryPort.addrin <= pcReg_signal;
				toMemoryPort.datain <= 32'b0;
				toMemoryPort.mask   <= mt_w;
				toMemoryPort.req    <= me_rd;
			end
			phase <= next_phase;
		end    
	end
endmodule