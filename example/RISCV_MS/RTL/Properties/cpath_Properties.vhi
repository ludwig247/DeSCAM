-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
--macro CtlToALU_port_notify  :  boolean  := end macro; 
--macro CtlToDec_port_notify  :  boolean  := end macro; 
--macro CtlToMem_port_notify  :  boolean  := end macro; 
--macro CtlToMem_port_sync    :  boolean  := end macro; 
--macro CtlToRegs_port_notify :  boolean  := end macro; 
--macro MemToCtl_port_notify  :  boolean  := end macro; 
--macro MemToCtl_port_sync    :  boolean  := end macro; 


-- DP SIGNALS -- 
macro ALUtoCtl_port_sig_ALU_result    : unsigned       := ALUtoCtl_port.ALU_result    end macro; 
macro CtlToALU_port_sig_alu_fun       : ALU_function   := CtlToALU_port.alu_fun       end macro; 
macro CtlToALU_port_sig_imm           : unsigned       := CtlToALU_port.imm           end macro; 
macro CtlToALU_port_sig_op1_sel       : ALUopType      := CtlToALU_port.op1_sel       end macro; 
macro CtlToALU_port_sig_op2_sel       : ALUopType      := CtlToALU_port.op2_sel       end macro; 
macro CtlToALU_port_sig_pc_reg        : unsigned       := CtlToALU_port.pc_reg        end macro; 
macro CtlToALU_port_sig_reg1_contents : unsigned       := CtlToALU_port.reg1_contents end macro; 
macro CtlToALU_port_sig_reg2_contents : unsigned       := CtlToALU_port.reg2_contents end macro; 
macro CtlToDec_port_sig               : unsigned       := CtlToDec_port               end macro; 
macro CtlToMem_port_sig_addrIn        : unsigned       := CtlToMem_port.addrIn        end macro; 
macro CtlToMem_port_sig_dataIn        : unsigned       := CtlToMem_port.dataIn        end macro; 
macro CtlToMem_port_sig_mask          : MemMaskType    := CtlToMem_port.mask          end macro; 
macro CtlToMem_port_sig_req           : AccessType_Mem := CtlToMem_port.req           end macro; 
macro CtlToRegs_port_sig_dst          : unsigned       := CtlToRegs_port.dst          end macro; 
macro CtlToRegs_port_sig_dst_data     : unsigned       := CtlToRegs_port.dst_data     end macro; 
macro CtlToRegs_port_sig_req          : AccessType_Reg := CtlToRegs_port.req          end macro; 
macro CtlToRegs_port_sig_src1         : unsigned       := CtlToRegs_port.src1         end macro; 
macro CtlToRegs_port_sig_src2         : unsigned       := CtlToRegs_port.src2         end macro; 
macro DecToCtl_port_sig_encType       : EncType        := DecToCtl_port.encType       end macro; 
macro DecToCtl_port_sig_imm           : unsigned       := DecToCtl_port.imm           end macro; 
macro DecToCtl_port_sig_instrType     : InstrType      := DecToCtl_port.instrType     end macro; 
macro DecToCtl_port_sig_rd_addr       : unsigned       := DecToCtl_port.rd_addr       end macro; 
macro DecToCtl_port_sig_rs1_addr      : unsigned       := DecToCtl_port.rs1_addr      end macro; 
macro DecToCtl_port_sig_rs2_addr      : unsigned       := DecToCtl_port.rs2_addr      end macro; 
macro MemToCtl_port_sig               : unsigned       := MemToCtl_port               end macro; 
macro RegsToCtl_port_sig_contents1    : unsigned       := RegsToCtl_port.contents1    end macro; 
macro RegsToCtl_port_sig_contents2    : unsigned       := RegsToCtl_port.contents2    end macro;  
--macro clk_sig : bool := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro ALUtoCtl_data_ALU_result          : unsigned       := ALUtoCtl_data_signal.ALU_result          end macro; 
macro CtlToALU_data_alu_fun             : ALU_function   := CtlToALU_data_signal_alu_fun             end macro; 
macro CtlToALU_data_imm                 : unsigned       := CtlToALU_port.imm                        end macro; 
macro CtlToALU_data_op1_sel             : ALUopType      := CtlToALU_data_signal_op1_sel             end macro; 
macro CtlToALU_data_op2_sel             : ALUopType      := CtlToALU_data_signal_op2_sel             end macro; 
macro CtlToALU_data_pc_reg              : unsigned       := CtlToALU_port.pc_reg                     end macro; 
macro CtlToALU_data_reg1_contents       : unsigned       := CtlToALU_port.reg1_contents              end macro; 
macro CtlToALU_data_reg2_contents       : unsigned       := CtlToALU_port.reg2_contents              end macro; 
macro CtlToRegs_data_dst                : unsigned       := CtlToRegs_data_signal_dst                end macro; 
macro CtlToRegs_data_dst_data           : unsigned       := CtlToRegs_port.dst_data           end macro; 
macro CtlToRegs_data_req                : AccessType_Reg := CtlToRegs_port.req                       end macro; 
macro CtlToRegs_data_src1               : unsigned       := CtlToRegs_data_signal_src1               end macro; 
macro CtlToRegs_data_src2               : unsigned       := CtlToRegs_data_signal_src2               end macro; 
macro RegsToCtl_data_contents1          : unsigned       := RegsToCtl_data_signal.contents1          end macro; 
macro RegsToCtl_data_contents2          : unsigned       := RegsToCtl_data_signal.contents2          end macro; 
macro br_en                             : bool           := br_en_signal                             end macro; 
macro decodedInstr_encType              : EncType        := DecToCtl_port.encType                    end macro; 
macro decodedInstr_imm                  : unsigned       := DecToCtl_data_signal_imm                 end macro; 
macro decodedInstr_instrType            : InstrType      := DecToCtl_data_signal_instrType           end macro; 
macro decodedInstr_rd_addr              : unsigned       := DecToCtl_data_signal_rd_addr             end macro; 
macro decodedInstr_rs1_addr             : unsigned       := DecToCtl_port.rs1_addr                   end macro; 
macro decodedInstr_rs2_addr             : unsigned       := DecToCtl_port.rs2_addr                   end macro; 
macro fromMemoryData                    : unsigned       := MemToCtl_data_signal                     end macro; 
macro mem_en                            : bool           := mem_en_signal                            end macro; 
macro memoryAccess_addrIn               : unsigned       := CtlToMem_port.addrIn                     end macro;  
macro memoryAccess_dataIn               : unsigned       := CtlToMem_port.dataIn                     end macro;
macro memoryAccess_mask                 : MemMaskType    := memoryAccess_signal_mask                 end macro; 
macro memoryAccess_req                  : AccessType_Mem := memoryAccess_signal_req                  end macro; 
macro pc_next                           : unsigned       := pc_next_signal                           end macro; 
macro pc_reg                            : unsigned       := pc_reg_signal                            end macro; 
macro reg_rd_en                         : bool           := reg_rd_en_signal                         end macro; 
macro wb_en                             : bool           := wb_en_signal                             end macro; 
macro wb_sel                            : WBselType      := wb_sel_signal                            end macro; 


