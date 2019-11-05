

-- FUNCTIONS --
macro check_interrupt(reg_CR_reg: unsigned;reg_RX_reg: unsigned;reg_SR_reg: unsigned;reg_TX_reg: unsigned;reg_r_act: reg_action) : unsigned := 
	if ((((reg_SR_reg and resize(2,32)) = resize(0,32)) or ((reg_CR_reg and resize(512,32)) /= resize(0,32))) and (((reg_SR_reg and resize(8,32)) /= resize(0,32)) and ((reg_CR_reg and resize(8,32)) /= resize(0,32)))) then unsigned(resize(1,32))
	elsif ((((reg_SR_reg and resize(2,32)) = resize(0,32)) or ((reg_CR_reg and resize(512,32)) /= resize(0,32))) and not((((reg_SR_reg and resize(8,32)) /= resize(0,32)) and ((reg_CR_reg and resize(8,32)) /= resize(0,32)))) and (((reg_SR_reg and resize(32,32)) /= resize(0,32)) and ((reg_CR_reg and resize(32,32)) /= resize(0,32)))) then unsigned(resize(1,32))
	elsif ((((reg_SR_reg and resize(2,32)) = resize(0,32)) or ((reg_CR_reg and resize(512,32)) /= resize(0,32))) and not((((reg_SR_reg and resize(8,32)) /= resize(0,32)) and ((reg_CR_reg and resize(8,32)) /= resize(0,32)))) and not((((reg_SR_reg and resize(32,32)) /= resize(0,32)) and ((reg_CR_reg and resize(32,32)) /= resize(0,32)))) and (((reg_SR_reg and resize(16,32)) /= resize(0,32)) and ((reg_CR_reg and resize(16,32)) /= resize(0,32)))) then unsigned(resize(1,32))
	elsif ((((reg_SR_reg and resize(2,32)) = resize(0,32)) or ((reg_CR_reg and resize(512,32)) /= resize(0,32))) and not((((reg_SR_reg and resize(8,32)) /= resize(0,32)) and ((reg_CR_reg and resize(8,32)) /= resize(0,32)))) and not((((reg_SR_reg and resize(32,32)) /= resize(0,32)) and ((reg_CR_reg and resize(32,32)) /= resize(0,32)))) and not((((reg_SR_reg and resize(16,32)) /= resize(0,32)) and ((reg_CR_reg and resize(16,32)) /= resize(0,32)))) and (((reg_SR_reg and resize(64,32)) /= resize(0,32)) and ((reg_CR_reg and resize(64,32)) /= resize(0,32)))) then unsigned(resize(1,32))
	elsif ((((reg_SR_reg and resize(2,32)) = resize(0,32)) or ((reg_CR_reg and resize(512,32)) /= resize(0,32))) and not((((reg_SR_reg and resize(8,32)) /= resize(0,32)) and ((reg_CR_reg and resize(8,32)) /= resize(0,32)))) and not((((reg_SR_reg and resize(32,32)) /= resize(0,32)) and ((reg_CR_reg and resize(32,32)) /= resize(0,32)))) and not((((reg_SR_reg and resize(16,32)) /= resize(0,32)) and ((reg_CR_reg and resize(16,32)) /= resize(0,32)))) and not((((reg_SR_reg and resize(64,32)) /= resize(0,32)) and ((reg_CR_reg and resize(64,32)) /= resize(0,32)))) and (((reg_SR_reg and resize(128,32)) /= resize(0,32)) and ((reg_CR_reg and resize(128,32)) /= resize(0,32)))) then unsigned(resize(1,32))
	elsif ((((reg_SR_reg and resize(2,32)) = resize(0,32)) or ((reg_CR_reg and resize(512,32)) /= resize(0,32))) and not((((reg_SR_reg and resize(8,32)) /= resize(0,32)) and ((reg_CR_reg and resize(8,32)) /= resize(0,32)))) and not((((reg_SR_reg and resize(32,32)) /= resize(0,32)) and ((reg_CR_reg and resize(32,32)) /= resize(0,32)))) and not((((reg_SR_reg and resize(16,32)) /= resize(0,32)) and ((reg_CR_reg and resize(16,32)) /= resize(0,32)))) and not((((reg_SR_reg and resize(64,32)) /= resize(0,32)) and ((reg_CR_reg and resize(64,32)) /= resize(0,32)))) and not((((reg_SR_reg and resize(128,32)) /= resize(0,32)) and ((reg_CR_reg and resize(128,32)) /= resize(0,32))))) then unsigned(resize(0,32))
	else unsigned(resize(0,32))
end if;
end macro; 

macro clear_SR_flags(reg_CR_reg: unsigned;reg_RX_reg: unsigned;reg_SR_reg: unsigned;reg_TX_reg: unsigned;reg_r_act: reg_action) : unsigned := 
	if ((reg_r_act = SR_RD)) then unsigned((reg_SR_reg and (((resize(17,32) * resize(4294967295,32))(31 downto 0) and (resize(65,32) * resize(4294967295,32))(31 downto 0)) and (resize(129,32) * resize(4294967295,32))(31 downto 0))))
	elsif (not((reg_r_act = SR_RD)) and (reg_r_act = RX_RD)) then unsigned((reg_SR_reg and (resize(9,32) * resize(4294967295,32))(31 downto 0)))
	else unsigned(reg_SR_reg)
end if;
end macro; 

macro get_flag(flag: unsigned;reg: unsigned) : unsigned := 
	if (((reg and flag) /= resize(0,32))) then unsigned(resize(1,32))
	else unsigned(resize(0,32))
