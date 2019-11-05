-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro CUtoDP_port_sync : boolean := CUtoDP_port_sync end macro;
--macro DPtoRF_port_notify : boolean := DPtoRF_port_notify end macro;


-- DP SIGNALS --
macro CUtoDP_port_sig_stallDmemAccess           : bool                  := CUtoDP_port.stallDmemAccess          end macro;
macro CUtoDP_port_sig_prevDmemAccess            : bool                  := CUtoDP_port.prevDmemAccess           end macro;
macro CUtoDP_port_sig_loadedData                : unsigned              := CUtoDP_port.loadedData               end macro;
macro CUtoDP_port_sig_pc_s2                     : unsigned              := CUtoDP_port.pc_s2                    end macro;
macro CUtoDP_port_sig_encType_s2                : EncType               := CUtoDP_port.encType_s2               end macro;
macro CUtoDP_port_sig_regFileReq_s2             : RF_RD_AccessType      := CUtoDP_port.regFileReq_s2            end macro;
macro CUtoDP_port_sig_regRs1Addr_s2             : unsigned              := CUtoDP_port.regRs1Addr_s2            end macro;
macro CUtoDP_port_sig_regRs2Addr_s2             : unsigned              := CUtoDP_port.regRs2Addr_s2            end macro;
macro CUtoDP_port_sig_regRdAddr_s2              : unsigned              := CUtoDP_port.regRdAddr_s2             end macro;
macro CUtoDP_port_sig_aluFunc_s3                : ALUfuncType           := CUtoDP_port.aluFunc_s3               end macro;
macro CUtoDP_port_sig_aluOp1Sel_s3              : AL_OperandSelType     := CUtoDP_port.aluOp1Sel_s3             end macro;
macro CUtoDP_port_sig_aluOp2Sel_s3              : AL_OperandSelType     := CUtoDP_port.aluOp2Sel_s3             end macro;
macro CUtoDP_port_sig_imm_s3                    : unsigned              := CUtoDP_port.imm_s3                   end macro;
macro CUtoDP_port_sig_dmemReq_s4                : ME_AccessType         := CUtoDP_port.dmemReq_s4               end macro;
macro CUtoDP_port_sig_dmemMask_s4               : ME_MaskType           := CUtoDP_port.dmemMask_s4              end macro;
macro CUtoDP_port_sig_regFileReq_s5             : RF_WR_AccessType      := CUtoDP_port.regFileReq_s5            end macro;
macro CUtoDP_port_sig_regFileWriteDataSel_s5    : RF_WriteDataSelType   := CUtoDP_port.regFileWriteDataSel_s5   end macro;
macro DPtoCU_port_sig_reg1Content               : unsigned              := DPtoCU_port.reg1Content              end macro;
macro DPtoCU_port_sig_reg2Content               : unsigned              := DPtoCU_port.reg2Content              end macro;
macro DPtoCU_port_sig_req                       : ME_AccessType         := DPtoCU_port.req                      end macro;
macro DPtoCU_port_sig_mask                      : ME_MaskType           := DPtoCU_port.mask                     end macro;
macro DPtoCU_port_sig_addrIn                    : unsigned              := DPtoCU_port.addrIn                   end macro;
macro DPtoCU_port_sig_dataIn                    : unsigned              := DPtoCU_port.dataIn                   end macro;
macro DPtoRF_port_sig_wrReq                     : RF_WR_AccessType      := DPtoRF_port.wrReq                    end macro;
macro DPtoRF_port_sig_dst                       : unsigned              := DPtoRF_port.dst                      end macro;
macro DPtoRF_port_sig_dstData                   : unsigned              := DPtoRF_port.dstData                  end macro;
macro RFtoDP_port_sig_reg_file_01               : unsigned              := RF/reg_file( 1)                      end macro;
macro RFtoDP_port_sig_reg_file_02               : unsigned              := RF/reg_file( 2)                      end macro;
macro RFtoDP_port_sig_reg_file_03               : unsigned              := RF/reg_file( 3)                      end macro;
macro RFtoDP_port_sig_reg_file_04               : unsigned              := RF/reg_file( 4)                      end macro;
macro RFtoDP_port_sig_reg_file_05               : unsigned              := RF/reg_file( 5)                      end macro;
macro RFtoDP_port_sig_reg_file_06               : unsigned              := RF/reg_file( 6)                      end macro;
macro RFtoDP_port_sig_reg_file_07               : unsigned              := RF/reg_file( 7)                      end macro;
macro RFtoDP_port_sig_reg_file_08               : unsigned              := RF/reg_file( 8)                      end macro;
macro RFtoDP_port_sig_reg_file_09               : unsigned              := RF/reg_file( 9)                      end macro;
macro RFtoDP_port_sig_reg_file_10               : unsigned              := RF/reg_file(10)                      end macro;
macro RFtoDP_port_sig_reg_file_11               : unsigned              := RF/reg_file(11)                      end macro;
macro RFtoDP_port_sig_reg_file_12               : unsigned              := RF/reg_file(12)                      end macro;
macro RFtoDP_port_sig_reg_file_13               : unsigned              := RF/reg_file(13)                      end macro;
macro RFtoDP_port_sig_reg_file_14               : unsigned              := RF/reg_file(14)                      end macro;
macro RFtoDP_port_sig_reg_file_15               : unsigned              := RF/reg_file(15)                      end macro;
macro RFtoDP_port_sig_reg_file_16               : unsigned              := RF/reg_file(16)                      end macro;
macro RFtoDP_port_sig_reg_file_17               : unsigned              := RF/reg_file(17)                      end macro;
macro RFtoDP_port_sig_reg_file_18               : unsigned              := RF/reg_file(18)                      end macro;
macro RFtoDP_port_sig_reg_file_19               : unsigned              := RF/reg_file(19)                      end macro;
macro RFtoDP_port_sig_reg_file_20               : unsigned              := RF/reg_file(20)                      end macro;
macro RFtoDP_port_sig_reg_file_21               : unsigned              := RF/reg_file(21)                      end macro;
macro RFtoDP_port_sig_reg_file_22               : unsigned              := RF/reg_file(22)                      end macro;
macro RFtoDP_port_sig_reg_file_23               : unsigned              := RF/reg_file(23)                      end macro;
macro RFtoDP_port_sig_reg_file_24               : unsigned              := RF/reg_file(24)                      end macro;
macro RFtoDP_port_sig_reg_file_25               : unsigned              := RF/reg_file(25)                      end macro;
macro RFtoDP_port_sig_reg_file_26               : unsigned              := RF/reg_file(26)                      end macro;
macro RFtoDP_port_sig_reg_file_27               : unsigned              := RF/reg_file(27)                      end macro;
macro RFtoDP_port_sig_reg_file_28               : unsigned              := RF/reg_file(28)                      end macro;
macro RFtoDP_port_sig_reg_file_29               : unsigned              := RF/reg_file(29)                      end macro;
macro RFtoDP_port_sig_reg_file_30               : unsigned              := RF/reg_file(30)                      end macro;
macro RFtoDP_port_sig_reg_file_31               : unsigned              := RF/reg_file(31)                      end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro DPtoCU_data_reg1Content       : unsigned      := DPtoCU_port.reg1Content      end macro;
macro DPtoCU_data_reg2Content       : unsigned      := DPtoCU_port.reg2Content      end macro;
macro DPtoCU_data_req               : ME_AccessType := DPtoCU_port.req              end macro;
macro DPtoCU_data_mask              : ME_MaskType   := DPtoCU_port.mask             end macro;
macro DPtoCU_data_addrIn            : unsigned      := DPtoCU_port.addrIn           end macro;
macro DPtoCU_data_dataIn            : unsigned      := DPtoCU_port.dataIn           end macro;
macro DP_S3_data_pc_s3              : unsigned      := DP_S3_data.pc_s3             end macro;
macro DP_S3_data_encType_s3         : EncType       := DP_S3_data.encType_s3        end macro;
macro DP_S3_data_regRs1Addr_s3      : unsigned      := DP_S3_data.regRs1Addr_s3     end macro;
macro DP_S3_data_regRs2Addr_s3      : unsigned      := DP_S3_data.regRs2Addr_s3     end macro;
macro DP_S3_data_regRdAddr_s3       : unsigned      := DP_S3_data.regRdAddr_s3      end macro;
macro DP_S3_data_reg1Content_s3     : unsigned      := DP_S3_data.reg1Content_s3    end macro;
macro DP_S3_data_reg2Content_s3     : unsigned      := DP_S3_data.reg2Content_s3    end macro;
macro DP_S4_data_fwdPrevLoadedData  : bool          := DP_S4_data.fwdPrevLoadedData end macro;
macro DP_S4_data_prevLoadedData     : unsigned      := DP_S4_data.prevLoadedData    end macro;
macro DP_S4_data_pc_s4              : unsigned      := DP_S4_data.pc_s4             end macro;
macro DP_S4_data_encType_s4         : EncType       := DP_S4_data.encType_s4        end macro;
macro DP_S4_data_regRs2Addr_s4      : unsigned      := DP_S4_data.regRs2Addr_s4     end macro;
macro DP_S4_data_regRdAddr_s4       : unsigned      := DP_S4_data.regRdAddr_s4      end macro;
macro DP_S4_data_reg2Content_s4     : unsigned      := DP_S4_data.reg2Content_s4    end macro;
macro DP_S4_data_aluResult_s4       : unsigned      := DP_S4_data.aluResult_s4      end macro;
macro DP_S5_data_pc_s5              : unsigned      := DP_S5_data.pc_s5             end macro;
macro DP_S5_data_encType_s5         : EncType       := DP_S5_data.encType_s5        end macro;
macro DP_S5_data_regRdAddr_s5       : unsigned      := DP_S5_data.regRdAddr_s5      end macro;
macro DP_S5_data_aluResult_s5       : unsigned      := DP_S5_data.aluResult_s5      end macro;

macro nextphase : DATA_PATH_PHASES := readRegFileStage end macro;


-- STATES --
macro state_97 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_97;
	 at t: DP_S3_data_encType_s3 = ENC_I_I;
	 at t: DP_S3_data_pc_s3 = resize(0,32);
	 at t: DP_S3_data_reg1Content_s3 = resize(0,32);
	 at t: DP_S3_data_reg2Content_s3 = resize(0,32);
	 at t: DP_S3_data_regRdAddr_s3 = resize(0,32);
	 at t: DP_S3_data_regRs1Addr_s3 = resize(0,32);
	 at t: DP_S3_data_regRs2Addr_s3 = resize(0,32);
	 at t: DP_S4_data_aluResult_s4 = resize(0,32);
	 at t: DP_S4_data_encType_s4 = ENC_I_I;
	 at t: DP_S4_data_fwdPrevLoadedData = false;
	 at t: DP_S4_data_pc_s4 = resize(0,32);
	 at t: DP_S4_data_prevLoadedData = resize(0,32);
	 at t: DP_S4_data_reg2Content_s4 = resize(0,32);
	 at t: DP_S4_data_regRdAddr_s4 = resize(0,32);
	 at t: DP_S4_data_regRs2Addr_s4 = resize(0,32);
	 at t: DP_S5_data_aluResult_s5 = resize(0,32);
	 at t: DP_S5_data_encType_s5 = ENC_I_I;
	 at t: DP_S5_data_pc_s5 = resize(0,32);
	 at t: DP_S5_data_regRdAddr_s5 = resize(0,32);
	 at t: DPtoCU_data_addrIn = resize(0,32);
	 at t: DPtoCU_data_dataIn = resize(0,32);
	 at t: DPtoCU_data_mask = MT_X;
	 at t: DPtoCU_data_reg1Content = resize(0,32);
	 at t: DPtoCU_data_reg2Content = resize(0,32);
	 at t: DPtoCU_data_req = ME_X;
	 at t: DPtoCU_port_sig_addrIn = resize(0,32);
	 at t: DPtoCU_port_sig_dataIn = resize(0,32);
	 at t: DPtoCU_port_sig_mask = MT_X;
	 at t: DPtoCU_port_sig_req = ME_X;
	 at t: nextphase = readRegFileStage;
	 at t: DPtoRF_port_notify = false;
end property;


property state_97_1 is
dependencies: no_reset;
freeze:
	CUtoDP_port_sig_aluFunc_s3_at_t = CUtoDP_port_sig_aluFunc_s3@t,
	CUtoDP_port_sig_aluOp1Sel_s3_at_t = CUtoDP_port_sig_aluOp1Sel_s3@t,
	CUtoDP_port_sig_aluOp2Sel_s3_at_t = CUtoDP_port_sig_aluOp2Sel_s3@t,
	CUtoDP_port_sig_dmemMask_s4_at_t = CUtoDP_port_sig_dmemMask_s4@t,
	CUtoDP_port_sig_dmemReq_s4_at_t = CUtoDP_port_sig_dmemReq_s4@t,
	CUtoDP_port_sig_encType_s2_at_t = CUtoDP_port_sig_encType_s2@t,
	CUtoDP_port_sig_imm_s3_at_t = CUtoDP_port_sig_imm_s3@t,
	CUtoDP_port_sig_loadedData_at_t = CUtoDP_port_sig_loadedData@t,
	CUtoDP_port_sig_pc_s2_at_t = CUtoDP_port_sig_pc_s2@t,
	CUtoDP_port_sig_regFileReq_s2_at_t = CUtoDP_port_sig_regFileReq_s2@t,
	CUtoDP_port_sig_regFileReq_s5_at_t = CUtoDP_port_sig_regFileReq_s5@t,
	CUtoDP_port_sig_regFileWriteDataSel_s5_at_t = CUtoDP_port_sig_regFileWriteDataSel_s5@t,
	CUtoDP_port_sig_regRdAddr_s2_at_t = CUtoDP_port_sig_regRdAddr_s2@t,
	CUtoDP_port_sig_regRs1Addr_s2_at_t = CUtoDP_port_sig_regRs1Addr_s2@t,
	CUtoDP_port_sig_regRs2Addr_s2_at_t = CUtoDP_port_sig_regRs2Addr_s2@t,
	DP_S3_data_encType_s3_at_t = DP_S3_data_encType_s3@t,
	DP_S3_data_pc_s3_at_t = DP_S3_data_pc_s3@t,
	DP_S3_data_reg1Content_s3_at_t = DP_S3_data_reg1Content_s3@t,
	DP_S3_data_reg2Content_s3_at_t = DP_S3_data_reg2Content_s3@t,
	DP_S3_data_regRdAddr_s3_at_t = DP_S3_data_regRdAddr_s3@t,
	DP_S3_data_regRs1Addr_s3_at_t = DP_S3_data_regRs1Addr_s3@t,
	DP_S3_data_regRs2Addr_s3_at_t = DP_S3_data_regRs2Addr_s3@t,
	DP_S4_data_aluResult_s4_at_t = DP_S4_data_aluResult_s4@t,
	DP_S4_data_encType_s4_at_t = DP_S4_data_encType_s4@t,
	DP_S4_data_pc_s4_at_t = DP_S4_data_pc_s4@t,
	DP_S4_data_regRdAddr_s4_at_t = DP_S4_data_regRdAddr_s4@t,
	DP_S5_data_aluResult_s5_at_t = DP_S5_data_aluResult_s5@t,
	DP_S5_data_encType_s5_at_t = DP_S5_data_encType_s5@t,
	DP_S5_data_pc_s5_at_t = DP_S5_data_pc_s5@t,
	DP_S5_data_regRdAddr_s5_at_t = DP_S5_data_regRdAddr_s5@t,
	RFtoDP_port_sig_reg_file_01_at_t = RFtoDP_port_sig_reg_file_01@t,
	RFtoDP_port_sig_reg_file_02_at_t = RFtoDP_port_sig_reg_file_02@t,
	RFtoDP_port_sig_reg_file_03_at_t = RFtoDP_port_sig_reg_file_03@t,
	RFtoDP_port_sig_reg_file_04_at_t = RFtoDP_port_sig_reg_file_04@t,
	RFtoDP_port_sig_reg_file_05_at_t = RFtoDP_port_sig_reg_file_05@t,
	RFtoDP_port_sig_reg_file_06_at_t = RFtoDP_port_sig_reg_file_06@t,
	RFtoDP_port_sig_reg_file_07_at_t = RFtoDP_port_sig_reg_file_07@t,
	RFtoDP_port_sig_reg_file_08_at_t = RFtoDP_port_sig_reg_file_08@t,
	RFtoDP_port_sig_reg_file_09_at_t = RFtoDP_port_sig_reg_file_09@t,
	RFtoDP_port_sig_reg_file_10_at_t = RFtoDP_port_sig_reg_file_10@t,
	RFtoDP_port_sig_reg_file_11_at_t = RFtoDP_port_sig_reg_file_11@t,
	RFtoDP_port_sig_reg_file_12_at_t = RFtoDP_port_sig_reg_file_12@t,
	RFtoDP_port_sig_reg_file_13_at_t = RFtoDP_port_sig_reg_file_13@t,
	RFtoDP_port_sig_reg_file_14_at_t = RFtoDP_port_sig_reg_file_14@t,
	RFtoDP_port_sig_reg_file_15_at_t = RFtoDP_port_sig_reg_file_15@t,
	RFtoDP_port_sig_reg_file_16_at_t = RFtoDP_port_sig_reg_file_16@t,
	RFtoDP_port_sig_reg_file_17_at_t = RFtoDP_port_sig_reg_file_17@t,
	RFtoDP_port_sig_reg_file_18_at_t = RFtoDP_port_sig_reg_file_18@t,
	RFtoDP_port_sig_reg_file_19_at_t = RFtoDP_port_sig_reg_file_19@t,
	RFtoDP_port_sig_reg_file_20_at_t = RFtoDP_port_sig_reg_file_20@t,
	RFtoDP_port_sig_reg_file_21_at_t = RFtoDP_port_sig_reg_file_21@t,
	RFtoDP_port_sig_reg_file_22_at_t = RFtoDP_port_sig_reg_file_22@t,
	RFtoDP_port_sig_reg_file_23_at_t = RFtoDP_port_sig_reg_file_23@t,
	RFtoDP_port_sig_reg_file_24_at_t = RFtoDP_port_sig_reg_file_24@t,
	RFtoDP_port_sig_reg_file_25_at_t = RFtoDP_port_sig_reg_file_25@t,
	RFtoDP_port_sig_reg_file_26_at_t = RFtoDP_port_sig_reg_file_26@t,
	RFtoDP_port_sig_reg_file_27_at_t = RFtoDP_port_sig_reg_file_27@t,
	RFtoDP_port_sig_reg_file_28_at_t = RFtoDP_port_sig_reg_file_28@t,
	RFtoDP_port_sig_reg_file_29_at_t = RFtoDP_port_sig_reg_file_29@t,
	RFtoDP_port_sig_reg_file_30_at_t = RFtoDP_port_sig_reg_file_30@t,
	RFtoDP_port_sig_reg_file_31_at_t = RFtoDP_port_sig_reg_file_31@t;
assume:
	at t: state_97;
	at t: CUtoDP_port_sync;
	at t: (CUtoDP_port_sig_dmemReq_s4 = ME_RD);
	at t: CUtoDP_port_sig_prevDmemAccess;
	at t: (DP_S3_data_encType_s3 = ENC_S);
	at t: (DP_S5_data_encType_s5 = ENC_I_L);
	at t: (DP_S3_data_regRs2Addr_s3 = DP_S5_data_regRdAddr_s5);
	at t: not((DP_S5_data_regRdAddr_s5 = resize(0,32)));
	at t: not(CUtoDP_port_sig_stallDmemAccess);
prove:
	at t+1: state_97;
	at t+1: DP_S3_data_encType_s3 = CUtoDP_port_sig_encType_s2_at_t;
	at t+1: DP_S3_data_pc_s3 = CUtoDP_port_sig_pc_s2_at_t;
	at t+1: DP_S3_data_reg1Content_s3 = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DP_S3_data_reg2Content_s3 = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DP_S3_data_regRdAddr_s3 = CUtoDP_port_sig_regRdAddr_s2_at_t;
	at t+1: DP_S3_data_regRs1Addr_s3 = CUtoDP_port_sig_regRs1Addr_s2_at_t;
	at t+1: DP_S3_data_regRs2Addr_s3 = CUtoDP_port_sig_regRs2Addr_s2_at_t;
	at t+1: DP_S4_data_aluResult_s4 = getALUresult(CUtoDP_port_sig_aluFunc_s3_at_t,getALUoperand(aluOpFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S3_data_reg1Content_s3_at_t,DP_S3_data_regRs1Addr_s3_at_t),CUtoDP_port_sig_aluOp1Sel_s3_at_t,CUtoDP_port_sig_imm_s3_at_t,DP_S3_data_pc_s3_at_t),getALUoperand(aluOpFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S3_data_reg2Content_s3_at_t,DP_S3_data_regRs2Addr_s3_at_t),CUtoDP_port_sig_aluOp2Sel_s3_at_t,CUtoDP_port_sig_imm_s3_at_t,DP_S3_data_pc_s3_at_t));
	at t+1: DP_S4_data_encType_s4 = DP_S3_data_encType_s3_at_t;
	at t+1: DP_S4_data_fwdPrevLoadedData = true;
	at t+1: DP_S4_data_pc_s4 = DP_S3_data_pc_s3_at_t;
	at t+1: DP_S4_data_prevLoadedData = CUtoDP_port_sig_loadedData_at_t;
	at t+1: DP_S4_data_reg2Content_s4 = DP_S3_data_reg2Content_s3_at_t;
	at t+1: DP_S4_data_regRdAddr_s4 = DP_S3_data_regRdAddr_s3_at_t;
	at t+1: DP_S4_data_regRs2Addr_s4 = DP_S3_data_regRs2Addr_s3_at_t;
	at t+1: DP_S5_data_aluResult_s5 = DP_S4_data_aluResult_s4_at_t;
	at t+1: DP_S5_data_encType_s5 = DP_S4_data_encType_s4_at_t;
	at t+1: DP_S5_data_pc_s5 = DP_S4_data_pc_s4_at_t;
	at t+1: DP_S5_data_regRdAddr_s5 = DP_S4_data_regRdAddr_s4_at_t;
	at t+1: DPtoCU_data_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_data_dataIn = 0;
	at t+1: DPtoCU_data_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_data_reg1Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DPtoCU_data_reg2Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DPtoCU_data_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoCU_port_sig_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_port_sig_dataIn = 0;
	at t+1: DPtoCU_port_sig_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_port_sig_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoRF_port_sig_dst = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoRF_port_sig_dstData = getWBdata(DP_S5_data_aluResult_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S5_data_pc_s5_at_t,CUtoDP_port_sig_regFileWriteDataSel_s5_at_t);
	at t+1: DPtoRF_port_sig_wrReq = CUtoDP_port_sig_regFileReq_s5_at_t;
	at t+1: nextphase = readRegFileStage;
	at t+1: DPtoRF_port_notify = true;
