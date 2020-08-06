--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 30.11.18
--

-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
-- macro fromMemoryPort_notify :  boolean  := end macro;
-- macro fromMemoryPort_sync   :  boolean  := end macro;
-- macro isa_syscall_Port_notify :  boolean  := end macro;
-- macro isa_syscall_Port_sync   :  boolean  := end macro;
-- macro syscall_isa_Port_notify :  boolean  := end macro;
-- macro syscall_isa_Port_sync   :  boolean  := end macro;
-- macro syscall_reg_Port_notify :  boolean  := end macro;
-- macro toMemoryPort_notify :  boolean  := end macro;
-- macro toMemoryPort_sync   :  boolean  := end macro;


-- DP SIGNALS --
macro fromMemoryPort_sig_loadedData : unsigned := fromMemoryPort.loadedData end macro;
macro isa_syscall_Port_sig : bool := isa_syscall_Port end macro;
macro reg_syscall_Port_sig_reg_file_10 : unsigned := reg_syscall_Port.reg_file_10 end macro;
macro reg_syscall_Port_sig_reg_file_11 : unsigned := reg_syscall_Port.reg_file_11 end macro;
macro reg_syscall_Port_sig_reg_file_12 : unsigned := reg_syscall_Port.reg_file_12 end macro;
macro reg_syscall_Port_sig_reg_file_17 : unsigned := reg_syscall_Port.reg_file_17 end macro;
macro syscall_isa_Port_sig : bool := syscall_isa_Port end macro;
macro syscall_reg_Port_sig_dst : unsigned := syscall_reg_Port.dst end macro;
macro syscall_reg_Port_sig_dstData : unsigned := syscall_reg_Port.dstData end macro;
macro toMemoryPort_sig_addrIn : unsigned := toMemoryPort.addrIn end macro;
macro toMemoryPort_sig_dataIn : unsigned := toMemoryPort.dataIn end macro;
macro toMemoryPort_sig_mask : ME_MaskType := toMemoryPort.mask end macro;
macro toMemoryPort_sig_req : ME_AccessType := toMemoryPort.req end macro;


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
-- macro ans : unsigned := ans end macro;
-- macro index : unsigned := index end macro;
macro memoryAccess_addrIn : unsigned := memoryRequest.addrIn end macro;
macro memoryAccess_dataIn : unsigned := memoryRequest.dataIn end macro;
macro memoryAccess_mask : ME_MaskType := memoryRequest.mask end macro;
macro memoryAccess_req : ME_AccessType := memoryRequest.req end macro;
macro regfileSyscall_reg_file_11 : unsigned := reg_11 end macro;
macro regfileSyscall_reg_file_12 : unsigned := reg_12 end macro;
-- macro sysRES : bool := end macro;


-- STATES --
macro idle_0 : boolean := (section = process_ecall) end macro;
macro process_2 : boolean := (section = return_to_isa1) end macro;
macro process_3 : boolean := (section = return_to_isa2) end macro;
macro writing_4 : boolean := (section = writing1) end macro;
macro writing_5 : boolean := (section = writing2) end macro;
macro writing_7 : boolean := (section = writing_done) end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: idle_0;
	 at t: ans = resize(0,32);
	 at t: index = resize(0,32);
	 at t: memoryAccess_addrIn = resize(0,32);
	 at t: memoryAccess_dataIn = resize(0,32);
	 at t: memoryAccess_mask = MT_B;
	 at t: memoryAccess_req = ME_RD;
	 at t: regfileSyscall_reg_file_11 = resize(0,32);
	 at t: regfileSyscall_reg_file_12 = resize(0,32);
	 at t: sysRES = false;
	 at t: fromMemoryPort_notify = false;
	 at t: isa_syscall_Port_notify = true;
	 at t: syscall_isa_Port_notify = false;
	 at t: syscall_reg_Port_notify = false;
	 at t: toMemoryPort_notify = false;
end property;


property idle_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ans_at_t = ans@t,
	index_at_t = index@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	reg_syscall_Port_sig_reg_file_11_at_t = reg_syscall_Port_sig_reg_file_11@t,
	reg_syscall_Port_sig_reg_file_12_at_t = reg_syscall_Port_sig_reg_file_12@t;
assume: 
	 at t: idle_0;
	 at t: (reg_syscall_Port_sig_reg_file_17 = resize(93,32));
	 at t: isa_syscall_Port_sync;