end if;
end macro; 

macro register_CR_command(regs_CR_reg: unsigned;regs_RX_reg: unsigned;regs_SR_reg: unsigned;regs_TX_reg: unsigned;regs_r_act: reg_action;u_in_addrIn: unsigned;u_in_dataIn: unsigned;u_in_mask: ME_MaskType;u_in_req: ME_AccessType) : unsigned := 
	if ((((u_in_addrIn = resize(1,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) then unsigned(u_in_dataIn)
	else unsigned(regs_CR_reg)
end if;
end macro; 

macro register_RX_event(regs_1_CR_reg: unsigned;regs_1_RX_reg: unsigned;regs_1_SR_reg: unsigned;regs_1_TX_reg: unsigned;regs_1_r_act: reg_action;regs_2_CR_reg: unsigned;regs_2_RX_reg: unsigned;regs_2_SR_reg: unsigned;regs_2_TX_reg: unsigned;regs_2_r_act: reg_action) : unsigned := 
	if ((regs_2_r_act = RX_WR)) then unsigned(regs_2_RX_reg)
	else unsigned(regs_1_RX_reg)
end if;
end macro; 

macro register_SR_command(regs_CR_reg: unsigned;regs_RX_reg: unsigned;regs_SR_reg: unsigned;regs_TX_reg: unsigned;regs_r_act: reg_action;u_in_addrIn: unsigned;u_in_dataIn: unsigned;u_in_mask: ME_MaskType;u_in_req: ME_AccessType) : unsigned := 
	if ((((u_in_addrIn = resize(2,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) then unsigned((regs_SR_reg and (u_in_dataIn or resize(40,32))))
	elsif (not((((u_in_addrIn = resize(2,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and (((u_in_addrIn = resize(3,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_BU))) then unsigned((regs2_SR_reg and (resize(9,32) * resize(4294967295,32))(31 downto 0)))
	elsif (not((((u_in_addrIn = resize(2,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(3,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_BU))) and (((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_BU))) then unsigned((regs2_SR_reg and (resize(17,32) * resize(4294967295,32))(31 downto 0)))
	else unsigned(regs_SR_reg)
end if;
end macro; 

macro register_SR_event(reg_2_CR_reg: unsigned;reg_2_RX_reg: unsigned;reg_2_SR_reg: unsigned;reg_2_TX_reg: unsigned;reg_2_r_act: reg_action;reg_3_CR_reg: unsigned;reg_3_RX_reg: unsigned;reg_3_SR_reg: unsigned;reg_3_TX_reg: unsigned;reg_3_r_act: reg_action;tcomp: boolean) : unsigned := 
	if (((tcomp = true) and (reg_3_r_act = RX_WR))) then unsigned(((reg_2_SR_reg or resize(16,32)) or reg_3_SR_reg))
	elsif (not(((tcomp = true) and (reg_3_r_act = RX_WR))) and ((tcomp = false) and (reg_3_r_act = RX_WR))) then unsigned((reg_2_SR_reg or reg_3_SR_reg))
	elsif (not(((tcomp = true) and (reg_3_r_act = RX_WR))) and not(((tcomp = false) and (reg_3_r_act = RX_WR))) and ((tcomp = true) and (reg_3_r_act /= RX_WR))) then unsigned((reg_2_SR_reg or resize(16,32)))
	else unsigned(reg_2_SR_reg)
end if;
end macro; 

macro register_TX_command(regs_CR_reg: unsigned;regs_RX_reg: unsigned;regs_SR_reg: unsigned;regs_TX_reg: unsigned;regs_r_act: reg_action;u_in_addrIn: unsigned;u_in_dataIn: unsigned;u_in_mask: ME_MaskType;u_in_req: ME_AccessType) : unsigned := 
	if ((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_BU))) then unsigned((u_in_dataIn and resize(255,32)))
	else unsigned(regs_TX_reg)
end if;
end macro; 

macro register_action(u_in_addrIn: unsigned;u_in_dataIn: unsigned;u_in_mask: ME_MaskType;u_in_req: ME_AccessType) : reg_action := 
	if ((((u_in_addrIn = resize(1,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) then (CR_WR)
	elsif (not((((u_in_addrIn = resize(1,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and (((u_in_addrIn = resize(1,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) then (CR_RD)
	elsif (not((((u_in_addrIn = resize(1,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(1,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) and (((u_in_addrIn = resize(2,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) then (SR_WR)
	elsif (not((((u_in_addrIn = resize(1,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(1,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(2,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and (((u_in_addrIn = resize(2,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) then (SR_RD)
	elsif (not((((u_in_addrIn = resize(1,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(1,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(2,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(2,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) and (((u_in_addrIn = resize(3,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_BU))) then (RX_RD)
	elsif (not((((u_in_addrIn = resize(1,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(1,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(2,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(2,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(3,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_BU))) and (((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_BU))) then (TX_WR)
	else (NA)
end if;
end macro; 

macro response_data(reg_CR_reg: unsigned;reg_RX_reg: unsigned;reg_SR_reg: unsigned;reg_TX_reg: unsigned;reg_r_act: reg_action) : unsigned := 
	if ((reg_r_act = CR_RD)) then unsigned(reg_CR_reg)
	elsif (not((reg_r_act = CR_RD)) and (reg_r_act = SR_RD)) then unsigned(reg_SR_reg)
	elsif (not((reg_r_act = CR_RD)) and not((reg_r_act = SR_RD)) and (reg_r_act = RX_RD)) then unsigned(reg_RX_reg)
	else unsigned(resize(0,32))
end if;
end macro; 