end property;


property state_97_3 is
dependencies: no_reset;
freeze:
	CUtoDP_port_sig_dmemMask_s4_at_t = CUtoDP_port_sig_dmemMask_s4@t,
	CUtoDP_port_sig_dmemReq_s4_at_t = CUtoDP_port_sig_dmemReq_s4@t,
	CUtoDP_port_sig_loadedData_at_t = CUtoDP_port_sig_loadedData@t,
	CUtoDP_port_sig_regFileReq_s2_at_t = CUtoDP_port_sig_regFileReq_s2@t,
	CUtoDP_port_sig_regFileReq_s5_at_t = CUtoDP_port_sig_regFileReq_s5@t,
	CUtoDP_port_sig_regFileWriteDataSel_s5_at_t = CUtoDP_port_sig_regFileWriteDataSel_s5@t,
	CUtoDP_port_sig_regRs1Addr_s2_at_t = CUtoDP_port_sig_regRs1Addr_s2@t,
	CUtoDP_port_sig_regRs2Addr_s2_at_t = CUtoDP_port_sig_regRs2Addr_s2@t,
	DP_S3_data_encType_s3_at_t = DP_S3_data_encType_s3@t,
	DP_S3_data_pc_s3_at_t = DP_S3_data_pc_s3@t,
	DP_S3_data_reg1Content_s3_at_t = DP_S3_data_reg1Content_s3@t,
	DP_S3_data_reg2Content_s3_at_t = DP_S3_data_reg2Content_s3@t,
	DP_S3_data_regRdAddr_s3_at_t = DP_S3_data_regRdAddr_s3@t,
	DP_S3_data_regRs1Addr_s3_at_t = DP_S3_data_regRs1Addr_s3@t,
	DP_S3_data_regRs2Addr_s3_at_t = DP_S3_data_regRs2Addr_s3@t,
	DP_S4_data_aluResult_s4_at_t = DP_S4_data_aluResult_s4@t,
	DP_S4_data_encType_s4_at_t = DP_S4_data_encType_s4@t,
	DP_S4_data_pc_s4_at_t = DP_S4_data_pc_s4@t,
	DP_S4_data_reg2Content_s4_at_t = DP_S4_data_reg2Content_s4@t,
	DP_S4_data_regRdAddr_s4_at_t = DP_S4_data_regRdAddr_s4@t,
	DP_S4_data_regRs2Addr_s4_at_t = DP_S4_data_regRs2Addr_s4@t,
	DP_S5_data_aluResult_s5_at_t = DP_S5_data_aluResult_s5@t,
	DP_S5_data_encType_s5_at_t = DP_S5_data_encType_s5@t,
	DP_S5_data_pc_s5_at_t = DP_S5_data_pc_s5@t,
	DP_S5_data_regRdAddr_s5_at_t = DP_S5_data_regRdAddr_s5@t,
	RFtoDP_port_sig_reg_file_01_at_t = RFtoDP_port_sig_reg_file_01@t,
	RFtoDP_port_sig_reg_file_02_at_t = RFtoDP_port_sig_reg_file_02@t,
	RFtoDP_port_sig_reg_file_03_at_t = RFtoDP_port_sig_reg_file_03@t,
	RFtoDP_port_sig_reg_file_04_at_t = RFtoDP_port_sig_reg_file_04@t,
	RFtoDP_port_sig_reg_file_05_at_t = RFtoDP_port_sig_reg_file_05@t,
	RFtoDP_port_sig_reg_file_06_at_t = RFtoDP_port_sig_reg_file_06@t,
	RFtoDP_port_sig_reg_file_07_at_t = RFtoDP_port_sig_reg_file_07@t,
	RFtoDP_port_sig_reg_file_08_at_t = RFtoDP_port_sig_reg_file_08@t,
	RFtoDP_port_sig_reg_file_09_at_t = RFtoDP_port_sig_reg_file_09@t,
	RFtoDP_port_sig_reg_file_10_at_t = RFtoDP_port_sig_reg_file_10@t,
	RFtoDP_port_sig_reg_file_11_at_t = RFtoDP_port_sig_reg_file_11@t,
	RFtoDP_port_sig_reg_file_12_at_t = RFtoDP_port_sig_reg_file_12@t,
	RFtoDP_port_sig_reg_file_13_at_t = RFtoDP_port_sig_reg_file_13@t,
	RFtoDP_port_sig_reg_file_14_at_t = RFtoDP_port_sig_reg_file_14@t,
	RFtoDP_port_sig_reg_file_15_at_t = RFtoDP_port_sig_reg_file_15@t,
	RFtoDP_port_sig_reg_file_16_at_t = RFtoDP_port_sig_reg_file_16@t,
	RFtoDP_port_sig_reg_file_17_at_t = RFtoDP_port_sig_reg_file_17@t,
	RFtoDP_port_sig_reg_file_18_at_t = RFtoDP_port_sig_reg_file_18@t,
	RFtoDP_port_sig_reg_file_19_at_t = RFtoDP_port_sig_reg_file_19@t,
	RFtoDP_port_sig_reg_file_20_at_t = RFtoDP_port_sig_reg_file_20@t,
	RFtoDP_port_sig_reg_file_21_at_t = RFtoDP_port_sig_reg_file_21@t,
	RFtoDP_port_sig_reg_file_22_at_t = RFtoDP_port_sig_reg_file_22@t,
	RFtoDP_port_sig_reg_file_23_at_t = RFtoDP_port_sig_reg_file_23@t,
	RFtoDP_port_sig_reg_file_24_at_t = RFtoDP_port_sig_reg_file_24@t,
	RFtoDP_port_sig_reg_file_25_at_t = RFtoDP_port_sig_reg_file_25@t,
	RFtoDP_port_sig_reg_file_26_at_t = RFtoDP_port_sig_reg_file_26@t,
	RFtoDP_port_sig_reg_file_27_at_t = RFtoDP_port_sig_reg_file_27@t,
	RFtoDP_port_sig_reg_file_28_at_t = RFtoDP_port_sig_reg_file_28@t,
	RFtoDP_port_sig_reg_file_29_at_t = RFtoDP_port_sig_reg_file_29@t,
	RFtoDP_port_sig_reg_file_30_at_t = RFtoDP_port_sig_reg_file_30@t,
	RFtoDP_port_sig_reg_file_31_at_t = RFtoDP_port_sig_reg_file_31@t;
assume:
	at t: state_97;
	at t: CUtoDP_port_sync;
	at t: (CUtoDP_port_sig_dmemReq_s4 = ME_RD);
	at t: CUtoDP_port_sig_prevDmemAccess;
	at t: (DP_S3_data_encType_s3 = ENC_S);
	at t: (DP_S5_data_encType_s5 = ENC_I_L);
	at t: (DP_S3_data_regRs2Addr_s3 = DP_S5_data_regRdAddr_s5);
	at t: not((DP_S5_data_regRdAddr_s5 = resize(0,32)));
	at t: CUtoDP_port_sig_stallDmemAccess;
prove:
	at t+1: state_97;
	at t+1: DP_S3_data_encType_s3 = DP_S3_data_encType_s3_at_t;
	at t+1: DP_S3_data_pc_s3 = DP_S3_data_pc_s3_at_t;
	at t+1: DP_S3_data_reg1Content_s3 = DP_S3_data_reg1Content_s3_at_t;
	at t+1: DP_S3_data_reg2Content_s3 = DP_S3_data_reg2Content_s3_at_t;
	at t+1: DP_S3_data_regRdAddr_s3 = DP_S3_data_regRdAddr_s3_at_t;
	at t+1: DP_S3_data_regRs1Addr_s3 = DP_S3_data_regRs1Addr_s3_at_t;
	at t+1: DP_S3_data_regRs2Addr_s3 = DP_S3_data_regRs2Addr_s3_at_t;
	at t+1: DP_S4_data_aluResult_s4 = DP_S4_data_aluResult_s4_at_t;
	at t+1: DP_S4_data_encType_s4 = DP_S4_data_encType_s4_at_t;
	at t+1: DP_S4_data_fwdPrevLoadedData = true;
	at t+1: DP_S4_data_pc_s4 = DP_S4_data_pc_s4_at_t;
	at t+1: DP_S4_data_prevLoadedData = CUtoDP_port_sig_loadedData_at_t;
	at t+1: DP_S4_data_reg2Content_s4 = DP_S4_data_reg2Content_s4_at_t;
	at t+1: DP_S4_data_regRdAddr_s4 = DP_S4_data_regRdAddr_s4_at_t;
	at t+1: DP_S4_data_regRs2Addr_s4 = DP_S4_data_regRs2Addr_s4_at_t;
	at t+1: DP_S5_data_aluResult_s5 = DP_S5_data_aluResult_s5_at_t;
	at t+1: DP_S5_data_encType_s5 = DP_S5_data_encType_s5_at_t;
	at t+1: DP_S5_data_pc_s5 = DP_S5_data_pc_s5_at_t;
	at t+1: DP_S5_data_regRdAddr_s5 = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoCU_data_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_data_dataIn = 0;
	at t+1: DPtoCU_data_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_data_reg1Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DPtoCU_data_reg2Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DPtoCU_data_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoCU_port_sig_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_port_sig_dataIn = 0;
	at t+1: DPtoCU_port_sig_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_port_sig_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoRF_port_sig_dst = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoRF_port_sig_dstData = getWBdata(DP_S5_data_aluResult_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S5_data_pc_s5_at_t,CUtoDP_port_sig_regFileWriteDataSel_s5_at_t);
	at t+1: DPtoRF_port_sig_wrReq = CUtoDP_port_sig_regFileReq_s5_at_t;
	at t+1: nextphase = readRegFileStage;
	at t+1: DPtoRF_port_notify = true;
end property;


property state_97_5 is
dependencies: no_reset;
freeze:
	CUtoDP_port_sig_dmemMask_s4_at_t = CUtoDP_port_sig_dmemMask_s4@t,
	CUtoDP_port_sig_dmemReq_s4_at_t = CUtoDP_port_sig_dmemReq_s4@t,
	CUtoDP_port_sig_loadedData_at_t = CUtoDP_port_sig_loadedData@t,
	CUtoDP_port_sig_regFileReq_s2_at_t = CUtoDP_port_sig_regFileReq_s2@t,
	CUtoDP_port_sig_regFileReq_s5_at_t = CUtoDP_port_sig_regFileReq_s5@t,
	CUtoDP_port_sig_regFileWriteDataSel_s5_at_t = CUtoDP_port_sig_regFileWriteDataSel_s5@t,
	CUtoDP_port_sig_regRs1Addr_s2_at_t = CUtoDP_port_sig_regRs1Addr_s2@t,
	CUtoDP_port_sig_regRs2Addr_s2_at_t = CUtoDP_port_sig_regRs2Addr_s2@t,
	DP_S3_data_encType_s3_at_t = DP_S3_data_encType_s3@t,
	DP_S3_data_pc_s3_at_t = DP_S3_data_pc_s3@t,
	DP_S3_data_reg1Content_s3_at_t = DP_S3_data_reg1Content_s3@t,
	DP_S3_data_reg2Content_s3_at_t = DP_S3_data_reg2Content_s3@t,
	DP_S3_data_regRdAddr_s3_at_t = DP_S3_data_regRdAddr_s3@t,
	DP_S3_data_regRs1Addr_s3_at_t = DP_S3_data_regRs1Addr_s3@t,
	DP_S3_data_regRs2Addr_s3_at_t = DP_S3_data_regRs2Addr_s3@t,
	DP_S4_data_aluResult_s4_at_t = DP_S4_data_aluResult_s4@t,
	DP_S4_data_encType_s4_at_t = DP_S4_data_encType_s4@t,
	DP_S4_data_pc_s4_at_t = DP_S4_data_pc_s4@t,
	DP_S4_data_prevLoadedData_at_t = DP_S4_data_prevLoadedData@t,
	DP_S4_data_reg2Content_s4_at_t = DP_S4_data_reg2Content_s4@t,
	DP_S4_data_regRdAddr_s4_at_t = DP_S4_data_regRdAddr_s4@t,
	DP_S4_data_regRs2Addr_s4_at_t = DP_S4_data_regRs2Addr_s4@t,
	DP_S5_data_aluResult_s5_at_t = DP_S5_data_aluResult_s5@t,
	DP_S5_data_encType_s5_at_t = DP_S5_data_encType_s5@t,
	DP_S5_data_pc_s5_at_t = DP_S5_data_pc_s5@t,
	DP_S5_data_regRdAddr_s5_at_t = DP_S5_data_regRdAddr_s5@t,
	RFtoDP_port_sig_reg_file_01_at_t = RFtoDP_port_sig_reg_file_01@t,
	RFtoDP_port_sig_reg_file_02_at_t = RFtoDP_port_sig_reg_file_02@t,
	RFtoDP_port_sig_reg_file_03_at_t = RFtoDP_port_sig_reg_file_03@t,
	RFtoDP_port_sig_reg_file_04_at_t = RFtoDP_port_sig_reg_file_04@t,
	RFtoDP_port_sig_reg_file_05_at_t = RFtoDP_port_sig_reg_file_05@t,
	RFtoDP_port_sig_reg_file_06_at_t = RFtoDP_port_sig_reg_file_06@t,
	RFtoDP_port_sig_reg_file_07_at_t = RFtoDP_port_sig_reg_file_07@t,
	RFtoDP_port_sig_reg_file_08_at_t = RFtoDP_port_sig_reg_file_08@t,
	RFtoDP_port_sig_reg_file_09_at_t = RFtoDP_port_sig_reg_file_09@t,
	RFtoDP_port_sig_reg_file_10_at_t = RFtoDP_port_sig_reg_file_10@t,
	RFtoDP_port_sig_reg_file_11_at_t = RFtoDP_port_sig_reg_file_11@t,
	RFtoDP_port_sig_reg_file_12_at_t = RFtoDP_port_sig_reg_file_12@t,
	RFtoDP_port_sig_reg_file_13_at_t = RFtoDP_port_sig_reg_file_13@t,
	RFtoDP_port_sig_reg_file_14_at_t = RFtoDP_port_sig_reg_file_14@t,
	RFtoDP_port_sig_reg_file_15_at_t = RFtoDP_port_sig_reg_file_15@t,
	RFtoDP_port_sig_reg_file_16_at_t = RFtoDP_port_sig_reg_file_16@t,
	RFtoDP_port_sig_reg_file_17_at_t = RFtoDP_port_sig_reg_file_17@t,
	RFtoDP_port_sig_reg_file_18_at_t = RFtoDP_port_sig_reg_file_18@t,
	RFtoDP_port_sig_reg_file_19_at_t = RFtoDP_port_sig_reg_file_19@t,
	RFtoDP_port_sig_reg_file_20_at_t = RFtoDP_port_sig_reg_file_20@t,
	RFtoDP_port_sig_reg_file_21_at_t = RFtoDP_port_sig_reg_file_21@t,
	RFtoDP_port_sig_reg_file_22_at_t = RFtoDP_port_sig_reg_file_22@t,
	RFtoDP_port_sig_reg_file_23_at_t = RFtoDP_port_sig_reg_file_23@t,
	RFtoDP_port_sig_reg_file_24_at_t = RFtoDP_port_sig_reg_file_24@t,
	RFtoDP_port_sig_reg_file_25_at_t = RFtoDP_port_sig_reg_file_25@t,
	RFtoDP_port_sig_reg_file_26_at_t = RFtoDP_port_sig_reg_file_26@t,
	RFtoDP_port_sig_reg_file_27_at_t = RFtoDP_port_sig_reg_file_27@t,
	RFtoDP_port_sig_reg_file_28_at_t = RFtoDP_port_sig_reg_file_28@t,
	RFtoDP_port_sig_reg_file_29_at_t = RFtoDP_port_sig_reg_file_29@t,
	RFtoDP_port_sig_reg_file_30_at_t = RFtoDP_port_sig_reg_file_30@t,
	RFtoDP_port_sig_reg_file_31_at_t = RFtoDP_port_sig_reg_file_31@t;
assume:
	at t: state_97;
	at t: CUtoDP_port_sync;
	at t: (CUtoDP_port_sig_dmemReq_s4 = ME_RD);
	at t: not(((((CUtoDP_port_sig_prevDmemAccess and (DP_S3_data_encType_s3 = ENC_S)) and (DP_S5_data_encType_s5 = ENC_I_L)) and (DP_S3_data_regRs2Addr_s3 = DP_S5_data_regRdAddr_s5)) and not((DP_S5_data_regRdAddr_s5 = resize(0,32)))));
	at t: DP_S4_data_fwdPrevLoadedData;
	at t: CUtoDP_port_sig_stallDmemAccess;
prove:
	at t+1: state_97;
	at t+1: DP_S3_data_encType_s3 = DP_S3_data_encType_s3_at_t;
	at t+1: DP_S3_data_pc_s3 = DP_S3_data_pc_s3_at_t;
	at t+1: DP_S3_data_reg1Content_s3 = DP_S3_data_reg1Content_s3_at_t;
	at t+1: DP_S3_data_reg2Content_s3 = DP_S3_data_reg2Content_s3_at_t;
	at t+1: DP_S3_data_regRdAddr_s3 = DP_S3_data_regRdAddr_s3_at_t;
	at t+1: DP_S3_data_regRs1Addr_s3 = DP_S3_data_regRs1Addr_s3_at_t;
	at t+1: DP_S3_data_regRs2Addr_s3 = DP_S3_data_regRs2Addr_s3_at_t;
	at t+1: DP_S4_data_aluResult_s4 = DP_S4_data_aluResult_s4_at_t;
	at t+1: DP_S4_data_encType_s4 = DP_S4_data_encType_s4_at_t;
	at t+1: DP_S4_data_fwdPrevLoadedData = true;
	at t+1: DP_S4_data_pc_s4 = DP_S4_data_pc_s4_at_t;
	at t+1: DP_S4_data_prevLoadedData = DP_S4_data_prevLoadedData_at_t;
	at t+1: DP_S4_data_reg2Content_s4 = DP_S4_data_reg2Content_s4_at_t;
	at t+1: DP_S4_data_regRdAddr_s4 = DP_S4_data_regRdAddr_s4_at_t;
	at t+1: DP_S4_data_regRs2Addr_s4 = DP_S4_data_regRs2Addr_s4_at_t;
	at t+1: DP_S5_data_aluResult_s5 = DP_S5_data_aluResult_s5_at_t;
	at t+1: DP_S5_data_encType_s5 = DP_S5_data_encType_s5_at_t;
	at t+1: DP_S5_data_pc_s5 = DP_S5_data_pc_s5_at_t;
	at t+1: DP_S5_data_regRdAddr_s5 = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoCU_data_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_data_dataIn = 0;
	at t+1: DPtoCU_data_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_data_reg1Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DPtoCU_data_reg2Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DPtoCU_data_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoCU_port_sig_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_port_sig_dataIn = 0;
	at t+1: DPtoCU_port_sig_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_port_sig_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoRF_port_sig_dst = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoRF_port_sig_dstData = getWBdata(DP_S5_data_aluResult_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S5_data_pc_s5_at_t,CUtoDP_port_sig_regFileWriteDataSel_s5_at_t);
	at t+1: DPtoRF_port_sig_wrReq = CUtoDP_port_sig_regFileReq_s5_at_t;
	at t+1: nextphase = readRegFileStage;
	at t+1: DPtoRF_port_notify = true;
end property;


