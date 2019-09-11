--
-- CREATED BY: SALAHEDDIN HETALANI (salaheddinhetalani@gmail.com) ON 30 SEP, 2018
--

-- FUNCTIONS 2 --
macro generalForwUnit(reg_num: unsigned;reg_signal: unsigned) : unsigned := 
	if   (EX_2(5,reg_num)) then next(CU/CUtoDP_port.loadedData,7)
	elsif(EX_1(5,reg_num)) then next(DP/DP_s4_data.aluResult_s4,5)
	elsif(ID_5(3,reg_num)) then next(CU/CUtoDP_port.loadedData,3)
	elsif(ID_4(3,reg_num)) then unsigned(next(DP/DP_s5_data.pc_s5,3) + 4)(31 downto 0)
	elsif(ID_3(3,reg_num)) then unsigned(next(DP/DP_s4_data.pc_s4,3) + 4)(31 downto 0)
	elsif(ID_2(3,reg_num)) then next(DP/DP_s4_data.aluResult_s4,3)
	elsif(ID_1(3,reg_num)) then next(DP/DP_s5_data.aluResult_s5,3)
	else   			    next(reg_signal,3) 
	end if;	
end macro;

macro storeForwUnitRS2(reg_num: unsigned) : unsigned := 
	if   (memAccess(5) and ME_4(9,reg_num)) then next(CU/CUtoDP_port.loadedData,11)
	elsif(memAccess(5) and ME_3(9,reg_num)) then next(DP/DP_s5_data.aluResult_s5,9)
	elsif(memAccess(5) and ME_2(9,reg_num)) then next(DP/DP_S4_data.prevLoadedData, 9)
	elsif(memAccess(5) and ME_1(9,reg_num)) then next(DP/DP_S4_data.reg2Content_s4,9)
	elsif(		       ME_4(7,reg_num)) then next(CU/CUtoDP_port.loadedData,9)
	elsif(		       ME_3(7,reg_num)) then next(DP/DP_s5_data.aluResult_s5,7)
	else   			      	             next(DP/DP_S4_data.reg2Content_s4,7)
	end if;	
end macro;

macro getStateValue(x:boolean;flushedInstr:boolean) : boolean := 
	if(flushedInstr = false) then
		if   (ID_time_16) then if(flush(18)) then next(x,18) else next(x,16) end if;
		elsif(ID_time_14) then if(flush(16)) then next(x,16) else next(x,14) end if;
		elsif(ID_time_12) then if(I_L_ENC or S_ENC) then if (memAccess(15)) then next(x,20) else next(x,18) end if;
				       elsif(flush(14)) then next(x,14) 	
				       else next(x,12) 
				       end if;
		elsif(ID_time_10) then if(I_L_ENC or S_ENC) then if (memAccess(13) or memAccess(15)) then next(x,18) else next(x,16) end if;
				       elsif(flush(12) and memAccess(12)) then next(x,14)
				       elsif(flush(12)) then next(x,12)
				       else next(x,10) 
				       end if; 
		elsif(ID_time_08) then if(I_L_ENC or S_ENC) then if (memAccess(11) or memAccess(13)) then next(x,16) else next(x,14) end if;
				       elsif(flush(10) and memAccess(10)) then next(x,12)
				       elsif(flush(10)) then next(x,10) 	
				       else next(x, 8) 
				       end if; 
		elsif(ID_time_06) then if(I_L_ENC or S_ENC) then if (memAccess( 9) and memAccess(13)) then next(x,16) elsif(memAccess( 9) or memAccess(11)) then next(x,14) else next(x,12) end if;
				       elsif(flush( 8) and memAccess( 8)) then next(x,10)
				       elsif(flush( 8)) then next(x, 8) 
				       else next(x, 6) 
				       end if; 	    
		elsif(ID_time_04) then if(I_L_ENC or S_ENC) then if (memAccess( 7) and memAccess(11)) then next(x,14) elsif(memAccess( 7) or memAccess( 9)) then next(x,12) else next(x,10) end if;
				       elsif(flush( 6) and memAccess( 6)) then next(x, 8)
				       elsif(flush( 6)) then next(x, 6) 	
				       else next(x, 4) 
				       end if;  
		else   		       if(I_L_ENC or S_ENC) then if (memAccess( 5) and memAccess( 9)) then next(x,12) elsif(memAccess( 5) or memAccess( 7)) then next(x,10) else next(x, 8) end if;
				       elsif(flush( 4) and memAccess( 4)) then next(x, 6)
				       elsif(flush( 4)) then next(x, 4) 
				       else next(x, 2) 
				       end if; 
		end if;
	elsif(Flush_time_13) then next(x,14)
	elsif(Flush_time_11) then next(x,12)
	elsif(Flush_time_09) then next(x,10) 
	elsif(Flush_time_07) then if(memAccess( 8)) then next(x,10) else next(x, 8) end if;  	    
	elsif(Flush_time_05) then if(memAccess( 6)) then next(x, 8) else next(x, 6) end if;
	elsif(Flush_time_03) then if(memAccess( 4)) then next(x, 6) else next(x, 4) end if;
	else   	   	          if(memAccess( 2)) then next(x, 4) else next(x, 2) end if;
	end if;