-- STATES -- 
macro decode_1 : boolean := (section = decode) end macro;
macro decode_2 : boolean := (section = setControl) end macro;
macro executeALU_5 : boolean := (section = executeALU) end macro;
macro executeALU_6 : boolean := (section = evaluateALUresult) end macro;
macro fetch_8 : boolean := (section = requestInstr) end macro;
macro fetch_9 : boolean := (section = receiveInstr) end macro;
macro memoryOperation_10 : boolean := (section = writeMemory) end macro;
macro memoryOperation_11 : boolean := (section = readMemory) end macro;
macro readRegisterFile_12 : boolean := (section = readRegisterFile) end macro;
macro readRegisterFile_13 : boolean := (section = requestALU) end macro;
macro writeBack_15 : boolean := (section = writeBack) end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: fetch_8;
	 at t: ALUtoCtl_data_ALU_result = 0;
	 at t: CtlToALU_data_alu_fun = ALU_ADD;
	 at t: CtlToALU_data_imm = 0;
	 at t: CtlToALU_data_op1_sel = OP_IMM;
	 at t: CtlToALU_data_op2_sel = OP_IMM;
	 at t: CtlToALU_data_pc_reg = 0;
	 at t: CtlToALU_data_reg1_contents = 0;
	 at t: CtlToALU_data_reg2_contents = 0;
	 at t: CtlToMem_port_sig_addrIn = 0;
	 at t: CtlToMem_port_sig_dataIn = 0;
	 at t: CtlToMem_port_sig_mask = MT_W;
	 at t: CtlToMem_port_sig_req = MEM_READ;
	 at t: CtlToRegs_data_dst = 0;
	 at t: CtlToRegs_data_dst_data = 0;
	 at t: CtlToRegs_data_req = REG_RD;
	 at t: CtlToRegs_data_src1 = 0;
	 at t: CtlToRegs_data_src2 = 0;
	 at t: RegsToCtl_data_contents1 = 0;
	 at t: RegsToCtl_data_contents2 = 0;
	 at t: br_en = false;
	 at t: decodedInstr_imm = 0;
	 at t: decodedInstr_instrType = And_Instr;
	 at t: decodedInstr_rd_addr = 0;
	 at t: fromMemoryData = 0;
	 at t: mem_en = false;
	 at t: memoryAccess_addrIn = 0;
	 at t: memoryAccess_dataIn = 0;
	 at t: memoryAccess_mask = MT_W;
	 at t: memoryAccess_req = MEM_READ;
	 at t: pc_next = 0;
	 at t: pc_reg = 0;
	 at t: reg_rd_en = false;
	 at t: wb_en = false;
	 at t: wb_sel = WB_ALU;
	 at t: CtlToALU_port_notify = false;
	 at t: CtlToDec_port_notify = false;
	 at t: CtlToMem_port_notify = true;
	 at t: CtlToRegs_port_notify = false;
	 at t: MemToCtl_port_notify = false;
end property;