property state_97_7 is
dependencies: no_reset;
freeze:
	CUtoDP_port_sig_aluFunc_s3_at_t = CUtoDP_port_sig_aluFunc_s3@t,
	CUtoDP_port_sig_aluOp1Sel_s3_at_t = CUtoDP_port_sig_aluOp1Sel_s3@t,
	CUtoDP_port_sig_aluOp2Sel_s3_at_t = CUtoDP_port_sig_aluOp2Sel_s3@t,
	CUtoDP_port_sig_dmemMask_s4_at_t = CUtoDP_port_sig_dmemMask_s4@t,
	CUtoDP_port_sig_dmemReq_s4_at_t = CUtoDP_port_sig_dmemReq_s4@t,
	CUtoDP_port_sig_encType_s2_at_t = CUtoDP_port_sig_encType_s2@t,
	CUtoDP_port_sig_imm_s3_at_t = CUtoDP_port_sig_imm_s3@t,
	CUtoDP_port_sig_loadedData_at_t = CUtoDP_port_sig_loadedData@t,
	CUtoDP_port_sig_pc_s2_at_t = CUtoDP_port_sig_pc_s2@t,
	CUtoDP_port_sig_regFileReq_s2_at_t = CUtoDP_port_sig_regFileReq_s2@t,
	CUtoDP_port_sig_regFileReq_s5_at_t = CUtoDP_port_sig_regFileReq_s5@t,
	CUtoDP_port_sig_regFileWriteDataSel_s5_at_t = CUtoDP_port_sig_regFileWriteDataSel_s5@t,
	CUtoDP_port_sig_regRdAddr_s2_at_t = CUtoDP_port_sig_regRdAddr_s2@t,
	CUtoDP_port_sig_regRs1Addr_s2_at_t = CUtoDP_port_sig_regRs1Addr_s2@t,
	CUtoDP_port_sig_regRs2Addr_s2_at_t = CUtoDP_port_sig_regRs2Addr_s2@t,
	DP_S3_data_encType_s3_at_t = DP_S3_data_encType_s3@t,
	DP_S3_data_pc_s3_at_t = DP_S3_data_pc_s3@t,
	DP_S3_data_reg1Content_s3_at_t = DP_S3_data_reg1Content_s3@t,
	DP_S3_data_reg2Content_s3_at_t = DP_S3_data_reg2Content_s3@t,
	DP_S3_data_regRdAddr_s3_at_t = DP_S3_data_regRdAddr_s3@t,
	DP_S3_data_regRs1Addr_s3_at_t = DP_S3_data_regRs1Addr_s3@t,
	DP_S3_data_regRs2Addr_s3_at_t = DP_S3_data_regRs2Addr_s3@t,
	DP_S4_data_aluResult_s4_at_t = DP_S4_data_aluResult_s4@t,
	DP_S4_data_encType_s4_at_t = DP_S4_data_encType_s4@t,
	DP_S4_data_pc_s4_at_t = DP_S4_data_pc_s4@t,
	DP_S4_data_prevLoadedData_at_t = DP_S4_data_prevLoadedData@t,
	DP_S4_data_regRdAddr_s4_at_t = DP_S4_data_regRdAddr_s4@t,
	DP_S5_data_aluResult_s5_at_t = DP_S5_data_aluResult_s5@t,
	DP_S5_data_encType_s5_at_t = DP_S5_data_encType_s5@t,
	DP_S5_data_pc_s5_at_t = DP_S5_data_pc_s5@t,
	DP_S5_data_regRdAddr_s5_at_t = DP_S5_data_regRdAddr_s5@t,
	RFtoDP_port_sig_reg_file_01_at_t = RFtoDP_port_sig_reg_file_01@t,
	RFtoDP_port_sig_reg_file_02_at_t = RFtoDP_port_sig_reg_file_02@t,
	RFtoDP_port_sig_reg_file_03_at_t = RFtoDP_port_sig_reg_file_03@t,
	RFtoDP_port_sig_reg_file_04_at_t = RFtoDP_port_sig_reg_file_04@t,
	RFtoDP_port_sig_reg_file_05_at_t = RFtoDP_port_sig_reg_file_05@t,
	RFtoDP_port_sig_reg_file_06_at_t = RFtoDP_port_sig_reg_file_06@t,
	RFtoDP_port_sig_reg_file_07_at_t = RFtoDP_port_sig_reg_file_07@t,
	RFtoDP_port_sig_reg_file_08_at_t = RFtoDP_port_sig_reg_file_08@t,
	RFtoDP_port_sig_reg_file_09_at_t = RFtoDP_port_sig_reg_file_09@t,
	RFtoDP_port_sig_reg_file_10_at_t = RFtoDP_port_sig_reg_file_10@t,
	RFtoDP_port_sig_reg_file_11_at_t = RFtoDP_port_sig_reg_file_11@t,
	RFtoDP_port_sig_reg_file_12_at_t = RFtoDP_port_sig_reg_file_12@t,
	RFtoDP_port_sig_reg_file_13_at_t = RFtoDP_port_sig_reg_file_13@t,
	RFtoDP_port_sig_reg_file_14_at_t = RFtoDP_port_sig_reg_file_14@t,
	RFtoDP_port_sig_reg_file_15_at_t = RFtoDP_port_sig_reg_file_15@t,
	RFtoDP_port_sig_reg_file_16_at_t = RFtoDP_port_sig_reg_file_16@t,
	RFtoDP_port_sig_reg_file_17_at_t = RFtoDP_port_sig_reg_file_17@t,
	RFtoDP_port_sig_reg_file_18_at_t = RFtoDP_port_sig_reg_file_18@t,
	RFtoDP_port_sig_reg_file_19_at_t = RFtoDP_port_sig_reg_file_19@t,
	RFtoDP_port_sig_reg_file_20_at_t = RFtoDP_port_sig_reg_file_20@t,
	RFtoDP_port_sig_reg_file_21_at_t = RFtoDP_port_sig_reg_file_21@t,
	RFtoDP_port_sig_reg_file_22_at_t = RFtoDP_port_sig_reg_file_22@t,
	RFtoDP_port_sig_reg_file_23_at_t = RFtoDP_port_sig_reg_file_23@t,
	RFtoDP_port_sig_reg_file_24_at_t = RFtoDP_port_sig_reg_file_24@t,
	RFtoDP_port_sig_reg_file_25_at_t = RFtoDP_port_sig_reg_file_25@t,
	RFtoDP_port_sig_reg_file_26_at_t = RFtoDP_port_sig_reg_file_26@t,
	RFtoDP_port_sig_reg_file_27_at_t = RFtoDP_port_sig_reg_file_27@t,
	RFtoDP_port_sig_reg_file_28_at_t = RFtoDP_port_sig_reg_file_28@t,
	RFtoDP_port_sig_reg_file_29_at_t = RFtoDP_port_sig_reg_file_29@t,
	RFtoDP_port_sig_reg_file_30_at_t = RFtoDP_port_sig_reg_file_30@t,
	RFtoDP_port_sig_reg_file_31_at_t = RFtoDP_port_sig_reg_file_31@t;
assume:
	at t: state_97;
	at t: CUtoDP_port_sync;
	at t: (CUtoDP_port_sig_dmemReq_s4 = ME_RD);
	at t: not(((((CUtoDP_port_sig_prevDmemAccess and (DP_S3_data_encType_s3 = ENC_S)) and (DP_S5_data_encType_s5 = ENC_I_L)) and (DP_S3_data_regRs2Addr_s3 = DP_S5_data_regRdAddr_s5)) and not((DP_S5_data_regRdAddr_s5 = resize(0,32)))));
	at t: not(CUtoDP_port_sig_stallDmemAccess);
prove:
	at t+1: state_97;
	at t+1: DP_S3_data_encType_s3 = CUtoDP_port_sig_encType_s2_at_t;
	at t+1: DP_S3_data_pc_s3 = CUtoDP_port_sig_pc_s2_at_t;
	at t+1: DP_S3_data_reg1Content_s3 = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DP_S3_data_reg2Content_s3 = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DP_S3_data_regRdAddr_s3 = CUtoDP_port_sig_regRdAddr_s2_at_t;
	at t+1: DP_S3_data_regRs1Addr_s3 = CUtoDP_port_sig_regRs1Addr_s2_at_t;
	at t+1: DP_S3_data_regRs2Addr_s3 = CUtoDP_port_sig_regRs2Addr_s2_at_t;
	at t+1: DP_S4_data_aluResult_s4 = getALUresult(CUtoDP_port_sig_aluFunc_s3_at_t,getALUoperand(aluOpFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S3_data_reg1Content_s3_at_t,DP_S3_data_regRs1Addr_s3_at_t),CUtoDP_port_sig_aluOp1Sel_s3_at_t,CUtoDP_port_sig_imm_s3_at_t,DP_S3_data_pc_s3_at_t),getALUoperand(aluOpFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S3_data_reg2Content_s3_at_t,DP_S3_data_regRs2Addr_s3_at_t),CUtoDP_port_sig_aluOp2Sel_s3_at_t,CUtoDP_port_sig_imm_s3_at_t,DP_S3_data_pc_s3_at_t));
	at t+1: DP_S4_data_encType_s4 = DP_S3_data_encType_s3_at_t;
	at t+1: DP_S4_data_fwdPrevLoadedData = false;
	at t+1: DP_S4_data_pc_s4 = DP_S3_data_pc_s3_at_t;
	at t+1: DP_S4_data_prevLoadedData = DP_S4_data_prevLoadedData_at_t;
	at t+1: DP_S4_data_reg2Content_s4 = DP_S3_data_reg2Content_s3_at_t;
	at t+1: DP_S4_data_regRdAddr_s4 = DP_S3_data_regRdAddr_s3_at_t;
	at t+1: DP_S4_data_regRs2Addr_s4 = DP_S3_data_regRs2Addr_s3_at_t;
	at t+1: DP_S5_data_aluResult_s5 = DP_S4_data_aluResult_s4_at_t;
	at t+1: DP_S5_data_encType_s5 = DP_S4_data_encType_s4_at_t;
	at t+1: DP_S5_data_pc_s5 = DP_S4_data_pc_s4_at_t;
	at t+1: DP_S5_data_regRdAddr_s5 = DP_S4_data_regRdAddr_s4_at_t;
	at t+1: DPtoCU_data_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_data_dataIn = 0;
	at t+1: DPtoCU_data_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_data_reg1Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DPtoCU_data_reg2Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DPtoCU_data_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoCU_port_sig_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_port_sig_dataIn = 0;
	at t+1: DPtoCU_port_sig_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_port_sig_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoRF_port_sig_dst = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoRF_port_sig_dstData = getWBdata(DP_S5_data_aluResult_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S5_data_pc_s5_at_t,CUtoDP_port_sig_regFileWriteDataSel_s5_at_t);
	at t+1: DPtoRF_port_sig_wrReq = CUtoDP_port_sig_regFileReq_s5_at_t;
	at t+1: nextphase = readRegFileStage;
	at t+1: DPtoRF_port_notify = true;
end property;


property state_97_9 is
dependencies: no_reset;
freeze:
	CUtoDP_port_sig_dmemMask_s4_at_t = CUtoDP_port_sig_dmemMask_s4@t,
	CUtoDP_port_sig_dmemReq_s4_at_t = CUtoDP_port_sig_dmemReq_s4@t,
	CUtoDP_port_sig_loadedData_at_t = CUtoDP_port_sig_loadedData@t,
	CUtoDP_port_sig_regFileReq_s2_at_t = CUtoDP_port_sig_regFileReq_s2@t,
	CUtoDP_port_sig_regFileReq_s5_at_t = CUtoDP_port_sig_regFileReq_s5@t,
	CUtoDP_port_sig_regFileWriteDataSel_s5_at_t = CUtoDP_port_sig_regFileWriteDataSel_s5@t,
	CUtoDP_port_sig_regRs1Addr_s2_at_t = CUtoDP_port_sig_regRs1Addr_s2@t,
	CUtoDP_port_sig_regRs2Addr_s2_at_t = CUtoDP_port_sig_regRs2Addr_s2@t,
	DP_S3_data_encType_s3_at_t = DP_S3_data_encType_s3@t,
	DP_S3_data_pc_s3_at_t = DP_S3_data_pc_s3@t,
	DP_S3_data_reg1Content_s3_at_t = DP_S3_data_reg1Content_s3@t,
	DP_S3_data_reg2Content_s3_at_t = DP_S3_data_reg2Content_s3@t,
	DP_S3_data_regRdAddr_s3_at_t = DP_S3_data_regRdAddr_s3@t,
	DP_S3_data_regRs1Addr_s3_at_t = DP_S3_data_regRs1Addr_s3@t,
	DP_S3_data_regRs2Addr_s3_at_t = DP_S3_data_regRs2Addr_s3@t,
	DP_S4_data_aluResult_s4_at_t = DP_S4_data_aluResult_s4@t,
	DP_S4_data_encType_s4_at_t = DP_S4_data_encType_s4@t,
	DP_S4_data_pc_s4_at_t = DP_S4_data_pc_s4@t,
	DP_S4_data_prevLoadedData_at_t = DP_S4_data_prevLoadedData@t,
	DP_S4_data_reg2Content_s4_at_t = DP_S4_data_reg2Content_s4@t,
	DP_S4_data_regRdAddr_s4_at_t = DP_S4_data_regRdAddr_s4@t,
	DP_S4_data_regRs2Addr_s4_at_t = DP_S4_data_regRs2Addr_s4@t,
	DP_S5_data_aluResult_s5_at_t = DP_S5_data_aluResult_s5@t,
	DP_S5_data_encType_s5_at_t = DP_S5_data_encType_s5@t,
	DP_S5_data_pc_s5_at_t = DP_S5_data_pc_s5@t,
	DP_S5_data_regRdAddr_s5_at_t = DP_S5_data_regRdAddr_s5@t,
	RFtoDP_port_sig_reg_file_01_at_t = RFtoDP_port_sig_reg_file_01@t,
	RFtoDP_port_sig_reg_file_02_at_t = RFtoDP_port_sig_reg_file_02@t,
	RFtoDP_port_sig_reg_file_03_at_t = RFtoDP_port_sig_reg_file_03@t,
	RFtoDP_port_sig_reg_file_04_at_t = RFtoDP_port_sig_reg_file_04@t,
	RFtoDP_port_sig_reg_file_05_at_t = RFtoDP_port_sig_reg_file_05@t,
	RFtoDP_port_sig_reg_file_06_at_t = RFtoDP_port_sig_reg_file_06@t,
	RFtoDP_port_sig_reg_file_07_at_t = RFtoDP_port_sig_reg_file_07@t,
	RFtoDP_port_sig_reg_file_08_at_t = RFtoDP_port_sig_reg_file_08@t,
	RFtoDP_port_sig_reg_file_09_at_t = RFtoDP_port_sig_reg_file_09@t,
	RFtoDP_port_sig_reg_file_10_at_t = RFtoDP_port_sig_reg_file_10@t,
	RFtoDP_port_sig_reg_file_11_at_t = RFtoDP_port_sig_reg_file_11@t,
	RFtoDP_port_sig_reg_file_12_at_t = RFtoDP_port_sig_reg_file_12@t,
	RFtoDP_port_sig_reg_file_13_at_t = RFtoDP_port_sig_reg_file_13@t,
	RFtoDP_port_sig_reg_file_14_at_t = RFtoDP_port_sig_reg_file_14@t,
	RFtoDP_port_sig_reg_file_15_at_t = RFtoDP_port_sig_reg_file_15@t,
	RFtoDP_port_sig_reg_file_16_at_t = RFtoDP_port_sig_reg_file_16@t,
	RFtoDP_port_sig_reg_file_17_at_t = RFtoDP_port_sig_reg_file_17@t,
	RFtoDP_port_sig_reg_file_18_at_t = RFtoDP_port_sig_reg_file_18@t,
	RFtoDP_port_sig_reg_file_19_at_t = RFtoDP_port_sig_reg_file_19@t,
	RFtoDP_port_sig_reg_file_20_at_t = RFtoDP_port_sig_reg_file_20@t,
	RFtoDP_port_sig_reg_file_21_at_t = RFtoDP_port_sig_reg_file_21@t,
	RFtoDP_port_sig_reg_file_22_at_t = RFtoDP_port_sig_reg_file_22@t,
	RFtoDP_port_sig_reg_file_23_at_t = RFtoDP_port_sig_reg_file_23@t,
	RFtoDP_port_sig_reg_file_24_at_t = RFtoDP_port_sig_reg_file_24@t,
	RFtoDP_port_sig_reg_file_25_at_t = RFtoDP_port_sig_reg_file_25@t,
	RFtoDP_port_sig_reg_file_26_at_t = RFtoDP_port_sig_reg_file_26@t,
	RFtoDP_port_sig_reg_file_27_at_t = RFtoDP_port_sig_reg_file_27@t,
	RFtoDP_port_sig_reg_file_28_at_t = RFtoDP_port_sig_reg_file_28@t,
	RFtoDP_port_sig_reg_file_29_at_t = RFtoDP_port_sig_reg_file_29@t,
	RFtoDP_port_sig_reg_file_30_at_t = RFtoDP_port_sig_reg_file_30@t,
	RFtoDP_port_sig_reg_file_31_at_t = RFtoDP_port_sig_reg_file_31@t;
assume:
	at t: state_97;
	at t: CUtoDP_port_sync;
	at t: (CUtoDP_port_sig_dmemReq_s4 = ME_RD);
	at t: not(((((CUtoDP_port_sig_prevDmemAccess and (DP_S3_data_encType_s3 = ENC_S)) and (DP_S5_data_encType_s5 = ENC_I_L)) and (DP_S3_data_regRs2Addr_s3 = DP_S5_data_regRdAddr_s5)) and not((DP_S5_data_regRdAddr_s5 = resize(0,32)))));
	at t: not(DP_S4_data_fwdPrevLoadedData);
	at t: CUtoDP_port_sig_stallDmemAccess;
prove:
	at t+1: state_97;
	at t+1: DP_S3_data_encType_s3 = DP_S3_data_encType_s3_at_t;
	at t+1: DP_S3_data_pc_s3 = DP_S3_data_pc_s3_at_t;
	at t+1: DP_S3_data_reg1Content_s3 = DP_S3_data_reg1Content_s3_at_t;
	at t+1: DP_S3_data_reg2Content_s3 = DP_S3_data_reg2Content_s3_at_t;
	at t+1: DP_S3_data_regRdAddr_s3 = DP_S3_data_regRdAddr_s3_at_t;
	at t+1: DP_S3_data_regRs1Addr_s3 = DP_S3_data_regRs1Addr_s3_at_t;
	at t+1: DP_S3_data_regRs2Addr_s3 = DP_S3_data_regRs2Addr_s3_at_t;
	at t+1: DP_S4_data_aluResult_s4 = DP_S4_data_aluResult_s4_at_t;
	at t+1: DP_S4_data_encType_s4 = DP_S4_data_encType_s4_at_t;
	at t+1: DP_S4_data_fwdPrevLoadedData = false;
	at t+1: DP_S4_data_pc_s4 = DP_S4_data_pc_s4_at_t;
	at t+1: DP_S4_data_prevLoadedData = DP_S4_data_prevLoadedData_at_t;
	at t+1: DP_S4_data_reg2Content_s4 = DP_S4_data_reg2Content_s4_at_t;
	at t+1: DP_S4_data_regRdAddr_s4 = DP_S4_data_regRdAddr_s4_at_t;
	at t+1: DP_S4_data_regRs2Addr_s4 = DP_S4_data_regRs2Addr_s4_at_t;
	at t+1: DP_S5_data_aluResult_s5 = DP_S5_data_aluResult_s5_at_t;
	at t+1: DP_S5_data_encType_s5 = DP_S5_data_encType_s5_at_t;
	at t+1: DP_S5_data_pc_s5 = DP_S5_data_pc_s5_at_t;
	at t+1: DP_S5_data_regRdAddr_s5 = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoCU_data_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_data_dataIn = 0;
	at t+1: DPtoCU_data_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_data_reg1Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DPtoCU_data_reg2Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DPtoCU_data_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoCU_port_sig_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_port_sig_dataIn = 0;
	at t+1: DPtoCU_port_sig_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_port_sig_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoRF_port_sig_dst = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoRF_port_sig_dstData = getWBdata(DP_S5_data_aluResult_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S5_data_pc_s5_at_t,CUtoDP_port_sig_regFileWriteDataSel_s5_at_t);
	at t+1: DPtoRF_port_sig_wrReq = CUtoDP_port_sig_regFileReq_s5_at_t;
	at t+1: nextphase = readRegFileStage;
	at t+1: DPtoRF_port_notify = true;
end property;


property state_97_11 is
dependencies: no_reset;
freeze:
	CUtoDP_port_sig_aluFunc_s3_at_t = CUtoDP_port_sig_aluFunc_s3@t,
	CUtoDP_port_sig_aluOp1Sel_s3_at_t = CUtoDP_port_sig_aluOp1Sel_s3@t,
	CUtoDP_port_sig_aluOp2Sel_s3_at_t = CUtoDP_port_sig_aluOp2Sel_s3@t,
	CUtoDP_port_sig_dmemMask_s4_at_t = CUtoDP_port_sig_dmemMask_s4@t,
	CUtoDP_port_sig_dmemReq_s4_at_t = CUtoDP_port_sig_dmemReq_s4@t,
	CUtoDP_port_sig_encType_s2_at_t = CUtoDP_port_sig_encType_s2@t,
	CUtoDP_port_sig_imm_s3_at_t = CUtoDP_port_sig_imm_s3@t,
	CUtoDP_port_sig_loadedData_at_t = CUtoDP_port_sig_loadedData@t,
	CUtoDP_port_sig_pc_s2_at_t = CUtoDP_port_sig_pc_s2@t,
	CUtoDP_port_sig_regFileReq_s2_at_t = CUtoDP_port_sig_regFileReq_s2@t,
	CUtoDP_port_sig_regFileReq_s5_at_t = CUtoDP_port_sig_regFileReq_s5@t,
	CUtoDP_port_sig_regFileWriteDataSel_s5_at_t = CUtoDP_port_sig_regFileWriteDataSel_s5@t,
	CUtoDP_port_sig_regRdAddr_s2_at_t = CUtoDP_port_sig_regRdAddr_s2@t,
	CUtoDP_port_sig_regRs1Addr_s2_at_t = CUtoDP_port_sig_regRs1Addr_s2@t,
	CUtoDP_port_sig_regRs2Addr_s2_at_t = CUtoDP_port_sig_regRs2Addr_s2@t,
	DP_S3_data_encType_s3_at_t = DP_S3_data_encType_s3@t,
	DP_S3_data_pc_s3_at_t = DP_S3_data_pc_s3@t,
	DP_S3_data_reg1Content_s3_at_t = DP_S3_data_reg1Content_s3@t,
	DP_S3_data_reg2Content_s3_at_t = DP_S3_data_reg2Content_s3@t,
	DP_S3_data_regRdAddr_s3_at_t = DP_S3_data_regRdAddr_s3@t,
	DP_S3_data_regRs1Addr_s3_at_t = DP_S3_data_regRs1Addr_s3@t,
	DP_S3_data_regRs2Addr_s3_at_t = DP_S3_data_regRs2Addr_s3@t,
	DP_S4_data_aluResult_s4_at_t = DP_S4_data_aluResult_s4@t,
	DP_S4_data_encType_s4_at_t = DP_S4_data_encType_s4@t,
	DP_S4_data_fwdPrevLoadedData_at_t = DP_S4_data_fwdPrevLoadedData@t,
	DP_S4_data_pc_s4_at_t = DP_S4_data_pc_s4@t,
	DP_S4_data_prevLoadedData_at_t = DP_S4_data_prevLoadedData@t,
	DP_S4_data_reg2Content_s4_at_t = DP_S4_data_reg2Content_s4@t,
	DP_S4_data_regRdAddr_s4_at_t = DP_S4_data_regRdAddr_s4@t,
	DP_S4_data_regRs2Addr_s4_at_t = DP_S4_data_regRs2Addr_s4@t,
	DP_S5_data_aluResult_s5_at_t = DP_S5_data_aluResult_s5@t,
	DP_S5_data_encType_s5_at_t = DP_S5_data_encType_s5@t,
	DP_S5_data_pc_s5_at_t = DP_S5_data_pc_s5@t,
	DP_S5_data_regRdAddr_s5_at_t = DP_S5_data_regRdAddr_s5@t,
	RFtoDP_port_sig_reg_file_01_at_t = RFtoDP_port_sig_reg_file_01@t,
	RFtoDP_port_sig_reg_file_02_at_t = RFtoDP_port_sig_reg_file_02@t,
	RFtoDP_port_sig_reg_file_03_at_t = RFtoDP_port_sig_reg_file_03@t,
	RFtoDP_port_sig_reg_file_04_at_t = RFtoDP_port_sig_reg_file_04@t,
	RFtoDP_port_sig_reg_file_05_at_t = RFtoDP_port_sig_reg_file_05@t,
	RFtoDP_port_sig_reg_file_06_at_t = RFtoDP_port_sig_reg_file_06@t,
	RFtoDP_port_sig_reg_file_07_at_t = RFtoDP_port_sig_reg_file_07@t,
	RFtoDP_port_sig_reg_file_08_at_t = RFtoDP_port_sig_reg_file_08@t,
	RFtoDP_port_sig_reg_file_09_at_t = RFtoDP_port_sig_reg_file_09@t,
	RFtoDP_port_sig_reg_file_10_at_t = RFtoDP_port_sig_reg_file_10@t,
	RFtoDP_port_sig_reg_file_11_at_t = RFtoDP_port_sig_reg_file_11@t,
	RFtoDP_port_sig_reg_file_12_at_t = RFtoDP_port_sig_reg_file_12@t,
	RFtoDP_port_sig_reg_file_13_at_t = RFtoDP_port_sig_reg_file_13@t,
	RFtoDP_port_sig_reg_file_14_at_t = RFtoDP_port_sig_reg_file_14@t,
	RFtoDP_port_sig_reg_file_15_at_t = RFtoDP_port_sig_reg_file_15@t,
	RFtoDP_port_sig_reg_file_16_at_t = RFtoDP_port_sig_reg_file_16@t,
	RFtoDP_port_sig_reg_file_17_at_t = RFtoDP_port_sig_reg_file_17@t,
	RFtoDP_port_sig_reg_file_18_at_t = RFtoDP_port_sig_reg_file_18@t,
	RFtoDP_port_sig_reg_file_19_at_t = RFtoDP_port_sig_reg_file_19@t,
	RFtoDP_port_sig_reg_file_20_at_t = RFtoDP_port_sig_reg_file_20@t,
	RFtoDP_port_sig_reg_file_21_at_t = RFtoDP_port_sig_reg_file_21@t,
	RFtoDP_port_sig_reg_file_22_at_t = RFtoDP_port_sig_reg_file_22@t,
	RFtoDP_port_sig_reg_file_23_at_t = RFtoDP_port_sig_reg_file_23@t,
	RFtoDP_port_sig_reg_file_24_at_t = RFtoDP_port_sig_reg_file_24@t,
	RFtoDP_port_sig_reg_file_25_at_t = RFtoDP_port_sig_reg_file_25@t,
	RFtoDP_port_sig_reg_file_26_at_t = RFtoDP_port_sig_reg_file_26@t,
	RFtoDP_port_sig_reg_file_27_at_t = RFtoDP_port_sig_reg_file_27@t,
	RFtoDP_port_sig_reg_file_28_at_t = RFtoDP_port_sig_reg_file_28@t,
	RFtoDP_port_sig_reg_file_29_at_t = RFtoDP_port_sig_reg_file_29@t,
	RFtoDP_port_sig_reg_file_30_at_t = RFtoDP_port_sig_reg_file_30@t,
	RFtoDP_port_sig_reg_file_31_at_t = RFtoDP_port_sig_reg_file_31@t;