prove:
	 at t_end: process_2;
	 at t_end: ans = ans_at_t;
	 at t_end: index = index_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: regfileSyscall_reg_file_11 = reg_syscall_Port_sig_reg_file_11_at_t;
	 at t_end: regfileSyscall_reg_file_12 = reg_syscall_Port_sig_reg_file_12_at_t;
	 at t_end: sysRES = false;
	 at t_end: syscall_isa_Port_sig = false;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: syscall_isa_Port_notify = false;
	 at t_end: syscall_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_reg_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
end property;

property idle_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ans_at_t = ans@t,
	index_at_t = index@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	reg_syscall_Port_sig_reg_file_11_at_t = reg_syscall_Port_sig_reg_file_11@t,
	reg_syscall_Port_sig_reg_file_12_at_t = reg_syscall_Port_sig_reg_file_12@t;
assume: 
	 at t: idle_0;
	 at t: not((reg_syscall_Port_sig_reg_file_17 = resize(93,32)));
	 at t: not((reg_syscall_Port_sig_reg_file_17 = resize(64,32)));
	 at t: isa_syscall_Port_sync;
prove:
	 at t_end: process_3;
	 at t_end: ans = ans_at_t;
	 at t_end: index = index_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: regfileSyscall_reg_file_11 = reg_syscall_Port_sig_reg_file_11_at_t;
	 at t_end: regfileSyscall_reg_file_12 = reg_syscall_Port_sig_reg_file_12_at_t;
	 at t_end: sysRES = true;
	 at t_end: syscall_isa_Port_sig = true;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: syscall_isa_Port_notify = false;
	 at t_end: syscall_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_reg_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
end property;

property idle_0_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	reg_syscall_Port_sig_reg_file_11_at_t = reg_syscall_Port_sig_reg_file_11@t,
	reg_syscall_Port_sig_reg_file_12_at_t = reg_syscall_Port_sig_reg_file_12@t,
	sysRES_at_t = sysRES@t;
assume: 
	 at t: idle_0;
	 at t: not((reg_syscall_Port_sig_reg_file_12 = resize(0,32)));
	 at t: (reg_syscall_Port_sig_reg_file_17 = resize(64,32));
	 at t: isa_syscall_Port_sync;
prove:
	 at t_end: writing_4;
	 at t_end: ans = reg_syscall_Port_sig_reg_file_12_at_t;
	 at t_end: index = 0;
	 at t_end: memoryAccess_addrIn = reg_syscall_Port_sig_reg_file_11_at_t;
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_BU;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: regfileSyscall_reg_file_11 = reg_syscall_Port_sig_reg_file_11_at_t;
	 at t_end: regfileSyscall_reg_file_12 = reg_syscall_Port_sig_reg_file_12_at_t;
	 at t_end: sysRES = sysRES_at_t;
	 at t_end: toMemoryPort_sig_addrIn = reg_syscall_Port_sig_reg_file_11_at_t;
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = MT_BU;
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: syscall_reg_Port_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
end property;

property idle_0_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	reg_syscall_Port_sig_reg_file_11_at_t = reg_syscall_Port_sig_reg_file_11@t,
	reg_syscall_Port_sig_reg_file_12_at_t = reg_syscall_Port_sig_reg_file_12@t;
assume: 
	 at t: idle_0;
	 at t: (reg_syscall_Port_sig_reg_file_12 = resize(0,32));
	 at t: (reg_syscall_Port_sig_reg_file_17 = resize(64,32));
	 at t: isa_syscall_Port_sync;
prove:
	 at t_end: writing_7;
	 at t_end: ans = reg_syscall_Port_sig_reg_file_12_at_t;
	 at t_end: index = 0;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: regfileSyscall_reg_file_11 = reg_syscall_Port_sig_reg_file_11_at_t;
	 at t_end: regfileSyscall_reg_file_12 = reg_syscall_Port_sig_reg_file_12_at_t;
	 at t_end: sysRES = true;
	 at t_end: syscall_isa_Port_sig = true;
	 at t_end: syscall_reg_Port_sig_dst = 0;
	 at t_end: syscall_reg_Port_sig_dstData = reg_syscall_Port_sig_reg_file_12_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: syscall_isa_Port_notify = false;
	 at t_end: syscall_isa_Port_notify = true;
	 during[t+1, t_end-1]: syscall_reg_Port_notify = false;
	 at t_end: syscall_reg_Port_notify = true;
	 during[t+1, t_end]: toMemoryPort_notify = false;
