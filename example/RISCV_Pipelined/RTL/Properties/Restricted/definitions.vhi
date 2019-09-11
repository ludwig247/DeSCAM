--
-- CREATED BY: SALAHEDDIN HETALANI (salaheddinhetalani@gmail.com) ON 30 SEP, 2018
--

-- RTL MAPPING --
macro state_04  		: boolean 	:= CU/section = writeMem and CU/dmemAccess and CU/CUtoME_port.req = ME_WR	end macro;
macro state_05  		: boolean 	:= CU/section = readMem  and CU/dmemAccess and CU/CUtoME_port.req = ME_WR	end macro;
macro state_11			: boolean 	:= CU/section = writeMem and CU/dmemAccess and CU/CUtoME_port.req = ME_RD 	end macro;
macro state_12 			: boolean 	:= CU/section = readMem  and CU/dmemAccess and CU/CUtoME_port.req = ME_RD	end macro;
macro state_16			: boolean 	:= CU/section = writeMem and not(CU/dmemAccess)					end macro;
macro state_17  		: boolean 	:= CU/section = readMem  and not(CU/dmemAccess) 				end macro;
macro loadedData		: unsigned 	:= CU/MEtoCU_port.loadedData							end macro;
macro addrIn			: unsigned 	:= CU/CUtoME_port.addrIn							end macro;
macro dataIn			: unsigned 	:= CU/CUtoME_port.dataIn							end macro;
macro mask			: ME_MaskType 	:= CU/CUtoME_port.mask								end macro;
macro req			: ME_AccessType	:= CU/CUtoME_port.req								end macro;
macro pc			: unsigned 	:= CU/pc									end macro;
macro dst			: unsigned 	:= DP/DPtoRF_port.dst								end macro;
macro dstData			: unsigned 	:= DP/DPtoRF_port.dstData							end macro;

-- GENERAL MACROS --
macro prevState_04		: boolean 	:= prev(state_04)								end macro;
macro prevState_05		: boolean 	:= prev(state_05)								end macro;
macro prevState_11		: boolean 	:= prev(state_11)								end macro;
macro prevState_12		: boolean 	:= prev(state_12)								end macro;
macro prevState_16  		: boolean 	:= prev(state_16) 								end macro;
macro prevState_17		: boolean       := not(prev(rst)) and prev(state_17)						end macro;
macro R_ENC   			: boolean 	:= getEncType(CU/loadedInstr) = ENC_R   					end macro;
macro I_I_ENC 			: boolean 	:= getEncType(CU/loadedInstr) = ENC_I_I 					end macro;
macro I_L_ENC 			: boolean 	:= getEncType(CU/loadedInstr) = ENC_I_L 					end macro;
macro I_J_ENC 			: boolean 	:= getEncType(CU/loadedInstr) = ENC_I_J 					end macro;
macro S_ENC   			: boolean 	:= getEncType(CU/loadedInstr) = ENC_S   					end macro;
macro B_ENC   			: boolean 	:= getEncType(CU/loadedInstr) = ENC_B   					end macro;
macro U_ENC   			: boolean 	:= getEncType(CU/loadedInstr) = ENC_U   					end macro;
macro J_ENC   			: boolean 	:= getEncType(CU/loadedInstr) = ENC_J						end macro;
macro ERR_ENC 			: boolean 	:= getEncType(CU/loadedInstr) = ENC_ERR						end macro;
macro flush(n: unsigned) 	: boolean 	:= next(CU/flush,n) = true 							end macro;
macro stall(n: unsigned) 	: boolean 	:= next(CU/stall,n) = true 							end macro;
macro memAccess(n: unsigned) 	: boolean 	:= next(CU/dmemAccess,n) = true 						end macro;
macro is_J_ENC(n: unsigned) 	: boolean 	:= next(DP/DP_S3_data.encType_s3,n) = ENC_J 					end macro;
macro rs2Num 			: unsigned	:= next(getRs2Addr(CU/loadedInstr));						end macro;
macro nop 			: unsigned 	:= ((loadedData and resize(19,32)) or resize(19,32)) 				end macro;
macro LUI_INSTR 		: boolean 	:= getInstrType(CU/loadedInstr) = INSTR_LUI end macro;

-- CASES WHERE INSTR IS FLUSHED --
macro Flush_13_1 : boolean := stall( 1) and stall( 3) and stall( 5) and stall( 7) and stall( 9) and flush(13) end macro;
macro Flush_11_1 : boolean := stall( 1) and stall( 3) and stall( 5) and stall( 7) and flush(11) end macro;
macro Flush_11_2 : boolean := stall( 1) and stall( 3) and stall( 5) and stall( 9) and flush( 9) end macro;
macro Flush_09_1 : boolean := stall( 1) and stall( 3) and stall( 5) and flush( 9) end macro;
macro Flush_09_2 : boolean := stall( 1) and stall( 3) and stall( 7) and flush( 7) end macro;
macro Flush_07_1 : boolean := stall( 1) and stall( 3) and flush( 7) end macro;
macro Flush_07_2 : boolean := stall( 1) and stall( 5) and flush( 5) end macro;
macro Flush_05_1 : boolean := stall( 1) and flush( 5) end macro;
macro Flush_05_2 : boolean := stall( 3) and flush( 3) end macro;
macro Flush_03_1 : boolean := flush( 3) end macro;
macro Flush_03_2 : boolean := memAccess( 1) and is_J_ENC( 4) end macro;
macro Flush_01_1 : boolean := flush( 1) end macro;
macro Flush_01_2 : boolean := is_J_ENC ( 2) and not(memAccess(1)) end macro;