assume:
	at t: state_97;
	at t: CUtoDP_port_sync;
	at t: (CUtoDP_port_sig_dmemReq_s4 = ME_WR);
	at t: CUtoDP_port_sig_prevDmemAccess;
	at t: (DP_S3_data_encType_s3 = ENC_S);
	at t: (DP_S5_data_encType_s5 = ENC_I_L);
	at t: (DP_S3_data_regRs2Addr_s3 = DP_S5_data_regRdAddr_s5);
	at t: not((DP_S5_data_regRdAddr_s5 = resize(0,32)));
	at t: not(CUtoDP_port_sig_stallDmemAccess);
prove:
	at t+1: state_97;
	at t+1: DP_S3_data_encType_s3 = CUtoDP_port_sig_encType_s2_at_t;
	at t+1: DP_S3_data_pc_s3 = CUtoDP_port_sig_pc_s2_at_t;
	at t+1: DP_S3_data_reg1Content_s3 = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DP_S3_data_reg2Content_s3 = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DP_S3_data_regRdAddr_s3 = CUtoDP_port_sig_regRdAddr_s2_at_t;
	at t+1: DP_S3_data_regRs1Addr_s3 = CUtoDP_port_sig_regRs1Addr_s2_at_t;
	at t+1: DP_S3_data_regRs2Addr_s3 = CUtoDP_port_sig_regRs2Addr_s2_at_t;
	at t+1: DP_S4_data_aluResult_s4 = getALUresult(CUtoDP_port_sig_aluFunc_s3_at_t,getALUoperand(aluOpFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S3_data_reg1Content_s3_at_t,DP_S3_data_regRs1Addr_s3_at_t),CUtoDP_port_sig_aluOp1Sel_s3_at_t,CUtoDP_port_sig_imm_s3_at_t,DP_S3_data_pc_s3_at_t),getALUoperand(aluOpFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S3_data_reg2Content_s3_at_t,DP_S3_data_regRs2Addr_s3_at_t),CUtoDP_port_sig_aluOp2Sel_s3_at_t,CUtoDP_port_sig_imm_s3_at_t,DP_S3_data_pc_s3_at_t));
	at t+1: DP_S4_data_encType_s4 = DP_S3_data_encType_s3_at_t;
	at t+1: DP_S4_data_fwdPrevLoadedData = true;
	at t+1: DP_S4_data_pc_s4 = DP_S3_data_pc_s3_at_t;
	at t+1: DP_S4_data_prevLoadedData = CUtoDP_port_sig_loadedData_at_t;
	at t+1: DP_S4_data_reg2Content_s4 = DP_S3_data_reg2Content_s3_at_t;
	at t+1: DP_S4_data_regRdAddr_s4 = DP_S3_data_regRdAddr_s3_at_t;
	at t+1: DP_S4_data_regRs2Addr_s4 = DP_S3_data_regRs2Addr_s3_at_t;
	at t+1: DP_S5_data_aluResult_s5 = DP_S4_data_aluResult_s4_at_t;
	at t+1: DP_S5_data_encType_s5 = DP_S4_data_encType_s4_at_t;
	at t+1: DP_S5_data_pc_s5 = DP_S4_data_pc_s4_at_t;
	at t+1: DP_S5_data_regRdAddr_s5 = DP_S4_data_regRdAddr_s4_at_t;
	at t+1: DPtoCU_data_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_data_dataIn = dmemDataInFwdUnit(DP_S5_data_aluResult_s5_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,DP_S4_data_fwdPrevLoadedData_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_prevLoadedData_at_t,DP_S4_data_reg2Content_s4_at_t,DP_S4_data_regRs2Addr_s4_at_t);
	at t+1: DPtoCU_data_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_data_reg1Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DPtoCU_data_reg2Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DPtoCU_data_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoCU_port_sig_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_port_sig_dataIn = dmemDataInFwdUnit(DP_S5_data_aluResult_s5_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,DP_S4_data_fwdPrevLoadedData_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_prevLoadedData_at_t,DP_S4_data_reg2Content_s4_at_t,DP_S4_data_regRs2Addr_s4_at_t);
	at t+1: DPtoCU_port_sig_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_port_sig_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoRF_port_sig_dst = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoRF_port_sig_dstData = getWBdata(DP_S5_data_aluResult_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S5_data_pc_s5_at_t,CUtoDP_port_sig_regFileWriteDataSel_s5_at_t);
	at t+1: DPtoRF_port_sig_wrReq = CUtoDP_port_sig_regFileReq_s5_at_t;
	at t+1: nextphase = readRegFileStage;
	at t+1: DPtoRF_port_notify = true;
end property;


property state_97_13 is
dependencies: no_reset;
freeze:
	CUtoDP_port_sig_dmemMask_s4_at_t = CUtoDP_port_sig_dmemMask_s4@t,
	CUtoDP_port_sig_dmemReq_s4_at_t = CUtoDP_port_sig_dmemReq_s4@t,
	CUtoDP_port_sig_loadedData_at_t = CUtoDP_port_sig_loadedData@t,
	CUtoDP_port_sig_regFileReq_s2_at_t = CUtoDP_port_sig_regFileReq_s2@t,
	CUtoDP_port_sig_regFileReq_s5_at_t = CUtoDP_port_sig_regFileReq_s5@t,
	CUtoDP_port_sig_regFileWriteDataSel_s5_at_t = CUtoDP_port_sig_regFileWriteDataSel_s5@t,
	CUtoDP_port_sig_regRs1Addr_s2_at_t = CUtoDP_port_sig_regRs1Addr_s2@t,
	CUtoDP_port_sig_regRs2Addr_s2_at_t = CUtoDP_port_sig_regRs2Addr_s2@t,
	DP_S3_data_encType_s3_at_t = DP_S3_data_encType_s3@t,
	DP_S3_data_pc_s3_at_t = DP_S3_data_pc_s3@t,
	DP_S3_data_reg1Content_s3_at_t = DP_S3_data_reg1Content_s3@t,
	DP_S3_data_reg2Content_s3_at_t = DP_S3_data_reg2Content_s3@t,
	DP_S3_data_regRdAddr_s3_at_t = DP_S3_data_regRdAddr_s3@t,
	DP_S3_data_regRs1Addr_s3_at_t = DP_S3_data_regRs1Addr_s3@t,
	DP_S3_data_regRs2Addr_s3_at_t = DP_S3_data_regRs2Addr_s3@t,
	DP_S4_data_aluResult_s4_at_t = DP_S4_data_aluResult_s4@t,
	DP_S4_data_encType_s4_at_t = DP_S4_data_encType_s4@t,
	DP_S4_data_fwdPrevLoadedData_at_t = DP_S4_data_fwdPrevLoadedData@t,
	DP_S4_data_pc_s4_at_t = DP_S4_data_pc_s4@t,
	DP_S4_data_prevLoadedData_at_t = DP_S4_data_prevLoadedData@t,
	DP_S4_data_reg2Content_s4_at_t = DP_S4_data_reg2Content_s4@t,
	DP_S4_data_regRdAddr_s4_at_t = DP_S4_data_regRdAddr_s4@t,
	DP_S4_data_regRs2Addr_s4_at_t = DP_S4_data_regRs2Addr_s4@t,
	DP_S5_data_aluResult_s5_at_t = DP_S5_data_aluResult_s5@t,
	DP_S5_data_encType_s5_at_t = DP_S5_data_encType_s5@t,
	DP_S5_data_pc_s5_at_t = DP_S5_data_pc_s5@t,
	DP_S5_data_regRdAddr_s5_at_t = DP_S5_data_regRdAddr_s5@t,
	RFtoDP_port_sig_reg_file_01_at_t = RFtoDP_port_sig_reg_file_01@t,
	RFtoDP_port_sig_reg_file_02_at_t = RFtoDP_port_sig_reg_file_02@t,
	RFtoDP_port_sig_reg_file_03_at_t = RFtoDP_port_sig_reg_file_03@t,
	RFtoDP_port_sig_reg_file_04_at_t = RFtoDP_port_sig_reg_file_04@t,
	RFtoDP_port_sig_reg_file_05_at_t = RFtoDP_port_sig_reg_file_05@t,
	RFtoDP_port_sig_reg_file_06_at_t = RFtoDP_port_sig_reg_file_06@t,
	RFtoDP_port_sig_reg_file_07_at_t = RFtoDP_port_sig_reg_file_07@t,
	RFtoDP_port_sig_reg_file_08_at_t = RFtoDP_port_sig_reg_file_08@t,
	RFtoDP_port_sig_reg_file_09_at_t = RFtoDP_port_sig_reg_file_09@t,
	RFtoDP_port_sig_reg_file_10_at_t = RFtoDP_port_sig_reg_file_10@t,
	RFtoDP_port_sig_reg_file_11_at_t = RFtoDP_port_sig_reg_file_11@t,
	RFtoDP_port_sig_reg_file_12_at_t = RFtoDP_port_sig_reg_file_12@t,
	RFtoDP_port_sig_reg_file_13_at_t = RFtoDP_port_sig_reg_file_13@t,
	RFtoDP_port_sig_reg_file_14_at_t = RFtoDP_port_sig_reg_file_14@t,
	RFtoDP_port_sig_reg_file_15_at_t = RFtoDP_port_sig_reg_file_15@t,
	RFtoDP_port_sig_reg_file_16_at_t = RFtoDP_port_sig_reg_file_16@t,
	RFtoDP_port_sig_reg_file_17_at_t = RFtoDP_port_sig_reg_file_17@t,
	RFtoDP_port_sig_reg_file_18_at_t = RFtoDP_port_sig_reg_file_18@t,
	RFtoDP_port_sig_reg_file_19_at_t = RFtoDP_port_sig_reg_file_19@t,
	RFtoDP_port_sig_reg_file_20_at_t = RFtoDP_port_sig_reg_file_20@t,
	RFtoDP_port_sig_reg_file_21_at_t = RFtoDP_port_sig_reg_file_21@t,
	RFtoDP_port_sig_reg_file_22_at_t = RFtoDP_port_sig_reg_file_22@t,
	RFtoDP_port_sig_reg_file_23_at_t = RFtoDP_port_sig_reg_file_23@t,
	RFtoDP_port_sig_reg_file_24_at_t = RFtoDP_port_sig_reg_file_24@t,
	RFtoDP_port_sig_reg_file_25_at_t = RFtoDP_port_sig_reg_file_25@t,
	RFtoDP_port_sig_reg_file_26_at_t = RFtoDP_port_sig_reg_file_26@t,
	RFtoDP_port_sig_reg_file_27_at_t = RFtoDP_port_sig_reg_file_27@t,
	RFtoDP_port_sig_reg_file_28_at_t = RFtoDP_port_sig_reg_file_28@t,
	RFtoDP_port_sig_reg_file_29_at_t = RFtoDP_port_sig_reg_file_29@t,
	RFtoDP_port_sig_reg_file_30_at_t = RFtoDP_port_sig_reg_file_30@t,
	RFtoDP_port_sig_reg_file_31_at_t = RFtoDP_port_sig_reg_file_31@t;
assume:
	at t: state_97;
	at t: CUtoDP_port_sync;
	at t: (CUtoDP_port_sig_dmemReq_s4 = ME_WR);
	at t: CUtoDP_port_sig_prevDmemAccess;
	at t: (DP_S3_data_encType_s3 = ENC_S);
	at t: (DP_S5_data_encType_s5 = ENC_I_L);
	at t: (DP_S3_data_regRs2Addr_s3 = DP_S5_data_regRdAddr_s5);
	at t: not((DP_S5_data_regRdAddr_s5 = resize(0,32)));
	at t: CUtoDP_port_sig_stallDmemAccess;
prove:
	at t+1: state_97;
	at t+1: DP_S3_data_encType_s3 = DP_S3_data_encType_s3_at_t;
	at t+1: DP_S3_data_pc_s3 = DP_S3_data_pc_s3_at_t;
	at t+1: DP_S3_data_reg1Content_s3 = DP_S3_data_reg1Content_s3_at_t;
	at t+1: DP_S3_data_reg2Content_s3 = DP_S3_data_reg2Content_s3_at_t;
	at t+1: DP_S3_data_regRdAddr_s3 = DP_S3_data_regRdAddr_s3_at_t;
	at t+1: DP_S3_data_regRs1Addr_s3 = DP_S3_data_regRs1Addr_s3_at_t;
	at t+1: DP_S3_data_regRs2Addr_s3 = DP_S3_data_regRs2Addr_s3_at_t;
	at t+1: DP_S4_data_aluResult_s4 = DP_S4_data_aluResult_s4_at_t;
	at t+1: DP_S4_data_encType_s4 = DP_S4_data_encType_s4_at_t;
	at t+1: DP_S4_data_fwdPrevLoadedData = true;
	at t+1: DP_S4_data_pc_s4 = DP_S4_data_pc_s4_at_t;
	at t+1: DP_S4_data_prevLoadedData = CUtoDP_port_sig_loadedData_at_t;
	at t+1: DP_S4_data_reg2Content_s4 = DP_S4_data_reg2Content_s4_at_t;
	at t+1: DP_S4_data_regRdAddr_s4 = DP_S4_data_regRdAddr_s4_at_t;
	at t+1: DP_S4_data_regRs2Addr_s4 = DP_S4_data_regRs2Addr_s4_at_t;
	at t+1: DP_S5_data_aluResult_s5 = DP_S5_data_aluResult_s5_at_t;
	at t+1: DP_S5_data_encType_s5 = DP_S5_data_encType_s5_at_t;
	at t+1: DP_S5_data_pc_s5 = DP_S5_data_pc_s5_at_t;
	at t+1: DP_S5_data_regRdAddr_s5 = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoCU_data_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_data_dataIn = dmemDataInFwdUnit(DP_S5_data_aluResult_s5_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,DP_S4_data_fwdPrevLoadedData_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_prevLoadedData_at_t,DP_S4_data_reg2Content_s4_at_t,DP_S4_data_regRs2Addr_s4_at_t);
	at t+1: DPtoCU_data_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_data_reg1Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DPtoCU_data_reg2Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DPtoCU_data_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoCU_port_sig_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_port_sig_dataIn = dmemDataInFwdUnit(DP_S5_data_aluResult_s5_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,DP_S4_data_fwdPrevLoadedData_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_prevLoadedData_at_t,DP_S4_data_reg2Content_s4_at_t,DP_S4_data_regRs2Addr_s4_at_t);
	at t+1: DPtoCU_port_sig_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_port_sig_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoRF_port_sig_dst = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoRF_port_sig_dstData = getWBdata(DP_S5_data_aluResult_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S5_data_pc_s5_at_t,CUtoDP_port_sig_regFileWriteDataSel_s5_at_t);
	at t+1: DPtoRF_port_sig_wrReq = CUtoDP_port_sig_regFileReq_s5_at_t;
	at t+1: nextphase = readRegFileStage;
	at t+1: DPtoRF_port_notify = true;
end property;


property state_97_15 is
dependencies: no_reset;
freeze:
	CUtoDP_port_sig_dmemMask_s4_at_t = CUtoDP_port_sig_dmemMask_s4@t,
	CUtoDP_port_sig_dmemReq_s4_at_t = CUtoDP_port_sig_dmemReq_s4@t,
	CUtoDP_port_sig_loadedData_at_t = CUtoDP_port_sig_loadedData@t,
	CUtoDP_port_sig_regFileReq_s2_at_t = CUtoDP_port_sig_regFileReq_s2@t,
	CUtoDP_port_sig_regFileReq_s5_at_t = CUtoDP_port_sig_regFileReq_s5@t,
	CUtoDP_port_sig_regFileWriteDataSel_s5_at_t = CUtoDP_port_sig_regFileWriteDataSel_s5@t,
	CUtoDP_port_sig_regRs1Addr_s2_at_t = CUtoDP_port_sig_regRs1Addr_s2@t,
	CUtoDP_port_sig_regRs2Addr_s2_at_t = CUtoDP_port_sig_regRs2Addr_s2@t,
	DP_S3_data_encType_s3_at_t = DP_S3_data_encType_s3@t,
	DP_S3_data_pc_s3_at_t = DP_S3_data_pc_s3@t,
	DP_S3_data_reg1Content_s3_at_t = DP_S3_data_reg1Content_s3@t,
	DP_S3_data_reg2Content_s3_at_t = DP_S3_data_reg2Content_s3@t,
	DP_S3_data_regRdAddr_s3_at_t = DP_S3_data_regRdAddr_s3@t,
	DP_S3_data_regRs1Addr_s3_at_t = DP_S3_data_regRs1Addr_s3@t,
	DP_S3_data_regRs2Addr_s3_at_t = DP_S3_data_regRs2Addr_s3@t,
	DP_S4_data_aluResult_s4_at_t = DP_S4_data_aluResult_s4@t,
	DP_S4_data_encType_s4_at_t = DP_S4_data_encType_s4@t,
	DP_S4_data_fwdPrevLoadedData_at_t = DP_S4_data_fwdPrevLoadedData@t,
	DP_S4_data_pc_s4_at_t = DP_S4_data_pc_s4@t,
	DP_S4_data_prevLoadedData_at_t = DP_S4_data_prevLoadedData@t,
	DP_S4_data_reg2Content_s4_at_t = DP_S4_data_reg2Content_s4@t,
	DP_S4_data_regRdAddr_s4_at_t = DP_S4_data_regRdAddr_s4@t,
	DP_S4_data_regRs2Addr_s4_at_t = DP_S4_data_regRs2Addr_s4@t,
	DP_S5_data_aluResult_s5_at_t = DP_S5_data_aluResult_s5@t,
	DP_S5_data_encType_s5_at_t = DP_S5_data_encType_s5@t,
	DP_S5_data_pc_s5_at_t = DP_S5_data_pc_s5@t,
	DP_S5_data_regRdAddr_s5_at_t = DP_S5_data_regRdAddr_s5@t,
	RFtoDP_port_sig_reg_file_01_at_t = RFtoDP_port_sig_reg_file_01@t,
	RFtoDP_port_sig_reg_file_02_at_t = RFtoDP_port_sig_reg_file_02@t,
	RFtoDP_port_sig_reg_file_03_at_t = RFtoDP_port_sig_reg_file_03@t,
	RFtoDP_port_sig_reg_file_04_at_t = RFtoDP_port_sig_reg_file_04@t,
	RFtoDP_port_sig_reg_file_05_at_t = RFtoDP_port_sig_reg_file_05@t,
	RFtoDP_port_sig_reg_file_06_at_t = RFtoDP_port_sig_reg_file_06@t,
	RFtoDP_port_sig_reg_file_07_at_t = RFtoDP_port_sig_reg_file_07@t,
	RFtoDP_port_sig_reg_file_08_at_t = RFtoDP_port_sig_reg_file_08@t,
	RFtoDP_port_sig_reg_file_09_at_t = RFtoDP_port_sig_reg_file_09@t,
	RFtoDP_port_sig_reg_file_10_at_t = RFtoDP_port_sig_reg_file_10@t,
	RFtoDP_port_sig_reg_file_11_at_t = RFtoDP_port_sig_reg_file_11@t,
	RFtoDP_port_sig_reg_file_12_at_t = RFtoDP_port_sig_reg_file_12@t,
	RFtoDP_port_sig_reg_file_13_at_t = RFtoDP_port_sig_reg_file_13@t,
	RFtoDP_port_sig_reg_file_14_at_t = RFtoDP_port_sig_reg_file_14@t,
	RFtoDP_port_sig_reg_file_15_at_t = RFtoDP_port_sig_reg_file_15@t,
	RFtoDP_port_sig_reg_file_16_at_t = RFtoDP_port_sig_reg_file_16@t,
	RFtoDP_port_sig_reg_file_17_at_t = RFtoDP_port_sig_reg_file_17@t,
	RFtoDP_port_sig_reg_file_18_at_t = RFtoDP_port_sig_reg_file_18@t,
	RFtoDP_port_sig_reg_file_19_at_t = RFtoDP_port_sig_reg_file_19@t,
	RFtoDP_port_sig_reg_file_20_at_t = RFtoDP_port_sig_reg_file_20@t,
	RFtoDP_port_sig_reg_file_21_at_t = RFtoDP_port_sig_reg_file_21@t,
	RFtoDP_port_sig_reg_file_22_at_t = RFtoDP_port_sig_reg_file_22@t,
	RFtoDP_port_sig_reg_file_23_at_t = RFtoDP_port_sig_reg_file_23@t,
	RFtoDP_port_sig_reg_file_24_at_t = RFtoDP_port_sig_reg_file_24@t,
	RFtoDP_port_sig_reg_file_25_at_t = RFtoDP_port_sig_reg_file_25@t,
	RFtoDP_port_sig_reg_file_26_at_t = RFtoDP_port_sig_reg_file_26@t,
	RFtoDP_port_sig_reg_file_27_at_t = RFtoDP_port_sig_reg_file_27@t,
	RFtoDP_port_sig_reg_file_28_at_t = RFtoDP_port_sig_reg_file_28@t,
	RFtoDP_port_sig_reg_file_29_at_t = RFtoDP_port_sig_reg_file_29@t,
	RFtoDP_port_sig_reg_file_30_at_t = RFtoDP_port_sig_reg_file_30@t,
	RFtoDP_port_sig_reg_file_31_at_t = RFtoDP_port_sig_reg_file_31@t;
