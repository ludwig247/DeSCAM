

-- FUNCTIONS --
macro align_control(ctrl: unsigned;reg: unsigned) : unsigned := 
	if ((ctrl = resize(256,32))) then unsigned(((shift_right(reg,resize(8,32))) and resize(3,32)))
	elsif (not((ctrl = resize(256,32))) and (ctrl = resize(65536,32))) then unsigned(((shift_right(reg,resize(16,32))) and resize(65535,32)))
	else unsigned(resize(0,32))
end if;
end macro; 

macro align_flag(flag: unsigned;reg: unsigned) : unsigned := 
	if ((flag = resize(1,32))) then unsigned((reg and resize(1,32)))
	elsif (not((flag = resize(1,32))) and (flag = resize(2,32))) then unsigned(((shift_right(reg,resize(1,32))) and resize(1,32)))
	else unsigned(resize(0,32))
end if;
end macro; 

macro check_interrupt(CR_reg: unsigned;SR_reg: unsigned) : unsigned := 
	if ((((SR_reg and resize(2,32)) = resize(0,32)) or ((CR_reg and resize(4096,32)) /= resize(0,32))) and (((SR_reg and resize(8,32)) /= resize(0,32)) and ((CR_reg and resize(8,32)) /= resize(0,32)))) then unsigned(resize(1,32))
	elsif ((((SR_reg and resize(2,32)) = resize(0,32)) or ((CR_reg and resize(4096,32)) /= resize(0,32))) and not((((SR_reg and resize(8,32)) /= resize(0,32)) and ((CR_reg and resize(8,32)) /= resize(0,32)))) and (((SR_reg and resize(32,32)) /= resize(0,32)) and ((CR_reg and resize(32,32)) /= resize(0,32)))) then unsigned(resize(1,32))
	elsif ((((SR_reg and resize(2,32)) = resize(0,32)) or ((CR_reg and resize(4096,32)) /= resize(0,32))) and not((((SR_reg and resize(8,32)) /= resize(0,32)) and ((CR_reg and resize(8,32)) /= resize(0,32)))) and not((((SR_reg and resize(32,32)) /= resize(0,32)) and ((CR_reg and resize(32,32)) /= resize(0,32)))) and (((SR_reg and resize(16,32)) /= resize(0,32)) and ((CR_reg and resize(16,32)) /= resize(0,32)))) then unsigned(resize(1,32))
	elsif ((((SR_reg and resize(2,32)) = resize(0,32)) or ((CR_reg and resize(4096,32)) /= resize(0,32))) and not((((SR_reg and resize(8,32)) /= resize(0,32)) and ((CR_reg and resize(8,32)) /= resize(0,32)))) and not((((SR_reg and resize(32,32)) /= resize(0,32)) and ((CR_reg and resize(32,32)) /= resize(0,32)))) and not((((SR_reg and resize(16,32)) /= resize(0,32)) and ((CR_reg and resize(16,32)) /= resize(0,32)))) and (((SR_reg and resize(64,32)) /= resize(0,32)) and ((CR_reg and resize(64,32)) /= resize(0,32)))) then unsigned(resize(1,32))
	elsif ((((SR_reg and resize(2,32)) = resize(0,32)) or ((CR_reg and resize(4096,32)) /= resize(0,32))) and not((((SR_reg and resize(8,32)) /= resize(0,32)) and ((CR_reg and resize(8,32)) /= resize(0,32)))) and not((((SR_reg and resize(32,32)) /= resize(0,32)) and ((CR_reg and resize(32,32)) /= resize(0,32)))) and not((((SR_reg and resize(16,32)) /= resize(0,32)) and ((CR_reg and resize(16,32)) /= resize(0,32)))) and not((((SR_reg and resize(64,32)) /= resize(0,32)) and ((CR_reg and resize(64,32)) /= resize(0,32)))) and (((SR_reg and resize(128,32)) /= resize(0,32)) and ((CR_reg and resize(128,32)) /= resize(0,32)))) then unsigned(resize(1,32))
	elsif ((((SR_reg and resize(2,32)) = resize(0,32)) or ((CR_reg and resize(4096,32)) /= resize(0,32))) and not((((SR_reg and resize(8,32)) /= resize(0,32)) and ((CR_reg and resize(8,32)) /= resize(0,32)))) and not((((SR_reg and resize(32,32)) /= resize(0,32)) and ((CR_reg and resize(32,32)) /= resize(0,32)))) and not((((SR_reg and resize(16,32)) /= resize(0,32)) and ((CR_reg and resize(16,32)) /= resize(0,32)))) and not((((SR_reg and resize(64,32)) /= resize(0,32)) and ((CR_reg and resize(64,32)) /= resize(0,32)))) and not((((SR_reg and resize(128,32)) /= resize(0,32)) and ((CR_reg and resize(128,32)) /= resize(0,32))))) then unsigned(resize(0,32))
	else unsigned(resize(0,32))
