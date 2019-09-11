-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
--macro CtlToDec_port_notify :  boolean  := end macro; 
--macro CtlToMem_port_notify :  boolean  := end macro; 
--macro CtlToMem_port_sync   :  boolean  := end macro; 
--macro CtlToRegs_port_notify :  boolean  := end macro; 
--macro MemToCtl_port_notify :  boolean  := end macro; 
--macro MemToCtl_port_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
--macro CtlToDec_port_sig : unsigned := end macro; 
macro CtlToMem_port_sig_addrIn : unsigned := CtlToMem_port_sig.addrIn end macro; 
macro CtlToMem_port_sig_dataIn : unsigned := CtlToMem_port_sig.dataIn end macro; 
macro CtlToMem_port_sig_mask : ME_MaskType := CtlToMem_port_sig.mask end macro; 
macro CtlToMem_port_sig_req : ME_AccessType := CtlToMem_port_sig.req end macro; 
macro CtlToRegs_port_sig_dst : unsigned := CtlToRegs_port_sig.dst end macro; 
macro CtlToRegs_port_sig_dst_data : unsigned := CtlToRegs_port_sig.dst_data end macro; 
macro CtlToRegs_port_sig_req : AccessType_Reg := CtlToRegs_port_sig.req end macro; 
macro CtlToRegs_port_sig_src1 : unsigned := CtlToRegs_port_sig.src1 end macro; 
macro CtlToRegs_port_sig_src2 : unsigned := CtlToRegs_port_sig.src2 end macro; 
macro DecToCtl_port_sig_encType : EncType := DecToCtl_port_sig.encType end macro; 
macro DecToCtl_port_sig_imm : unsigned := DecToCtl_port_sig.imm end macro; 
macro DecToCtl_port_sig_instrType : InstrType := DecToCtl_port_sig.instrType end macro; 
macro DecToCtl_port_sig_rd_addr : unsigned := DecToCtl_port_sig.rd_addr end macro; 
macro DecToCtl_port_sig_rs1_addr : unsigned := DecToCtl_port_sig.rs1_addr end macro; 
macro DecToCtl_port_sig_rs2_addr : unsigned := DecToCtl_port_sig.rs2_addr end macro; 
macro MemToCtl_port_sig_loadedData : unsigned := MemToCtl_port_sig.loadedData end macro; 
macro RegsToCtl_port_sig_contents1 : unsigned := RegsToCtl_port_sig.contents1 end macro; 
macro RegsToCtl_port_sig_contents2 : unsigned := RegsToCtl_port_sig.contents2 end macro; 
--macro dummy_port_sig : boolean := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro ALUtoCtl_data_ALU_result : unsigned := ALUtoCtl_data.ALU_result end macro; 
macro CtlToALU_data_alu_fun : ALU_function := CtlToALU_data.alu_fun end macro; 
macro CtlToALU_data_op1_sel : ALUopType := CtlToALU_data.op1_sel end macro; 
macro CtlToALU_data_op2_sel : ALUopType := CtlToALU_data.op2_sel end macro; 
macro CtlToRegs_data_dst : unsigned := CtlToRegs_data.dst end macro; 
macro CtlToRegs_data_dst_data : unsigned := CtlToRegs_data.dst_data end macro; 
macro CtlToRegs_data_src1 : unsigned := CtlToRegs_data.src1 end macro; 
macro CtlToRegs_data_src2 : unsigned := CtlToRegs_data.src2 end macro; 
macro RegsToCtl_data_contents1 : unsigned := RegsToCtl_data.contents1 end macro; 
macro RegsToCtl_data_contents2 : unsigned := RegsToCtl_data.contents2 end macro; 
--macro br_en : boolean := end macro; 
macro decodedInstr_imm : unsigned := decodedInstr.imm end macro; 
macro decodedInstr_instrType : InstrType := decodedInstr.instrType end macro; 
macro decodedInstr_rd_addr : unsigned := decodedInstr.rd_addr end macro; 
macro fromMemoryData_loadedData : unsigned := fromMemoryData.loadedData end macro; 
--macro mem_en : boolean := end macro; 
macro memoryAccess_addrIn : unsigned := memoryAccess.addrIn end macro; 
macro memoryAccess_dataIn : unsigned := memoryAccess.dataIn end macro; 
macro memoryAccess_mask : ME_MaskType := memoryAccess.mask end macro; 
macro memoryAccess_req : ME_AccessType := memoryAccess.req end macro; 
--macro pc_next : unsigned := end macro; 
--macro pc_reg : unsigned := end macro; 
--macro reg_rd_en : boolean := end macro; 
--macro wb_en : boolean := end macro; 
--macro wb_sel : WBselType := end macro; 