assume:
	at t: state_97;
	at t: CUtoDP_port_sync;
	at t: (CUtoDP_port_sig_dmemReq_s4 = ME_WR);
	at t: not(((((CUtoDP_port_sig_prevDmemAccess and (DP_S3_data_encType_s3 = ENC_S)) and (DP_S5_data_encType_s5 = ENC_I_L)) and (DP_S3_data_regRs2Addr_s3 = DP_S5_data_regRdAddr_s5)) and not((DP_S5_data_regRdAddr_s5 = resize(0,32)))));
	at t: DP_S4_data_fwdPrevLoadedData;
	at t: CUtoDP_port_sig_stallDmemAccess;
prove:
	at t+1: state_97;
	at t+1: DP_S3_data_encType_s3 = DP_S3_data_encType_s3_at_t;
	at t+1: DP_S3_data_pc_s3 = DP_S3_data_pc_s3_at_t;
	at t+1: DP_S3_data_reg1Content_s3 = DP_S3_data_reg1Content_s3_at_t;
	at t+1: DP_S3_data_reg2Content_s3 = DP_S3_data_reg2Content_s3_at_t;
	at t+1: DP_S3_data_regRdAddr_s3 = DP_S3_data_regRdAddr_s3_at_t;
	at t+1: DP_S3_data_regRs1Addr_s3 = DP_S3_data_regRs1Addr_s3_at_t;
	at t+1: DP_S3_data_regRs2Addr_s3 = DP_S3_data_regRs2Addr_s3_at_t;
	at t+1: DP_S4_data_aluResult_s4 = DP_S4_data_aluResult_s4_at_t;
	at t+1: DP_S4_data_encType_s4 = DP_S4_data_encType_s4_at_t;
	at t+1: DP_S4_data_fwdPrevLoadedData = true;
	at t+1: DP_S4_data_pc_s4 = DP_S4_data_pc_s4_at_t;
	at t+1: DP_S4_data_prevLoadedData = DP_S4_data_prevLoadedData_at_t;
	at t+1: DP_S4_data_reg2Content_s4 = DP_S4_data_reg2Content_s4_at_t;
	at t+1: DP_S4_data_regRdAddr_s4 = DP_S4_data_regRdAddr_s4_at_t;
	at t+1: DP_S4_data_regRs2Addr_s4 = DP_S4_data_regRs2Addr_s4_at_t;
	at t+1: DP_S5_data_aluResult_s5 = DP_S5_data_aluResult_s5_at_t;
	at t+1: DP_S5_data_encType_s5 = DP_S5_data_encType_s5_at_t;
	at t+1: DP_S5_data_pc_s5 = DP_S5_data_pc_s5_at_t;
	at t+1: DP_S5_data_regRdAddr_s5 = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoCU_data_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_data_dataIn = dmemDataInFwdUnit(DP_S5_data_aluResult_s5_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,DP_S4_data_fwdPrevLoadedData_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_prevLoadedData_at_t,DP_S4_data_reg2Content_s4_at_t,DP_S4_data_regRs2Addr_s4_at_t);
	at t+1: DPtoCU_data_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_data_reg1Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DPtoCU_data_reg2Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DPtoCU_data_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoCU_port_sig_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_port_sig_dataIn = dmemDataInFwdUnit(DP_S5_data_aluResult_s5_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,DP_S4_data_fwdPrevLoadedData_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_prevLoadedData_at_t,DP_S4_data_reg2Content_s4_at_t,DP_S4_data_regRs2Addr_s4_at_t);
	at t+1: DPtoCU_port_sig_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_port_sig_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoRF_port_sig_dst = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoRF_port_sig_dstData = getWBdata(DP_S5_data_aluResult_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S5_data_pc_s5_at_t,CUtoDP_port_sig_regFileWriteDataSel_s5_at_t);
	at t+1: DPtoRF_port_sig_wrReq = CUtoDP_port_sig_regFileReq_s5_at_t;
	at t+1: nextphase = readRegFileStage;
	at t+1: DPtoRF_port_notify = true;
end property;


property state_97_17 is
dependencies: no_reset;
freeze:
	CUtoDP_port_sig_aluFunc_s3_at_t = CUtoDP_port_sig_aluFunc_s3@t,
	CUtoDP_port_sig_aluOp1Sel_s3_at_t = CUtoDP_port_sig_aluOp1Sel_s3@t,
	CUtoDP_port_sig_aluOp2Sel_s3_at_t = CUtoDP_port_sig_aluOp2Sel_s3@t,
	CUtoDP_port_sig_dmemMask_s4_at_t = CUtoDP_port_sig_dmemMask_s4@t,
	CUtoDP_port_sig_dmemReq_s4_at_t = CUtoDP_port_sig_dmemReq_s4@t,
	CUtoDP_port_sig_encType_s2_at_t = CUtoDP_port_sig_encType_s2@t,
	CUtoDP_port_sig_imm_s3_at_t = CUtoDP_port_sig_imm_s3@t,
	CUtoDP_port_sig_loadedData_at_t = CUtoDP_port_sig_loadedData@t,
	CUtoDP_port_sig_pc_s2_at_t = CUtoDP_port_sig_pc_s2@t,
	CUtoDP_port_sig_regFileReq_s2_at_t = CUtoDP_port_sig_regFileReq_s2@t,
	CUtoDP_port_sig_regFileReq_s5_at_t = CUtoDP_port_sig_regFileReq_s5@t,
	CUtoDP_port_sig_regFileWriteDataSel_s5_at_t = CUtoDP_port_sig_regFileWriteDataSel_s5@t,
	CUtoDP_port_sig_regRdAddr_s2_at_t = CUtoDP_port_sig_regRdAddr_s2@t,
	CUtoDP_port_sig_regRs1Addr_s2_at_t = CUtoDP_port_sig_regRs1Addr_s2@t,
	CUtoDP_port_sig_regRs2Addr_s2_at_t = CUtoDP_port_sig_regRs2Addr_s2@t,
	DP_S3_data_encType_s3_at_t = DP_S3_data_encType_s3@t,
	DP_S3_data_pc_s3_at_t = DP_S3_data_pc_s3@t,
	DP_S3_data_reg1Content_s3_at_t = DP_S3_data_reg1Content_s3@t,
	DP_S3_data_reg2Content_s3_at_t = DP_S3_data_reg2Content_s3@t,
	DP_S3_data_regRdAddr_s3_at_t = DP_S3_data_regRdAddr_s3@t,
	DP_S3_data_regRs1Addr_s3_at_t = DP_S3_data_regRs1Addr_s3@t,
	DP_S3_data_regRs2Addr_s3_at_t = DP_S3_data_regRs2Addr_s3@t,
	DP_S4_data_aluResult_s4_at_t = DP_S4_data_aluResult_s4@t,
	DP_S4_data_encType_s4_at_t = DP_S4_data_encType_s4@t,
	DP_S4_data_fwdPrevLoadedData_at_t = DP_S4_data_fwdPrevLoadedData@t,
	DP_S4_data_pc_s4_at_t = DP_S4_data_pc_s4@t,
	DP_S4_data_prevLoadedData_at_t = DP_S4_data_prevLoadedData@t,
	DP_S4_data_reg2Content_s4_at_t = DP_S4_data_reg2Content_s4@t,
	DP_S4_data_regRdAddr_s4_at_t = DP_S4_data_regRdAddr_s4@t,
	DP_S4_data_regRs2Addr_s4_at_t = DP_S4_data_regRs2Addr_s4@t,
	DP_S5_data_aluResult_s5_at_t = DP_S5_data_aluResult_s5@t,
	DP_S5_data_encType_s5_at_t = DP_S5_data_encType_s5@t,
	DP_S5_data_pc_s5_at_t = DP_S5_data_pc_s5@t,
	DP_S5_data_regRdAddr_s5_at_t = DP_S5_data_regRdAddr_s5@t,
	RFtoDP_port_sig_reg_file_01_at_t = RFtoDP_port_sig_reg_file_01@t,
	RFtoDP_port_sig_reg_file_02_at_t = RFtoDP_port_sig_reg_file_02@t,
	RFtoDP_port_sig_reg_file_03_at_t = RFtoDP_port_sig_reg_file_03@t,
	RFtoDP_port_sig_reg_file_04_at_t = RFtoDP_port_sig_reg_file_04@t,
	RFtoDP_port_sig_reg_file_05_at_t = RFtoDP_port_sig_reg_file_05@t,
	RFtoDP_port_sig_reg_file_06_at_t = RFtoDP_port_sig_reg_file_06@t,
	RFtoDP_port_sig_reg_file_07_at_t = RFtoDP_port_sig_reg_file_07@t,
	RFtoDP_port_sig_reg_file_08_at_t = RFtoDP_port_sig_reg_file_08@t,
	RFtoDP_port_sig_reg_file_09_at_t = RFtoDP_port_sig_reg_file_09@t,
	RFtoDP_port_sig_reg_file_10_at_t = RFtoDP_port_sig_reg_file_10@t,
	RFtoDP_port_sig_reg_file_11_at_t = RFtoDP_port_sig_reg_file_11@t,
	RFtoDP_port_sig_reg_file_12_at_t = RFtoDP_port_sig_reg_file_12@t,
	RFtoDP_port_sig_reg_file_13_at_t = RFtoDP_port_sig_reg_file_13@t,
	RFtoDP_port_sig_reg_file_14_at_t = RFtoDP_port_sig_reg_file_14@t,
	RFtoDP_port_sig_reg_file_15_at_t = RFtoDP_port_sig_reg_file_15@t,
	RFtoDP_port_sig_reg_file_16_at_t = RFtoDP_port_sig_reg_file_16@t,
	RFtoDP_port_sig_reg_file_17_at_t = RFtoDP_port_sig_reg_file_17@t,
	RFtoDP_port_sig_reg_file_18_at_t = RFtoDP_port_sig_reg_file_18@t,
	RFtoDP_port_sig_reg_file_19_at_t = RFtoDP_port_sig_reg_file_19@t,
	RFtoDP_port_sig_reg_file_20_at_t = RFtoDP_port_sig_reg_file_20@t,
	RFtoDP_port_sig_reg_file_21_at_t = RFtoDP_port_sig_reg_file_21@t,
	RFtoDP_port_sig_reg_file_22_at_t = RFtoDP_port_sig_reg_file_22@t,
	RFtoDP_port_sig_reg_file_23_at_t = RFtoDP_port_sig_reg_file_23@t,
	RFtoDP_port_sig_reg_file_24_at_t = RFtoDP_port_sig_reg_file_24@t,
	RFtoDP_port_sig_reg_file_25_at_t = RFtoDP_port_sig_reg_file_25@t,
	RFtoDP_port_sig_reg_file_26_at_t = RFtoDP_port_sig_reg_file_26@t,
	RFtoDP_port_sig_reg_file_27_at_t = RFtoDP_port_sig_reg_file_27@t,
	RFtoDP_port_sig_reg_file_28_at_t = RFtoDP_port_sig_reg_file_28@t,
	RFtoDP_port_sig_reg_file_29_at_t = RFtoDP_port_sig_reg_file_29@t,
	RFtoDP_port_sig_reg_file_30_at_t = RFtoDP_port_sig_reg_file_30@t,
	RFtoDP_port_sig_reg_file_31_at_t = RFtoDP_port_sig_reg_file_31@t;
assume:
	at t: state_97;
	at t: CUtoDP_port_sync;
	at t: (CUtoDP_port_sig_dmemReq_s4 = ME_WR);
	at t: not(((((CUtoDP_port_sig_prevDmemAccess and (DP_S3_data_encType_s3 = ENC_S)) and (DP_S5_data_encType_s5 = ENC_I_L)) and (DP_S3_data_regRs2Addr_s3 = DP_S5_data_regRdAddr_s5)) and not((DP_S5_data_regRdAddr_s5 = resize(0,32)))));
	at t: not(CUtoDP_port_sig_stallDmemAccess);
prove:
	at t+1: state_97;
	at t+1: DP_S3_data_encType_s3 = CUtoDP_port_sig_encType_s2_at_t;
	at t+1: DP_S3_data_pc_s3 = CUtoDP_port_sig_pc_s2_at_t;
	at t+1: DP_S3_data_reg1Content_s3 = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DP_S3_data_reg2Content_s3 = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DP_S3_data_regRdAddr_s3 = CUtoDP_port_sig_regRdAddr_s2_at_t;
	at t+1: DP_S3_data_regRs1Addr_s3 = CUtoDP_port_sig_regRs1Addr_s2_at_t;
	at t+1: DP_S3_data_regRs2Addr_s3 = CUtoDP_port_sig_regRs2Addr_s2_at_t;
	at t+1: DP_S4_data_aluResult_s4 = getALUresult(CUtoDP_port_sig_aluFunc_s3_at_t,getALUoperand(aluOpFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S3_data_reg1Content_s3_at_t,DP_S3_data_regRs1Addr_s3_at_t),CUtoDP_port_sig_aluOp1Sel_s3_at_t,CUtoDP_port_sig_imm_s3_at_t,DP_S3_data_pc_s3_at_t),getALUoperand(aluOpFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S3_data_reg2Content_s3_at_t,DP_S3_data_regRs2Addr_s3_at_t),CUtoDP_port_sig_aluOp2Sel_s3_at_t,CUtoDP_port_sig_imm_s3_at_t,DP_S3_data_pc_s3_at_t));
	at t+1: DP_S4_data_encType_s4 = DP_S3_data_encType_s3_at_t;
	at t+1: DP_S4_data_fwdPrevLoadedData = false;
	at t+1: DP_S4_data_pc_s4 = DP_S3_data_pc_s3_at_t;
	at t+1: DP_S4_data_prevLoadedData = DP_S4_data_prevLoadedData_at_t;
	at t+1: DP_S4_data_reg2Content_s4 = DP_S3_data_reg2Content_s3_at_t;
	at t+1: DP_S4_data_regRdAddr_s4 = DP_S3_data_regRdAddr_s3_at_t;
	at t+1: DP_S4_data_regRs2Addr_s4 = DP_S3_data_regRs2Addr_s3_at_t;
	at t+1: DP_S5_data_aluResult_s5 = DP_S4_data_aluResult_s4_at_t;
	at t+1: DP_S5_data_encType_s5 = DP_S4_data_encType_s4_at_t;
	at t+1: DP_S5_data_pc_s5 = DP_S4_data_pc_s4_at_t;
	at t+1: DP_S5_data_regRdAddr_s5 = DP_S4_data_regRdAddr_s4_at_t;
	at t+1: DPtoCU_data_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_data_dataIn = dmemDataInFwdUnit(DP_S5_data_aluResult_s5_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,DP_S4_data_fwdPrevLoadedData_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_prevLoadedData_at_t,DP_S4_data_reg2Content_s4_at_t,DP_S4_data_regRs2Addr_s4_at_t);
	at t+1: DPtoCU_data_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_data_reg1Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DPtoCU_data_reg2Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DPtoCU_data_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoCU_port_sig_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_port_sig_dataIn = dmemDataInFwdUnit(DP_S5_data_aluResult_s5_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,DP_S4_data_fwdPrevLoadedData_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_prevLoadedData_at_t,DP_S4_data_reg2Content_s4_at_t,DP_S4_data_regRs2Addr_s4_at_t);
	at t+1: DPtoCU_port_sig_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_port_sig_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoRF_port_sig_dst = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoRF_port_sig_dstData = getWBdata(DP_S5_data_aluResult_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S5_data_pc_s5_at_t,CUtoDP_port_sig_regFileWriteDataSel_s5_at_t);
	at t+1: DPtoRF_port_sig_wrReq = CUtoDP_port_sig_regFileReq_s5_at_t;
	at t+1: nextphase = readRegFileStage;
	at t+1: DPtoRF_port_notify = true;
end property;


property state_97_19 is
dependencies: no_reset;
freeze:
	CUtoDP_port_sig_dmemMask_s4_at_t = CUtoDP_port_sig_dmemMask_s4@t,
	CUtoDP_port_sig_dmemReq_s4_at_t = CUtoDP_port_sig_dmemReq_s4@t,
	CUtoDP_port_sig_loadedData_at_t = CUtoDP_port_sig_loadedData@t,
	CUtoDP_port_sig_regFileReq_s2_at_t = CUtoDP_port_sig_regFileReq_s2@t,
	CUtoDP_port_sig_regFileReq_s5_at_t = CUtoDP_port_sig_regFileReq_s5@t,
	CUtoDP_port_sig_regFileWriteDataSel_s5_at_t = CUtoDP_port_sig_regFileWriteDataSel_s5@t,
	CUtoDP_port_sig_regRs1Addr_s2_at_t = CUtoDP_port_sig_regRs1Addr_s2@t,
	CUtoDP_port_sig_regRs2Addr_s2_at_t = CUtoDP_port_sig_regRs2Addr_s2@t,
	DP_S3_data_encType_s3_at_t = DP_S3_data_encType_s3@t,
	DP_S3_data_pc_s3_at_t = DP_S3_data_pc_s3@t,
	DP_S3_data_reg1Content_s3_at_t = DP_S3_data_reg1Content_s3@t,
	DP_S3_data_reg2Content_s3_at_t = DP_S3_data_reg2Content_s3@t,
	DP_S3_data_regRdAddr_s3_at_t = DP_S3_data_regRdAddr_s3@t,
	DP_S3_data_regRs1Addr_s3_at_t = DP_S3_data_regRs1Addr_s3@t,
	DP_S3_data_regRs2Addr_s3_at_t = DP_S3_data_regRs2Addr_s3@t,
	DP_S4_data_aluResult_s4_at_t = DP_S4_data_aluResult_s4@t,
	DP_S4_data_encType_s4_at_t = DP_S4_data_encType_s4@t,
	DP_S4_data_fwdPrevLoadedData_at_t = DP_S4_data_fwdPrevLoadedData@t,
	DP_S4_data_pc_s4_at_t = DP_S4_data_pc_s4@t,
	DP_S4_data_prevLoadedData_at_t = DP_S4_data_prevLoadedData@t,
	DP_S4_data_reg2Content_s4_at_t = DP_S4_data_reg2Content_s4@t,
	DP_S4_data_regRdAddr_s4_at_t = DP_S4_data_regRdAddr_s4@t,
	DP_S4_data_regRs2Addr_s4_at_t = DP_S4_data_regRs2Addr_s4@t,
	DP_S5_data_aluResult_s5_at_t = DP_S5_data_aluResult_s5@t,
	DP_S5_data_encType_s5_at_t = DP_S5_data_encType_s5@t,
	DP_S5_data_pc_s5_at_t = DP_S5_data_pc_s5@t,
	DP_S5_data_regRdAddr_s5_at_t = DP_S5_data_regRdAddr_s5@t,
	RFtoDP_port_sig_reg_file_01_at_t = RFtoDP_port_sig_reg_file_01@t,
	RFtoDP_port_sig_reg_file_02_at_t = RFtoDP_port_sig_reg_file_02@t,
	RFtoDP_port_sig_reg_file_03_at_t = RFtoDP_port_sig_reg_file_03@t,
	RFtoDP_port_sig_reg_file_04_at_t = RFtoDP_port_sig_reg_file_04@t,
	RFtoDP_port_sig_reg_file_05_at_t = RFtoDP_port_sig_reg_file_05@t,
	RFtoDP_port_sig_reg_file_06_at_t = RFtoDP_port_sig_reg_file_06@t,
	RFtoDP_port_sig_reg_file_07_at_t = RFtoDP_port_sig_reg_file_07@t,
	RFtoDP_port_sig_reg_file_08_at_t = RFtoDP_port_sig_reg_file_08@t,
	RFtoDP_port_sig_reg_file_09_at_t = RFtoDP_port_sig_reg_file_09@t,
	RFtoDP_port_sig_reg_file_10_at_t = RFtoDP_port_sig_reg_file_10@t,
	RFtoDP_port_sig_reg_file_11_at_t = RFtoDP_port_sig_reg_file_11@t,
	RFtoDP_port_sig_reg_file_12_at_t = RFtoDP_port_sig_reg_file_12@t,
	RFtoDP_port_sig_reg_file_13_at_t = RFtoDP_port_sig_reg_file_13@t,
	RFtoDP_port_sig_reg_file_14_at_t = RFtoDP_port_sig_reg_file_14@t,
	RFtoDP_port_sig_reg_file_15_at_t = RFtoDP_port_sig_reg_file_15@t,
	RFtoDP_port_sig_reg_file_16_at_t = RFtoDP_port_sig_reg_file_16@t,
	RFtoDP_port_sig_reg_file_17_at_t = RFtoDP_port_sig_reg_file_17@t,
	RFtoDP_port_sig_reg_file_18_at_t = RFtoDP_port_sig_reg_file_18@t,
	RFtoDP_port_sig_reg_file_19_at_t = RFtoDP_port_sig_reg_file_19@t,
	RFtoDP_port_sig_reg_file_20_at_t = RFtoDP_port_sig_reg_file_20@t,
	RFtoDP_port_sig_reg_file_21_at_t = RFtoDP_port_sig_reg_file_21@t,
	RFtoDP_port_sig_reg_file_22_at_t = RFtoDP_port_sig_reg_file_22@t,
	RFtoDP_port_sig_reg_file_23_at_t = RFtoDP_port_sig_reg_file_23@t,
	RFtoDP_port_sig_reg_file_24_at_t = RFtoDP_port_sig_reg_file_24@t,
	RFtoDP_port_sig_reg_file_25_at_t = RFtoDP_port_sig_reg_file_25@t,
	RFtoDP_port_sig_reg_file_26_at_t = RFtoDP_port_sig_reg_file_26@t,
	RFtoDP_port_sig_reg_file_27_at_t = RFtoDP_port_sig_reg_file_27@t,
	RFtoDP_port_sig_reg_file_28_at_t = RFtoDP_port_sig_reg_file_28@t,
	RFtoDP_port_sig_reg_file_29_at_t = RFtoDP_port_sig_reg_file_29@t,
	RFtoDP_port_sig_reg_file_30_at_t = RFtoDP_port_sig_reg_file_30@t,
	RFtoDP_port_sig_reg_file_31_at_t = RFtoDP_port_sig_reg_file_31@t;