end macro;

macro getUnsignedValue(x:unsigned;flushedInstr:boolean) : unsigned := 
	if(flushedInstr = false) then
		if   (ID_time_16) then if(flush(18)) then next(x,18) else next(x,16) end if;
		elsif(ID_time_14) then if(flush(16)) then next(x,16) else next(x,14) end if;
		elsif(ID_time_12) then if(I_L_ENC or S_ENC) then if (memAccess(15)) then next(x,20) else next(x,18) end if;
				       elsif(flush(14)) then next(x,14) 	
				       else next(x,12) 
				       end if;
		elsif(ID_time_10) then if(I_L_ENC or S_ENC) then if (memAccess(13) or memAccess(15)) then next(x,18) else next(x,16) end if;
				       elsif(flush(12) and memAccess(12)) then next(x,14)
				       elsif(flush(12)) then next(x,12)
				       else next(x,10) 
				       end if; 
		elsif(ID_time_08) then if(I_L_ENC or S_ENC) then if (memAccess(11) or memAccess(13)) then next(x,16) else next(x,14) end if;
				       elsif(flush(10) and memAccess(10)) then next(x,12)
				       elsif(flush(10)) then next(x,10) 	
				       else next(x, 8) 
				       end if; 
		elsif(ID_time_06) then if(I_L_ENC or S_ENC) then if (memAccess( 9) and memAccess(13)) then next(x,16) elsif(memAccess( 9) or memAccess(11)) then next(x,14) else next(x,12) end if;
				       elsif(flush( 8) and memAccess( 8)) then next(x,10)
				       elsif(flush( 8)) then next(x, 8) 
				       else next(x, 6) 
				       end if; 	    
		elsif(ID_time_04) then if(I_L_ENC or S_ENC) then if (memAccess( 7) and memAccess(11)) then next(x,14) elsif(memAccess( 7) or memAccess( 9)) then next(x,12) else next(x,10) end if;
				       elsif(flush( 6) and memAccess( 6)) then next(x, 8)
				       elsif(flush( 6)) then next(x, 6) 	
				       else next(x, 4) 
				       end if;  
		else   		       if(I_L_ENC or S_ENC) then if (memAccess( 5) and memAccess( 9)) then next(x,12) elsif(memAccess( 5) or memAccess( 7)) then next(x,10) else next(x, 8) end if;
				       elsif(flush( 4) and memAccess( 4)) then next(x, 6)
				       elsif(flush( 4)) then next(x, 4) 
				       else next(x, 2) 
				       end if; 
		end if;
	elsif(Flush_time_13) then next(x,14)
	elsif(Flush_time_11) then next(x,12)
	elsif(Flush_time_09) then next(x,10) 
	elsif(Flush_time_07) then if(memAccess( 8)) then next(x,10) else next(x, 8) end if;  	    
	elsif(Flush_time_05) then if(memAccess( 6)) then next(x, 8) else next(x, 6) end if;
	elsif(Flush_time_03) then if(memAccess( 4)) then next(x, 6) else next(x, 4) end if;
	else   	   	          if(memAccess( 2)) then next(x, 4) else next(x, 2) end if;
	end if;
end macro;	

