--
-- CREATED BY: SALAHEDDIN HETALANI (salaheddinhetalani@gmail.com) ON 30 SEP, 2018
--

-- Restrictions --
macro ENC_R_ADD_x1_x1_x1 	:  bool 	:= CU/MEtoCU_port.loadedData = 1081523; 	end macro; -- R
macro ENC_I_I_ADDI_x1_x1_4 	:  bool 	:= CU/MEtoCU_port.loadedData = 4227219; 	end macro; -- I_I
macro ENC_I_J_x1_x1_4 		:  bool 	:= CU/MEtoCU_port.loadedData = 4227303;		end macro; -- I_J
macro ENC_I_L_x1_x1_4 		:  bool 	:= CU/MEtoCU_port.loadedData = 4227203;		end macro; -- I_L
macro ENC_S_x1_x1_4 		:  bool 	:= CU/MEtoCU_port.loadedData = 1081891;		end macro; -- S
macro ENC_S_x1_x2_4 		:  bool 	:= CU/MEtoCU_port.loadedData = 2130467;		end macro; -- S
macro ENC_B_BEQ_x1_x1_4 	:  bool 	:= CU/MEtoCU_port.loadedData = 1082467;		end macro; -- B (BEQ)
macro ENC_B_BNEQ_x1_x1_4 	:  bool 	:= CU/MEtoCU_port.loadedData = 1086563;		end macro; -- B (BNEQ)
macro ENC_U_LUI_x1_4 		:  bool 	:= CU/MEtoCU_port.loadedData = 16567; 		end macro; -- U (LUI)
macro ENC_U_AUIPC_x1_4 		:  bool 	:= CU/MEtoCU_port.loadedData = 16535; 		end macro; -- U (AUIPC)
macro ENC_J_x1_4 		:  bool 	:= CU/MEtoCU_port.loadedData = 8388847;		end macro; -- J