end if;
end macro; 

macro manage_RX_flags(SR_reg1: unsigned;reg_2_CR_reg: unsigned;reg_2_DR_reg: unsigned;reg_2_SR_reg: unsigned;reg_2_r_act: reg_action) : unsigned := 
	if ((reg_2_r_act = RX_WR)) then unsigned((SR_reg1 or reg_2_SR_reg))
	else unsigned(SR_reg1)
end if;
end macro; 

macro manage_TX_flags(SR_reg: unsigned;flags_tc_flag: tx_flags;flags_txe_flag: tx_flags) : unsigned := 
	if (((flags_tc_flag = SET) and (((SR_reg and resize(32,32)) /= resize(0,32)) or (flags_txe_flag = SET)))) then unsigned(((SR_reg or resize(32,32)) or resize(16,32)))
	elsif (not(((flags_tc_flag = SET) and (((SR_reg and resize(32,32)) /= resize(0,32)) or (flags_txe_flag = SET)))) and (((SR_reg and resize(32,32)) = resize(0,32)) and (flags_txe_flag = SET))) then unsigned((SR_reg or resize(32,32)))
	else unsigned(SR_reg)
end if;
end macro; 

macro register_CR_command(CR_reg: unsigned;u_in_addrIn: unsigned;u_in_dataIn: unsigned;u_in_mask: ME_MaskType;u_in_req: ME_AccessType) : unsigned := 
	if ((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) then unsigned(u_in_dataIn)
	elsif (not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and (((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) then unsigned(((CR_reg and (resize(65536,32) * resize(4294967295,32))(31 downto 0)) or (u_in_dataIn and resize(65535,32))))
	elsif (not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and (((u_in_addrIn = (resize(0,32) + resize(2,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) then unsigned(((CR_reg and resize(65535,32)) or ((shift_left(u_in_dataIn,resize(16,32))) and (resize(65536,32) * resize(4294967295,32))(31 downto 0))))
	elsif (not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = (resize(0,32) + resize(2,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and (((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) then unsigned(((CR_reg and (resize(256,32) * resize(4294967295,32))(31 downto 0)) or (u_in_dataIn and resize(255,32))))
	elsif (not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = (resize(0,32) + resize(2,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and (((u_in_addrIn = (resize(0,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) then unsigned(((CR_reg and (resize(65281,32) * resize(4294967295,32))(31 downto 0)) or ((shift_left(u_in_dataIn,resize(8,32))) and resize(65280,32))))
	elsif (not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = (resize(0,32) + resize(2,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = (resize(0,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and (((u_in_addrIn = (resize(0,32) + resize(2,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) then unsigned(((CR_reg and (resize(16711681,32) * resize(4294967295,32))(31 downto 0)) or ((shift_left(u_in_dataIn,resize(16,32))) and resize(16711680,32))))
	elsif (not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = (resize(0,32) + resize(2,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = (resize(0,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = (resize(0,32) + resize(2,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and (((u_in_addrIn = (resize(0,32) + resize(3,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) then unsigned(((CR_reg and resize(16777215,32)) or ((shift_left(u_in_dataIn,resize(24,32))) and (resize(16777216,32) * resize(4294967295,32))(31 downto 0))))
	else unsigned(CR_reg)
end if;
end macro; 

macro register_RX_event(DR_reg1: unsigned;regs_2_CR_reg: unsigned;regs_2_DR_reg: unsigned;regs_2_SR_reg: unsigned;regs_2_r_act: reg_action) : unsigned := 
	if ((regs_2_r_act = RX_WR)) then unsigned(((DR_reg1 and (resize(65281,32) * resize(4294967295,32))(31 downto 0)) or (regs_2_DR_reg and resize(65280,32))))
	else unsigned(DR_reg1)
end if;
end macro; 

macro register_SR_command(SR_reg: unsigned;u_in_addrIn: unsigned;u_in_dataIn: unsigned;u_in_mask: ME_MaskType;u_in_req: ME_AccessType) : unsigned := 
	if ((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) then unsigned((SR_reg and (u_in_dataIn or resize(40,32))))
	elsif (not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and (((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) then unsigned((SR_reg and (u_in_dataIn or resize(40,32))))
	elsif (not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and (((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) then unsigned((SR_reg and ((u_in_dataIn or (resize(256,32) * resize(4294967295,32))(31 downto 0)) or resize(40,32))))
	elsif (not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and (((u_in_addrIn = (resize(4,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) then unsigned((SR_reg and ((shift_left(u_in_dataIn,resize(8,32))) or (resize(65281,32) * resize(4294967295,32))(31 downto 0))))
	elsif (not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = (resize(4,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and (((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) then unsigned((SR_reg and (((resize(17,32) * resize(4294967295,32))(31 downto 0) and (resize(65,32) * resize(4294967295,32))(31 downto 0)) and (resize(129,32) * resize(4294967295,32))(31 downto 0))))
	elsif (not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = (resize(4,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) and (((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) then unsigned((SR_reg and (((resize(17,32) * resize(4294967295,32))(31 downto 0) and (resize(65,32) * resize(4294967295,32))(31 downto 0)) and (resize(129,32) * resize(4294967295,32))(31 downto 0))))
	elsif (not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = (resize(4,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and (((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) then unsigned((SR_reg and (((resize(17,32) * resize(4294967295,32))(31 downto 0) and (resize(65,32) * resize(4294967295,32))(31 downto 0)) and (resize(129,32) * resize(4294967295,32))(31 downto 0))))
	elsif (not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = (resize(4,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and (((u_in_addrIn = resize(8,32)) and (u_in_req = ME_RD)) and (((u_in_mask = MT_W) or (u_in_mask = MT_H)) or (u_in_mask = MT_HU)))) then unsigned((SR_reg and (resize(9,32) * resize(4294967295,32))(31 downto 0)))
	elsif (not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = (resize(4,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = resize(8,32)) and (u_in_req = ME_RD)) and (((u_in_mask = MT_W) or (u_in_mask = MT_H)) or (u_in_mask = MT_HU)))) and (((u_in_addrIn = resize(9,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) then unsigned((SR_reg and (resize(9,32) * resize(4294967295,32))(31 downto 0)))
	elsif (not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = (resize(4,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = resize(8,32)) and (u_in_req = ME_RD)) and (((u_in_mask = MT_W) or (u_in_mask = MT_H)) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(9,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and (((u_in_addrIn = resize(8,32)) and (u_in_req = ME_WR)) and (u_in_mask /= MT_X))) then unsigned((SR_reg and (resize(33,32) * resize(4294967295,32))(31 downto 0)))
	else unsigned(SR_reg)
end if;
end macro; 

macro register_TX_command(DR_reg: unsigned;u_in_addrIn: unsigned;u_in_dataIn: unsigned;u_in_mask: ME_MaskType;u_in_req: ME_AccessType) : unsigned := 
	if ((((u_in_addrIn = resize(8,32)) and (u_in_req = ME_WR)) and (u_in_mask /= MT_X))) then unsigned(((DR_reg and (resize(256,32) * resize(4294967295,32))(31 downto 0)) or (u_in_dataIn and resize(255,32))))
	else unsigned(DR_reg)
end if;
end macro; 

macro tx_action(temp_TX_temp_register: unsigned;temp_r_act: reg_action;u_in_addrIn: unsigned;u_in_dataIn: unsigned;u_in_mask: ME_MaskType;u_in_req: ME_AccessType) : reg_action := 
	if (((u_in_addrIn = resize(8,32)) and (u_in_req = ME_WR))) then (TX_WR)
	else (temp_r_act)
end if;
end macro; 

macro tx_no_action(flags_tc_flag: tx_flags;flags_txe_flag: tx_flags;temp_TX_temp_register: unsigned;temp_r_act: reg_action) : reg_action := 
	if ((flags_txe_flag = SET)) then (NA)
	else (temp_r_act)
end if;
end macro; 