-- MEM ACCESS TIME FOR BRANCH OR JUMP INSTR THAT FLUSHED THE FETCHED INSTR --
macro Flush_time_13 : boolean := Flush_13_1 end macro;
macro Flush_time_11 : boolean := Flush_11_1 or Flush_11_2 end macro;
macro Flush_time_09 : boolean := Flush_09_1 or Flush_09_2 end macro;
macro Flush_time_07 : boolean := Flush_07_1 or Flush_07_2 end macro;
macro Flush_time_05 : boolean := Flush_05_1 or Flush_05_2 end macro;
macro Flush_time_03 : boolean := Flush_03_1 or Flush_03_2 end macro;

-- IF FETCHED INSTR IS FLUSHED BECAUSE OF ANOTHER INSTR, OR IGNORED BECAUSE OF STALL WHILE FETCHING -> IT'S NOP! --
macro instrFlushed : boolean := state_17 and (Flush_01_1 or Flush_01_2 or Flush_03_1 or Flush_03_2 or Flush_05_1 or Flush_07_1 or Flush_09_1 or Flush_11_1 or Flush_13_1) end macro;
macro stallWhileFetching : boolean := state_17 and stall(0) end macro;		

-- CASES TO SPECIFY WHEN INSTR IS DECODED --
macro ID_16_1 : boolean := stall( 1) and stall( 3) and stall( 5) and stall( 9) and stall(11) and stall(13) and stall(15) end macro;
macro ID_14_1 : boolean := stall( 1) and stall( 3) and stall( 7) and stall( 9) and stall(11) and stall(13) end macro;
macro ID_14_2 : boolean := stall( 1) and stall( 5) and stall( 7) and stall( 9) and stall(11) and stall(13) end macro;
macro ID_12_1 : boolean := stall( 1) and stall( 3) and stall( 5) and stall( 7) and stall( 9) end macro;
macro ID_12_2 : boolean := stall( 1) and stall( 3) and stall( 5) and stall( 9) and stall(11) end macro;
macro ID_12_3 : boolean := stall( 1) and stall( 5) and stall( 7) and stall( 9) and stall(11) end macro;
macro ID_12_4 : boolean := stall( 3) and stall( 5) and stall( 7) and stall( 9) and stall(11) end macro;
macro ID_10_1 : boolean := stall( 1) and stall( 3) and stall( 5) and stall( 7) end macro;
macro ID_10_2 : boolean := stall( 1) and stall( 3) and stall( 5) and stall( 9) end macro;
macro ID_10_3 : boolean := stall( 1) and stall( 3) and stall( 7) and stall( 9) end macro;
macro ID_10_4 : boolean := stall( 1) and stall( 5) and stall( 7) and stall( 9) end macro;
macro ID_10_5 : boolean := stall( 3) and stall( 5) and stall( 7) and stall( 9) end macro;
macro ID_08_1 : boolean := stall( 1) and stall( 3) and stall( 5) end macro;
macro ID_08_2 : boolean := stall( 1) and stall( 3) and stall( 7) end macro;
macro ID_08_3 : boolean := stall( 1) and stall( 5) and stall( 7) end macro;
macro ID_08_4 : boolean := stall( 3) and stall( 5) and stall( 7) end macro;
macro ID_06_1 : boolean := stall( 1) and stall( 3) end macro;
macro ID_06_2 : boolean := stall( 1) and stall( 5) end macro;
macro ID_06_3 : boolean := stall( 3) and stall( 5) end macro;
macro ID_04_1 : boolean := stall( 1) end macro;
macro ID_04_2 : boolean := stall( 3) end macro;

-- DECODE TIME OF INSTR --
macro ID_time_16 : boolean := ID_16_1 end macro;
macro ID_time_14 : boolean := ID_14_1 or ID_14_2 end macro;
macro ID_time_12 : boolean := ID_12_1 or ID_12_2 or ID_12_3 or ID_12_4 end macro;
macro ID_time_10 : boolean := ID_10_1 or ID_10_2 or ID_10_3 or ID_10_4 or ID_10_5 end macro;
macro ID_time_08 : boolean := ID_08_1 or ID_08_2 or ID_08_3 or ID_08_4 end macro;
macro ID_time_06 : boolean := ID_06_1 or ID_06_2 or ID_06_3 end macro;
macro ID_time_04 : boolean := ID_04_1 or ID_04_2 end macro;