assume:
	at t: state_97;
	at t: CUtoDP_port_sync;
	at t: (CUtoDP_port_sig_dmemReq_s4 = ME_WR);
	at t: not(((((CUtoDP_port_sig_prevDmemAccess and (DP_S3_data_encType_s3 = ENC_S)) and (DP_S5_data_encType_s5 = ENC_I_L)) and (DP_S3_data_regRs2Addr_s3 = DP_S5_data_regRdAddr_s5)) and not((DP_S5_data_regRdAddr_s5 = resize(0,32)))));
	at t: not(DP_S4_data_fwdPrevLoadedData);
	at t: CUtoDP_port_sig_stallDmemAccess;
prove:
	at t+1: state_97;
	at t+1: DP_S3_data_encType_s3 = DP_S3_data_encType_s3_at_t;
	at t+1: DP_S3_data_pc_s3 = DP_S3_data_pc_s3_at_t;
	at t+1: DP_S3_data_reg1Content_s3 = DP_S3_data_reg1Content_s3_at_t;
	at t+1: DP_S3_data_reg2Content_s3 = DP_S3_data_reg2Content_s3_at_t;
	at t+1: DP_S3_data_regRdAddr_s3 = DP_S3_data_regRdAddr_s3_at_t;
	at t+1: DP_S3_data_regRs1Addr_s3 = DP_S3_data_regRs1Addr_s3_at_t;
	at t+1: DP_S3_data_regRs2Addr_s3 = DP_S3_data_regRs2Addr_s3_at_t;
	at t+1: DP_S4_data_aluResult_s4 = DP_S4_data_aluResult_s4_at_t;
	at t+1: DP_S4_data_encType_s4 = DP_S4_data_encType_s4_at_t;
	at t+1: DP_S4_data_fwdPrevLoadedData = false;
	at t+1: DP_S4_data_pc_s4 = DP_S4_data_pc_s4_at_t;
	at t+1: DP_S4_data_prevLoadedData = DP_S4_data_prevLoadedData_at_t;
	at t+1: DP_S4_data_reg2Content_s4 = DP_S4_data_reg2Content_s4_at_t;
	at t+1: DP_S4_data_regRdAddr_s4 = DP_S4_data_regRdAddr_s4_at_t;
	at t+1: DP_S4_data_regRs2Addr_s4 = DP_S4_data_regRs2Addr_s4_at_t;
	at t+1: DP_S5_data_aluResult_s5 = DP_S5_data_aluResult_s5_at_t;
	at t+1: DP_S5_data_encType_s5 = DP_S5_data_encType_s5_at_t;
	at t+1: DP_S5_data_pc_s5 = DP_S5_data_pc_s5_at_t;
	at t+1: DP_S5_data_regRdAddr_s5 = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoCU_data_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_data_dataIn = dmemDataInFwdUnit(DP_S5_data_aluResult_s5_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,DP_S4_data_fwdPrevLoadedData_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_prevLoadedData_at_t,DP_S4_data_reg2Content_s4_at_t,DP_S4_data_regRs2Addr_s4_at_t);
	at t+1: DPtoCU_data_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_data_reg1Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DPtoCU_data_reg2Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DPtoCU_data_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoCU_port_sig_addrIn = DP_S4_data_aluResult_s4_at_t;
	at t+1: DPtoCU_port_sig_dataIn = dmemDataInFwdUnit(DP_S5_data_aluResult_s5_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,DP_S4_data_fwdPrevLoadedData_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_prevLoadedData_at_t,DP_S4_data_reg2Content_s4_at_t,DP_S4_data_regRs2Addr_s4_at_t);
	at t+1: DPtoCU_port_sig_mask = CUtoDP_port_sig_dmemMask_s4_at_t;
	at t+1: DPtoCU_port_sig_req = CUtoDP_port_sig_dmemReq_s4_at_t;
	at t+1: DPtoRF_port_sig_dst = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoRF_port_sig_dstData = getWBdata(DP_S5_data_aluResult_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S5_data_pc_s5_at_t,CUtoDP_port_sig_regFileWriteDataSel_s5_at_t);
	at t+1: DPtoRF_port_sig_wrReq = CUtoDP_port_sig_regFileReq_s5_at_t;
	at t+1: nextphase = readRegFileStage;
	at t+1: DPtoRF_port_notify = true;
end property;


property state_97_21 is
dependencies: no_reset;
freeze:
	CUtoDP_port_sig_aluFunc_s3_at_t = CUtoDP_port_sig_aluFunc_s3@t,
	CUtoDP_port_sig_aluOp1Sel_s3_at_t = CUtoDP_port_sig_aluOp1Sel_s3@t,
	CUtoDP_port_sig_aluOp2Sel_s3_at_t = CUtoDP_port_sig_aluOp2Sel_s3@t,
	CUtoDP_port_sig_encType_s2_at_t = CUtoDP_port_sig_encType_s2@t,
	CUtoDP_port_sig_imm_s3_at_t = CUtoDP_port_sig_imm_s3@t,
	CUtoDP_port_sig_loadedData_at_t = CUtoDP_port_sig_loadedData@t,
	CUtoDP_port_sig_pc_s2_at_t = CUtoDP_port_sig_pc_s2@t,
	CUtoDP_port_sig_regFileReq_s2_at_t = CUtoDP_port_sig_regFileReq_s2@t,
	CUtoDP_port_sig_regFileReq_s5_at_t = CUtoDP_port_sig_regFileReq_s5@t,
	CUtoDP_port_sig_regFileWriteDataSel_s5_at_t = CUtoDP_port_sig_regFileWriteDataSel_s5@t,
	CUtoDP_port_sig_regRdAddr_s2_at_t = CUtoDP_port_sig_regRdAddr_s2@t,
	CUtoDP_port_sig_regRs1Addr_s2_at_t = CUtoDP_port_sig_regRs1Addr_s2@t,
	CUtoDP_port_sig_regRs2Addr_s2_at_t = CUtoDP_port_sig_regRs2Addr_s2@t,
	DP_S3_data_encType_s3_at_t = DP_S3_data_encType_s3@t,
	DP_S3_data_pc_s3_at_t = DP_S3_data_pc_s3@t,
	DP_S3_data_reg1Content_s3_at_t = DP_S3_data_reg1Content_s3@t,
	DP_S3_data_reg2Content_s3_at_t = DP_S3_data_reg2Content_s3@t,
	DP_S3_data_regRdAddr_s3_at_t = DP_S3_data_regRdAddr_s3@t,
	DP_S3_data_regRs1Addr_s3_at_t = DP_S3_data_regRs1Addr_s3@t,
	DP_S3_data_regRs2Addr_s3_at_t = DP_S3_data_regRs2Addr_s3@t,
	DP_S4_data_aluResult_s4_at_t = DP_S4_data_aluResult_s4@t,
	DP_S4_data_encType_s4_at_t = DP_S4_data_encType_s4@t,
	DP_S4_data_pc_s4_at_t = DP_S4_data_pc_s4@t,
	DP_S4_data_regRdAddr_s4_at_t = DP_S4_data_regRdAddr_s4@t,
	DP_S5_data_aluResult_s5_at_t = DP_S5_data_aluResult_s5@t,
	DP_S5_data_encType_s5_at_t = DP_S5_data_encType_s5@t,
	DP_S5_data_pc_s5_at_t = DP_S5_data_pc_s5@t,
	DP_S5_data_regRdAddr_s5_at_t = DP_S5_data_regRdAddr_s5@t,
	RFtoDP_port_sig_reg_file_01_at_t = RFtoDP_port_sig_reg_file_01@t,
	RFtoDP_port_sig_reg_file_02_at_t = RFtoDP_port_sig_reg_file_02@t,
	RFtoDP_port_sig_reg_file_03_at_t = RFtoDP_port_sig_reg_file_03@t,
	RFtoDP_port_sig_reg_file_04_at_t = RFtoDP_port_sig_reg_file_04@t,
	RFtoDP_port_sig_reg_file_05_at_t = RFtoDP_port_sig_reg_file_05@t,
	RFtoDP_port_sig_reg_file_06_at_t = RFtoDP_port_sig_reg_file_06@t,
	RFtoDP_port_sig_reg_file_07_at_t = RFtoDP_port_sig_reg_file_07@t,
	RFtoDP_port_sig_reg_file_08_at_t = RFtoDP_port_sig_reg_file_08@t,
	RFtoDP_port_sig_reg_file_09_at_t = RFtoDP_port_sig_reg_file_09@t,
	RFtoDP_port_sig_reg_file_10_at_t = RFtoDP_port_sig_reg_file_10@t,
	RFtoDP_port_sig_reg_file_11_at_t = RFtoDP_port_sig_reg_file_11@t,
	RFtoDP_port_sig_reg_file_12_at_t = RFtoDP_port_sig_reg_file_12@t,
	RFtoDP_port_sig_reg_file_13_at_t = RFtoDP_port_sig_reg_file_13@t,
	RFtoDP_port_sig_reg_file_14_at_t = RFtoDP_port_sig_reg_file_14@t,
	RFtoDP_port_sig_reg_file_15_at_t = RFtoDP_port_sig_reg_file_15@t,
	RFtoDP_port_sig_reg_file_16_at_t = RFtoDP_port_sig_reg_file_16@t,
	RFtoDP_port_sig_reg_file_17_at_t = RFtoDP_port_sig_reg_file_17@t,
	RFtoDP_port_sig_reg_file_18_at_t = RFtoDP_port_sig_reg_file_18@t,
	RFtoDP_port_sig_reg_file_19_at_t = RFtoDP_port_sig_reg_file_19@t,
	RFtoDP_port_sig_reg_file_20_at_t = RFtoDP_port_sig_reg_file_20@t,
	RFtoDP_port_sig_reg_file_21_at_t = RFtoDP_port_sig_reg_file_21@t,
	RFtoDP_port_sig_reg_file_22_at_t = RFtoDP_port_sig_reg_file_22@t,
	RFtoDP_port_sig_reg_file_23_at_t = RFtoDP_port_sig_reg_file_23@t,
	RFtoDP_port_sig_reg_file_24_at_t = RFtoDP_port_sig_reg_file_24@t,
	RFtoDP_port_sig_reg_file_25_at_t = RFtoDP_port_sig_reg_file_25@t,
	RFtoDP_port_sig_reg_file_26_at_t = RFtoDP_port_sig_reg_file_26@t,
	RFtoDP_port_sig_reg_file_27_at_t = RFtoDP_port_sig_reg_file_27@t,
	RFtoDP_port_sig_reg_file_28_at_t = RFtoDP_port_sig_reg_file_28@t,
	RFtoDP_port_sig_reg_file_29_at_t = RFtoDP_port_sig_reg_file_29@t,
	RFtoDP_port_sig_reg_file_30_at_t = RFtoDP_port_sig_reg_file_30@t,
	RFtoDP_port_sig_reg_file_31_at_t = RFtoDP_port_sig_reg_file_31@t;
assume:
	at t: state_97;
	at t: CUtoDP_port_sync;
	at t: not((CUtoDP_port_sig_dmemReq_s4 = ME_RD));
	at t: not((CUtoDP_port_sig_dmemReq_s4 = ME_WR));
	at t: CUtoDP_port_sig_prevDmemAccess;
	at t: (DP_S3_data_encType_s3 = ENC_S);
	at t: (DP_S5_data_encType_s5 = ENC_I_L);
	at t: (DP_S3_data_regRs2Addr_s3 = DP_S5_data_regRdAddr_s5);
	at t: not((DP_S5_data_regRdAddr_s5 = resize(0,32)));
	at t: not(CUtoDP_port_sig_stallDmemAccess);
prove:
	at t+1: state_97;
	at t+1: DP_S3_data_encType_s3 = CUtoDP_port_sig_encType_s2_at_t;
	at t+1: DP_S3_data_pc_s3 = CUtoDP_port_sig_pc_s2_at_t;
	at t+1: DP_S3_data_reg1Content_s3 = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DP_S3_data_reg2Content_s3 = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DP_S3_data_regRdAddr_s3 = CUtoDP_port_sig_regRdAddr_s2_at_t;
	at t+1: DP_S3_data_regRs1Addr_s3 = CUtoDP_port_sig_regRs1Addr_s2_at_t;
	at t+1: DP_S3_data_regRs2Addr_s3 = CUtoDP_port_sig_regRs2Addr_s2_at_t;
	at t+1: DP_S4_data_aluResult_s4 = getALUresult(CUtoDP_port_sig_aluFunc_s3_at_t,getALUoperand(aluOpFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S3_data_reg1Content_s3_at_t,DP_S3_data_regRs1Addr_s3_at_t),CUtoDP_port_sig_aluOp1Sel_s3_at_t,CUtoDP_port_sig_imm_s3_at_t,DP_S3_data_pc_s3_at_t),getALUoperand(aluOpFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S3_data_reg2Content_s3_at_t,DP_S3_data_regRs2Addr_s3_at_t),CUtoDP_port_sig_aluOp2Sel_s3_at_t,CUtoDP_port_sig_imm_s3_at_t,DP_S3_data_pc_s3_at_t));
	at t+1: DP_S4_data_encType_s4 = DP_S3_data_encType_s3_at_t;
	at t+1: DP_S4_data_fwdPrevLoadedData = true;
	at t+1: DP_S4_data_pc_s4 = DP_S3_data_pc_s3_at_t;
	at t+1: DP_S4_data_prevLoadedData = CUtoDP_port_sig_loadedData_at_t;
	at t+1: DP_S4_data_reg2Content_s4 = DP_S3_data_reg2Content_s3_at_t;
	at t+1: DP_S4_data_regRdAddr_s4 = DP_S3_data_regRdAddr_s3_at_t;
	at t+1: DP_S4_data_regRs2Addr_s4 = DP_S3_data_regRs2Addr_s3_at_t;
	at t+1: DP_S5_data_aluResult_s5 = DP_S4_data_aluResult_s4_at_t;
	at t+1: DP_S5_data_encType_s5 = DP_S4_data_encType_s4_at_t;
	at t+1: DP_S5_data_pc_s5 = DP_S4_data_pc_s4_at_t;
	at t+1: DP_S5_data_regRdAddr_s5 = DP_S4_data_regRdAddr_s4_at_t;
	at t+1: DPtoCU_data_addrIn = 0;
	at t+1: DPtoCU_data_dataIn = 0;
	at t+1: DPtoCU_data_mask = MT_X;
	at t+1: DPtoCU_data_reg1Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DPtoCU_data_reg2Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DPtoCU_data_req = ME_X;
	at t+1: DPtoCU_port_sig_addrIn = 0;
	at t+1: DPtoCU_port_sig_dataIn = 0;
	at t+1: DPtoCU_port_sig_mask = MT_X;
	at t+1: DPtoCU_port_sig_req = ME_X;
	at t+1: DPtoRF_port_sig_dst = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoRF_port_sig_dstData = getWBdata(DP_S5_data_aluResult_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S5_data_pc_s5_at_t,CUtoDP_port_sig_regFileWriteDataSel_s5_at_t);
	at t+1: DPtoRF_port_sig_wrReq = CUtoDP_port_sig_regFileReq_s5_at_t;
	at t+1: nextphase = readRegFileStage;
	at t+1: DPtoRF_port_notify = true;
end property;


property state_97_23 is
dependencies: no_reset;
freeze:
	CUtoDP_port_sig_loadedData_at_t = CUtoDP_port_sig_loadedData@t,
	CUtoDP_port_sig_regFileReq_s2_at_t = CUtoDP_port_sig_regFileReq_s2@t,
	CUtoDP_port_sig_regFileReq_s5_at_t = CUtoDP_port_sig_regFileReq_s5@t,
	CUtoDP_port_sig_regFileWriteDataSel_s5_at_t = CUtoDP_port_sig_regFileWriteDataSel_s5@t,
	CUtoDP_port_sig_regRs1Addr_s2_at_t = CUtoDP_port_sig_regRs1Addr_s2@t,
	CUtoDP_port_sig_regRs2Addr_s2_at_t = CUtoDP_port_sig_regRs2Addr_s2@t,
	DP_S3_data_encType_s3_at_t = DP_S3_data_encType_s3@t,
	DP_S3_data_pc_s3_at_t = DP_S3_data_pc_s3@t,
	DP_S3_data_reg1Content_s3_at_t = DP_S3_data_reg1Content_s3@t,
	DP_S3_data_reg2Content_s3_at_t = DP_S3_data_reg2Content_s3@t,
	DP_S3_data_regRdAddr_s3_at_t = DP_S3_data_regRdAddr_s3@t,
	DP_S3_data_regRs1Addr_s3_at_t = DP_S3_data_regRs1Addr_s3@t,
	DP_S3_data_regRs2Addr_s3_at_t = DP_S3_data_regRs2Addr_s3@t,
	DP_S4_data_aluResult_s4_at_t = DP_S4_data_aluResult_s4@t,
	DP_S4_data_encType_s4_at_t = DP_S4_data_encType_s4@t,
	DP_S4_data_pc_s4_at_t = DP_S4_data_pc_s4@t,
	DP_S4_data_reg2Content_s4_at_t = DP_S4_data_reg2Content_s4@t,
	DP_S4_data_regRdAddr_s4_at_t = DP_S4_data_regRdAddr_s4@t,
	DP_S4_data_regRs2Addr_s4_at_t = DP_S4_data_regRs2Addr_s4@t,
	DP_S5_data_aluResult_s5_at_t = DP_S5_data_aluResult_s5@t,
	DP_S5_data_encType_s5_at_t = DP_S5_data_encType_s5@t,
	DP_S5_data_pc_s5_at_t = DP_S5_data_pc_s5@t,
	DP_S5_data_regRdAddr_s5_at_t = DP_S5_data_regRdAddr_s5@t,
	RFtoDP_port_sig_reg_file_01_at_t = RFtoDP_port_sig_reg_file_01@t,
	RFtoDP_port_sig_reg_file_02_at_t = RFtoDP_port_sig_reg_file_02@t,
	RFtoDP_port_sig_reg_file_03_at_t = RFtoDP_port_sig_reg_file_03@t,
	RFtoDP_port_sig_reg_file_04_at_t = RFtoDP_port_sig_reg_file_04@t,
	RFtoDP_port_sig_reg_file_05_at_t = RFtoDP_port_sig_reg_file_05@t,
	RFtoDP_port_sig_reg_file_06_at_t = RFtoDP_port_sig_reg_file_06@t,
	RFtoDP_port_sig_reg_file_07_at_t = RFtoDP_port_sig_reg_file_07@t,
	RFtoDP_port_sig_reg_file_08_at_t = RFtoDP_port_sig_reg_file_08@t,
	RFtoDP_port_sig_reg_file_09_at_t = RFtoDP_port_sig_reg_file_09@t,
	RFtoDP_port_sig_reg_file_10_at_t = RFtoDP_port_sig_reg_file_10@t,
	RFtoDP_port_sig_reg_file_11_at_t = RFtoDP_port_sig_reg_file_11@t,
	RFtoDP_port_sig_reg_file_12_at_t = RFtoDP_port_sig_reg_file_12@t,
	RFtoDP_port_sig_reg_file_13_at_t = RFtoDP_port_sig_reg_file_13@t,
	RFtoDP_port_sig_reg_file_14_at_t = RFtoDP_port_sig_reg_file_14@t,
	RFtoDP_port_sig_reg_file_15_at_t = RFtoDP_port_sig_reg_file_15@t,
	RFtoDP_port_sig_reg_file_16_at_t = RFtoDP_port_sig_reg_file_16@t,
	RFtoDP_port_sig_reg_file_17_at_t = RFtoDP_port_sig_reg_file_17@t,
	RFtoDP_port_sig_reg_file_18_at_t = RFtoDP_port_sig_reg_file_18@t,
	RFtoDP_port_sig_reg_file_19_at_t = RFtoDP_port_sig_reg_file_19@t,
	RFtoDP_port_sig_reg_file_20_at_t = RFtoDP_port_sig_reg_file_20@t,
	RFtoDP_port_sig_reg_file_21_at_t = RFtoDP_port_sig_reg_file_21@t,
	RFtoDP_port_sig_reg_file_22_at_t = RFtoDP_port_sig_reg_file_22@t,
	RFtoDP_port_sig_reg_file_23_at_t = RFtoDP_port_sig_reg_file_23@t,
	RFtoDP_port_sig_reg_file_24_at_t = RFtoDP_port_sig_reg_file_24@t,
	RFtoDP_port_sig_reg_file_25_at_t = RFtoDP_port_sig_reg_file_25@t,
	RFtoDP_port_sig_reg_file_26_at_t = RFtoDP_port_sig_reg_file_26@t,
	RFtoDP_port_sig_reg_file_27_at_t = RFtoDP_port_sig_reg_file_27@t,
	RFtoDP_port_sig_reg_file_28_at_t = RFtoDP_port_sig_reg_file_28@t,
	RFtoDP_port_sig_reg_file_29_at_t = RFtoDP_port_sig_reg_file_29@t,
	RFtoDP_port_sig_reg_file_30_at_t = RFtoDP_port_sig_reg_file_30@t,
	RFtoDP_port_sig_reg_file_31_at_t = RFtoDP_port_sig_reg_file_31@t;