property decode_1_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: decode_1;
prove:
	 at t_end: decode_2;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = I);
	 at t: not((DecToCtl_port_sig_instrType = addI));
	 at t: not((DecToCtl_port_sig_instrType = sltI));
	 at t: not((DecToCtl_port_sig_instrType = sltIu));
	 at t: not((DecToCtl_port_sig_instrType = xorI));
	 at t: not((DecToCtl_port_sig_instrType = orI));
	 at t: not((DecToCtl_port_sig_instrType = andI));
	 at t: not((DecToCtl_port_sig_instrType = sllI));
	 at t: not((DecToCtl_port_sig_instrType = srlI));
	 at t: not((DecToCtl_port_sig_instrType = sraI));
	 at t: not((DecToCtl_port_sig_instrType = lb));
	 at t: not((DecToCtl_port_sig_instrType = lh));
	 at t: not((DecToCtl_port_sig_instrType = lw));
	 at t: not((DecToCtl_port_sig_instrType = lbu));
	 at t: not((DecToCtl_port_sig_instrType = lhu));
	 at t: not((DecToCtl_port_sig_instrType = jalr));
	 at t: reg_rd_en;
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = J);
	 at t: not((DecToCtl_port_sig_instrType = jal));
	 at t: reg_rd_en;
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: decode_2;
	 at t: not((DecToCtl_port_sig_encType = I));
	 at t: not((DecToCtl_port_sig_encType = R));
	 at t: not((DecToCtl_port_sig_encType = B));
	 at t: not((DecToCtl_port_sig_encType = J));
	 at t: not((DecToCtl_port_sig_encType = S));
	 at t: not((DecToCtl_port_sig_encType = U));
	 at t: reg_rd_en;
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = I);
	 at t: (DecToCtl_port_sig_instrType = addI);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_ADD;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = R);
	 at t: (DecToCtl_port_sig_instrType = add);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_ADD;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_REG;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = I);
	 at t: (DecToCtl_port_sig_instrType = sltI);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_SLT;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = I);
	 at t: (DecToCtl_port_sig_instrType = jalr);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_X;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_X;
	 at t_end: CtlToALU_data_op2_sel = OP_X;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_PC4;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = R);
	 at t: (DecToCtl_port_sig_instrType = sub);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_SUB;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_REG;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = B);
	 at t: (DecToCtl_port_sig_instrType = beq);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_SUB;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_REG;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = true;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = false;
	 at t_end: wb_sel = WB_X;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = I);
	 at t: (DecToCtl_port_sig_instrType = sltIu);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_SLTU;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = R);
	 at t: (DecToCtl_port_sig_instrType = sll_Instr);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_SLL;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_REG;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = B);
	 at t: (DecToCtl_port_sig_instrType = bne);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_SUB;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_REG;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = true;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = false;
	 at t_end: wb_sel = WB_X;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = I);
	 at t: (DecToCtl_port_sig_instrType = xorI);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_XOR;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_14 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = I);
	 at t: (DecToCtl_port_sig_instrType = lb);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_ADD;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = true;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = MT_B;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_MEM;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_15 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = R);
	 at t: (DecToCtl_port_sig_instrType = slt);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_SLT;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_REG;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_16 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = B);
	 at t: (DecToCtl_port_sig_instrType = blt);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_SLT;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_REG;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = true;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = false;
	 at t_end: wb_sel = WB_X;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_17 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = I);
	 at t: (DecToCtl_port_sig_instrType = orI);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_OR;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_18 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = I);
	 at t: (DecToCtl_port_sig_instrType = lh);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_ADD;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = true;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = MT_H;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_MEM;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_19 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = R);
	 at t: (DecToCtl_port_sig_instrType = sltu);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_SLTU;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_REG;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_20 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = B);
	 at t: (DecToCtl_port_sig_instrType = bge);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_SLT;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_REG;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = true;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = false;
	 at t_end: wb_sel = WB_X;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_21 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = I);
	 at t: (DecToCtl_port_sig_instrType = andI);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_AND;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_22 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = I);
	 at t: (DecToCtl_port_sig_instrType = lw);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_ADD;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = true;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_MEM;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_23 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = R);
	 at t: (DecToCtl_port_sig_instrType = Xor_Instr);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_XOR;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_REG;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_24 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = B);
	 at t: (DecToCtl_port_sig_instrType = bltu);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_SLTU;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_REG;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = true;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = false;
	 at t_end: wb_sel = WB_X;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_25 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = B);
	 at t: not((DecToCtl_port_sig_instrType = beq));
	 at t: not((DecToCtl_port_sig_instrType = bne));
	 at t: not((DecToCtl_port_sig_instrType = blt));
	 at t: not((DecToCtl_port_sig_instrType = bge));
	 at t: not((DecToCtl_port_sig_instrType = bltu));
	 at t: not((DecToCtl_port_sig_instrType = bgeu));
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_REG;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = true;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = false;
	 at t_end: wb_sel = WB_X;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_26 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = S);
	 at t: (DecToCtl_port_sig_instrType = sb);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_ADD;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = true;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = MT_B;
	 at t_end: memoryAccess_req = MEM_WRITE;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = false;
	 at t_end: wb_sel = WB_X;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_27 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = I);
	 at t: (DecToCtl_port_sig_instrType = sllI);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_SLL;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_28 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = I);
	 at t: (DecToCtl_port_sig_instrType = lbu);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_ADD;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = true;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = MT_BU;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_MEM;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_29 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = R);
	 at t: (DecToCtl_port_sig_instrType = srl_Instr);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_SRL;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_REG;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_30 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = B);
	 at t: (DecToCtl_port_sig_instrType = bgeu);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_SLTU;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_REG;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = true;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = false;
	 at t_end: wb_sel = WB_X;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_31 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = S);
	 at t: (DecToCtl_port_sig_instrType = sh);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_ADD;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = true;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = MT_H;
	 at t_end: memoryAccess_req = MEM_WRITE;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = false;
	 at t_end: wb_sel = WB_X;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_32 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = S);
	 at t: not((DecToCtl_port_sig_instrType = sb));
	 at t: not((DecToCtl_port_sig_instrType = sh));
	 at t: not((DecToCtl_port_sig_instrType = sw));
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_ADD;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = true;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = MEM_WRITE;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = false;
	 at t_end: wb_sel = WB_X;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_33 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = I);
	 at t: (DecToCtl_port_sig_instrType = srlI);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_SRL;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_34 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = I);
	 at t: (DecToCtl_port_sig_instrType = lhu);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_ADD;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = true;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = MT_HU;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_MEM;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_35 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = R);
	 at t: (DecToCtl_port_sig_instrType = sra_Instr);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_SRA;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_REG;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_36 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = S);
	 at t: (DecToCtl_port_sig_instrType = sw);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_ADD;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = true;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_WRITE;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = false;
	 at t_end: wb_sel = WB_X;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_37 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = I);
	 at t: (DecToCtl_port_sig_instrType = sraI);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_SRA;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_38 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = R);
	 at t: (DecToCtl_port_sig_instrType = Or_Instr);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_OR;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_REG;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_39 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = R);
	 at t: not((DecToCtl_port_sig_instrType = add));
	 at t: not((DecToCtl_port_sig_instrType = sub));
	 at t: not((DecToCtl_port_sig_instrType = sll_Instr));
	 at t: not((DecToCtl_port_sig_instrType = slt));
	 at t: not((DecToCtl_port_sig_instrType = sltu));
	 at t: not((DecToCtl_port_sig_instrType = Xor_Instr));
	 at t: not((DecToCtl_port_sig_instrType = srl_Instr));
	 at t: not((DecToCtl_port_sig_instrType = sra_Instr));
	 at t: not((DecToCtl_port_sig_instrType = Or_Instr));
	 at t: not((DecToCtl_port_sig_instrType = And_Instr));
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_REG;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_40 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	DecToCtl_port_sig_rs1_addr_at_t = DecToCtl_port_sig_rs1_addr@t,
	DecToCtl_port_sig_rs2_addr_at_t = DecToCtl_port_sig_rs2_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = R);
	 at t: (DecToCtl_port_sig_instrType = And_Instr);
prove:
	 at t_end: readRegisterFile_12;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_AND;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_REG;
	 at t_end: CtlToALU_data_op2_sel = OP_REG;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = REG_RD;
	 at t_end: CtlToRegs_data_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_data_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_RD;
	 at t_end: CtlToRegs_port_sig_src1 = DecToCtl_port_sig_rs1_addr_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = DecToCtl_port_sig_rs2_addr_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = true;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_41 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = I);
	 at t: not((DecToCtl_port_sig_instrType = addI));
	 at t: not((DecToCtl_port_sig_instrType = sltI));
	 at t: not((DecToCtl_port_sig_instrType = sltIu));
	 at t: not((DecToCtl_port_sig_instrType = xorI));
	 at t: not((DecToCtl_port_sig_instrType = orI));
	 at t: not((DecToCtl_port_sig_instrType = andI));
	 at t: not((DecToCtl_port_sig_instrType = sllI));
	 at t: not((DecToCtl_port_sig_instrType = srlI));
	 at t: not((DecToCtl_port_sig_instrType = sraI));
	 at t: not((DecToCtl_port_sig_instrType = lb));
	 at t: not((DecToCtl_port_sig_instrType = lh));
	 at t: not((DecToCtl_port_sig_instrType = lw));
	 at t: not((DecToCtl_port_sig_instrType = lbu));
	 at t: not((DecToCtl_port_sig_instrType = lhu));
	 at t: not((DecToCtl_port_sig_instrType = jalr));
	 at t: not(reg_rd_en);
prove:
	 at t_end: executeALU_5;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = RegsToCtl_data_contents1_at_t;
	 at t_end: CtlToALU_data_reg2_contents = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToALU_port_sig_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_port_sig_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: CtlToALU_port_sig_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_port_sig_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_port_sig_pc_reg = pc_reg_at_t;
	 at t_end: CtlToALU_port_sig_reg1_contents = RegsToCtl_data_contents1_at_t;
	 at t_end: CtlToALU_port_sig_reg2_contents = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end-1]: CtlToALU_port_notify = false;
	 at t_end: CtlToALU_port_notify = true;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_42 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = J);
	 at t: not((DecToCtl_port_sig_instrType = jal));
	 at t: not(reg_rd_en);
