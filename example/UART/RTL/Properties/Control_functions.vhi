-- FUNCTIONS --
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

macro countones(reg: unsigned) : unsigned := 
	unsigned(((((((((reg and resize(1,32)) + ((shift_right(reg,resize(1,32))) and resize(1,32)))(31 downto 0) + ((shift_right(reg,resize(2,32))) and resize(1,32)))(31 downto 0) + ((shift_right(reg,resize(3,32))) and resize(1,32)))(31 downto 0) + ((shift_right(reg,resize(4,32))) and resize(1,32)))(31 downto 0) + ((shift_right(reg,resize(5,32))) and resize(1,32)))(31 downto 0) + ((shift_right(reg,resize(6,32))) and resize(1,32)))(31 downto 0) + ((shift_right(reg,resize(7,32))) and resize(1,32)))(31 downto 0));
end macro; 

macro manage_RX_flags(SR_reg1: unsigned;SR_reg2: unsigned) : unsigned := 
	unsigned((SR_reg1 or SR_reg2));
end macro; 

macro manage_TX_flags(SR_reg: unsigned;flags: unsigned) : unsigned :=
if ((flags = resize(2,32)) and ((SR_reg and resize(32,32)) /= resize(0,32))) then unsigned((SR_reg or resize(16,32)))
elsif ((flags = resize(2,32)) and not(((SR_reg and resize(32,32)) /= resize(0,32)))) then unsigned(SR_reg)
elsif (not((flags = resize(2,32))) and (((SR_reg and resize(32,32)) = resize(0,32)) and (flags = resize(1,32)))) then unsigned((SR_reg or resize(32,32)))
else unsigned(SR_reg)
end if;
end macro; 

macro parity_bit(bitcount: unsigned) : unsigned := 
	if (((bitcount mod resize(2,32))(31 downto 0) /= resize(0,32))) then unsigned(resize(512,32))
	else unsigned(resize(0,32))
end if;
end macro; 