assume:
	at t: state_97;
	at t: CUtoDP_port_sync;
	at t: not((CUtoDP_port_sig_dmemReq_s4 = ME_RD));
	at t: not((CUtoDP_port_sig_dmemReq_s4 = ME_WR));
	at t: CUtoDP_port_sig_prevDmemAccess;
	at t: (DP_S3_data_encType_s3 = ENC_S);
	at t: (DP_S5_data_encType_s5 = ENC_I_L);
	at t: (DP_S3_data_regRs2Addr_s3 = DP_S5_data_regRdAddr_s5);
	at t: not((DP_S5_data_regRdAddr_s5 = resize(0,32)));
	at t: CUtoDP_port_sig_stallDmemAccess;
prove:
	at t+1: state_97;
	at t+1: DP_S3_data_encType_s3 = DP_S3_data_encType_s3_at_t;
	at t+1: DP_S3_data_pc_s3 = DP_S3_data_pc_s3_at_t;
	at t+1: DP_S3_data_reg1Content_s3 = DP_S3_data_reg1Content_s3_at_t;
	at t+1: DP_S3_data_reg2Content_s3 = DP_S3_data_reg2Content_s3_at_t;
	at t+1: DP_S3_data_regRdAddr_s3 = DP_S3_data_regRdAddr_s3_at_t;
	at t+1: DP_S3_data_regRs1Addr_s3 = DP_S3_data_regRs1Addr_s3_at_t;
	at t+1: DP_S3_data_regRs2Addr_s3 = DP_S3_data_regRs2Addr_s3_at_t;
	at t+1: DP_S4_data_aluResult_s4 = DP_S4_data_aluResult_s4_at_t;
	at t+1: DP_S4_data_encType_s4 = DP_S4_data_encType_s4_at_t;
	at t+1: DP_S4_data_fwdPrevLoadedData = true;
	at t+1: DP_S4_data_pc_s4 = DP_S4_data_pc_s4_at_t;
	at t+1: DP_S4_data_prevLoadedData = CUtoDP_port_sig_loadedData_at_t;
	at t+1: DP_S4_data_reg2Content_s4 = DP_S4_data_reg2Content_s4_at_t;
	at t+1: DP_S4_data_regRdAddr_s4 = DP_S4_data_regRdAddr_s4_at_t;
	at t+1: DP_S4_data_regRs2Addr_s4 = DP_S4_data_regRs2Addr_s4_at_t;
	at t+1: DP_S5_data_aluResult_s5 = DP_S5_data_aluResult_s5_at_t;
	at t+1: DP_S5_data_encType_s5 = DP_S5_data_encType_s5_at_t;
	at t+1: DP_S5_data_pc_s5 = DP_S5_data_pc_s5_at_t;
	at t+1: DP_S5_data_regRdAddr_s5 = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoCU_data_addrIn = 0;
	at t+1: DPtoCU_data_dataIn = 0;
	at t+1: DPtoCU_data_mask = MT_X;
	at t+1: DPtoCU_data_reg1Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DPtoCU_data_reg2Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DPtoCU_data_req = ME_X;
	at t+1: DPtoCU_port_sig_addrIn = 0;
	at t+1: DPtoCU_port_sig_dataIn = 0;
	at t+1: DPtoCU_port_sig_mask = MT_X;
	at t+1: DPtoCU_port_sig_req = ME_X;
	at t+1: DPtoRF_port_sig_dst = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoRF_port_sig_dstData = getWBdata(DP_S5_data_aluResult_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S5_data_pc_s5_at_t,CUtoDP_port_sig_regFileWriteDataSel_s5_at_t);
	at t+1: DPtoRF_port_sig_wrReq = CUtoDP_port_sig_regFileReq_s5_at_t;
	at t+1: nextphase = readRegFileStage;
	at t+1: DPtoRF_port_notify = true;
end property;


property state_97_25 is
dependencies: no_reset;
freeze:
	CUtoDP_port_sig_loadedData_at_t = CUtoDP_port_sig_loadedData@t,
	CUtoDP_port_sig_regFileReq_s2_at_t = CUtoDP_port_sig_regFileReq_s2@t,
	CUtoDP_port_sig_regFileReq_s5_at_t = CUtoDP_port_sig_regFileReq_s5@t,
	CUtoDP_port_sig_regFileWriteDataSel_s5_at_t = CUtoDP_port_sig_regFileWriteDataSel_s5@t,
	CUtoDP_port_sig_regRs1Addr_s2_at_t = CUtoDP_port_sig_regRs1Addr_s2@t,
	CUtoDP_port_sig_regRs2Addr_s2_at_t = CUtoDP_port_sig_regRs2Addr_s2@t,
	DP_S3_data_encType_s3_at_t = DP_S3_data_encType_s3@t,
	DP_S3_data_pc_s3_at_t = DP_S3_data_pc_s3@t,
	DP_S3_data_reg1Content_s3_at_t = DP_S3_data_reg1Content_s3@t,
	DP_S3_data_reg2Content_s3_at_t = DP_S3_data_reg2Content_s3@t,
	DP_S3_data_regRdAddr_s3_at_t = DP_S3_data_regRdAddr_s3@t,
	DP_S3_data_regRs1Addr_s3_at_t = DP_S3_data_regRs1Addr_s3@t,
	DP_S3_data_regRs2Addr_s3_at_t = DP_S3_data_regRs2Addr_s3@t,
	DP_S4_data_aluResult_s4_at_t = DP_S4_data_aluResult_s4@t,
	DP_S4_data_encType_s4_at_t = DP_S4_data_encType_s4@t,
	DP_S4_data_pc_s4_at_t = DP_S4_data_pc_s4@t,
	DP_S4_data_prevLoadedData_at_t = DP_S4_data_prevLoadedData@t,
	DP_S4_data_reg2Content_s4_at_t = DP_S4_data_reg2Content_s4@t,
	DP_S4_data_regRdAddr_s4_at_t = DP_S4_data_regRdAddr_s4@t,
	DP_S4_data_regRs2Addr_s4_at_t = DP_S4_data_regRs2Addr_s4@t,
	DP_S5_data_aluResult_s5_at_t = DP_S5_data_aluResult_s5@t,
	DP_S5_data_encType_s5_at_t = DP_S5_data_encType_s5@t,
	DP_S5_data_pc_s5_at_t = DP_S5_data_pc_s5@t,
	DP_S5_data_regRdAddr_s5_at_t = DP_S5_data_regRdAddr_s5@t,
	RFtoDP_port_sig_reg_file_01_at_t = RFtoDP_port_sig_reg_file_01@t,
	RFtoDP_port_sig_reg_file_02_at_t = RFtoDP_port_sig_reg_file_02@t,
	RFtoDP_port_sig_reg_file_03_at_t = RFtoDP_port_sig_reg_file_03@t,
	RFtoDP_port_sig_reg_file_04_at_t = RFtoDP_port_sig_reg_file_04@t,
	RFtoDP_port_sig_reg_file_05_at_t = RFtoDP_port_sig_reg_file_05@t,
	RFtoDP_port_sig_reg_file_06_at_t = RFtoDP_port_sig_reg_file_06@t,
	RFtoDP_port_sig_reg_file_07_at_t = RFtoDP_port_sig_reg_file_07@t,
	RFtoDP_port_sig_reg_file_08_at_t = RFtoDP_port_sig_reg_file_08@t,
	RFtoDP_port_sig_reg_file_09_at_t = RFtoDP_port_sig_reg_file_09@t,
	RFtoDP_port_sig_reg_file_10_at_t = RFtoDP_port_sig_reg_file_10@t,
	RFtoDP_port_sig_reg_file_11_at_t = RFtoDP_port_sig_reg_file_11@t,
	RFtoDP_port_sig_reg_file_12_at_t = RFtoDP_port_sig_reg_file_12@t,
	RFtoDP_port_sig_reg_file_13_at_t = RFtoDP_port_sig_reg_file_13@t,
	RFtoDP_port_sig_reg_file_14_at_t = RFtoDP_port_sig_reg_file_14@t,
	RFtoDP_port_sig_reg_file_15_at_t = RFtoDP_port_sig_reg_file_15@t,
	RFtoDP_port_sig_reg_file_16_at_t = RFtoDP_port_sig_reg_file_16@t,
	RFtoDP_port_sig_reg_file_17_at_t = RFtoDP_port_sig_reg_file_17@t,
	RFtoDP_port_sig_reg_file_18_at_t = RFtoDP_port_sig_reg_file_18@t,
	RFtoDP_port_sig_reg_file_19_at_t = RFtoDP_port_sig_reg_file_19@t,
	RFtoDP_port_sig_reg_file_20_at_t = RFtoDP_port_sig_reg_file_20@t,
	RFtoDP_port_sig_reg_file_21_at_t = RFtoDP_port_sig_reg_file_21@t,
	RFtoDP_port_sig_reg_file_22_at_t = RFtoDP_port_sig_reg_file_22@t,
	RFtoDP_port_sig_reg_file_23_at_t = RFtoDP_port_sig_reg_file_23@t,
	RFtoDP_port_sig_reg_file_24_at_t = RFtoDP_port_sig_reg_file_24@t,
	RFtoDP_port_sig_reg_file_25_at_t = RFtoDP_port_sig_reg_file_25@t,
	RFtoDP_port_sig_reg_file_26_at_t = RFtoDP_port_sig_reg_file_26@t,
	RFtoDP_port_sig_reg_file_27_at_t = RFtoDP_port_sig_reg_file_27@t,
	RFtoDP_port_sig_reg_file_28_at_t = RFtoDP_port_sig_reg_file_28@t,
	RFtoDP_port_sig_reg_file_29_at_t = RFtoDP_port_sig_reg_file_29@t,
	RFtoDP_port_sig_reg_file_30_at_t = RFtoDP_port_sig_reg_file_30@t,
	RFtoDP_port_sig_reg_file_31_at_t = RFtoDP_port_sig_reg_file_31@t;
assume:
	at t: state_97;
	at t: CUtoDP_port_sync;
	at t: not((CUtoDP_port_sig_dmemReq_s4 = ME_RD));
	at t: not((CUtoDP_port_sig_dmemReq_s4 = ME_WR));
	at t: not(((((CUtoDP_port_sig_prevDmemAccess and (DP_S3_data_encType_s3 = ENC_S)) and (DP_S5_data_encType_s5 = ENC_I_L)) and (DP_S3_data_regRs2Addr_s3 = DP_S5_data_regRdAddr_s5)) and not((DP_S5_data_regRdAddr_s5 = resize(0,32)))));
	at t: DP_S4_data_fwdPrevLoadedData;
	at t: CUtoDP_port_sig_stallDmemAccess;
prove:
	at t+1: state_97;
	at t+1: DP_S3_data_encType_s3 = DP_S3_data_encType_s3_at_t;
	at t+1: DP_S3_data_pc_s3 = DP_S3_data_pc_s3_at_t;
	at t+1: DP_S3_data_reg1Content_s3 = DP_S3_data_reg1Content_s3_at_t;
	at t+1: DP_S3_data_reg2Content_s3 = DP_S3_data_reg2Content_s3_at_t;
	at t+1: DP_S3_data_regRdAddr_s3 = DP_S3_data_regRdAddr_s3_at_t;
	at t+1: DP_S3_data_regRs1Addr_s3 = DP_S3_data_regRs1Addr_s3_at_t;
	at t+1: DP_S3_data_regRs2Addr_s3 = DP_S3_data_regRs2Addr_s3_at_t;
	at t+1: DP_S4_data_aluResult_s4 = DP_S4_data_aluResult_s4_at_t;
	at t+1: DP_S4_data_encType_s4 = DP_S4_data_encType_s4_at_t;
	at t+1: DP_S4_data_fwdPrevLoadedData = true;
	at t+1: DP_S4_data_pc_s4 = DP_S4_data_pc_s4_at_t;
	at t+1: DP_S4_data_prevLoadedData = DP_S4_data_prevLoadedData_at_t;
	at t+1: DP_S4_data_reg2Content_s4 = DP_S4_data_reg2Content_s4_at_t;
	at t+1: DP_S4_data_regRdAddr_s4 = DP_S4_data_regRdAddr_s4_at_t;
	at t+1: DP_S4_data_regRs2Addr_s4 = DP_S4_data_regRs2Addr_s4_at_t;
	at t+1: DP_S5_data_aluResult_s5 = DP_S5_data_aluResult_s5_at_t;
	at t+1: DP_S5_data_encType_s5 = DP_S5_data_encType_s5_at_t;
	at t+1: DP_S5_data_pc_s5 = DP_S5_data_pc_s5_at_t;
	at t+1: DP_S5_data_regRdAddr_s5 = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoCU_data_addrIn = 0;
	at t+1: DPtoCU_data_dataIn = 0;
	at t+1: DPtoCU_data_mask = MT_X;
	at t+1: DPtoCU_data_reg1Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DPtoCU_data_reg2Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DPtoCU_data_req = ME_X;
	at t+1: DPtoCU_port_sig_addrIn = 0;
	at t+1: DPtoCU_port_sig_dataIn = 0;
	at t+1: DPtoCU_port_sig_mask = MT_X;
	at t+1: DPtoCU_port_sig_req = ME_X;
	at t+1: DPtoRF_port_sig_dst = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoRF_port_sig_dstData = getWBdata(DP_S5_data_aluResult_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S5_data_pc_s5_at_t,CUtoDP_port_sig_regFileWriteDataSel_s5_at_t);
	at t+1: DPtoRF_port_sig_wrReq = CUtoDP_port_sig_regFileReq_s5_at_t;
	at t+1: nextphase = readRegFileStage;
	at t+1: DPtoRF_port_notify = true;
end property;


property state_97_27 is
dependencies: no_reset;
freeze:
	CUtoDP_port_sig_aluFunc_s3_at_t = CUtoDP_port_sig_aluFunc_s3@t,
	CUtoDP_port_sig_aluOp1Sel_s3_at_t = CUtoDP_port_sig_aluOp1Sel_s3@t,
	CUtoDP_port_sig_aluOp2Sel_s3_at_t = CUtoDP_port_sig_aluOp2Sel_s3@t,
	CUtoDP_port_sig_encType_s2_at_t = CUtoDP_port_sig_encType_s2@t,
	CUtoDP_port_sig_imm_s3_at_t = CUtoDP_port_sig_imm_s3@t,
	CUtoDP_port_sig_loadedData_at_t = CUtoDP_port_sig_loadedData@t,
	CUtoDP_port_sig_pc_s2_at_t = CUtoDP_port_sig_pc_s2@t,
	CUtoDP_port_sig_regFileReq_s2_at_t = CUtoDP_port_sig_regFileReq_s2@t,
	CUtoDP_port_sig_regFileReq_s5_at_t = CUtoDP_port_sig_regFileReq_s5@t,
	CUtoDP_port_sig_regFileWriteDataSel_s5_at_t = CUtoDP_port_sig_regFileWriteDataSel_s5@t,
	CUtoDP_port_sig_regRdAddr_s2_at_t = CUtoDP_port_sig_regRdAddr_s2@t,
	CUtoDP_port_sig_regRs1Addr_s2_at_t = CUtoDP_port_sig_regRs1Addr_s2@t,
	CUtoDP_port_sig_regRs2Addr_s2_at_t = CUtoDP_port_sig_regRs2Addr_s2@t,
	DP_S3_data_encType_s3_at_t = DP_S3_data_encType_s3@t,
	DP_S3_data_pc_s3_at_t = DP_S3_data_pc_s3@t,
	DP_S3_data_reg1Content_s3_at_t = DP_S3_data_reg1Content_s3@t,
	DP_S3_data_reg2Content_s3_at_t = DP_S3_data_reg2Content_s3@t,
	DP_S3_data_regRdAddr_s3_at_t = DP_S3_data_regRdAddr_s3@t,
	DP_S3_data_regRs1Addr_s3_at_t = DP_S3_data_regRs1Addr_s3@t,
	DP_S3_data_regRs2Addr_s3_at_t = DP_S3_data_regRs2Addr_s3@t,
	DP_S4_data_aluResult_s4_at_t = DP_S4_data_aluResult_s4@t,
	DP_S4_data_encType_s4_at_t = DP_S4_data_encType_s4@t,
	DP_S4_data_pc_s4_at_t = DP_S4_data_pc_s4@t,
	DP_S4_data_prevLoadedData_at_t = DP_S4_data_prevLoadedData@t,
	DP_S4_data_regRdAddr_s4_at_t = DP_S4_data_regRdAddr_s4@t,
	DP_S5_data_aluResult_s5_at_t = DP_S5_data_aluResult_s5@t,
	DP_S5_data_encType_s5_at_t = DP_S5_data_encType_s5@t,
	DP_S5_data_pc_s5_at_t = DP_S5_data_pc_s5@t,
	DP_S5_data_regRdAddr_s5_at_t = DP_S5_data_regRdAddr_s5@t,
	RFtoDP_port_sig_reg_file_01_at_t = RFtoDP_port_sig_reg_file_01@t,
	RFtoDP_port_sig_reg_file_02_at_t = RFtoDP_port_sig_reg_file_02@t,
	RFtoDP_port_sig_reg_file_03_at_t = RFtoDP_port_sig_reg_file_03@t,
	RFtoDP_port_sig_reg_file_04_at_t = RFtoDP_port_sig_reg_file_04@t,
	RFtoDP_port_sig_reg_file_05_at_t = RFtoDP_port_sig_reg_file_05@t,
	RFtoDP_port_sig_reg_file_06_at_t = RFtoDP_port_sig_reg_file_06@t,
	RFtoDP_port_sig_reg_file_07_at_t = RFtoDP_port_sig_reg_file_07@t,
	RFtoDP_port_sig_reg_file_08_at_t = RFtoDP_port_sig_reg_file_08@t,
	RFtoDP_port_sig_reg_file_09_at_t = RFtoDP_port_sig_reg_file_09@t,
	RFtoDP_port_sig_reg_file_10_at_t = RFtoDP_port_sig_reg_file_10@t,
	RFtoDP_port_sig_reg_file_11_at_t = RFtoDP_port_sig_reg_file_11@t,
	RFtoDP_port_sig_reg_file_12_at_t = RFtoDP_port_sig_reg_file_12@t,
	RFtoDP_port_sig_reg_file_13_at_t = RFtoDP_port_sig_reg_file_13@t,
	RFtoDP_port_sig_reg_file_14_at_t = RFtoDP_port_sig_reg_file_14@t,
	RFtoDP_port_sig_reg_file_15_at_t = RFtoDP_port_sig_reg_file_15@t,
	RFtoDP_port_sig_reg_file_16_at_t = RFtoDP_port_sig_reg_file_16@t,
	RFtoDP_port_sig_reg_file_17_at_t = RFtoDP_port_sig_reg_file_17@t,
	RFtoDP_port_sig_reg_file_18_at_t = RFtoDP_port_sig_reg_file_18@t,
	RFtoDP_port_sig_reg_file_19_at_t = RFtoDP_port_sig_reg_file_19@t,
	RFtoDP_port_sig_reg_file_20_at_t = RFtoDP_port_sig_reg_file_20@t,
	RFtoDP_port_sig_reg_file_21_at_t = RFtoDP_port_sig_reg_file_21@t,
	RFtoDP_port_sig_reg_file_22_at_t = RFtoDP_port_sig_reg_file_22@t,
	RFtoDP_port_sig_reg_file_23_at_t = RFtoDP_port_sig_reg_file_23@t,
	RFtoDP_port_sig_reg_file_24_at_t = RFtoDP_port_sig_reg_file_24@t,
	RFtoDP_port_sig_reg_file_25_at_t = RFtoDP_port_sig_reg_file_25@t,
	RFtoDP_port_sig_reg_file_26_at_t = RFtoDP_port_sig_reg_file_26@t,
	RFtoDP_port_sig_reg_file_27_at_t = RFtoDP_port_sig_reg_file_27@t,
	RFtoDP_port_sig_reg_file_28_at_t = RFtoDP_port_sig_reg_file_28@t,
	RFtoDP_port_sig_reg_file_29_at_t = RFtoDP_port_sig_reg_file_29@t,
	RFtoDP_port_sig_reg_file_30_at_t = RFtoDP_port_sig_reg_file_30@t,
	RFtoDP_port_sig_reg_file_31_at_t = RFtoDP_port_sig_reg_file_31@t;