prove:
	 at t_end: executeALU_5;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = RegsToCtl_data_contents1_at_t;
	 at t_end: CtlToALU_data_reg2_contents = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToALU_port_sig_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_port_sig_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: CtlToALU_port_sig_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_port_sig_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_port_sig_pc_reg = pc_reg_at_t;
	 at t_end: CtlToALU_port_sig_reg1_contents = RegsToCtl_data_contents1_at_t;
	 at t_end: CtlToALU_port_sig_reg2_contents = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end-1]: CtlToALU_port_notify = false;
	 at t_end: CtlToALU_port_notify = true;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_43 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: decode_2;
	 at t: not((DecToCtl_port_sig_encType = I));
	 at t: not((DecToCtl_port_sig_encType = R));
	 at t: not((DecToCtl_port_sig_encType = B));
	 at t: not((DecToCtl_port_sig_encType = J));
	 at t: not((DecToCtl_port_sig_encType = S));
	 at t: not((DecToCtl_port_sig_encType = U));
	 at t: not(reg_rd_en);
prove:
	 at t_end: executeALU_5;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = RegsToCtl_data_contents1_at_t;
	 at t_end: CtlToALU_data_reg2_contents = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToALU_port_sig_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_port_sig_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: CtlToALU_port_sig_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_port_sig_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_port_sig_pc_reg = pc_reg_at_t;
	 at t_end: CtlToALU_port_sig_reg1_contents = RegsToCtl_data_contents1_at_t;
	 at t_end: CtlToALU_port_sig_reg2_contents = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end-1]: CtlToALU_port_notify = false;
	 at t_end: CtlToALU_port_notify = true;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_44 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = J);
	 at t: (DecToCtl_port_sig_instrType = jal);
prove:
	 at t_end: executeALU_5;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_X;
	 at t_end: CtlToALU_data_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_X;
	 at t_end: CtlToALU_data_op2_sel = OP_X;
	 at t_end: CtlToALU_data_pc_reg = pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = RegsToCtl_data_contents1_at_t;
	 at t_end: CtlToALU_data_reg2_contents = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToALU_port_sig_alu_fun = ALU_X;
	 at t_end: CtlToALU_port_sig_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: CtlToALU_port_sig_op1_sel = OP_X;
	 at t_end: CtlToALU_port_sig_op2_sel = OP_X;
	 at t_end: CtlToALU_port_sig_pc_reg = pc_reg_at_t;
	 at t_end: CtlToALU_port_sig_reg1_contents = RegsToCtl_data_contents1_at_t;
	 at t_end: CtlToALU_port_sig_reg2_contents = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = false;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_PC4;
	 during[t+1, t_end-1]: CtlToALU_port_notify = false;
	 at t_end: CtlToALU_port_notify = true;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_45 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = U);
	 at t: not((DecToCtl_port_sig_instrType = lui));
	 at t: not((DecToCtl_port_sig_instrType = auipc));
prove:
	 at t_end: executeALU_5;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = RegsToCtl_data_contents1_at_t;
	 at t_end: CtlToALU_data_reg2_contents = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToALU_port_sig_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_port_sig_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: CtlToALU_port_sig_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_port_sig_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_port_sig_pc_reg = pc_reg_at_t;
	 at t_end: CtlToALU_port_sig_reg1_contents = RegsToCtl_data_contents1_at_t;
	 at t_end: CtlToALU_port_sig_reg2_contents = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = false;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end-1]: CtlToALU_port_notify = false;
	 at t_end: CtlToALU_port_notify = true;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_46 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = U);
	 at t: (DecToCtl_port_sig_instrType = lui);
prove:
	 at t_end: executeALU_5;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_COPY1;
	 at t_end: CtlToALU_data_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_IMM;
	 at t_end: CtlToALU_data_op2_sel = OP_X;
	 at t_end: CtlToALU_data_pc_reg = pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = RegsToCtl_data_contents1_at_t;
	 at t_end: CtlToALU_data_reg2_contents = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToALU_port_sig_alu_fun = ALU_COPY1;
	 at t_end: CtlToALU_port_sig_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: CtlToALU_port_sig_op1_sel = OP_IMM;
	 at t_end: CtlToALU_port_sig_op2_sel = OP_X;
	 at t_end: CtlToALU_port_sig_pc_reg = pc_reg_at_t;
	 at t_end: CtlToALU_port_sig_reg1_contents = RegsToCtl_data_contents1_at_t;
	 at t_end: CtlToALU_port_sig_reg2_contents = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = false;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end-1]: CtlToALU_port_notify = false;
	 at t_end: CtlToALU_port_notify = true;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property decode_2_read_47 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	DecToCtl_port_sig_imm_at_t = DecToCtl_port_sig_imm@t,
	DecToCtl_port_sig_instrType_at_t = DecToCtl_port_sig_instrType@t,
	DecToCtl_port_sig_rd_addr_at_t = DecToCtl_port_sig_rd_addr@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	fromMemoryData_at_t = fromMemoryData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t;
assume: 
	 at t: decode_2;
	 at t: (DecToCtl_port_sig_encType = U);
	 at t: (DecToCtl_port_sig_instrType = auipc);
prove:
	 at t_end: executeALU_5;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = ALU_ADD;
	 at t_end: CtlToALU_data_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = OP_PC;
	 at t_end: CtlToALU_data_op2_sel = OP_IMM;
	 at t_end: CtlToALU_data_pc_reg = pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = RegsToCtl_data_contents1_at_t;
	 at t_end: CtlToALU_data_reg2_contents = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToALU_port_sig_alu_fun = ALU_ADD;
	 at t_end: CtlToALU_port_sig_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: CtlToALU_port_sig_op1_sel = OP_PC;
	 at t_end: CtlToALU_port_sig_op2_sel = OP_IMM;
	 at t_end: CtlToALU_port_sig_pc_reg = pc_reg_at_t;
	 at t_end: CtlToALU_port_sig_reg1_contents = RegsToCtl_data_contents1_at_t;
	 at t_end: CtlToALU_port_sig_reg2_contents = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = false;
	 at t_end: decodedInstr_imm = DecToCtl_port_sig_imm_at_t;
	 at t_end: decodedInstr_instrType = DecToCtl_port_sig_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = DecToCtl_port_sig_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = false;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = false;
	 at t_end: wb_en = true;
	 at t_end: wb_sel = WB_ALU;
	 during[t+1, t_end-1]: CtlToALU_port_notify = false;
	 at t_end: CtlToALU_port_notify = true;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_5_read_48 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_5;
