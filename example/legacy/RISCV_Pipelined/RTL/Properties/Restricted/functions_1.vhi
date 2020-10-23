--
-- CREATED BY: SALAHEDDIN HETALANI (salaheddinhetalani@gmail.com) ON 30 SEP, 2018
--

-- FUNCTIONS 1 --
macro getRegValue(reg_num: unsigned;reg_signal: unsigned) : unsigned := 
	if   (ID_time_16) then if(next(S_ENC) and reg_num = rs2Num) then next(storeForwUnitRS2(reg_num),14) else next(generalForwUnit(reg_num,reg_signal),14) end if;  
	elsif(ID_time_14) then if(next(S_ENC) and reg_num = rs2Num) then next(storeForwUnitRS2(reg_num),12) else next(generalForwUnit(reg_num,reg_signal),12) end if; 
	elsif(ID_time_12) then if(next(S_ENC) and reg_num = rs2Num) then next(storeForwUnitRS2(reg_num),10) else next(generalForwUnit(reg_num,reg_signal),10) end if; 
	elsif(ID_time_10) then if(next(S_ENC) and reg_num = rs2Num) then next(storeForwUnitRS2(reg_num), 8) else next(generalForwUnit(reg_num,reg_signal), 8) end if;
	elsif(ID_time_08) then if(next(S_ENC) and reg_num = rs2Num) then next(storeForwUnitRS2(reg_num), 6) else next(generalForwUnit(reg_num,reg_signal), 6) end if;	    
	elsif(ID_time_06) then if(next(S_ENC) and reg_num = rs2Num) then next(storeForwUnitRS2(reg_num), 4) else next(generalForwUnit(reg_num,reg_signal), 4) end if;	    
	elsif(ID_time_04) then if(next(S_ENC) and reg_num = rs2Num) then next(storeForwUnitRS2(reg_num), 2) else next(generalForwUnit(reg_num,reg_signal), 2) end if;	    
	else         	       if(next(S_ENC) and reg_num = rs2Num) then next(storeForwUnitRS2(reg_num), 0) else next(generalForwUnit(reg_num,reg_signal), 0) end if;
	end if;	
end macro;

macro getState(state_num:unsigned) : boolean := 
	if   (state_num =  4) then getStateValue(state_04,false)
	elsif(state_num = 11) then getStateValue(state_11,false)
	elsif(prev(instrFlushed)) then getStateValue(state_16,true) 
	elsif(prev(stallWhileFetching)) then CU/section = writeMem
	else getStateValue(state_16,false)
	end if;
end macro;

macro getAddrIn : unsigned      := if(prev(instrFlushed)) then getUnsignedValue(addrIn,true) elsif(prev(stallWhileFetching)) then pc elsif(ERR_ENC) then next(pc) else getUnsignedValue(addrIn,false) end if; end macro;	
macro getDataIn : unsigned      := if(prev(instrFlushed)) then getUnsignedValue(dataIn,true) elsif(prev(stallWhileFetching)) then 0     else getUnsignedValue(dataIn,false) end if; end macro;	
macro getMask   : ME_MaskType   := if(prev(instrFlushed)) then getMaskTypeValue(mask,true)   elsif(prev(stallWhileFetching)) then MT_W  else getMaskTypeValue(mask,false)   end if; end macro;	
macro getReq    : ME_AccessType := if(prev(instrFlushed)) then getAccessTypeValue(req,true)  elsif(prev(stallWhileFetching)) then ME_RD else getAccessTypeValue(req,false)  end if; end macro;	

macro getFreezedPC : unsigned := 
	if   (state_17) then 
		if   (instrFlushed) then getFreezedPCvalue(true)
		elsif(stallWhileFetching) then unsigned(next(pc) - 4)(31 downto 0)
		elsif(next(R_ENC or U_ENC or I_I_ENC)) then unsigned(pc + 4)(31 downto 0) 
		elsif(next(I_L_ENC or S_ENC or ERR_ENC)) then next(pc) 
		elsif(next(B_ENC)) then getFreezedPCvalue(false)
		else pc
		end if;
	elsif(state_12 or state_05) then unsigned(next(pc) - 4)(31 downto 0)
	else pc	
	end if;
end macro;

macro getPC : unsigned := 
	if   (prev(instrFlushed)) then getUnsignedValue(pc,true)
	elsif(prev(stallWhileFetching)) then pc
	elsif(I_L_ENC or S_ENC or ERR_ENC) then next(pc) 
	else getUnsignedValue(pc,false)
	end if;
end macro;

macro getFreezed(x:unsigned) : unsigned := if(state_16 or state_11 or state_04) then next(x) else x end if; end macro;

macro getDst : unsigned := 
	if   (prev(instrFlushed)) then getRegisterFileWrite(dst)
	elsif(prev(stallWhileFetching)) then 0 
	elsif(R_ENC or J_ENC or U_ENC or I_I_ENC or I_L_ENC or I_J_ENC) then getRegisterFileWrite(dst)
	else dst	
	end if;  	
end macro;

macro getDstData : unsigned := 
	if   (prev(instrFlushed)) then getRegisterFileWrite(dstData)
	elsif(prev(stallWhileFetching)) then 0
	elsif(R_ENC or J_ENC or I_I_ENC or I_J_ENC) then getRegisterFileWrite(dstData)
	elsif(U_ENC) then if(LUI_INSTR) then getRegisterFileWrite(dstData) else unsigned(getRegisterFileWrite(dstData) + 4)(31 downto 0) end if;
	else dstData	
	end if;  
end macro;