assume:
	at t: state_97;
	at t: CUtoDP_port_sync;
	at t: not((CUtoDP_port_sig_dmemReq_s4 = ME_RD));
	at t: not((CUtoDP_port_sig_dmemReq_s4 = ME_WR));
	at t: not(((((CUtoDP_port_sig_prevDmemAccess and (DP_S3_data_encType_s3 = ENC_S)) and (DP_S5_data_encType_s5 = ENC_I_L)) and (DP_S3_data_regRs2Addr_s3 = DP_S5_data_regRdAddr_s5)) and not((DP_S5_data_regRdAddr_s5 = resize(0,32)))));
	at t: not(CUtoDP_port_sig_stallDmemAccess);
prove:
	at t+1: state_97;
	at t+1: DP_S3_data_encType_s3 = CUtoDP_port_sig_encType_s2_at_t;
	at t+1: DP_S3_data_pc_s3 = CUtoDP_port_sig_pc_s2_at_t;
	at t+1: DP_S3_data_reg1Content_s3 = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DP_S3_data_reg2Content_s3 = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DP_S3_data_regRdAddr_s3 = CUtoDP_port_sig_regRdAddr_s2_at_t;
	at t+1: DP_S3_data_regRs1Addr_s3 = CUtoDP_port_sig_regRs1Addr_s2_at_t;
	at t+1: DP_S3_data_regRs2Addr_s3 = CUtoDP_port_sig_regRs2Addr_s2_at_t;
	at t+1: DP_S4_data_aluResult_s4 = getALUresult(CUtoDP_port_sig_aluFunc_s3_at_t,getALUoperand(aluOpFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S3_data_reg1Content_s3_at_t,DP_S3_data_regRs1Addr_s3_at_t),CUtoDP_port_sig_aluOp1Sel_s3_at_t,CUtoDP_port_sig_imm_s3_at_t,DP_S3_data_pc_s3_at_t),getALUoperand(aluOpFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S3_data_reg2Content_s3_at_t,DP_S3_data_regRs2Addr_s3_at_t),CUtoDP_port_sig_aluOp2Sel_s3_at_t,CUtoDP_port_sig_imm_s3_at_t,DP_S3_data_pc_s3_at_t));
	at t+1: DP_S4_data_encType_s4 = DP_S3_data_encType_s3_at_t;
	at t+1: DP_S4_data_fwdPrevLoadedData = false;
	at t+1: DP_S4_data_pc_s4 = DP_S3_data_pc_s3_at_t;
	at t+1: DP_S4_data_prevLoadedData = DP_S4_data_prevLoadedData_at_t;
	at t+1: DP_S4_data_reg2Content_s4 = DP_S3_data_reg2Content_s3_at_t;
	at t+1: DP_S4_data_regRdAddr_s4 = DP_S3_data_regRdAddr_s3_at_t;
	at t+1: DP_S4_data_regRs2Addr_s4 = DP_S3_data_regRs2Addr_s3_at_t;
	at t+1: DP_S5_data_aluResult_s5 = DP_S4_data_aluResult_s4_at_t;
	at t+1: DP_S5_data_encType_s5 = DP_S4_data_encType_s4_at_t;
	at t+1: DP_S5_data_pc_s5 = DP_S4_data_pc_s4_at_t;
	at t+1: DP_S5_data_regRdAddr_s5 = DP_S4_data_regRdAddr_s4_at_t;
	at t+1: DPtoCU_data_addrIn = 0;
	at t+1: DPtoCU_data_dataIn = 0;
	at t+1: DPtoCU_data_mask = MT_X;
	at t+1: DPtoCU_data_reg1Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DPtoCU_data_reg2Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DPtoCU_data_req = ME_X;
	at t+1: DPtoCU_port_sig_addrIn = 0;
	at t+1: DPtoCU_port_sig_dataIn = 0;
	at t+1: DPtoCU_port_sig_mask = MT_X;
	at t+1: DPtoCU_port_sig_req = ME_X;
	at t+1: DPtoRF_port_sig_dst = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoRF_port_sig_dstData = getWBdata(DP_S5_data_aluResult_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S5_data_pc_s5_at_t,CUtoDP_port_sig_regFileWriteDataSel_s5_at_t);
	at t+1: DPtoRF_port_sig_wrReq = CUtoDP_port_sig_regFileReq_s5_at_t;
	at t+1: nextphase = readRegFileStage;
	at t+1: DPtoRF_port_notify = true;
end property;


property state_97_29 is
dependencies: no_reset;
freeze:
	CUtoDP_port_sig_loadedData_at_t = CUtoDP_port_sig_loadedData@t,
	CUtoDP_port_sig_regFileReq_s2_at_t = CUtoDP_port_sig_regFileReq_s2@t,
	CUtoDP_port_sig_regFileReq_s5_at_t = CUtoDP_port_sig_regFileReq_s5@t,
	CUtoDP_port_sig_regFileWriteDataSel_s5_at_t = CUtoDP_port_sig_regFileWriteDataSel_s5@t,
	CUtoDP_port_sig_regRs1Addr_s2_at_t = CUtoDP_port_sig_regRs1Addr_s2@t,
	CUtoDP_port_sig_regRs2Addr_s2_at_t = CUtoDP_port_sig_regRs2Addr_s2@t,
	DP_S3_data_encType_s3_at_t = DP_S3_data_encType_s3@t,
	DP_S3_data_pc_s3_at_t = DP_S3_data_pc_s3@t,
	DP_S3_data_reg1Content_s3_at_t = DP_S3_data_reg1Content_s3@t,
	DP_S3_data_reg2Content_s3_at_t = DP_S3_data_reg2Content_s3@t,
	DP_S3_data_regRdAddr_s3_at_t = DP_S3_data_regRdAddr_s3@t,
	DP_S3_data_regRs1Addr_s3_at_t = DP_S3_data_regRs1Addr_s3@t,
	DP_S3_data_regRs2Addr_s3_at_t = DP_S3_data_regRs2Addr_s3@t,
	DP_S4_data_aluResult_s4_at_t = DP_S4_data_aluResult_s4@t,
	DP_S4_data_encType_s4_at_t = DP_S4_data_encType_s4@t,
	DP_S4_data_pc_s4_at_t = DP_S4_data_pc_s4@t,
	DP_S4_data_prevLoadedData_at_t = DP_S4_data_prevLoadedData@t,
	DP_S4_data_reg2Content_s4_at_t = DP_S4_data_reg2Content_s4@t,
	DP_S4_data_regRdAddr_s4_at_t = DP_S4_data_regRdAddr_s4@t,
	DP_S4_data_regRs2Addr_s4_at_t = DP_S4_data_regRs2Addr_s4@t,
	DP_S5_data_aluResult_s5_at_t = DP_S5_data_aluResult_s5@t,
	DP_S5_data_encType_s5_at_t = DP_S5_data_encType_s5@t,
	DP_S5_data_pc_s5_at_t = DP_S5_data_pc_s5@t,
	DP_S5_data_regRdAddr_s5_at_t = DP_S5_data_regRdAddr_s5@t,
	RFtoDP_port_sig_reg_file_01_at_t = RFtoDP_port_sig_reg_file_01@t,
	RFtoDP_port_sig_reg_file_02_at_t = RFtoDP_port_sig_reg_file_02@t,
	RFtoDP_port_sig_reg_file_03_at_t = RFtoDP_port_sig_reg_file_03@t,
	RFtoDP_port_sig_reg_file_04_at_t = RFtoDP_port_sig_reg_file_04@t,
	RFtoDP_port_sig_reg_file_05_at_t = RFtoDP_port_sig_reg_file_05@t,
	RFtoDP_port_sig_reg_file_06_at_t = RFtoDP_port_sig_reg_file_06@t,
	RFtoDP_port_sig_reg_file_07_at_t = RFtoDP_port_sig_reg_file_07@t,
	RFtoDP_port_sig_reg_file_08_at_t = RFtoDP_port_sig_reg_file_08@t,
	RFtoDP_port_sig_reg_file_09_at_t = RFtoDP_port_sig_reg_file_09@t,
	RFtoDP_port_sig_reg_file_10_at_t = RFtoDP_port_sig_reg_file_10@t,
	RFtoDP_port_sig_reg_file_11_at_t = RFtoDP_port_sig_reg_file_11@t,
	RFtoDP_port_sig_reg_file_12_at_t = RFtoDP_port_sig_reg_file_12@t,
	RFtoDP_port_sig_reg_file_13_at_t = RFtoDP_port_sig_reg_file_13@t,
	RFtoDP_port_sig_reg_file_14_at_t = RFtoDP_port_sig_reg_file_14@t,
	RFtoDP_port_sig_reg_file_15_at_t = RFtoDP_port_sig_reg_file_15@t,
	RFtoDP_port_sig_reg_file_16_at_t = RFtoDP_port_sig_reg_file_16@t,
	RFtoDP_port_sig_reg_file_17_at_t = RFtoDP_port_sig_reg_file_17@t,
	RFtoDP_port_sig_reg_file_18_at_t = RFtoDP_port_sig_reg_file_18@t,
	RFtoDP_port_sig_reg_file_19_at_t = RFtoDP_port_sig_reg_file_19@t,
	RFtoDP_port_sig_reg_file_20_at_t = RFtoDP_port_sig_reg_file_20@t,
	RFtoDP_port_sig_reg_file_21_at_t = RFtoDP_port_sig_reg_file_21@t,
	RFtoDP_port_sig_reg_file_22_at_t = RFtoDP_port_sig_reg_file_22@t,
	RFtoDP_port_sig_reg_file_23_at_t = RFtoDP_port_sig_reg_file_23@t,
	RFtoDP_port_sig_reg_file_24_at_t = RFtoDP_port_sig_reg_file_24@t,
	RFtoDP_port_sig_reg_file_25_at_t = RFtoDP_port_sig_reg_file_25@t,
	RFtoDP_port_sig_reg_file_26_at_t = RFtoDP_port_sig_reg_file_26@t,
	RFtoDP_port_sig_reg_file_27_at_t = RFtoDP_port_sig_reg_file_27@t,
	RFtoDP_port_sig_reg_file_28_at_t = RFtoDP_port_sig_reg_file_28@t,
	RFtoDP_port_sig_reg_file_29_at_t = RFtoDP_port_sig_reg_file_29@t,
	RFtoDP_port_sig_reg_file_30_at_t = RFtoDP_port_sig_reg_file_30@t,
	RFtoDP_port_sig_reg_file_31_at_t = RFtoDP_port_sig_reg_file_31@t;
assume:
	at t: state_97;
	at t: CUtoDP_port_sync;
	at t: not((CUtoDP_port_sig_dmemReq_s4 = ME_RD));
	at t: not((CUtoDP_port_sig_dmemReq_s4 = ME_WR));
	at t: not(((((CUtoDP_port_sig_prevDmemAccess and (DP_S3_data_encType_s3 = ENC_S)) and (DP_S5_data_encType_s5 = ENC_I_L)) and (DP_S3_data_regRs2Addr_s3 = DP_S5_data_regRdAddr_s5)) and not((DP_S5_data_regRdAddr_s5 = resize(0,32)))));
	at t: not(DP_S4_data_fwdPrevLoadedData);
	at t: CUtoDP_port_sig_stallDmemAccess;
prove:
	at t+1: state_97;
	at t+1: DP_S3_data_encType_s3 = DP_S3_data_encType_s3_at_t;
	at t+1: DP_S3_data_pc_s3 = DP_S3_data_pc_s3_at_t;
	at t+1: DP_S3_data_reg1Content_s3 = DP_S3_data_reg1Content_s3_at_t;
	at t+1: DP_S3_data_reg2Content_s3 = DP_S3_data_reg2Content_s3_at_t;
	at t+1: DP_S3_data_regRdAddr_s3 = DP_S3_data_regRdAddr_s3_at_t;
	at t+1: DP_S3_data_regRs1Addr_s3 = DP_S3_data_regRs1Addr_s3_at_t;
	at t+1: DP_S3_data_regRs2Addr_s3 = DP_S3_data_regRs2Addr_s3_at_t;
	at t+1: DP_S4_data_aluResult_s4 = DP_S4_data_aluResult_s4_at_t;
	at t+1: DP_S4_data_encType_s4 = DP_S4_data_encType_s4_at_t;
	at t+1: DP_S4_data_fwdPrevLoadedData = false;
	at t+1: DP_S4_data_pc_s4 = DP_S4_data_pc_s4_at_t;
	at t+1: DP_S4_data_prevLoadedData = DP_S4_data_prevLoadedData_at_t;
	at t+1: DP_S4_data_reg2Content_s4 = DP_S4_data_reg2Content_s4_at_t;
	at t+1: DP_S4_data_regRdAddr_s4 = DP_S4_data_regRdAddr_s4_at_t;
	at t+1: DP_S4_data_regRs2Addr_s4 = DP_S4_data_regRs2Addr_s4_at_t;
	at t+1: DP_S5_data_aluResult_s5 = DP_S5_data_aluResult_s5_at_t;
	at t+1: DP_S5_data_encType_s5 = DP_S5_data_encType_s5_at_t;
	at t+1: DP_S5_data_pc_s5 = DP_S5_data_pc_s5_at_t;
	at t+1: DP_S5_data_regRdAddr_s5 = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoCU_data_addrIn = 0;
	at t+1: DPtoCU_data_dataIn = 0;
	at t+1: DPtoCU_data_mask = MT_X;
	at t+1: DPtoCU_data_reg1Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs1Addr_s2_at_t),CUtoDP_port_sig_regRs1Addr_s2_at_t);
	at t+1: DPtoCU_data_reg2Content = regContentFwdUnit(DP_S4_data_aluResult_s4_at_t,DP_S5_data_aluResult_s5_at_t,DP_S4_data_regRdAddr_s4_at_t,DP_S5_data_regRdAddr_s5_at_t,DP_S4_data_encType_s4_at_t,DP_S5_data_encType_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S4_data_pc_s4_at_t,DP_S5_data_pc_s5_at_t,getRegContent(RFtoDP_port_sig_reg_file_01_at_t,RFtoDP_port_sig_reg_file_02_at_t,RFtoDP_port_sig_reg_file_03_at_t,RFtoDP_port_sig_reg_file_04_at_t,RFtoDP_port_sig_reg_file_05_at_t,RFtoDP_port_sig_reg_file_06_at_t,RFtoDP_port_sig_reg_file_07_at_t,RFtoDP_port_sig_reg_file_08_at_t,RFtoDP_port_sig_reg_file_09_at_t,RFtoDP_port_sig_reg_file_10_at_t,RFtoDP_port_sig_reg_file_11_at_t,RFtoDP_port_sig_reg_file_12_at_t,RFtoDP_port_sig_reg_file_13_at_t,RFtoDP_port_sig_reg_file_14_at_t,RFtoDP_port_sig_reg_file_15_at_t,RFtoDP_port_sig_reg_file_16_at_t,RFtoDP_port_sig_reg_file_17_at_t,RFtoDP_port_sig_reg_file_18_at_t,RFtoDP_port_sig_reg_file_19_at_t,RFtoDP_port_sig_reg_file_20_at_t,RFtoDP_port_sig_reg_file_21_at_t,RFtoDP_port_sig_reg_file_22_at_t,RFtoDP_port_sig_reg_file_23_at_t,RFtoDP_port_sig_reg_file_24_at_t,RFtoDP_port_sig_reg_file_25_at_t,RFtoDP_port_sig_reg_file_26_at_t,RFtoDP_port_sig_reg_file_27_at_t,RFtoDP_port_sig_reg_file_28_at_t,RFtoDP_port_sig_reg_file_29_at_t,RFtoDP_port_sig_reg_file_30_at_t,RFtoDP_port_sig_reg_file_31_at_t,CUtoDP_port_sig_regFileReq_s2_at_t,CUtoDP_port_sig_regRs2Addr_s2_at_t),CUtoDP_port_sig_regRs2Addr_s2_at_t);
	at t+1: DPtoCU_data_req = ME_X;
	at t+1: DPtoCU_port_sig_addrIn = 0;
	at t+1: DPtoCU_port_sig_dataIn = 0;
	at t+1: DPtoCU_port_sig_mask = MT_X;
	at t+1: DPtoCU_port_sig_req = ME_X;
	at t+1: DPtoRF_port_sig_dst = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoRF_port_sig_dstData = getWBdata(DP_S5_data_aluResult_s5_at_t,CUtoDP_port_sig_loadedData_at_t,DP_S5_data_pc_s5_at_t,CUtoDP_port_sig_regFileWriteDataSel_s5_at_t);
	at t+1: DPtoRF_port_sig_wrReq = CUtoDP_port_sig_regFileReq_s5_at_t;
	at t+1: nextphase = readRegFileStage;
	at t+1: DPtoRF_port_notify = true;
end property;


property state_97_32 is
dependencies: no_reset;
freeze:
	DP_S3_data_encType_s3_at_t = DP_S3_data_encType_s3@t,
	DP_S3_data_pc_s3_at_t = DP_S3_data_pc_s3@t,
	DP_S3_data_reg1Content_s3_at_t = DP_S3_data_reg1Content_s3@t,
	DP_S3_data_reg2Content_s3_at_t = DP_S3_data_reg2Content_s3@t,
	DP_S3_data_regRdAddr_s3_at_t = DP_S3_data_regRdAddr_s3@t,
	DP_S3_data_regRs1Addr_s3_at_t = DP_S3_data_regRs1Addr_s3@t,
	DP_S3_data_regRs2Addr_s3_at_t = DP_S3_data_regRs2Addr_s3@t,
	DP_S4_data_aluResult_s4_at_t = DP_S4_data_aluResult_s4@t,
	DP_S4_data_encType_s4_at_t = DP_S4_data_encType_s4@t,
	DP_S4_data_fwdPrevLoadedData_at_t = DP_S4_data_fwdPrevLoadedData@t,
	DP_S4_data_pc_s4_at_t = DP_S4_data_pc_s4@t,
	DP_S4_data_prevLoadedData_at_t = DP_S4_data_prevLoadedData@t,
	DP_S4_data_reg2Content_s4_at_t = DP_S4_data_reg2Content_s4@t,
	DP_S4_data_regRdAddr_s4_at_t = DP_S4_data_regRdAddr_s4@t,
	DP_S4_data_regRs2Addr_s4_at_t = DP_S4_data_regRs2Addr_s4@t,
	DP_S5_data_aluResult_s5_at_t = DP_S5_data_aluResult_s5@t,
	DP_S5_data_encType_s5_at_t = DP_S5_data_encType_s5@t,
	DP_S5_data_pc_s5_at_t = DP_S5_data_pc_s5@t,
	DP_S5_data_regRdAddr_s5_at_t = DP_S5_data_regRdAddr_s5@t,
	DPtoCU_data_addrIn_at_t = DPtoCU_data_addrIn@t,
	DPtoCU_data_dataIn_at_t = DPtoCU_data_dataIn@t,
	DPtoCU_data_mask_at_t = DPtoCU_data_mask@t,
	DPtoCU_data_reg1Content_at_t = DPtoCU_data_reg1Content@t,
	DPtoCU_data_reg2Content_at_t = DPtoCU_data_reg2Content@t,
	DPtoCU_data_req_at_t = DPtoCU_data_req@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_97;
	at t: not(CUtoDP_port_sync);
	at t: (nextphase = readRegFileStage);
prove:
	at t+1: state_97;
	at t+1: DP_S3_data_encType_s3 = DP_S3_data_encType_s3_at_t;
	at t+1: DP_S3_data_pc_s3 = DP_S3_data_pc_s3_at_t;
	at t+1: DP_S3_data_reg1Content_s3 = DP_S3_data_reg1Content_s3_at_t;
	at t+1: DP_S3_data_reg2Content_s3 = DP_S3_data_reg2Content_s3_at_t;
	at t+1: DP_S3_data_regRdAddr_s3 = DP_S3_data_regRdAddr_s3_at_t;
	at t+1: DP_S3_data_regRs1Addr_s3 = DP_S3_data_regRs1Addr_s3_at_t;
	at t+1: DP_S3_data_regRs2Addr_s3 = DP_S3_data_regRs2Addr_s3_at_t;
	at t+1: DP_S4_data_aluResult_s4 = DP_S4_data_aluResult_s4_at_t;
	at t+1: DP_S4_data_encType_s4 = DP_S4_data_encType_s4_at_t;
	at t+1: DP_S4_data_fwdPrevLoadedData = DP_S4_data_fwdPrevLoadedData_at_t;
	at t+1: DP_S4_data_pc_s4 = DP_S4_data_pc_s4_at_t;
	at t+1: DP_S4_data_prevLoadedData = DP_S4_data_prevLoadedData_at_t;
	at t+1: DP_S4_data_reg2Content_s4 = DP_S4_data_reg2Content_s4_at_t;
	at t+1: DP_S4_data_regRdAddr_s4 = DP_S4_data_regRdAddr_s4_at_t;
	at t+1: DP_S4_data_regRs2Addr_s4 = DP_S4_data_regRs2Addr_s4_at_t;
	at t+1: DP_S5_data_aluResult_s5 = DP_S5_data_aluResult_s5_at_t;
	at t+1: DP_S5_data_encType_s5 = DP_S5_data_encType_s5_at_t;
	at t+1: DP_S5_data_pc_s5 = DP_S5_data_pc_s5_at_t;
	at t+1: DP_S5_data_regRdAddr_s5 = DP_S5_data_regRdAddr_s5_at_t;
	at t+1: DPtoCU_data_addrIn = DPtoCU_data_addrIn_at_t;
	at t+1: DPtoCU_data_dataIn = DPtoCU_data_dataIn_at_t;
	at t+1: DPtoCU_data_mask = DPtoCU_data_mask_at_t;
	at t+1: DPtoCU_data_reg1Content = DPtoCU_data_reg1Content_at_t;
	at t+1: DPtoCU_data_reg2Content = DPtoCU_data_reg2Content_at_t;
	at t+1: DPtoCU_data_req = DPtoCU_data_req_at_t;
	at t+1: DPtoCU_port_sig_addrIn = DPtoCU_data_addrIn_at_t;
	at t+1: DPtoCU_port_sig_dataIn = DPtoCU_data_dataIn_at_t;
	at t+1: DPtoCU_port_sig_mask = DPtoCU_data_mask_at_t;
	at t+1: DPtoCU_port_sig_req = DPtoCU_data_req_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: DPtoRF_port_notify = false;
end property;