end property;

property process_2_write_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ans_at_t = ans@t,
	index_at_t = index@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	regfileSyscall_reg_file_11_at_t = regfileSyscall_reg_file_11@t,
	regfileSyscall_reg_file_12_at_t = regfileSyscall_reg_file_12@t,
	sysRES_at_t = sysRES@t;
assume: 
	 at t: process_2;
	 at t: syscall_isa_Port_sync;
prove:
	 at t_end: idle_0;
	 at t_end: ans = ans_at_t;
	 at t_end: index = index_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: regfileSyscall_reg_file_11 = regfileSyscall_reg_file_11_at_t;
	 at t_end: regfileSyscall_reg_file_12 = regfileSyscall_reg_file_12_at_t;
	 at t_end: sysRES = sysRES_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: isa_syscall_Port_notify = false;
	 at t_end: isa_syscall_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: syscall_reg_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
end property;

property process_3_write_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ans_at_t = ans@t,
	index_at_t = index@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	regfileSyscall_reg_file_11_at_t = regfileSyscall_reg_file_11@t,
	regfileSyscall_reg_file_12_at_t = regfileSyscall_reg_file_12@t,
	sysRES_at_t = sysRES@t;
assume: 
	 at t: process_3;
	 at t: syscall_isa_Port_sync;
prove:
	 at t_end: idle_0;
	 at t_end: ans = ans_at_t;
	 at t_end: index = index_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: regfileSyscall_reg_file_11 = regfileSyscall_reg_file_11_at_t;
	 at t_end: regfileSyscall_reg_file_12 = regfileSyscall_reg_file_12_at_t;
	 at t_end: sysRES = sysRES_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: isa_syscall_Port_notify = false;
	 at t_end: isa_syscall_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: syscall_reg_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
end property;

property writing_4_write_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ans_at_t = ans@t,
	index_at_t = index@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	regfileSyscall_reg_file_11_at_t = regfileSyscall_reg_file_11@t,
	regfileSyscall_reg_file_12_at_t = regfileSyscall_reg_file_12@t,
	sysRES_at_t = sysRES@t;
assume: 
	 at t: writing_4;
	 at t: toMemoryPort_sync;
prove:
	 at t_end: writing_5;
	 at t_end: ans = ans_at_t;
	 at t_end: index = index_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: regfileSyscall_reg_file_11 = regfileSyscall_reg_file_11_at_t;
	 at t_end: regfileSyscall_reg_file_12 = regfileSyscall_reg_file_12_at_t;
	 at t_end: sysRES = sysRES_at_t;
	 during[t+1, t_end-1]: fromMemoryPort_notify = false;
	 at t_end: fromMemoryPort_notify = true;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: syscall_reg_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
end property;

property writing_5_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ans_at_t = ans@t,
	index_at_t = index@t,
	regfileSyscall_reg_file_11_at_t = regfileSyscall_reg_file_11@t,
	regfileSyscall_reg_file_12_at_t = regfileSyscall_reg_file_12@t,
	sysRES_at_t = sysRES@t;