macro getAccessTypeValue(x:ME_AccessType;flushedInstr:boolean) : ME_AccessType := 
	if(flushedInstr = false) then
		if   (ID_time_16) then if(flush(18)) then next(x,18) else next(x,16) end if;
		elsif(ID_time_14) then if(flush(16)) then next(x,16) else next(x,14) end if;
		elsif(ID_time_12) then if(I_L_ENC or S_ENC) then if (memAccess(15)) then next(x,20) else next(x,18) end if;
				       elsif(flush(14)) then next(x,14) 	
				       else next(x,12) 
				       end if;
		elsif(ID_time_10) then if(I_L_ENC or S_ENC) then if (memAccess(13) or memAccess(15)) then next(x,18) else next(x,16) end if;
				       elsif(flush(12) and memAccess(12)) then next(x,14)
				       elsif(flush(12)) then next(x,12)
				       else next(x,10) 
				       end if; 
		elsif(ID_time_08) then if(I_L_ENC or S_ENC) then if (memAccess(11) or memAccess(13)) then next(x,16) else next(x,14) end if;
				       elsif(flush(10) and memAccess(10)) then next(x,12)
				       elsif(flush(10)) then next(x,10) 	
				       else next(x, 8) 
				       end if; 
		elsif(ID_time_06) then if(I_L_ENC or S_ENC) then if (memAccess( 9) and memAccess(13)) then next(x,16) elsif(memAccess( 9) or memAccess(11)) then next(x,14) else next(x,12) end if;
				       elsif(flush( 8) and memAccess( 8)) then next(x,10)
				       elsif(flush( 8)) then next(x, 8) 
				       else next(x, 6) 
				       end if; 	    
		elsif(ID_time_04) then if(I_L_ENC or S_ENC) then if (memAccess( 7) and memAccess(11)) then next(x,14) elsif(memAccess( 7) or memAccess( 9)) then next(x,12) else next(x,10) end if;
				       elsif(flush( 6) and memAccess( 6)) then next(x, 8)
				       elsif(flush( 6)) then next(x, 6) 	
				       else next(x, 4) 
				       end if;  
		else   		       if(I_L_ENC or S_ENC) then if (memAccess( 5) and memAccess( 9)) then next(x,12) elsif(memAccess( 5) or memAccess( 7)) then next(x,10) else next(x, 8) end if;
				       elsif(flush( 4) and memAccess( 4)) then next(x, 6)
				       elsif(flush( 4)) then next(x, 4) 
				       else next(x, 2) 
				       end if; 
		end if;
	elsif(Flush_time_13) then next(x,14)
	elsif(Flush_time_11) then next(x,12)
	elsif(Flush_time_09) then next(x,10) 
	elsif(Flush_time_07) then if(memAccess( 8)) then next(x,10) else next(x, 8) end if;  	    
	elsif(Flush_time_05) then if(memAccess( 6)) then next(x, 8) else next(x, 6) end if;
	elsif(Flush_time_03) then if(memAccess( 4)) then next(x, 6) else next(x, 4) end if;
	else   	   	          if(memAccess( 2)) then next(x, 4) else next(x, 2) end if;
	end if;
end macro;

