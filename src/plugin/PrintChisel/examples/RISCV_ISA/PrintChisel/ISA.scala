package isa
import chisel3._
import chisel3.util._

class Metocuif extends Bundle {
	val loadedData = UInt(32.W)
}

class Regfiletype extends Bundle {
	val reg_file_01 = UInt(32.W)
	val reg_file_02 = UInt(32.W)
	val reg_file_03 = UInt(32.W)
	val reg_file_04 = UInt(32.W)
	val reg_file_05 = UInt(32.W)
	val reg_file_06 = UInt(32.W)
	val reg_file_07 = UInt(32.W)
	val reg_file_08 = UInt(32.W)
	val reg_file_09 = UInt(32.W)
	val reg_file_10 = UInt(32.W)
	val reg_file_11 = UInt(32.W)
	val reg_file_12 = UInt(32.W)
	val reg_file_13 = UInt(32.W)
	val reg_file_14 = UInt(32.W)
	val reg_file_15 = UInt(32.W)
	val reg_file_16 = UInt(32.W)
	val reg_file_17 = UInt(32.W)
	val reg_file_18 = UInt(32.W)
	val reg_file_19 = UInt(32.W)
	val reg_file_20 = UInt(32.W)
	val reg_file_21 = UInt(32.W)
	val reg_file_22 = UInt(32.W)
	val reg_file_23 = UInt(32.W)
	val reg_file_24 = UInt(32.W)
	val reg_file_25 = UInt(32.W)
	val reg_file_26 = UInt(32.W)
	val reg_file_27 = UInt(32.W)
	val reg_file_28 = UInt(32.W)
	val reg_file_29 = UInt(32.W)
	val reg_file_30 = UInt(32.W)
	val reg_file_31 = UInt(32.W)
}

class Cutomeif extends Bundle {
	val addrIn = UInt(32.W)
	val dataIn = UInt(32.W)
	val mask = UInt(32.W)
	val req = UInt(32.W)
}

class Regfilewritetype extends Bundle {
	val dst = UInt(32.W)
	val dstData = UInt(32.W)
}

class ISA extends Module {
	val io = IO(new Bundle {
		val fromMemoryPort_sync = Input(Bool())
		val toMemoryPort_sync = Input(Bool())
		val fromMemoryPort_notify = Output(Bool())
		val toMemoryPort_notify = Output(Bool())
		val toRegsPort_notify = Output(Bool())
		val fromMemoryPort = Input(new Metocuif())
		val fromRegsPort = Input(new Regfiletype())
		val toMemoryPort = Output(new Cutomeif())
		val toRegsPort = Output(new Regfilewritetype())
	})

	val fromMemoryPort_notify_r = Reg(Bool())
	val toMemoryPort_notify_r = Reg(Bool())
	val toRegsPort_notify_r = Reg(Bool())
	val toMemoryPort_r = Reg(new Cutomeif())
	val toRegsPort_r = Reg(new Regfilewritetype())
	val memoryAccess_signal_r = Reg(new Cutomeif())
	val pcReg_signal_r = Reg(UInt(32.W))
	val regfileWrite_signal_r = Reg(new Regfilewritetype())
	val state_r = Reg(UInt())

	val mt_x :: mt_w :: mt_h :: mt_b :: mt_hu :: mt_bu ::  Nil = Enum(6)
	val me_x :: me_rd :: me_wr ::  Nil = Enum(3)
	val execute_4 :: execute_5 :: execute_11 :: execute_12 :: fetch_16 :: fetch_17 ::  Nil = Enum(6)