macro register_CR_command(CR_reg: unsigned;u_in_addrIn: unsigned;u_in_dataIn: unsigned;u_in_mask: ME_MaskType;u_in_req: ME_AccessType) : unsigned := 
	if ((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) then unsigned(u_in_dataIn)
	elsif (not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and (((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) then unsigned(((CR_reg and resize(4294901760,32)) or (u_in_dataIn and resize(65535,32))))
	elsif (not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and (((u_in_addrIn = (resize(0,32) + resize(2,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) then unsigned(((CR_reg and resize(65535,32)) or ((shift_left(u_in_dataIn,resize(16,32))) and resize(4294901760,32))))
	elsif (not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = (resize(0,32) + resize(2,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and (((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) then unsigned(((CR_reg and resize(4294967040,32)) or (u_in_dataIn and resize(255,32))))
	elsif (not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = (resize(0,32) + resize(2,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and (((u_in_addrIn = (resize(0,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) then unsigned(((CR_reg and resize(4294902015,32)) or ((shift_left(u_in_dataIn,resize(8,32))) and resize(65280,32))))
	elsif (not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = (resize(0,32) + resize(2,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = (resize(0,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and (((u_in_addrIn = (resize(0,32) + resize(2,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) then unsigned(((CR_reg and resize(4278255615,32)) or ((shift_left(u_in_dataIn,resize(16,32))) and resize(16711680,32))))
	elsif (not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = (resize(0,32) + resize(2,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(0,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = (resize(0,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = (resize(0,32) + resize(2,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and (((u_in_addrIn = (resize(0,32) + resize(3,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) then unsigned(((CR_reg and resize(16777215,32)) or ((shift_left(u_in_dataIn,resize(24,32))) and resize(4278190080,32))))
	else unsigned(CR_reg)
end if;
end macro; 

macro register_RX_event(DR_reg1: unsigned;DR_reg2: unsigned;SR_reg2: unsigned) : unsigned := 
	if (((SR_reg2 and resize(8,32)) /= resize(0,32))) then unsigned(((DR_reg1 and resize(4294902015,32)) or (DR_reg2 and resize(65280,32))))
	elsif (not(((SR_reg2 and resize(8,32)) /= resize(0,32))) and (((SR_reg2 and resize(128,32)) /= resize(0,32)) or ((SR_reg2 and resize(64,32)) /= resize(0,32)))) then unsigned(((DR_reg1 and resize(4278255615,32)) or (DR_reg2 and resize(16711680,32))))
	else unsigned(DR_reg1)
end if;
end macro; 

macro register_SR_command(SR_reg: unsigned;u_in_addrIn: unsigned;u_in_dataIn: unsigned;u_in_mask: ME_MaskType;u_in_req: ME_AccessType) : unsigned := 
	if ((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) then unsigned((SR_reg and (u_in_dataIn or resize(40,32))))
	elsif (not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and (((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) then unsigned((SR_reg and (u_in_dataIn or resize(40,32))))
	elsif (not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and (((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) then unsigned((SR_reg and ((u_in_dataIn or resize(4294967040,32)) or resize(40,32))))
	elsif (not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and (((u_in_addrIn = (resize(4,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) then unsigned((SR_reg and ((shift_left(u_in_dataIn,resize(8,32))) or resize(4294902015,32))))
	elsif (not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = (resize(4,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and (((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) then unsigned((SR_reg and resize(4294967087,32)))
	elsif (not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = (resize(4,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) and (((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) then unsigned((SR_reg and resize(4294967087,32)))
	elsif (not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = (resize(4,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and (((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) then unsigned((SR_reg and resize(4294967087,32)))
	elsif (not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = (resize(4,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and (((u_in_addrIn = resize(8,32)) and (u_in_req = ME_RD)) and (((u_in_mask = MT_W) or (u_in_mask = MT_H)) or (u_in_mask = MT_HU)))) then unsigned((SR_reg and resize(4294967287,32)))
	elsif (not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = (resize(4,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = resize(8,32)) and (u_in_req = ME_RD)) and (((u_in_mask = MT_W) or (u_in_mask = MT_H)) or (u_in_mask = MT_HU)))) and (((u_in_addrIn = resize(9,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) then unsigned((SR_reg and resize(4294967287,32)))
	elsif (not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = (resize(4,32) + resize(1,32))(31 downto 0)) and (u_in_req = ME_WR)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and (u_in_mask = MT_W))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_H) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(4,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and not((((u_in_addrIn = resize(8,32)) and (u_in_req = ME_RD)) and (((u_in_mask = MT_W) or (u_in_mask = MT_H)) or (u_in_mask = MT_HU)))) and not((((u_in_addrIn = resize(9,32)) and (u_in_req = ME_RD)) and ((u_in_mask = MT_B) or (u_in_mask = MT_BU)))) and (((u_in_addrIn = resize(8,32)) and (u_in_req = ME_WR)) and (u_in_mask /= MT_X))) then unsigned((SR_reg and resize(4294967263,32)))
	else unsigned(SR_reg)
end if;
end macro; 

macro register_TX_command(DR_reg: unsigned;u_in_addrIn: unsigned;u_in_dataIn: unsigned;u_in_mask: ME_MaskType;u_in_req: ME_AccessType) : unsigned :=
if ((((u_in_addrIn = resize(8,32)) and (u_in_req = ME_WR)) and (u_in_mask /= MT_X))) then unsigned(((DR_reg and resize(4294967040,32)) or (u_in_dataIn and resize(255,32))))
else unsigned(DR_reg)
end if;
end macro;

macro set_tx(data: unsigned) : unsigned := 
	unsigned((((shift_left((data and resize(255,32)),resize(1,32))) or parity_bit(countones((data and resize(255,32))))) or resize(1024,32)));
end macro; 

macro tx_action(temp_r_act: reg_action;temp_tx_reg: unsigned;u_in_addrIn: unsigned;u_in_dataIn: unsigned;u_in_mask: ME_MaskType;u_in_req: ME_AccessType) : reg_action := 
	if (((u_in_addrIn = resize(8,32)) and (u_in_req = ME_WR))) then (TX_WR)
	else (temp_r_act)
end if;
end macro; 

macro tx_no_action(flags: unsigned;temp_r_act: reg_action;temp_tx_reg: unsigned) : reg_action := 
	if ((flags = resize(1,32))) then (NA)
	else (temp_r_act)
end if;
end macro; 