-- STATES -- 
--macro executeALU_2 : boolean := true end macro;
--macro executeALU_3 : boolean := true end macro;
--macro fetch_4 : boolean := true end macro;
--macro fetch_5 : boolean := true end macro;
--macro memoryOperation_6 : boolean := true end macro;
--macro memoryOperation_7 : boolean := true end macro;
--macro readRegisterFile_8 : boolean := true end macro;
--macro writeBack_10 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: fetch_4;
	 at t: ALUtoCtl_data_ALU_result = resize(0,32);
	 at t: CtlToALU_data_alu_fun = ALU_ADD;
	 at t: CtlToALU_data_op1_sel = OP_IMM;
	 at t: CtlToALU_data_op2_sel = OP_IMM;
	 at t: CtlToMem_port_sig_addrIn = resize(0,32);
	 at t: CtlToMem_port_sig_dataIn = resize(0,32);
	 at t: CtlToMem_port_sig_mask = MT_W;
	 at t: CtlToMem_port_sig_req = ME_RD;
	 at t: CtlToRegs_data_dst = resize(0,32);
	 at t: CtlToRegs_data_dst_data = resize(0,32);
	 at t: CtlToRegs_data_src1 = resize(0,32);
	 at t: CtlToRegs_data_src2 = resize(0,32);
	 at t: RegsToCtl_data_contents1 = resize(0,32);
	 at t: RegsToCtl_data_contents2 = resize(0,32);
	 at t: br_en = false;
	 at t: decodedInstr_imm = resize(0,32);
	 at t: decodedInstr_instrType = And_Instr;
	 at t: decodedInstr_rd_addr = resize(0,32);
	 at t: fromMemoryData_loadedData = resize(0,32);
	 at t: mem_en = false;
	 at t: memoryAccess_addrIn = resize(0,32);
	 at t: memoryAccess_dataIn = resize(0,32);
	 at t: memoryAccess_mask = MT_W;
	 at t: memoryAccess_req = ME_RD;
	 at t: pc_next = resize(0,32);
	 at t: pc_reg = resize(0,32);
	 at t: reg_rd_en = false;
	 at t: wb_en = false;
	 at t: wb_sel = WB_ALU;
	 at t: CtlToDec_port_notify = false;
	 at t: CtlToMem_port_notify = true;
	 at t: CtlToRegs_port_notify = false;
	 at t: MemToCtl_port_notify = false;
end property;


property memoryOperation_7_read_997 is
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
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	MemToCtl_port_sig_loadedData_at_t = MemToCtl_port_sig_loadedData@t,
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
	 at t: memoryOperation_7;
	 at t: (wb_sel = WB_ALU);
	 at t: not((wb_en and not((decodedInstr_rd_addr = resize(0,32)))));
	 at t: MemToCtl_port_sync;
prove:
	 at t_end: fetch_4;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = pc_next_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = ME_RD;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = MemToCtl_port_sig_loadedData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = pc_next_at_t;
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_next_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property memoryOperation_7_read_998 is
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
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	MemToCtl_port_sig_loadedData_at_t = MemToCtl_port_sig_loadedData@t,
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
	 at t: memoryOperation_7;
	 at t: (wb_sel = WB_MEM);
	 at t: not((wb_en and not((decodedInstr_rd_addr = resize(0,32)))));
	 at t: MemToCtl_port_sync;