prove:
	 at t_end: executeALU_6;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_49 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: not((decodedInstr_instrType = jal));
	 at t: not((decodedInstr_instrType = jalr));
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: pc_reg = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_50 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: not((decodedInstr_instrType = jal));
	 at t: not((decodedInstr_instrType = jalr));
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (4 + pc_reg_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (4 + pc_reg_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (4 + pc_reg_at_t);
	 at t_end: pc_reg = (4 + pc_reg_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_51 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: not((decodedInstr_instrType = jal));
	 at t: not((decodedInstr_instrType = jalr));
	 at t: not(mem_en);
	 at t: not((wb_sel = WB_ALU));
	 at t: not((wb_sel = WB_MEM));
	 at t: not((wb_sel = WB_PC4));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (4 + pc_reg_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (4 + pc_reg_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (4 + pc_reg_at_t);
	 at t_end: pc_reg = (4 + pc_reg_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_52 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: (decodedInstr_instrType = jal);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_53 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: not((decodedInstr_instrType = jal));
	 at t: not((decodedInstr_instrType = jalr));
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: pc_reg = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_54 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = beq);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_55 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: (decodedInstr_instrType = jal);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_56 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: (decodedInstr_instrType = jal);
	 at t: not(mem_en);
	 at t: not((wb_sel = WB_ALU));
	 at t: not((wb_sel = WB_MEM));
	 at t: not((wb_sel = WB_PC4));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_57 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = beq);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_58 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = beq);
	 at t: not(mem_en);
	 at t: not((wb_sel = WB_ALU));
	 at t: not((wb_sel = WB_MEM));
	 at t: not((wb_sel = WB_PC4));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_59 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bne);
	 at t: not((ALUtoCtl_port_sig_ALU_result = 0));
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_60 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: (decodedInstr_instrType = jal);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_61 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: (decodedInstr_instrType = jalr);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: pc_reg = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_62 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = beq);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_63 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bne);
	 at t: not((ALUtoCtl_port_sig_ALU_result = 0));
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_64 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bne);
	 at t: not((ALUtoCtl_port_sig_ALU_result = 0));
	 at t: not(mem_en);
	 at t: not((wb_sel = WB_ALU));
	 at t: not((wb_sel = WB_MEM));
	 at t: not((wb_sel = WB_PC4));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_65 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = blt);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
	 at t: (ALUtoCtl_port_sig_ALU_result = 1);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_66 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: (decodedInstr_instrType = jalr);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_67 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: (decodedInstr_instrType = jalr);
	 at t: not(mem_en);
	 at t: not((wb_sel = WB_ALU));
	 at t: not((wb_sel = WB_MEM));
	 at t: not((wb_sel = WB_PC4));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_68 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bne);
	 at t: not((ALUtoCtl_port_sig_ALU_result = 0));
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_69 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = blt);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
	 at t: (ALUtoCtl_port_sig_ALU_result = 1);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_70 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = blt);
	 at t: not(mem_en);
	 at t: not((wb_sel = WB_ALU));
	 at t: not((wb_sel = WB_MEM));
	 at t: not((wb_sel = WB_PC4));
	 at t: (ALUtoCtl_port_sig_ALU_result = 1);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_71 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bge);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_72 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: not(((decodedInstr_instrType = beq) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not(((decodedInstr_instrType = bne) and not((ALUtoCtl_port_sig_ALU_result = 0))));
	 at t: not(((decodedInstr_instrType = blt) and (ALUtoCtl_port_sig_ALU_result = 1)));
	 at t: not(((decodedInstr_instrType = bge) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not(((decodedInstr_instrType = bltu) and (ALUtoCtl_port_sig_ALU_result = 1)));
	 at t: not(((decodedInstr_instrType = bgeu) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not((decodedInstr_instrType = jal));
	 at t: not((decodedInstr_instrType = jalr));
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (4 + pc_reg_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (4 + pc_reg_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (4 + pc_reg_at_t);
	 at t_end: pc_reg = (4 + pc_reg_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_73 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: (decodedInstr_instrType = jalr);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: pc_reg = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_74 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = blt);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
	 at t: (ALUtoCtl_port_sig_ALU_result = 1);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_75 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bge);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_76 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bge);
	 at t: not(mem_en);
	 at t: not((wb_sel = WB_ALU));
	 at t: not((wb_sel = WB_MEM));
	 at t: not((wb_sel = WB_PC4));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_77 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bltu);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
	 at t: (ALUtoCtl_port_sig_ALU_result = 1);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_78 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: not(((decodedInstr_instrType = beq) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not(((decodedInstr_instrType = bne) and not((ALUtoCtl_port_sig_ALU_result = 0))));
	 at t: not(((decodedInstr_instrType = blt) and (ALUtoCtl_port_sig_ALU_result = 1)));
	 at t: not(((decodedInstr_instrType = bge) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not(((decodedInstr_instrType = bltu) and (ALUtoCtl_port_sig_ALU_result = 1)));
	 at t: not(((decodedInstr_instrType = bgeu) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not((decodedInstr_instrType = jal));
	 at t: not((decodedInstr_instrType = jalr));
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (4 + pc_reg_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (4 + pc_reg_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (4 + pc_reg_at_t);
	 at t_end: pc_reg = (4 + pc_reg_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_79 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: not(((decodedInstr_instrType = beq) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not(((decodedInstr_instrType = bne) and not((ALUtoCtl_port_sig_ALU_result = 0))));
	 at t: not(((decodedInstr_instrType = blt) and (ALUtoCtl_port_sig_ALU_result = 1)));
	 at t: not(((decodedInstr_instrType = bge) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not(((decodedInstr_instrType = bltu) and (ALUtoCtl_port_sig_ALU_result = 1)));
	 at t: not(((decodedInstr_instrType = bgeu) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not((decodedInstr_instrType = jal));
	 at t: not((decodedInstr_instrType = jalr));
	 at t: not(mem_en);
	 at t: not((wb_sel = WB_ALU));
	 at t: not((wb_sel = WB_MEM));
	 at t: not((wb_sel = WB_PC4));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: pc_reg = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_80 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bge);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_81 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bltu);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
	 at t: (ALUtoCtl_port_sig_ALU_result = 1);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_82 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bltu);
	 at t: not(mem_en);
	 at t: not((wb_sel = WB_ALU));
	 at t: not((wb_sel = WB_MEM));
	 at t: not((wb_sel = WB_PC4));
	 at t: (ALUtoCtl_port_sig_ALU_result = 1);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_83 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bgeu);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_84 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = jal);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_85 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: not(((decodedInstr_instrType = beq) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not(((decodedInstr_instrType = bne) and not((ALUtoCtl_port_sig_ALU_result = 0))));
	 at t: not(((decodedInstr_instrType = blt) and (ALUtoCtl_port_sig_ALU_result = 1)));
	 at t: not(((decodedInstr_instrType = bge) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not(((decodedInstr_instrType = bltu) and (ALUtoCtl_port_sig_ALU_result = 1)));
	 at t: not(((decodedInstr_instrType = bgeu) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not((decodedInstr_instrType = jal));
	 at t: not((decodedInstr_instrType = jalr));
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (4 + pc_reg_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (4 + pc_reg_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (4 + pc_reg_at_t);
	 at t_end: pc_reg = (4 + pc_reg_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_86 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bltu);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
	 at t: (ALUtoCtl_port_sig_ALU_result = 1);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_87 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bgeu);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_88 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bgeu);
	 at t: not(mem_en);
	 at t: not((wb_sel = WB_ALU));
	 at t: not((wb_sel = WB_MEM));
	 at t: not((wb_sel = WB_PC4));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_89 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = jal);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_90 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = jal);
	 at t: not(mem_en);
	 at t: not((wb_sel = WB_ALU));
	 at t: not((wb_sel = WB_MEM));
	 at t: not((wb_sel = WB_PC4));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_91 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bgeu);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_92 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = jal);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_93 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = jalr);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_94 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = jalr);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_95 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = jalr);
	 at t: not(mem_en);
	 at t: not((wb_sel = WB_ALU));
	 at t: not((wb_sel = WB_MEM));
	 at t: not((wb_sel = WB_PC4));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: pc_reg = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_96 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = jalr);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_97 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: not((decodedInstr_instrType = jal));
	 at t: not((decodedInstr_instrType = jalr));
	 at t: mem_en;
prove:
	 at t_end: memoryOperation_10;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToMem_port_sig_mask = memoryAccess_mask_at_t;
	 at t_end: CtlToMem_port_sig_req = memoryAccess_req_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: memoryAccess_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_98 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: (decodedInstr_instrType = jal);
	 at t: mem_en;
prove:
	 at t_end: memoryOperation_10;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToMem_port_sig_mask = memoryAccess_mask_at_t;
	 at t_end: CtlToMem_port_sig_req = memoryAccess_req_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: memoryAccess_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_99 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = beq);
	 at t: mem_en;
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: memoryOperation_10;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToMem_port_sig_mask = memoryAccess_mask_at_t;
	 at t_end: CtlToMem_port_sig_req = memoryAccess_req_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: memoryAccess_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_100 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bne);
	 at t: not((ALUtoCtl_port_sig_ALU_result = 0));
	 at t: mem_en;
prove:
	 at t_end: memoryOperation_10;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToMem_port_sig_mask = memoryAccess_mask_at_t;
	 at t_end: CtlToMem_port_sig_req = memoryAccess_req_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: memoryAccess_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_101 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: (decodedInstr_instrType = jalr);
	 at t: mem_en;
prove:
	 at t_end: memoryOperation_10;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToMem_port_sig_mask = memoryAccess_mask_at_t;
	 at t_end: CtlToMem_port_sig_req = memoryAccess_req_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: memoryAccess_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_102 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = blt);
	 at t: mem_en;
	 at t: (ALUtoCtl_port_sig_ALU_result = 1);
prove:
	 at t_end: memoryOperation_10;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToMem_port_sig_mask = memoryAccess_mask_at_t;
	 at t_end: CtlToMem_port_sig_req = memoryAccess_req_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: memoryAccess_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_103 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bge);
	 at t: mem_en;
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: memoryOperation_10;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToMem_port_sig_mask = memoryAccess_mask_at_t;
	 at t_end: CtlToMem_port_sig_req = memoryAccess_req_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: memoryAccess_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_104 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: not(((decodedInstr_instrType = beq) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not(((decodedInstr_instrType = bne) and not((ALUtoCtl_port_sig_ALU_result = 0))));
	 at t: not(((decodedInstr_instrType = blt) and (ALUtoCtl_port_sig_ALU_result = 1)));
	 at t: not(((decodedInstr_instrType = bge) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not(((decodedInstr_instrType = bltu) and (ALUtoCtl_port_sig_ALU_result = 1)));
	 at t: not(((decodedInstr_instrType = bgeu) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not((decodedInstr_instrType = jal));
	 at t: not((decodedInstr_instrType = jalr));
	 at t: mem_en;
prove:
	 at t_end: memoryOperation_10;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToMem_port_sig_mask = memoryAccess_mask_at_t;
	 at t_end: CtlToMem_port_sig_req = memoryAccess_req_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: memoryAccess_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (4 + pc_reg_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_105 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bltu);
	 at t: mem_en;
	 at t: (ALUtoCtl_port_sig_ALU_result = 1);
prove:
	 at t_end: memoryOperation_10;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToMem_port_sig_mask = memoryAccess_mask_at_t;
	 at t_end: CtlToMem_port_sig_req = memoryAccess_req_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: memoryAccess_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_106 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bgeu);
	 at t: mem_en;
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: memoryOperation_10;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToMem_port_sig_mask = memoryAccess_mask_at_t;
	 at t_end: CtlToMem_port_sig_req = memoryAccess_req_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: memoryAccess_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_107 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = jal);
	 at t: mem_en;
prove:
	 at t_end: memoryOperation_10;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToMem_port_sig_mask = memoryAccess_mask_at_t;
	 at t_end: CtlToMem_port_sig_req = memoryAccess_req_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: memoryAccess_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_108 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = jalr);
	 at t: mem_en;
prove:
	 at t_end: memoryOperation_10;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: CtlToMem_port_sig_mask = memoryAccess_mask_at_t;
	 at t_end: CtlToMem_port_sig_req = memoryAccess_req_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: memoryAccess_dataIn = RegsToCtl_data_contents2_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_109 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: not((decodedInstr_instrType = jal));
	 at t: not((decodedInstr_instrType = jalr));
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_110 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: not((decodedInstr_instrType = jal));
	 at t: not((decodedInstr_instrType = jalr));
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (4 + pc_reg_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_111 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: (decodedInstr_instrType = jal);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_112 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: not((decodedInstr_instrType = jal));
	 at t: not((decodedInstr_instrType = jalr));
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_113 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = beq);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_114 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: (decodedInstr_instrType = jal);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_115 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = beq);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_116 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bne);
	 at t: not((ALUtoCtl_port_sig_ALU_result = 0));
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_117 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: (decodedInstr_instrType = jal);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_118 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: (decodedInstr_instrType = jalr);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_119 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = beq);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_120 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bne);
	 at t: not((ALUtoCtl_port_sig_ALU_result = 0));
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_121 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = blt);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
	 at t: (ALUtoCtl_port_sig_ALU_result = 1);
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_122 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: (decodedInstr_instrType = jalr);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_123 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bne);
	 at t: not((ALUtoCtl_port_sig_ALU_result = 0));
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_124 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = blt);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
	 at t: (ALUtoCtl_port_sig_ALU_result = 1);
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_125 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bge);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_126 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: not(((decodedInstr_instrType = beq) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not(((decodedInstr_instrType = bne) and not((ALUtoCtl_port_sig_ALU_result = 0))));
	 at t: not(((decodedInstr_instrType = blt) and (ALUtoCtl_port_sig_ALU_result = 1)));
	 at t: not(((decodedInstr_instrType = bge) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not(((decodedInstr_instrType = bltu) and (ALUtoCtl_port_sig_ALU_result = 1)));
	 at t: not(((decodedInstr_instrType = bgeu) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not((decodedInstr_instrType = jal));
	 at t: not((decodedInstr_instrType = jalr));
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (4 + pc_reg_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_127 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: not(br_en);
	 at t: (decodedInstr_instrType = jalr);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = (4 + pc_reg_at_t)(31 downto 0);
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_128 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = blt);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
	 at t: (ALUtoCtl_port_sig_ALU_result = 1);
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_129 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bge);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_130 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bltu);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
	 at t: (ALUtoCtl_port_sig_ALU_result = 1);
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_131 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: not(((decodedInstr_instrType = beq) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not(((decodedInstr_instrType = bne) and not((ALUtoCtl_port_sig_ALU_result = 0))));
	 at t: not(((decodedInstr_instrType = blt) and (ALUtoCtl_port_sig_ALU_result = 1)));
	 at t: not(((decodedInstr_instrType = bge) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not(((decodedInstr_instrType = bltu) and (ALUtoCtl_port_sig_ALU_result = 1)));
	 at t: not(((decodedInstr_instrType = bgeu) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not((decodedInstr_instrType = jal));
	 at t: not((decodedInstr_instrType = jalr));
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (4 + pc_reg_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_132 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bge);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_133 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bltu);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
	 at t: (ALUtoCtl_port_sig_ALU_result = 1);
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_134 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bgeu);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_135 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = jal);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_136 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: not(((decodedInstr_instrType = beq) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not(((decodedInstr_instrType = bne) and not((ALUtoCtl_port_sig_ALU_result = 0))));
	 at t: not(((decodedInstr_instrType = blt) and (ALUtoCtl_port_sig_ALU_result = 1)));
	 at t: not(((decodedInstr_instrType = bge) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not(((decodedInstr_instrType = bltu) and (ALUtoCtl_port_sig_ALU_result = 1)));
	 at t: not(((decodedInstr_instrType = bgeu) and (ALUtoCtl_port_sig_ALU_result = 0)));
	 at t: not((decodedInstr_instrType = jal));
	 at t: not((decodedInstr_instrType = jalr));
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (4 + pc_reg_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_137 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bltu);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
	 at t: (ALUtoCtl_port_sig_ALU_result = 1);
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_138 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bgeu);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_139 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = jal);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_140 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = bgeu);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
	 at t: (ALUtoCtl_port_sig_ALU_result = 0);
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_141 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = jal);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (pc_reg_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_142 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = jalr);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_ALU);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_143 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = jalr);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_MEM);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = fromMemoryData_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property executeALU_6_read_144 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_port_sig_ALU_result_at_t = ALUtoCtl_port_sig_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: executeALU_6;
	 at t: br_en;
	 at t: (decodedInstr_instrType = jalr);
	 at t: not(mem_en);
	 at t: (wb_sel = WB_PC4);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_port_sig_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = (RegsToCtl_data_contents1_at_t + decodedInstr_imm_at_t);
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property fetch_8_write_145 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: fetch_8;
	 at t: CtlToMem_port_sync;
prove:
	 at t_end: fetch_9;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end-1]: MemToCtl_port_notify = false;
	 at t_end: MemToCtl_port_notify = true;
end property;

property fetch_9_read_146 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	MemToCtl_port_sig_at_t = MemToCtl_port_sig@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: fetch_9;
	 at t: MemToCtl_port_sync;
prove:
	 at t_end: decode_1;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToDec_port_sig = MemToCtl_port_sig_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end-1]: CtlToDec_port_notify = false;
	 at t_end: CtlToDec_port_notify = true;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property memoryOperation_10_write_147 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: memoryOperation_10;
	 at t: CtlToMem_port_sync;
prove:
	 at t_end: memoryOperation_11;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end-1]: MemToCtl_port_notify = false;
	 at t_end: MemToCtl_port_notify = true;
end property;

property memoryOperation_11_read_148 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	MemToCtl_port_sig_at_t = MemToCtl_port_sig@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	mem_en_at_t = mem_en@t,
	pc_next_at_t = pc_next@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: memoryOperation_11;
	 at t: (wb_sel = WB_ALU);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
	 at t: MemToCtl_port_sync;
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = pc_next_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = MemToCtl_port_sig_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = pc_next_at_t;
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_next_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property memoryOperation_11_read_149 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	MemToCtl_port_sig_at_t = MemToCtl_port_sig@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	mem_en_at_t = mem_en@t,
	pc_next_at_t = pc_next@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: memoryOperation_11;
	 at t: (wb_sel = WB_MEM);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
	 at t: MemToCtl_port_sync;
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = pc_next_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = MemToCtl_port_sig_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = pc_next_at_t;
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_next_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property memoryOperation_11_read_150 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	MemToCtl_port_sig_at_t = MemToCtl_port_sig@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	mem_en_at_t = mem_en@t,
	pc_next_at_t = pc_next@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: memoryOperation_11;
	 at t: not((wb_sel = WB_ALU));
	 at t: not((wb_sel = WB_MEM));
	 at t: not((wb_sel = WB_PC4));
	 at t: MemToCtl_port_sync;
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = pc_next_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = MemToCtl_port_sig_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = pc_next_at_t;
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_next_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property memoryOperation_11_read_151 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	MemToCtl_port_sig_at_t = MemToCtl_port_sig@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	mem_en_at_t = mem_en@t,
	pc_next_at_t = pc_next@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: memoryOperation_11;
	 at t: (wb_sel = WB_PC4);
	 at t: not((wb_en and not((decodedInstr_rd_addr = 0))));
	 at t: MemToCtl_port_sync;
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = pc_next_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = MemToCtl_port_sig_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = pc_next_at_t;
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_next_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property memoryOperation_11_read_152 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	MemToCtl_port_sig_at_t = MemToCtl_port_sig@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: memoryOperation_11;
	 at t: (wb_sel = WB_ALU);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
	 at t: MemToCtl_port_sync;
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = MemToCtl_port_sig_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property memoryOperation_11_read_153 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	MemToCtl_port_sig_at_t = MemToCtl_port_sig@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: memoryOperation_11;
	 at t: (wb_sel = WB_MEM);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
	 at t: MemToCtl_port_sync;
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = MemToCtl_port_sig_at_t;
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = MemToCtl_port_sig_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = MemToCtl_port_sig_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property memoryOperation_11_read_154 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	MemToCtl_port_sig_at_t = MemToCtl_port_sig@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: memoryOperation_11;
	 at t: (wb_sel = WB_PC4);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = 0));
	 at t: MemToCtl_port_sync;
prove:
	 at t_end: writeBack_15;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_data_req = REG_WR;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = (4 + pc_reg_at_t);
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = MemToCtl_port_sig_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_12_write_155 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: readRegisterFile_12;
prove:
	 at t_end: readRegisterFile_13;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_13_read_156 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: readRegisterFile_13;
prove:
	 at t_end: executeALU_5;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = decodedInstr_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: CtlToALU_data_reg2_contents = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: CtlToALU_port_sig_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_port_sig_imm = decodedInstr_imm_at_t;
	 at t_end: CtlToALU_port_sig_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_port_sig_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_port_sig_pc_reg = pc_reg_at_t;
	 at t_end: CtlToALU_port_sig_reg1_contents = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: CtlToALU_port_sig_reg2_contents = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_reg_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end-1]: CtlToALU_port_notify = false;
	 at t_end: CtlToALU_port_notify = true;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property writeBack_15_write_157 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	pc_next_at_t = pc_next@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: writeBack_15;
prove:
	 at t_end: fetch_8;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t_end: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t_end: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = pc_next_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = MEM_READ;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData = fromMemoryData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = pc_next_at_t;
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = MEM_READ;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_next_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToALU_port_notify = false;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property wait_fetch_8 is
dependencies: no_reset;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: fetch_8;
	 at t: not(CtlToMem_port_sync);
prove:
	 at t+1: fetch_8;
	 at t+1: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t+1: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t+1: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t+1: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t+1: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t+1: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t+1: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t+1: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t+1: CtlToMem_port_sig_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: CtlToMem_port_sig_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: CtlToMem_port_sig_mask = memoryAccess_mask_at_t;
	 at t+1: CtlToMem_port_sig_req = memoryAccess_req_at_t;
	 at t+1: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t+1: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t+1: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t+1: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t+1: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t+1: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t+1: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t+1: br_en = br_en_at_t;
	 at t+1: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t+1: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t+1: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t+1: fromMemoryData = fromMemoryData_at_t;
	 at t+1: mem_en = mem_en_at_t;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: pc_next = pc_next_at_t;
	 at t+1: pc_reg = pc_reg_at_t;
	 at t+1: reg_rd_en = reg_rd_en_at_t;
	 at t+1: wb_en = wb_en_at_t;
	 at t+1: wb_sel = wb_sel_at_t;
	 at t+1: CtlToALU_port_notify = false;
	 at t+1: CtlToDec_port_notify = false;
	 at t+1: CtlToMem_port_notify = true;
	 at t+1: CtlToRegs_port_notify = false;
	 at t+1: MemToCtl_port_notify = false;
end property;

property wait_fetch_9 is
dependencies: no_reset;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: fetch_9;
	 at t: not(MemToCtl_port_sync);
prove:
	 at t+1: fetch_9;
	 at t+1: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t+1: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t+1: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t+1: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t+1: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t+1: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t+1: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t+1: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t+1: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t+1: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t+1: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t+1: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t+1: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t+1: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t+1: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t+1: br_en = br_en_at_t;
	 at t+1: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t+1: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t+1: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t+1: fromMemoryData = fromMemoryData_at_t;
	 at t+1: mem_en = mem_en_at_t;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: pc_next = pc_next_at_t;
	 at t+1: pc_reg = pc_reg_at_t;
	 at t+1: reg_rd_en = reg_rd_en_at_t;
	 at t+1: wb_en = wb_en_at_t;
	 at t+1: wb_sel = wb_sel_at_t;
	 at t+1: CtlToALU_port_notify = false;
	 at t+1: CtlToDec_port_notify = false;
	 at t+1: CtlToMem_port_notify = false;
	 at t+1: CtlToRegs_port_notify = false;
	 at t+1: MemToCtl_port_notify = true;
end property;

property wait_memoryOperation_10 is
dependencies: no_reset;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: memoryOperation_10;
	 at t: not(CtlToMem_port_sync);
prove:
	 at t+1: memoryOperation_10;
	 at t+1: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t+1: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t+1: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t+1: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t+1: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t+1: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t+1: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t+1: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t+1: CtlToMem_port_sig_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: CtlToMem_port_sig_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: CtlToMem_port_sig_mask = memoryAccess_mask_at_t;
	 at t+1: CtlToMem_port_sig_req = memoryAccess_req_at_t;
	 at t+1: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t+1: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t+1: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t+1: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t+1: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t+1: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t+1: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t+1: br_en = br_en_at_t;
	 at t+1: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t+1: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t+1: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t+1: fromMemoryData = fromMemoryData_at_t;
	 at t+1: mem_en = mem_en_at_t;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: pc_next = pc_next_at_t;
	 at t+1: pc_reg = pc_reg_at_t;
	 at t+1: reg_rd_en = reg_rd_en_at_t;
	 at t+1: wb_en = wb_en_at_t;
	 at t+1: wb_sel = wb_sel_at_t;
	 at t+1: CtlToALU_port_notify = false;
	 at t+1: CtlToDec_port_notify = false;
	 at t+1: CtlToMem_port_notify = true;
	 at t+1: CtlToRegs_port_notify = false;
	 at t+1: MemToCtl_port_notify = false;
end property;

property wait_memoryOperation_11 is
dependencies: no_reset;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_imm_at_t = CtlToALU_data_imm@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToALU_data_pc_reg_at_t = CtlToALU_data_pc_reg@t,
	CtlToALU_data_reg1_contents_at_t = CtlToALU_data_reg1_contents@t,
	CtlToALU_data_reg2_contents_at_t = CtlToALU_data_reg2_contents@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_req_at_t = CtlToRegs_data_req@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_at_t = fromMemoryData@t,
	mem_en_at_t = mem_en@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pc_next_at_t = pc_next@t,
	pc_reg_at_t = pc_reg@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: memoryOperation_11;
	 at t: not(MemToCtl_port_sync);
prove:
	 at t+1: memoryOperation_11;
	 at t+1: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t+1: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t+1: CtlToALU_data_imm = CtlToALU_data_imm_at_t;
	 at t+1: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t+1: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t+1: CtlToALU_data_pc_reg = CtlToALU_data_pc_reg_at_t;
	 at t+1: CtlToALU_data_reg1_contents = CtlToALU_data_reg1_contents_at_t;
	 at t+1: CtlToALU_data_reg2_contents = CtlToALU_data_reg2_contents_at_t;
	 at t+1: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t+1: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t+1: CtlToRegs_data_req = CtlToRegs_data_req_at_t;
	 at t+1: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t+1: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t+1: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t+1: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t+1: br_en = br_en_at_t;
	 at t+1: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t+1: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t+1: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t+1: fromMemoryData = fromMemoryData_at_t;
	 at t+1: mem_en = mem_en_at_t;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: pc_next = pc_next_at_t;
	 at t+1: pc_reg = pc_reg_at_t;
	 at t+1: reg_rd_en = reg_rd_en_at_t;
	 at t+1: wb_en = wb_en_at_t;
	 at t+1: wb_sel = wb_sel_at_t;
	 at t+1: CtlToALU_port_notify = false;
	 at t+1: CtlToDec_port_notify = false;
	 at t+1: CtlToMem_port_notify = false;
	 at t+1: CtlToRegs_port_notify = false;
	 at t+1: MemToCtl_port_notify = true;
end property;