-- FORWARDING CASES --
macro ME_4(n: unsigned;reg_num: unsigned) : boolean := next(DP/DP_S4_data.regRs2Addr_s4,n) = next(DP/DP_S5_data.regRdAddr_s5,n) and next(DP/DP_S5_data.regRdAddr_s5,n) = reg_num and next(DP/DP_S5_data.encType_s5,n) = ENC_I_L and next(DP/CUtoDP_port.dmemReq_s4,n) = ME_WR end macro;
macro ME_3(n: unsigned;reg_num: unsigned) : boolean := next(DP/DP_S4_data.regRs2Addr_s4,n) = next(DP/DP_S5_data.regRdAddr_s5,n) and next(DP/DP_S5_data.regRdAddr_s5,n) = reg_num and next(DP/CUtoDP_port.dmemReq_s4,n) = ME_WR end macro;
macro ME_2(n: unsigned;reg_num: unsigned) : boolean := next(DP/DP_S4_data.fwdPrevLoadedData,n) and next(DP/DP_S4_data.regRs2Addr_s4,n) = reg_num and next(DP/CUtoDP_port.dmemReq_s4,n) = ME_WR end macro;
macro ME_1(n: unsigned;reg_num: unsigned) : boolean := next(DP/DP_S4_data.regRs2Addr_s4,n) = reg_num and next(DP/CUtoDP_port.dmemReq_s4,n) = ME_WR end macro;
macro EX_2(n: unsigned;reg_num: unsigned) : boolean := ((next(DP/DP_S3_data.regRs1Addr_s3,n) = next(DP/DP_S5_data.regRdAddr_s5,n)) or (next(DP/DP_S3_data.regRs2Addr_s3,n) = next(DP/DP_S5_data.regRdAddr_s5,n))) and next(DP/DP_S5_data.regRdAddr_s5,n) /= next(DP/DP_S4_data.regRdAddr_s4,n) and next(DP/DP_S5_data.regRdAddr_s5,n) = reg_num and next(DP/DP_S5_data.encType_s5,n) = ENC_I_L end macro;
macro EX_1(n: unsigned;reg_num: unsigned) : boolean := ((next(DP/DP_S3_data.regRs1Addr_s3,n) = next(DP/DP_S4_data.regRdAddr_s4,n)) or (next(DP/DP_S3_data.regRs2Addr_s3,n) = next(DP/DP_S4_data.regRdAddr_s4,n))) and next(DP/DP_S4_data.regRdAddr_s4,n) = reg_num end macro;
macro ID_5(n: unsigned;reg_num: unsigned) : boolean := ((next(DP/CUtoDP_port.regRs1Addr_s2,n) = next(DP/DP_S5_data.regRdAddr_s5,n)) or (next(DP/CUtoDP_port.regRs2Addr_s2,n) = next(DP/DP_S5_data.regRdAddr_s5,n))) and next(DP/DP_S5_data.regRdAddr_s5,n) /= next(DP/DP_S4_data.regRdAddr_s4,n) and next(DP/DP_S5_data.regRdAddr_s5,n) = reg_num and next(DP/DP_S5_data.encType_s5,n) = ENC_I_L end macro;
macro ID_4(n: unsigned;reg_num: unsigned) : boolean := ((next(CU/CUtoDP_port.regRs1Addr_s2,n) = next(DP/DP_S5_data.regRdAddr_s5,n)) or (next(CU/CUtoDP_port.regRs2Addr_s2,n) = next(DP/DP_S5_data.regRdAddr_s5,n))) and next(DP/DP_S5_data.regRdAddr_s5,n) = reg_num and (next(DP/DP_S5_data.encType_s5,n) = ENC_J or next(DP/DP_S5_data.encType_s5,n) = ENC_I_J) end macro;
macro ID_3(n: unsigned;reg_num: unsigned) : boolean := ((next(CU/CUtoDP_port.regRs1Addr_s2,n) = next(DP/DP_S4_data.regRdAddr_s4,n)) or (next(CU/CUtoDP_port.regRs2Addr_s2,n) = next(DP/DP_S4_data.regRdAddr_s4,n))) and next(DP/DP_S4_data.regRdAddr_s4,n) = reg_num and next(DP/DP_S4_data.encType_s4,n) = ENC_J end macro;
macro ID_2(n: unsigned;reg_num: unsigned) : boolean := ((next(CU/CUtoDP_port.regRs1Addr_s2,n) = next(DP/DP_S4_data.regRdAddr_s4,n)) or (next(CU/CUtoDP_port.regRs2Addr_s2,n) = next(DP/DP_S4_data.regRdAddr_s4,n))) and next(DP/DP_S4_data.regRdAddr_s4,n) = reg_num end macro;
macro ID_1(n: unsigned;reg_num: unsigned) : boolean := ((next(CU/CUtoDP_port.regRs1Addr_s2,n) = next(DP/DP_S5_data.regRdAddr_s5,n)) or (next(CU/CUtoDP_port.regRs2Addr_s2,n) = next(DP/DP_S5_data.regRdAddr_s5,n))) and next(DP/DP_S5_data.regRdAddr_s5,n) = reg_num end macro;