prove:
	 at t_end: fetch_4;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = pc_next_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = ME_RD;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = MemToCtl_port_sig_loadedData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = pc_next_at_t;
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_next_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property memoryOperation_7_read_999 is
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
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	MemToCtl_port_sig_loadedData_at_t = MemToCtl_port_sig_loadedData@t,
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
	 at t: memoryOperation_7;
	 at t: not((wb_sel = WB_ALU));
	 at t: not((wb_sel = WB_MEM));
	 at t: not((wb_sel = WB_PC4));
	 at t: MemToCtl_port_sync;
prove:
	 at t_end: fetch_4;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = pc_next_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = ME_RD;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = MemToCtl_port_sig_loadedData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = pc_next_at_t;
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_next_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property memoryOperation_7_read_1000 is
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
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	MemToCtl_port_sig_loadedData_at_t = MemToCtl_port_sig_loadedData@t,
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
	 at t: memoryOperation_7;
	 at t: (wb_sel = WB_PC4);
	 at t: not((wb_en and not((decodedInstr_rd_addr = resize(0,32)))));
	 at t: MemToCtl_port_sync;
prove:
	 at t_end: fetch_4;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = pc_next_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = ME_RD;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = MemToCtl_port_sig_loadedData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = pc_next_at_t;
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_next_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property memoryOperation_7_read_1001 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	MemToCtl_port_sig_loadedData_at_t = MemToCtl_port_sig_loadedData@t,
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
	 at t: memoryOperation_7;
	 at t: (wb_sel = WB_ALU);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = resize(0,32)));
	 at t: MemToCtl_port_sync;
prove:
	 at t_end: writeBack_10;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = ALUtoCtl_data_ALU_result_at_t;
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
	 at t_end: fromMemoryData_loadedData = MemToCtl_port_sig_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property memoryOperation_7_read_1002 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	MemToCtl_port_sig_loadedData_at_t = MemToCtl_port_sig_loadedData@t,
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
	 at t: memoryOperation_7;
	 at t: (wb_sel = WB_MEM);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = resize(0,32)));
	 at t: MemToCtl_port_sync;
prove:
	 at t_end: writeBack_10;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = MemToCtl_port_sig_loadedData_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: CtlToRegs_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_port_sig_dst_data = MemToCtl_port_sig_loadedData_at_t;
	 at t_end: CtlToRegs_port_sig_req = REG_WR;
	 at t_end: CtlToRegs_port_sig_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_port_sig_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = MemToCtl_port_sig_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property memoryOperation_7_read_1003 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	MemToCtl_port_sig_loadedData_at_t = MemToCtl_port_sig_loadedData@t,
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
	 at t: memoryOperation_7;
	 at t: (wb_sel = WB_PC4);
	 at t: wb_en;
	 at t: not((decodedInstr_rd_addr = resize(0,32)));
	 at t: MemToCtl_port_sync;