	when(reset.toBool) {
		state_r := fetch_16
		memoryAccess_signal_r.addrIn := 0.U(32.W)
		memoryAccess_signal_r.dataIn := 0.U(32.W)
		memoryAccess_signal_r.mask := mt_w
		memoryAccess_signal_r.req := me_rd
		pcReg_signal_r := 0.U(32.W)
		regfileWrite_signal_r.dst := 0.U(32.W)
		regfileWrite_signal_r.dstData := 0.U(32.W)
		toMemoryPort_r.addrIn := 0.U(32.W)
		toMemoryPort_r.dataIn := 0.U(32.W)
		toMemoryPort_r.mask := mt_w
		toMemoryPort_r.req := me_rd
		fromMemoryPort_notify_r := false.B
		toMemoryPort_notify_r := true.B
		toRegsPort_notify_r := false.B
	}
	.otherwise {
		when(state_r === execute_4) {
			when(io.toMemoryPort_sync) {
				state_r := execute_5
				memoryAccess_signal_r.addrIn := memoryAccess_signal_r.addrIn
				memoryAccess_signal_r.dataIn := memoryAccess_signal_r.dataIn
				memoryAccess_signal_r.mask := memoryAccess_signal_r.mask
				memoryAccess_signal_r.req := memoryAccess_signal_r.req
				pcReg_signal_r := pcReg_signal_r
				regfileWrite_signal_r.dst := regfileWrite_signal_r.dst
				regfileWrite_signal_r.dstData := regfileWrite_signal_r.dstData
				fromMemoryPort_notify_r := true.B
				toMemoryPort_notify_r := false.B
				toRegsPort_notify_r := false.B
			}
		}
		when(state_r === execute_5) {
			when(io.fromMemoryPort_sync) {
				state_r := fetch_16
				memoryAccess_signal_r.addrIn := (4.U(32.W) + pcReg_signal_r)
				memoryAccess_signal_r.dataIn := 0.U(32.W)
				memoryAccess_signal_r.mask := mt_w
				memoryAccess_signal_r.req := me_rd
				pcReg_signal_r := (4.U(32.W) + pcReg_signal_r)
				regfileWrite_signal_r.dst := regfileWrite_signal_r.dst
				regfileWrite_signal_r.dstData := regfileWrite_signal_r.dstData
				toMemoryPort_r.addrIn := (4.U(32.W) + pcReg_signal_r)
				toMemoryPort_r.dataIn := 0.U(32.W)
				toMemoryPort_r.mask := mt_w
				toMemoryPort_r.req := me_rd
				fromMemoryPort_notify_r := false.B
				toMemoryPort_notify_r := true.B
				toRegsPort_notify_r := false.B
			}
		}
		when(state_r === execute_11) {
			when(io.toMemoryPort_sync) {
				state_r := execute_12
				memoryAccess_signal_r.addrIn := memoryAccess_signal_r.addrIn
				memoryAccess_signal_r.dataIn := memoryAccess_signal_r.dataIn
				memoryAccess_signal_r.mask := memoryAccess_signal_r.mask
				memoryAccess_signal_r.req := memoryAccess_signal_r.req
				pcReg_signal_r := pcReg_signal_r
				regfileWrite_signal_r.dst := regfileWrite_signal_r.dst
				regfileWrite_signal_r.dstData := regfileWrite_signal_r.dstData
				fromMemoryPort_notify_r := true.B
				toMemoryPort_notify_r := false.B
				toRegsPort_notify_r := false.B
			}
		}
		when(state_r === execute_12) {
			when(io.fromMemoryPort_sync) {
				state_r := fetch_16
				memoryAccess_signal_r.addrIn := (4.U(32.W) + pcReg_signal_r)
				memoryAccess_signal_r.dataIn := 0.U(32.W)
				memoryAccess_signal_r.mask := mt_w
				memoryAccess_signal_r.req := me_rd
				pcReg_signal_r := (4.U(32.W) + pcReg_signal_r)
				regfileWrite_signal_r.dst := regfileWrite_signal_r.dst
				regfileWrite_signal_r.dstData := io.fromMemoryPort.loadedData
				toMemoryPort_r.addrIn := (4.U(32.W) + pcReg_signal_r)
				toMemoryPort_r.dataIn := 0.U(32.W)
				toMemoryPort_r.mask := mt_w
				toMemoryPort_r.req := me_rd
				toRegsPort_r.dst := regfileWrite_signal_r.dst
				toRegsPort_r.dstData := io.fromMemoryPort.loadedData
				fromMemoryPort_notify_r := false.B
				toMemoryPort_notify_r := true.B
				toRegsPort_notify_r := true.B
			}
		}
		when(state_r === fetch_16) {
			when(io.toMemoryPort_sync) {
				state_r := fetch_17
				memoryAccess_signal_r.addrIn := memoryAccess_signal_r.addrIn
				memoryAccess_signal_r.dataIn := memoryAccess_signal_r.dataIn
				memoryAccess_signal_r.mask := memoryAccess_signal_r.mask
				memoryAccess_signal_r.req := memoryAccess_signal_r.req
				pcReg_signal_r := pcReg_signal_r
				regfileWrite_signal_r.dst := regfileWrite_signal_r.dst
				regfileWrite_signal_r.dstData := regfileWrite_signal_r.dstData
				fromMemoryPort_notify_r := true.B
				toMemoryPort_notify_r := false.B
				toRegsPort_notify_r := false.B
			}
		}
		when(state_r === fetch_17) {
			when(!(getEncType(io.fromMemoryPort.loadedData) === enc_r)) {
				when(!(getEncType(io.fromMemoryPort.loadedData) === enc_b)) {
					when(!(getEncType(io.fromMemoryPort.loadedData) === enc_s)) {
						when(!(getEncType(io.fromMemoryPort.loadedData) === enc_u)) {
							when(!(getEncType(io.fromMemoryPort.loadedData) === enc_j)) {
								when(!(getEncType(io.fromMemoryPort.loadedData) === enc_i_i)) {
									when(!(getEncType(io.fromMemoryPort.loadedData) === enc_i_l)) {
										when(!(getEncType(io.fromMemoryPort.loadedData) === enc_i_j)) {
											when(io.fromMemoryPort_sync) {
												state_r := fetch_16
												memoryAccess_signal_r.addrIn := pcReg_signal_r
												memoryAccess_signal_r.dataIn := 0.U(32.W)
												memoryAccess_signal_r.mask := mt_w
												memoryAccess_signal_r.req := me_rd
												pcReg_signal_r := pcReg_signal_r
												regfileWrite_signal_r.dst := regfileWrite_signal_r.dst
												regfileWrite_signal_r.dstData := regfileWrite_signal_r.dstData
												toMemoryPort_r.addrIn := pcReg_signal_r
												toMemoryPort_r.dataIn := 0.U(32.W)
												toMemoryPort_r.mask := mt_w
												toMemoryPort_r.req := me_rd
												fromMemoryPort_notify_r := false.B
												toMemoryPort_notify_r := true.B
												toRegsPort_notify_r := false.B
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		when(state_r === fetch_17) {
			when((getEncType(io.fromMemoryPort.loadedData) === enc_r)) {
				when(io.fromMemoryPort_sync) {
					state_r := fetch_16
					memoryAccess_signal_r.addrIn := (4.U(32.W) + pcReg_signal_r)
					memoryAccess_signal_r.dataIn := 0.U(32.W)
					memoryAccess_signal_r.mask := mt_w
					memoryAccess_signal_r.req := me_rd
					pcReg_signal_r := (4.U(32.W) + pcReg_signal_r)
					regfileWrite_signal_r.dst := getRdAddr(io.fromMemoryPort.loadedData)
					regfileWrite_signal_r.dstData := getALUresult(getALUfunc(getInstrType(io.fromMemoryPort.loadedData)),readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs1Addr(io.fromMemoryPort.loadedData)),readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs2Addr(io.fromMemoryPort.loadedData)))
					toMemoryPort_r.addrIn := (4.U(32.W) + pcReg_signal_r)
					toMemoryPort_r.dataIn := 0.U(32.W)
					toMemoryPort_r.mask := mt_w
					toMemoryPort_r.req := me_rd
					toRegsPort_r.dst := getRdAddr(io.fromMemoryPort.loadedData)
					toRegsPort_r.dstData := getALUresult(getALUfunc(getInstrType(io.fromMemoryPort.loadedData)),readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs1Addr(io.fromMemoryPort.loadedData)),readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs2Addr(io.fromMemoryPort.loadedData)))
					fromMemoryPort_notify_r := false.B
					toMemoryPort_notify_r := true.B
					toRegsPort_notify_r := true.B
				}
			}
		}
		when(state_r === fetch_17) {
			when(!(getEncType(io.fromMemoryPort.loadedData) === enc_r)) {
				when((getEncType(io.fromMemoryPort.loadedData) === enc_b)) {
					when(io.fromMemoryPort_sync) {
						state_r := fetch_16
						memoryAccess_signal_r.addrIn := branchPCcalculation(getALUresult(getALUfunc(getInstrType(io.fromMemoryPort.loadedData)),readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs1Addr(io.fromMemoryPort.loadedData)),readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs2Addr(io.fromMemoryPort.loadedData))),io.fromMemoryPort.loadedData,pcReg_signal_r)
						memoryAccess_signal_r.dataIn := 0.U(32.W)
						memoryAccess_signal_r.mask := mt_w
						memoryAccess_signal_r.req := me_rd
						pcReg_signal_r := branchPCcalculation(getALUresult(getALUfunc(getInstrType(io.fromMemoryPort.loadedData)),readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs1Addr(io.fromMemoryPort.loadedData)),readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs2Addr(io.fromMemoryPort.loadedData))),io.fromMemoryPort.loadedData,pcReg_signal_r)
						regfileWrite_signal_r.dst := regfileWrite_signal_r.dst
						regfileWrite_signal_r.dstData := regfileWrite_signal_r.dstData
						toMemoryPort_r.addrIn := branchPCcalculation(getALUresult(getALUfunc(getInstrType(io.fromMemoryPort.loadedData)),readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs1Addr(io.fromMemoryPort.loadedData)),readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs2Addr(io.fromMemoryPort.loadedData))),io.fromMemoryPort.loadedData,pcReg_signal_r)
						toMemoryPort_r.dataIn := 0.U(32.W)
						toMemoryPort_r.mask := mt_w
						toMemoryPort_r.req := me_rd
						fromMemoryPort_notify_r := false.B
						toMemoryPort_notify_r := true.B
						toRegsPort_notify_r := false.B
					}
				}
			}
		}
		when(state_r === fetch_17) {
			when(!(getEncType(io.fromMemoryPort.loadedData) === enc_r)) {
				when(!(getEncType(io.fromMemoryPort.loadedData) === enc_b)) {
					when((getEncType(io.fromMemoryPort.loadedData) === enc_s)) {
						when(io.fromMemoryPort_sync) {
							state_r := execute_4
							memoryAccess_signal_r.addrIn := getALUresult(alu_add,readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs1Addr(io.fromMemoryPort.loadedData)),getImmediate(io.fromMemoryPort.loadedData))
							memoryAccess_signal_r.dataIn := readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs2Addr(io.fromMemoryPort.loadedData))
							memoryAccess_signal_r.mask := getMemoryMask(getInstrType(io.fromMemoryPort.loadedData))
							memoryAccess_signal_r.req := me_wr
							pcReg_signal_r := pcReg_signal_r
							regfileWrite_signal_r.dst := regfileWrite_signal_r.dst
							regfileWrite_signal_r.dstData := regfileWrite_signal_r.dstData
							toMemoryPort_r.addrIn := getALUresult(alu_add,readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs1Addr(io.fromMemoryPort.loadedData)),getImmediate(io.fromMemoryPort.loadedData))
							toMemoryPort_r.dataIn := readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs2Addr(io.fromMemoryPort.loadedData))
							toMemoryPort_r.mask := getMemoryMask(getInstrType(io.fromMemoryPort.loadedData))
							toMemoryPort_r.req := me_wr
							fromMemoryPort_notify_r := false.B
							toMemoryPort_notify_r := true.B
							toRegsPort_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === fetch_17) {
			when(!(getEncType(io.fromMemoryPort.loadedData) === enc_r)) {
				when(!(getEncType(io.fromMemoryPort.loadedData) === enc_b)) {
					when(!(getEncType(io.fromMemoryPort.loadedData) === enc_s)) {
						when((getEncType(io.fromMemoryPort.loadedData) === enc_u)) {
							when(io.fromMemoryPort_sync) {
								state_r := fetch_16
								memoryAccess_signal_r.addrIn := (4.U(32.W) + pcReg_signal_r)
								memoryAccess_signal_r.dataIn := 0.U(32.W)
								memoryAccess_signal_r.mask := mt_w
								memoryAccess_signal_r.req := me_rd
								pcReg_signal_r := (4.U(32.W) + pcReg_signal_r)
								regfileWrite_signal_r.dst := getRdAddr(io.fromMemoryPort.loadedData)
								regfileWrite_signal_r.dstData := getEncUALUresult(io.fromMemoryPort.loadedData,pcReg_signal_r)
								toMemoryPort_r.addrIn := (4.U(32.W) + pcReg_signal_r)
								toMemoryPort_r.dataIn := 0.U(32.W)
								toMemoryPort_r.mask := mt_w
								toMemoryPort_r.req := me_rd
								toRegsPort_r.dst := getRdAddr(io.fromMemoryPort.loadedData)
								toRegsPort_r.dstData := getEncUALUresult(io.fromMemoryPort.loadedData,pcReg_signal_r)
								fromMemoryPort_notify_r := false.B
								toMemoryPort_notify_r := true.B
								toRegsPort_notify_r := true.B
							}
						}
					}
				}
			}
		}
		when(state_r === fetch_17) {
			when(!(getEncType(io.fromMemoryPort.loadedData) === enc_r)) {
				when(!(getEncType(io.fromMemoryPort.loadedData) === enc_b)) {
					when(!(getEncType(io.fromMemoryPort.loadedData) === enc_s)) {
						when(!(getEncType(io.fromMemoryPort.loadedData) === enc_u)) {
							when((getEncType(io.fromMemoryPort.loadedData) === enc_j)) {
								when(io.fromMemoryPort_sync) {
									state_r := fetch_16
									memoryAccess_signal_r.addrIn := (pcReg_signal_r + getImmediate(io.fromMemoryPort.loadedData))
									memoryAccess_signal_r.dataIn := 0.U(32.W)
									memoryAccess_signal_r.mask := mt_w
									memoryAccess_signal_r.req := me_rd
									pcReg_signal_r := (pcReg_signal_r + getImmediate(io.fromMemoryPort.loadedData))
									regfileWrite_signal_r.dst := getRdAddr(io.fromMemoryPort.loadedData)
									regfileWrite_signal_r.dstData := (4.U(32.W) + pcReg_signal_r)
									toMemoryPort_r.addrIn := (pcReg_signal_r + getImmediate(io.fromMemoryPort.loadedData))
									toMemoryPort_r.dataIn := 0.U(32.W)
									toMemoryPort_r.mask := mt_w
									toMemoryPort_r.req := me_rd
									toRegsPort_r.dst := getRdAddr(io.fromMemoryPort.loadedData)
									toRegsPort_r.dstData := (4.U(32.W) + pcReg_signal_r)
									fromMemoryPort_notify_r := false.B
									toMemoryPort_notify_r := true.B
									toRegsPort_notify_r := true.B
								}
							}
						}
					}
				}
			}
		}
		when(state_r === fetch_17) {
			when(!(getEncType(io.fromMemoryPort.loadedData) === enc_r)) {
				when(!(getEncType(io.fromMemoryPort.loadedData) === enc_b)) {
					when(!(getEncType(io.fromMemoryPort.loadedData) === enc_s)) {
						when(!(getEncType(io.fromMemoryPort.loadedData) === enc_u)) {
							when(!(getEncType(io.fromMemoryPort.loadedData) === enc_j)) {
								when((getEncType(io.fromMemoryPort.loadedData) === enc_i_i)) {
									when(io.fromMemoryPort_sync) {
										state_r := fetch_16
										memoryAccess_signal_r.addrIn := (4.U(32.W) + pcReg_signal_r)
										memoryAccess_signal_r.dataIn := 0.U(32.W)
										memoryAccess_signal_r.mask := mt_w
										memoryAccess_signal_r.req := me_rd
										pcReg_signal_r := (4.U(32.W) + pcReg_signal_r)
										regfileWrite_signal_r.dst := getRdAddr(io.fromMemoryPort.loadedData)
										regfileWrite_signal_r.dstData := getALUresult(getALUfunc(getInstrType(io.fromMemoryPort.loadedData)),readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs1Addr(io.fromMemoryPort.loadedData)),getImmediate(io.fromMemoryPort.loadedData))
										toMemoryPort_r.addrIn := (4.U(32.W) + pcReg_signal_r)
										toMemoryPort_r.dataIn := 0.U(32.W)
										toMemoryPort_r.mask := mt_w
										toMemoryPort_r.req := me_rd
										toRegsPort_r.dst := getRdAddr(io.fromMemoryPort.loadedData)
										toRegsPort_r.dstData := getALUresult(getALUfunc(getInstrType(io.fromMemoryPort.loadedData)),readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs1Addr(io.fromMemoryPort.loadedData)),getImmediate(io.fromMemoryPort.loadedData))
										fromMemoryPort_notify_r := false.B
										toMemoryPort_notify_r := true.B
										toRegsPort_notify_r := true.B
									}
								}
							}
						}
					}
				}
			}
		}
		when(state_r === fetch_17) {
			when(!(getEncType(io.fromMemoryPort.loadedData) === enc_r)) {
				when(!(getEncType(io.fromMemoryPort.loadedData) === enc_b)) {
					when(!(getEncType(io.fromMemoryPort.loadedData) === enc_s)) {
						when(!(getEncType(io.fromMemoryPort.loadedData) === enc_u)) {
							when(!(getEncType(io.fromMemoryPort.loadedData) === enc_j)) {
								when(!(getEncType(io.fromMemoryPort.loadedData) === enc_i_i)) {
									when((getEncType(io.fromMemoryPort.loadedData) === enc_i_l)) {
										when(io.fromMemoryPort_sync) {
											state_r := execute_11
											memoryAccess_signal_r.addrIn := getALUresult(alu_add,readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs1Addr(io.fromMemoryPort.loadedData)),getImmediate(io.fromMemoryPort.loadedData))
											memoryAccess_signal_r.dataIn := 0.U(32.W)
											memoryAccess_signal_r.mask := getMemoryMask(getInstrType(io.fromMemoryPort.loadedData))
											memoryAccess_signal_r.req := me_rd
											pcReg_signal_r := pcReg_signal_r
											regfileWrite_signal_r.dst := getRdAddr(io.fromMemoryPort.loadedData)
											regfileWrite_signal_r.dstData := regfileWrite_signal_r.dstData
											toMemoryPort_r.addrIn := getALUresult(alu_add,readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs1Addr(io.fromMemoryPort.loadedData)),getImmediate(io.fromMemoryPort.loadedData))
											toMemoryPort_r.dataIn := 0.U(32.W)
											toMemoryPort_r.mask := getMemoryMask(getInstrType(io.fromMemoryPort.loadedData))
											toMemoryPort_r.req := me_rd
											fromMemoryPort_notify_r := false.B
											toMemoryPort_notify_r := true.B
											toRegsPort_notify_r := false.B
										}
									}
								}
							}
						}
					}
				}
			}
		}
		when(state_r === fetch_17) {
			when(!(getEncType(io.fromMemoryPort.loadedData) === enc_r)) {
				when(!(getEncType(io.fromMemoryPort.loadedData) === enc_b)) {
					when(!(getEncType(io.fromMemoryPort.loadedData) === enc_s)) {
						when(!(getEncType(io.fromMemoryPort.loadedData) === enc_u)) {
							when(!(getEncType(io.fromMemoryPort.loadedData) === enc_j)) {
								when(!(getEncType(io.fromMemoryPort.loadedData) === enc_i_i)) {
									when(!(getEncType(io.fromMemoryPort.loadedData) === enc_i_l)) {
										when((getEncType(io.fromMemoryPort.loadedData) === enc_i_j)) {
											when(io.fromMemoryPort_sync) {
												state_r := fetch_16
												memoryAccess_signal_r.addrIn := (readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs1Addr(io.fromMemoryPort.loadedData)) + getImmediate(io.fromMemoryPort.loadedData))
												memoryAccess_signal_r.dataIn := 0.U(32.W)
												memoryAccess_signal_r.mask := mt_w
												memoryAccess_signal_r.req := me_rd
												pcReg_signal_r := (readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs1Addr(io.fromMemoryPort.loadedData)) + getImmediate(io.fromMemoryPort.loadedData))
												regfileWrite_signal_r.dst := getRdAddr(io.fromMemoryPort.loadedData)
												regfileWrite_signal_r.dstData := (4.U(32.W) + pcReg_signal_r)
												toMemoryPort_r.addrIn := (readRegfile(io.fromRegsPort.reg_file_01,io.fromRegsPort.reg_file_02,io.fromRegsPort.reg_file_03,io.fromRegsPort.reg_file_04,io.fromRegsPort.reg_file_05,io.fromRegsPort.reg_file_06,io.fromRegsPort.reg_file_07,io.fromRegsPort.reg_file_08,io.fromRegsPort.reg_file_09,io.fromRegsPort.reg_file_10,io.fromRegsPort.reg_file_11,io.fromRegsPort.reg_file_12,io.fromRegsPort.reg_file_13,io.fromRegsPort.reg_file_14,io.fromRegsPort.reg_file_15,io.fromRegsPort.reg_file_16,io.fromRegsPort.reg_file_17,io.fromRegsPort.reg_file_18,io.fromRegsPort.reg_file_19,io.fromRegsPort.reg_file_20,io.fromRegsPort.reg_file_21,io.fromRegsPort.reg_file_22,io.fromRegsPort.reg_file_23,io.fromRegsPort.reg_file_24,io.fromRegsPort.reg_file_25,io.fromRegsPort.reg_file_26,io.fromRegsPort.reg_file_27,io.fromRegsPort.reg_file_28,io.fromRegsPort.reg_file_29,io.fromRegsPort.reg_file_30,io.fromRegsPort.reg_file_31,getRs1Addr(io.fromMemoryPort.loadedData)) + getImmediate(io.fromMemoryPort.loadedData))
												toMemoryPort_r.dataIn := 0.U(32.W)
												toMemoryPort_r.mask := mt_w
												toMemoryPort_r.req := me_rd
												toRegsPort_r.dst := getRdAddr(io.fromMemoryPort.loadedData)
												toRegsPort_r.dstData := (4.U(32.W) + pcReg_signal_r)
												fromMemoryPort_notify_r := false.B
												toMemoryPort_notify_r := true.B
												toRegsPort_notify_r := true.B
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}

	core.dontTouch(memoryAccess_signal_r)
	core.dontTouch(pcReg_signal_r)
	core.dontTouch(regfileWrite_signal_r)

	io.fromMemoryPort_notify := fromMemoryPort_notify_r
	io.toMemoryPort_notify := toMemoryPort_notify_r
	io.toRegsPort_notify := toRegsPort_notify_r
	io.toMemoryPort := toMemoryPort_r
	io.toRegsPort := toRegsPort_r
}

object ISA extends App {
	chisel3.Driver.execute(args, () => new ISA)
}