assume: 
	 at t: writing_5;
	 at t: not((regfileSyscall_reg_file_12 <= (resize(1,32) + index)(31 downto 0)));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: writing_4;
	 at t_end: ans = ans_at_t;
	 at t_end: index = (1 + index_at_t)(31 downto 0);
	 at t_end: memoryAccess_addrIn = ((1 + regfileSyscall_reg_file_11_at_t)(31 downto 0) + index_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_BU;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: regfileSyscall_reg_file_11 = regfileSyscall_reg_file_11_at_t;
	 at t_end: regfileSyscall_reg_file_12 = regfileSyscall_reg_file_12_at_t;
	 at t_end: sysRES = sysRES_at_t;
	 at t_end: toMemoryPort_sig_addrIn = ((1 + regfileSyscall_reg_file_11_at_t)(31 downto 0) + index_at_t)(31 downto 0);
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = MT_BU;
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: syscall_reg_Port_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
end property;

property writing_5_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ans_at_t = ans@t,
	index_at_t = index@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	regfileSyscall_reg_file_11_at_t = regfileSyscall_reg_file_11@t,
	regfileSyscall_reg_file_12_at_t = regfileSyscall_reg_file_12@t;
assume: 
	 at t: writing_5;
	 at t: (regfileSyscall_reg_file_12 <= (resize(1,32) + index)(31 downto 0));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: writing_7;
	 at t_end: ans = ans_at_t;
	 at t_end: index = (1 + index_at_t)(31 downto 0);
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: regfileSyscall_reg_file_11 = regfileSyscall_reg_file_11_at_t;
	 at t_end: regfileSyscall_reg_file_12 = regfileSyscall_reg_file_12_at_t;
	 at t_end: sysRES = true;
	 at t_end: syscall_isa_Port_sig = true;
	 at t_end: syscall_reg_Port_sig_dst = 0;
	 at t_end: syscall_reg_Port_sig_dstData = ans_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: syscall_isa_Port_notify = false;
	 at t_end: syscall_isa_Port_notify = true;
	 during[t+1, t_end-1]: syscall_reg_Port_notify = false;
	 at t_end: syscall_reg_Port_notify = true;
	 during[t+1, t_end]: toMemoryPort_notify = false;
end property;

property writing_7_write_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ans_at_t = ans@t,
	index_at_t = index@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	regfileSyscall_reg_file_11_at_t = regfileSyscall_reg_file_11@t,
	regfileSyscall_reg_file_12_at_t = regfileSyscall_reg_file_12@t,
	sysRES_at_t = sysRES@t;
assume: 
	 at t: writing_7;
	 at t: syscall_isa_Port_sync;
prove:
	 at t_end: idle_0;
	 at t_end: ans = ans_at_t;
	 at t_end: index = index_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: regfileSyscall_reg_file_11 = regfileSyscall_reg_file_11_at_t;
	 at t_end: regfileSyscall_reg_file_12 = regfileSyscall_reg_file_12_at_t;
	 at t_end: sysRES = sysRES_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: isa_syscall_Port_notify = false;
	 at t_end: isa_syscall_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: syscall_reg_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
end property;

property wait_idle_0 is
dependencies: no_reset;
freeze:
	ans_at_t = ans@t,
	index_at_t = index@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	regfileSyscall_reg_file_11_at_t = regfileSyscall_reg_file_11@t,
	regfileSyscall_reg_file_12_at_t = regfileSyscall_reg_file_12@t,
	sysRES_at_t = sysRES@t;
assume: 
	 at t: idle_0;
	 at t: not(isa_syscall_Port_sync);
prove:
	 at t+1: idle_0;
	 at t+1: ans = ans_at_t;
	 at t+1: index = index_at_t;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: regfileSyscall_reg_file_11 = regfileSyscall_reg_file_11_at_t;
	 at t+1: regfileSyscall_reg_file_12 = regfileSyscall_reg_file_12_at_t;
	 at t+1: sysRES = sysRES_at_t;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: isa_syscall_Port_notify = true;
	 at t+1: syscall_isa_Port_notify = false;
	 at t+1: syscall_reg_Port_notify = false;
	 at t+1: toMemoryPort_notify = false;
end property;

property wait_process_2 is
dependencies: no_reset;
freeze:
	ans_at_t = ans@t,
	index_at_t = index@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	regfileSyscall_reg_file_11_at_t = regfileSyscall_reg_file_11@t,
	regfileSyscall_reg_file_12_at_t = regfileSyscall_reg_file_12@t,
	sysRES_at_t = sysRES@t;
assume: 
	 at t: process_2;
	 at t: not(syscall_isa_Port_sync);
prove:
	 at t+1: process_2;
	 at t+1: ans = ans_at_t;
	 at t+1: index = index_at_t;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: regfileSyscall_reg_file_11 = regfileSyscall_reg_file_11_at_t;
	 at t+1: regfileSyscall_reg_file_12 = regfileSyscall_reg_file_12_at_t;
	 at t+1: sysRES = sysRES_at_t;
	 at t+1: syscall_isa_Port_sig = sysRES_at_t;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: isa_syscall_Port_notify = false;
	 at t+1: syscall_isa_Port_notify = true;
	 at t+1: syscall_reg_Port_notify = false;
	 at t+1: toMemoryPort_notify = false;
end property;

property wait_process_3 is
dependencies: no_reset;
freeze:
	ans_at_t = ans@t,
	index_at_t = index@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	regfileSyscall_reg_file_11_at_t = regfileSyscall_reg_file_11@t,
	regfileSyscall_reg_file_12_at_t = regfileSyscall_reg_file_12@t,
	sysRES_at_t = sysRES@t;
assume: 
	 at t: process_3;
	 at t: not(syscall_isa_Port_sync);
prove:
	 at t+1: process_3;
	 at t+1: ans = ans_at_t;
	 at t+1: index = index_at_t;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: regfileSyscall_reg_file_11 = regfileSyscall_reg_file_11_at_t;
	 at t+1: regfileSyscall_reg_file_12 = regfileSyscall_reg_file_12_at_t;
	 at t+1: sysRES = sysRES_at_t;
	 at t+1: syscall_isa_Port_sig = sysRES_at_t;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: isa_syscall_Port_notify = false;
	 at t+1: syscall_isa_Port_notify = true;
	 at t+1: syscall_reg_Port_notify = false;
	 at t+1: toMemoryPort_notify = false;
end property;

property wait_writing_4 is
dependencies: no_reset;
freeze:
	ans_at_t = ans@t,
	index_at_t = index@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	regfileSyscall_reg_file_11_at_t = regfileSyscall_reg_file_11@t,
	regfileSyscall_reg_file_12_at_t = regfileSyscall_reg_file_12@t,
	sysRES_at_t = sysRES@t;
assume: 
	 at t: writing_4;
	 at t: not(toMemoryPort_sync);
prove:
	 at t+1: writing_4;
	 at t+1: ans = ans_at_t;
	 at t+1: index = index_at_t;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: regfileSyscall_reg_file_11 = regfileSyscall_reg_file_11_at_t;
	 at t+1: regfileSyscall_reg_file_12 = regfileSyscall_reg_file_12_at_t;
	 at t+1: sysRES = sysRES_at_t;
	 at t+1: toMemoryPort_sig_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: toMemoryPort_sig_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: toMemoryPort_sig_mask = memoryAccess_mask_at_t;
	 at t+1: toMemoryPort_sig_req = memoryAccess_req_at_t;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: isa_syscall_Port_notify = false;
	 at t+1: syscall_isa_Port_notify = false;
	 at t+1: syscall_reg_Port_notify = false;
	 at t+1: toMemoryPort_notify = true;
end property;

property wait_writing_5 is
dependencies: no_reset;
freeze:
	ans_at_t = ans@t,
	index_at_t = index@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	regfileSyscall_reg_file_11_at_t = regfileSyscall_reg_file_11@t,
	regfileSyscall_reg_file_12_at_t = regfileSyscall_reg_file_12@t,
	sysRES_at_t = sysRES@t;
assume: 
	 at t: writing_5;
	 at t: not(fromMemoryPort_sync);
prove:
	 at t+1: writing_5;
	 at t+1: ans = ans_at_t;
	 at t+1: index = index_at_t;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: regfileSyscall_reg_file_11 = regfileSyscall_reg_file_11_at_t;
	 at t+1: regfileSyscall_reg_file_12 = regfileSyscall_reg_file_12_at_t;
	 at t+1: sysRES = sysRES_at_t;
	 at t+1: fromMemoryPort_notify = true;
	 at t+1: isa_syscall_Port_notify = false;
	 at t+1: syscall_isa_Port_notify = false;
	 at t+1: syscall_reg_Port_notify = false;
	 at t+1: toMemoryPort_notify = false;
end property;

property wait_writing_7 is
dependencies: no_reset;
freeze:
	ans_at_t = ans@t,
	index_at_t = index@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	regfileSyscall_reg_file_11_at_t = regfileSyscall_reg_file_11@t,
	regfileSyscall_reg_file_12_at_t = regfileSyscall_reg_file_12@t,
	sysRES_at_t = sysRES@t;
assume: 
	 at t: writing_7;
	 at t: not(syscall_isa_Port_sync);
prove:
	 at t+1: writing_7;
	 at t+1: ans = ans_at_t;
	 at t+1: index = index_at_t;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: regfileSyscall_reg_file_11 = regfileSyscall_reg_file_11_at_t;
	 at t+1: regfileSyscall_reg_file_12 = regfileSyscall_reg_file_12_at_t;
	 at t+1: sysRES = sysRES_at_t;
	 at t+1: syscall_isa_Port_sig = sysRES_at_t;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: isa_syscall_Port_notify = false;
	 at t+1: syscall_isa_Port_notify = true;
	 at t+1: syscall_reg_Port_notify = false;
	 at t+1: toMemoryPort_notify = false;
end property;