prove:
	 at t_end: writeBack_10;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = decodedInstr_rd_addr_at_t;
	 at t_end: CtlToRegs_data_dst_data = (4 + pc_reg_at_t)(31 downto 0);
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
	 at t_end: fromMemoryData_loadedData = MemToCtl_port_sig_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end-1]: CtlToRegs_port_notify = false;
	 at t_end: CtlToRegs_port_notify = true;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1004 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_X);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1005 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_X);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1006 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_X);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1007 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_ADD);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (RegsToCtl_port_sig_contents1_at_t + RegsToCtl_port_sig_contents2_at_t)(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1008 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_X);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1009 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_X);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1010 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_X);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1011 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_X);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1012 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_X);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1013 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SUB);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (RegsToCtl_port_sig_contents1_at_t + (4294967295 * RegsToCtl_port_sig_contents2_at_t)(31 downto 0))(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1014 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_ADD);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (RegsToCtl_port_sig_contents1_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1015 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_ADD);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (decodedInstr_imm_at_t + RegsToCtl_port_sig_contents2_at_t)(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1016 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_X);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1017 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_X);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1018 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_X);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1019 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_X);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1020 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_AND);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = not((not(RegsToCtl_port_sig_contents1_at_t) or not(RegsToCtl_port_sig_contents2_at_t)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1021 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SUB);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (RegsToCtl_port_sig_contents1_at_t + (4294967295 * decodedInstr_imm_at_t)(31 downto 0))(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1022 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_ADD);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (RegsToCtl_port_sig_contents1_at_t + pc_reg_at_t)(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1023 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_ADD);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1024 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SUB);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (decodedInstr_imm_at_t + (4294967295 * RegsToCtl_port_sig_contents2_at_t)(31 downto 0))(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1025 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_ADD);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (2 * decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1026 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_ADD);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (pc_reg_at_t + RegsToCtl_port_sig_contents2_at_t)(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1027 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_X);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1028 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_X);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1029 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_ADD);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1030 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_X);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1031 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_X);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1032 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_OR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (RegsToCtl_port_sig_contents1_at_t or RegsToCtl_port_sig_contents2_at_t);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1033 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_AND);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = not((not(RegsToCtl_port_sig_contents1_at_t) or not(decodedInstr_imm_at_t)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1034 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SUB);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (RegsToCtl_port_sig_contents1_at_t + (4294967295 * pc_reg_at_t)(31 downto 0))(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1035 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SUB);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1036 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_AND);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = not((not(decodedInstr_imm_at_t) or not(RegsToCtl_port_sig_contents2_at_t)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1037 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SUB);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (0 * decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1038 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_ADD);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (decodedInstr_imm_at_t + pc_reg_at_t)(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1039 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_ADD);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = decodedInstr_imm_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1040 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SUB);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (pc_reg_at_t + (4294967295 * RegsToCtl_port_sig_contents2_at_t)(31 downto 0))(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1041 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_ADD);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (pc_reg_at_t + decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1042 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SUB);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (4294967295 * RegsToCtl_port_sig_contents2_at_t)(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1043 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_ADD);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = decodedInstr_imm_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1044 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_XOR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (RegsToCtl_port_sig_contents1_at_t xor RegsToCtl_port_sig_contents2_at_t);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1045 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_OR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (RegsToCtl_port_sig_contents1_at_t or decodedInstr_imm_at_t);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1046 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_AND);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = not((not(RegsToCtl_port_sig_contents1_at_t) or not(pc_reg_at_t)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1047 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_AND);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1048 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_OR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (decodedInstr_imm_at_t or RegsToCtl_port_sig_contents2_at_t);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1049 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_AND);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = decodedInstr_imm_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1050 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SUB);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (decodedInstr_imm_at_t + (4294967295 * pc_reg_at_t)(31 downto 0))(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1051 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SUB);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = decodedInstr_imm_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1052 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_AND);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = not((not(pc_reg_at_t) or not(RegsToCtl_port_sig_contents2_at_t)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1053 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SUB);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (pc_reg_at_t + (4294967295 * decodedInstr_imm_at_t)(31 downto 0))(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1054 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_ADD);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (2 * pc_reg_at_t)(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1055 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_ADD);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = pc_reg_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1056 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_AND);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1057 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SUB);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (4294967295 * decodedInstr_imm_at_t)(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1058 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_ADD);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = pc_reg_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1059 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_ADD);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1060 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_XOR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (RegsToCtl_port_sig_contents1_at_t xor decodedInstr_imm_at_t);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1061 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_OR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (RegsToCtl_port_sig_contents1_at_t or pc_reg_at_t);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1062 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_OR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1063 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_XOR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (decodedInstr_imm_at_t xor RegsToCtl_port_sig_contents2_at_t);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1064 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_OR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = decodedInstr_imm_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1065 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_AND);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = not((not(decodedInstr_imm_at_t) or not(pc_reg_at_t)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1066 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_AND);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1067 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_OR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (pc_reg_at_t or RegsToCtl_port_sig_contents2_at_t);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1068 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_AND);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = not((not(pc_reg_at_t) or not(decodedInstr_imm_at_t)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1069 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SUB);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (0 * pc_reg_at_t)(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1070 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SUB);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = pc_reg_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1071 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_OR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1072 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_AND);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1073 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SUB);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (4294967295 * pc_reg_at_t)(31 downto 0);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1074 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SUB);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1075 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: not((RegsToCtl_port_sig_contents2 <= RegsToCtl_port_sig_contents1));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1076 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: (RegsToCtl_port_sig_contents2 <= RegsToCtl_port_sig_contents1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1077 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_XOR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (RegsToCtl_port_sig_contents1_at_t xor pc_reg_at_t);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1078 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_XOR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1079 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_XOR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1080 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_OR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (decodedInstr_imm_at_t or pc_reg_at_t);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1081 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_OR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = decodedInstr_imm_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1082 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_XOR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (pc_reg_at_t xor RegsToCtl_port_sig_contents2_at_t);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1083 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_OR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (pc_reg_at_t or decodedInstr_imm_at_t);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1084 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_AND);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = pc_reg_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1085 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_AND);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1086 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_XOR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1087 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_OR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = decodedInstr_imm_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1088 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_AND);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1089 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_AND);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1090 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: not((RegsToCtl_port_sig_contents2 <= RegsToCtl_port_sig_contents1));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1091 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: (RegsToCtl_port_sig_contents2 <= RegsToCtl_port_sig_contents1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1092 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_left(RegsToCtl_port_sig_contents1_at_t,(RegsToCtl_port_sig_contents2_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1093 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: not((decodedInstr_imm <= RegsToCtl_port_sig_contents1));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1094 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: (decodedInstr_imm <= RegsToCtl_port_sig_contents1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1095 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: not((RegsToCtl_port_sig_contents2 <= decodedInstr_imm));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1096 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: (RegsToCtl_port_sig_contents2 <= decodedInstr_imm);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1097 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_XOR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (decodedInstr_imm_at_t xor pc_reg_at_t);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1098 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_XOR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = decodedInstr_imm_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1099 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_XOR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (pc_reg_at_t xor decodedInstr_imm_at_t);
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1100 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_OR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = pc_reg_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1101 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_OR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = pc_reg_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1102 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_XOR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = decodedInstr_imm_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1103 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_OR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = pc_reg_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1104 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_OR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1105 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SRA);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(RegsToCtl_port_sig_contents1_at_t,(RegsToCtl_port_sig_contents2_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1106 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: not((decodedInstr_imm <= RegsToCtl_port_sig_contents1));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1107 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: (decodedInstr_imm <= RegsToCtl_port_sig_contents1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1108 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SLL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_left(RegsToCtl_port_sig_contents1_at_t,(decodedInstr_imm_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1109 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: not((pc_reg <= RegsToCtl_port_sig_contents1));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1110 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: (pc_reg <= RegsToCtl_port_sig_contents1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1111 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1112 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: not((RegsToCtl_port_sig_contents2 <= decodedInstr_imm));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1113 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: (RegsToCtl_port_sig_contents2 <= decodedInstr_imm);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1114 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_left(decodedInstr_imm_at_t,(RegsToCtl_port_sig_contents2_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1115 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1116 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: not((RegsToCtl_port_sig_contents2 <= pc_reg));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1117 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: (RegsToCtl_port_sig_contents2 <= pc_reg);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1118 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_XOR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1119 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_XOR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = pc_reg_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1120 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: not((RegsToCtl_port_sig_contents2 = resize(0,32)));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1121 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: (RegsToCtl_port_sig_contents2 = resize(0,32));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1122 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_XOR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = pc_reg_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1123 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_XOR);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1124 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SRL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(RegsToCtl_port_sig_contents1_at_t,(RegsToCtl_port_sig_contents2_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1125 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SRA);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(RegsToCtl_port_sig_contents1_at_t,(decodedInstr_imm_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1126 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: not((pc_reg <= RegsToCtl_port_sig_contents1));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1127 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: (pc_reg <= RegsToCtl_port_sig_contents1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1128 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SLL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_left(RegsToCtl_port_sig_contents1_at_t,(pc_reg_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1129 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1130 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SLL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1131 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SRA);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(decodedInstr_imm_at_t,(RegsToCtl_port_sig_contents2_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1132 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1133 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SLL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_left(decodedInstr_imm_at_t,(decodedInstr_imm_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1134 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: not((pc_reg <= decodedInstr_imm));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1135 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: (pc_reg <= decodedInstr_imm);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1136 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1137 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: not((RegsToCtl_port_sig_contents2 <= pc_reg));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1138 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: (RegsToCtl_port_sig_contents2 <= pc_reg);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1139 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_left(pc_reg_at_t,(RegsToCtl_port_sig_contents2_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1140 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: not((decodedInstr_imm <= pc_reg));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1141 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: (decodedInstr_imm <= pc_reg);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1142 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: not((RegsToCtl_port_sig_contents2 = resize(0,32)));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1143 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: (RegsToCtl_port_sig_contents2 = resize(0,32));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1144 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SLL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_left(resize(0,32),(RegsToCtl_port_sig_contents2_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1145 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: not((decodedInstr_imm = resize(0,32)));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1146 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: (decodedInstr_imm = resize(0,32));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1147 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_COPY1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1148 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SRL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(RegsToCtl_port_sig_contents1_at_t,(decodedInstr_imm_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1149 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SRA);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(RegsToCtl_port_sig_contents1_at_t,(pc_reg_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1150 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SRA);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1151 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SRL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(decodedInstr_imm_at_t,(RegsToCtl_port_sig_contents2_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1152 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SRA);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(decodedInstr_imm_at_t,(decodedInstr_imm_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1153 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: not((pc_reg <= decodedInstr_imm));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1154 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: (pc_reg <= decodedInstr_imm);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1155 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SLL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_left(decodedInstr_imm_at_t,(pc_reg_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1156 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1157 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SLL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = decodedInstr_imm_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1158 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SRA);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(pc_reg_at_t,(RegsToCtl_port_sig_contents2_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1159 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: not((decodedInstr_imm <= pc_reg));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1160 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: (decodedInstr_imm <= pc_reg);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1161 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SLL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_left(pc_reg_at_t,(decodedInstr_imm_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1162 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1163 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1164 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SRA);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(0,(RegsToCtl_port_sig_contents2_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1165 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: not((decodedInstr_imm = resize(0,32)));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1166 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: (decodedInstr_imm = resize(0,32));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1167 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SLL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_left(resize(0,32),(decodedInstr_imm_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1168 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: not((pc_reg = resize(0,32)));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1169 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
	 at t: (pc_reg = resize(0,32));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1170 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SLT);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1171 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_COPY1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1172 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SRL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(RegsToCtl_port_sig_contents1_at_t,(pc_reg_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1173 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SRL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1174 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_COPY1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = decodedInstr_imm_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1175 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SRL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(decodedInstr_imm_at_t,(decodedInstr_imm_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1176 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SRA);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(decodedInstr_imm_at_t,(pc_reg_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1177 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SRA);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = decodedInstr_imm_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1178 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SRL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(pc_reg_at_t,(RegsToCtl_port_sig_contents2_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1179 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SRA);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(pc_reg_at_t,(decodedInstr_imm_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1180 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1181 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SLL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_left(pc_reg_at_t,(pc_reg_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1182 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1183 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SLL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = pc_reg_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1184 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_SRL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(0,(RegsToCtl_port_sig_contents2_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1185 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SRA);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(0,(decodedInstr_imm_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1186 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: not((pc_reg = resize(0,32)));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 1;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1187 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
	 at t: (pc_reg = resize(0,32));
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1188 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SLL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_left(resize(0,32),(pc_reg_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1189 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SLTU);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1190 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SLL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1191 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_COPY1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1192 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_REG);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_COPY1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1193 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_COPY1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = decodedInstr_imm_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1194 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SRL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(decodedInstr_imm_at_t,(pc_reg_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1195 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SRL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = decodedInstr_imm_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1196 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_COPY1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = pc_reg_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1197 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SRL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(pc_reg_at_t,(decodedInstr_imm_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1198 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SRA);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(pc_reg_at_t,(pc_reg_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1199 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SRA);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = pc_reg_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1200 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_REG);
	 at t: (CtlToALU_data_alu_fun = ALU_COPY1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1201 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_SRL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(0,(decodedInstr_imm_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1202 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SRA);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(0,(pc_reg_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1203 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SRA);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1204 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_COPY1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = decodedInstr_imm_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1205 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_IMM);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_COPY1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = decodedInstr_imm_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1206 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_COPY1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = pc_reg_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1207 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SRL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(pc_reg_at_t,(pc_reg_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1208 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SRL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = pc_reg_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1209 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_IMM);
	 at t: (CtlToALU_data_alu_fun = ALU_COPY1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1210 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_SRL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = (shift_right(0,(pc_reg_at_t and 31)));
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1211 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_SRL);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1212 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_COPY1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = pc_reg_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1213 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: (CtlToALU_data_op1_sel = OP_PC);
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_COPY1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = pc_reg_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1214 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: (CtlToALU_data_op2_sel = OP_PC);
	 at t: (CtlToALU_data_alu_fun = ALU_COPY1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property readRegisterFile_8_write_1215 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_port_sig_contents1_at_t = RegsToCtl_port_sig_contents1@t,
	RegsToCtl_port_sig_contents2_at_t = RegsToCtl_port_sig_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: readRegisterFile_8;
	 at t: not((CtlToALU_data_op1_sel = OP_REG));
	 at t: not((CtlToALU_data_op1_sel = OP_IMM));
	 at t: not((CtlToALU_data_op1_sel = OP_PC));
	 at t: not((CtlToALU_data_op2_sel = OP_REG));
	 at t: not((CtlToALU_data_op2_sel = OP_IMM));
	 at t: not((CtlToALU_data_op2_sel = OP_PC));
	 at t: (CtlToALU_data_alu_fun = ALU_COPY1);
prove:
	 at t_end: executeALU_2;
	 at t_end: ALUtoCtl_data_ALU_result = 0;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_port_sig_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_port_sig_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end]: CtlToMem_port_notify = false;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property writeBack_10_write_1216 is
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
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
	mem_en_at_t = mem_en@t,
	pc_next_at_t = pc_next@t,
	reg_rd_en_at_t = reg_rd_en@t,
	wb_en_at_t = wb_en@t,
	wb_sel_at_t = wb_sel@t;
assume: 
	 at t: writeBack_10;
prove:
	 at t_end: fetch_4;
	 at t_end: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t_end: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t_end: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t_end: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t_end: CtlToMem_port_sig_addrIn = pc_next_at_t;
	 at t_end: CtlToMem_port_sig_dataIn = 0;
	 at t_end: CtlToMem_port_sig_mask = MT_W;
	 at t_end: CtlToMem_port_sig_req = ME_RD;
	 at t_end: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t_end: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t_end: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t_end: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t_end: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t_end: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t_end: br_en = br_en_at_t;
	 at t_end: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t_end: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
	 at t_end: mem_en = mem_en_at_t;
	 at t_end: memoryAccess_addrIn = pc_next_at_t;
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pc_next = pc_next_at_t;
	 at t_end: pc_reg = pc_next_at_t;
	 at t_end: reg_rd_en = reg_rd_en_at_t;
	 at t_end: wb_en = wb_en_at_t;
	 at t_end: wb_sel = wb_sel_at_t;
	 during[t+1, t_end]: CtlToDec_port_notify = false;
	 during[t+1, t_end-1]: CtlToMem_port_notify = false;
	 at t_end: CtlToMem_port_notify = true;
	 during[t+1, t_end]: CtlToRegs_port_notify = false;
	 during[t+1, t_end]: MemToCtl_port_notify = false;
end property;

property wait_fetch_4 is
dependencies: no_reset;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: fetch_4;
	 at t: not(CtlToMem_port_sync);
prove:
	 at t+1: fetch_4;
	 at t+1: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t+1: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t+1: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t+1: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t+1: CtlToMem_port_sig_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: CtlToMem_port_sig_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: CtlToMem_port_sig_mask = memoryAccess_mask_at_t;
	 at t+1: CtlToMem_port_sig_req = memoryAccess_req_at_t;
	 at t+1: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t+1: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t+1: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t+1: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t+1: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t+1: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t+1: br_en = br_en_at_t;
	 at t+1: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t+1: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t+1: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t+1: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 at t+1: CtlToDec_port_notify = false;
	 at t+1: CtlToMem_port_notify = true;
	 at t+1: CtlToRegs_port_notify = false;
	 at t+1: MemToCtl_port_notify = false;
end property;

property wait_fetch_5 is
dependencies: no_reset;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: fetch_5;
	 at t: not(MemToCtl_port_sync);
prove:
	 at t+1: fetch_5;
	 at t+1: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t+1: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t+1: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t+1: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t+1: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t+1: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t+1: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t+1: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t+1: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t+1: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t+1: br_en = br_en_at_t;
	 at t+1: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t+1: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t+1: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t+1: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 at t+1: CtlToDec_port_notify = false;
	 at t+1: CtlToMem_port_notify = false;
	 at t+1: CtlToRegs_port_notify = false;
	 at t+1: MemToCtl_port_notify = true;
end property;

property wait_memoryOperation_6 is
dependencies: no_reset;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: memoryOperation_6;
	 at t: not(CtlToMem_port_sync);
prove:
	 at t+1: memoryOperation_6;
	 at t+1: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t+1: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t+1: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t+1: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t+1: CtlToMem_port_sig_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: CtlToMem_port_sig_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: CtlToMem_port_sig_mask = memoryAccess_mask_at_t;
	 at t+1: CtlToMem_port_sig_req = memoryAccess_req_at_t;
	 at t+1: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t+1: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t+1: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t+1: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t+1: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t+1: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t+1: br_en = br_en_at_t;
	 at t+1: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t+1: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t+1: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t+1: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 at t+1: CtlToDec_port_notify = false;
	 at t+1: CtlToMem_port_notify = true;
	 at t+1: CtlToRegs_port_notify = false;
	 at t+1: MemToCtl_port_notify = false;
end property;

property wait_memoryOperation_7 is
dependencies: no_reset;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t,
	CtlToALU_data_alu_fun_at_t = CtlToALU_data_alu_fun@t,
	CtlToALU_data_op1_sel_at_t = CtlToALU_data_op1_sel@t,
	CtlToALU_data_op2_sel_at_t = CtlToALU_data_op2_sel@t,
	CtlToRegs_data_dst_at_t = CtlToRegs_data_dst@t,
	CtlToRegs_data_dst_data_at_t = CtlToRegs_data_dst_data@t,
	CtlToRegs_data_src1_at_t = CtlToRegs_data_src1@t,
	CtlToRegs_data_src2_at_t = CtlToRegs_data_src2@t,
	RegsToCtl_data_contents1_at_t = RegsToCtl_data_contents1@t,
	RegsToCtl_data_contents2_at_t = RegsToCtl_data_contents2@t,
	br_en_at_t = br_en@t,
	decodedInstr_imm_at_t = decodedInstr_imm@t,
	decodedInstr_instrType_at_t = decodedInstr_instrType@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
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
	 at t: memoryOperation_7;
	 at t: not(MemToCtl_port_sync);
prove:
	 at t+1: memoryOperation_7;
	 at t+1: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t+1: CtlToALU_data_alu_fun = CtlToALU_data_alu_fun_at_t;
	 at t+1: CtlToALU_data_op1_sel = CtlToALU_data_op1_sel_at_t;
	 at t+1: CtlToALU_data_op2_sel = CtlToALU_data_op2_sel_at_t;
	 at t+1: CtlToRegs_data_dst = CtlToRegs_data_dst_at_t;
	 at t+1: CtlToRegs_data_dst_data = CtlToRegs_data_dst_data_at_t;
	 at t+1: CtlToRegs_data_src1 = CtlToRegs_data_src1_at_t;
	 at t+1: CtlToRegs_data_src2 = CtlToRegs_data_src2_at_t;
	 at t+1: RegsToCtl_data_contents1 = RegsToCtl_data_contents1_at_t;
	 at t+1: RegsToCtl_data_contents2 = RegsToCtl_data_contents2_at_t;
	 at t+1: br_en = br_en_at_t;
	 at t+1: decodedInstr_imm = decodedInstr_imm_at_t;
	 at t+1: decodedInstr_instrType = decodedInstr_instrType_at_t;
	 at t+1: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t+1: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
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
	 at t+1: CtlToDec_port_notify = false;
	 at t+1: CtlToMem_port_notify = false;
	 at t+1: CtlToRegs_port_notify = false;
	 at t+1: MemToCtl_port_notify = true;
end property;