macro getMaskTypeValue(x:ME_MaskType;flushedInstr:boolean) : ME_MaskType := 
	if(flushedInstr = false) then
		if   (ID_time_16) then if(flush(18)) then next(x,18) else next(x,16) end if;
		elsif(ID_time_14) then if(flush(16)) then next(x,16) else next(x,14) end if;
		elsif(ID_time_12) then if(I_L_ENC or S_ENC) then if (memAccess(15)) then next(x,20) else next(x,18) end if;
				       elsif(flush(14)) then next(x,14) 	
				       else next(x,12) 
				       end if;
		elsif(ID_time_10) then if(I_L_ENC or S_ENC) then if (memAccess(13) or memAccess(15)) then next(x,18) else next(x,16) end if;
				       elsif(flush(12) and memAccess(12)) then next(x,14)
				       elsif(flush(12)) then next(x,12)
				       else next(x,10) 
				       end if; 
		elsif(ID_time_08) then if(I_L_ENC or S_ENC) then if (memAccess(11) or memAccess(13)) then next(x,16) else next(x,14) end if;
				       elsif(flush(10) and memAccess(10)) then next(x,12)
				       elsif(flush(10)) then next(x,10) 	
				       else next(x, 8) 
				       end if; 
		elsif(ID_time_06) then if(I_L_ENC or S_ENC) then if (memAccess( 9) and memAccess(13)) then next(x,16) elsif(memAccess( 9) or memAccess(11)) then next(x,14) else next(x,12) end if;
				       elsif(flush( 8) and memAccess( 8)) then next(x,10)
				       elsif(flush( 8)) then next(x, 8) 
				       else next(x, 6) 
				       end if; 	    
		elsif(ID_time_04) then if(I_L_ENC or S_ENC) then if (memAccess( 7) and memAccess(11)) then next(x,14) elsif(memAccess( 7) or memAccess( 9)) then next(x,12) else next(x,10) end if;
				       elsif(flush( 6) and memAccess( 6)) then next(x, 8)
				       elsif(flush( 6)) then next(x, 6) 	
				       else next(x, 4) 
				       end if;  
		else   		       if(I_L_ENC or S_ENC) then if (memAccess( 5) and memAccess( 9)) then next(x,12) elsif(memAccess( 5) or memAccess( 7)) then next(x,10) else next(x, 8) end if;
				       elsif(flush( 4) and memAccess( 4)) then next(x, 6)
				       elsif(flush( 4)) then next(x, 4) 
				       else next(x, 2) 
				       end if; 
		end if;
	elsif(Flush_time_13) then next(x,14)
	elsif(Flush_time_11) then next(x,12)
	elsif(Flush_time_09) then next(x,10) 
	elsif(Flush_time_07) then if(memAccess( 8)) then next(x,10) else next(x, 8) end if;  	    
	elsif(Flush_time_05) then if(memAccess( 6)) then next(x, 8) else next(x, 6) end if;
	elsif(Flush_time_03) then if(memAccess( 4)) then next(x, 6) else next(x, 4) end if;
	else   	   	          if(memAccess( 2)) then next(x, 4) else next(x, 2) end if;
	end if;
end macro;

macro getFreezedPCvalue(flushedInstr:boolean) : unsigned := 
	if(flushedInstr = false) then 	-- BRANCH INSTR
		if   (ID_time_16) then if (flush(19)) then pc else unsigned(pc + 4)(31 downto 0) end if;
		elsif(ID_time_14) then if (flush(17)) then pc else unsigned(pc + 4)(31 downto 0) end if;
		elsif(ID_time_12) then if (flush(15)) then pc else unsigned(pc + 4)(31 downto 0) end if;
		elsif(ID_time_10) then if (flush(13)) then pc else unsigned(pc + 4)(31 downto 0) end if;
		elsif(ID_time_08) then if (flush(11)) then pc else unsigned(pc + 4)(31 downto 0) end if;
		elsif(ID_time_06) then if (flush( 9)) then pc else unsigned(pc + 4)(31 downto 0) end if;	    
		elsif(ID_time_04) then if (flush( 7)) then pc else unsigned(pc + 4)(31 downto 0) end if;  
		else   	   	       if (flush( 5)) then pc else unsigned(pc + 4)(31 downto 0) end if; 
		end if;	
	elsif(Flush_time_13) then next(pc,13)
	elsif(Flush_time_11) then next(pc,11)
	elsif(Flush_time_09) then next(pc, 9) 
	elsif(Flush_time_07) then next(pc, 7) 	    
	elsif(Flush_time_05) then next(pc, 5) 
	elsif(Flush_time_03) then next(pc, 3) 
	else   	   	          next(pc, 1)
	end if;
end macro;

macro getRegisterFileWrite(x:unsigned) : unsigned := 
	if   (ID_time_16) then next(x,23)
	elsif(ID_time_14) then next(x,21)
	elsif(ID_time_12) then if (memAccess(15)) then next(x,21) else next(x,19) end if;
	elsif(ID_time_10) then if (memAccess(13) or memAccess(15)) then next(x,19) else next(x,17) end if; 
	elsif(ID_time_08) then if (memAccess(11) or memAccess(13)) then next(x,17) else next(x,15) end if; 
	elsif(ID_time_06) then if ((memAccess( 9) and memAccess(13))) then next(x,17) elsif(memAccess( 9) or memAccess(11)) then next(x,15) else next(x,13) end if; 	    
	elsif(ID_time_04) then if ((memAccess( 7) and memAccess(11))) then next(x,15) elsif(memAccess( 7) or memAccess( 9)) then next(x,13) else next(x,11) end if; 
	else   	   	       if ((memAccess( 5) and memAccess( 9))) then next(x,13) elsif(memAccess( 5) or memAccess( 7)) then next(x,11) else next(x, 9) end if;  
	end if;	
end macro;