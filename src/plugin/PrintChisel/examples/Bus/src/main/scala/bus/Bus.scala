package bus
import chisel3._
import chisel3.util._

class Busreqt extends Bundle {
	val addr = SInt(32.W)
	val data = SInt(32.W)
	val trans_type = UInt(32.W)
}

class Busrespt extends Bundle {
	val ack = UInt(32.W)
	val data = SInt(32.W)
}

class Bus extends Module {
	val io = IO(new Bundle {
		val master_in_sync = Input(Bool())
		val master_out_sync = Input(Bool())
		val slave_in0_sync = Input(Bool())
		val slave_in1_sync = Input(Bool())
		val slave_in2_sync = Input(Bool())
		val slave_in3_sync = Input(Bool())
		val slave_out0_sync = Input(Bool())
		val slave_out1_sync = Input(Bool())
		val slave_out2_sync = Input(Bool())
		val slave_out3_sync = Input(Bool())
		val master_in_notify = Output(Bool())
		val master_out_notify = Output(Bool())
		val slave_in0_notify = Output(Bool())
		val slave_in1_notify = Output(Bool())
		val slave_in2_notify = Output(Bool())
		val slave_in3_notify = Output(Bool())
		val slave_out0_notify = Output(Bool())
		val slave_out1_notify = Output(Bool())
		val slave_out2_notify = Output(Bool())
		val slave_out3_notify = Output(Bool())
		val master_in = Input(new Busreqt())
		val master_out = Output(new Busrespt())
		val slave_in0 = Input(new Busrespt())
		val slave_in1 = Input(new Busrespt())
		val slave_in2 = Input(new Busrespt())
		val slave_in3 = Input(new Busrespt())
		val slave_out0 = Output(new Busreqt())
		val slave_out1 = Output(new Busreqt())
		val slave_out2 = Output(new Busreqt())
		val slave_out3 = Output(new Busreqt())
	})

	val master_in_notify_r = Reg(Bool())
	val master_out_notify_r = Reg(Bool())
	val slave_in0_notify_r = Reg(Bool())
	val slave_in1_notify_r = Reg(Bool())
	val slave_in2_notify_r = Reg(Bool())
	val slave_in3_notify_r = Reg(Bool())
	val slave_out0_notify_r = Reg(Bool())
	val slave_out1_notify_r = Reg(Bool())
	val slave_out2_notify_r = Reg(Bool())
	val slave_out3_notify_r = Reg(Bool())
	val master_out_r = Reg(new Busrespt())
	val slave_out0_r = Reg(new Busreqt())
	val slave_out1_r = Reg(new Busreqt())
	val slave_out2_r = Reg(new Busreqt())
	val slave_out3_r = Reg(new Busreqt())
	val req_signal_r = Reg(new Busreqt())
	val resp_signal_r = Reg(new Busrespt())
	val state_r = Reg(UInt())

	val single_read :: single_write ::  Nil = Enum(2)
	val ok :: rty :: err ::  Nil = Enum(3)
	val run_0 :: run_1 :: run_2 :: run_3 :: run_4 :: run_5 :: run_6 :: run_7 :: run_8 :: run_9 ::  Nil = Enum(10)

	when(reset.toBool) {
		state_r := run_0
		req_signal_r.addr := 0.S(32.W)
		req_signal_r.data := 0.S(32.W)
		req_signal_r.trans_type := single_read
		resp_signal_r.ack := err
		resp_signal_r.data := 0.S(32.W)
		master_in_notify_r := true.B
		master_out_notify_r := false.B
		slave_in0_notify_r := false.B
		slave_in1_notify_r := false.B
		slave_in2_notify_r := false.B
		slave_in3_notify_r := false.B
		slave_out0_notify_r := false.B
		slave_out1_notify_r := false.B
		slave_out2_notify_r := false.B
		slave_out3_notify_r := false.B
	}
	.otherwise {
		when(state_r === run_0) {
			when(!(single_read === io.master_in.trans_type)) {
				when((io.master_in.addr >= 0.S(32.W))) {
					when((io.master_in.addr <= 7.S(32.W))) {
						when(io.master_in_sync) {
							state_r := run_1
							req_signal_r.addr := io.master_in.addr
							req_signal_r.data := io.master_in.data
							req_signal_r.trans_type := io.master_in.trans_type
							resp_signal_r.ack := resp_signal_r.ack
							resp_signal_r.data := resp_signal_r.data
							slave_out0_r.addr := io.master_in.addr
							slave_out0_r.data := io.master_in.data
							slave_out0_r.trans_type := io.master_in.trans_type
							master_in_notify_r := false.B
							master_out_notify_r := false.B
							slave_in0_notify_r := false.B
							slave_in1_notify_r := false.B
							slave_in2_notify_r := false.B
							slave_in3_notify_r := false.B
							slave_out0_notify_r := true.B
							slave_out1_notify_r := false.B
							slave_out2_notify_r := false.B
							slave_out3_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_0) {
			when((single_read === io.master_in.trans_type)) {
				when((io.master_in.addr >= 0.S(32.W))) {
					when((io.master_in.addr <= 7.S(32.W))) {
						when(io.master_in_sync) {
							state_r := run_1
							req_signal_r.addr := io.master_in.addr
							req_signal_r.data := (0).S(32.W)
							req_signal_r.trans_type := io.master_in.trans_type
							resp_signal_r.ack := resp_signal_r.ack
							resp_signal_r.data := resp_signal_r.data
							slave_out0_r.addr := io.master_in.addr
							slave_out0_r.data := (0).S(32.W)
							slave_out0_r.trans_type := io.master_in.trans_type
							master_in_notify_r := false.B
							master_out_notify_r := false.B
							slave_in0_notify_r := false.B
							slave_in1_notify_r := false.B
							slave_in2_notify_r := false.B
							slave_in3_notify_r := false.B
							slave_out0_notify_r := true.B
							slave_out1_notify_r := false.B
							slave_out2_notify_r := false.B
							slave_out3_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_0) {
			when((single_read === io.master_in.trans_type)) {
				when(!((io.master_in.addr >= 0.S(32.W)) && !(8.S(32.W) <= io.master_in.addr))) {
					when(!((io.master_in.addr >= 8.S(32.W)) && !(16.S(32.W) <= io.master_in.addr))) {
						when(!((io.master_in.addr >= 16.S(32.W)) && !(24.S(32.W) <= io.master_in.addr))) {
							when(!((io.master_in.addr >= 24.S(32.W)) && !(32.S(32.W) <= io.master_in.addr))) {
								when(io.master_in_sync) {
									state_r := run_3
									master_out_r.ack := ok
									master_out_r.data := (0).S(32.W)
									req_signal_r.addr := io.master_in.addr
									req_signal_r.data := (0).S(32.W)
									req_signal_r.trans_type := io.master_in.trans_type
									resp_signal_r.ack := ok
									resp_signal_r.data := (0).S(32.W)
									master_in_notify_r := false.B
									master_out_notify_r := true.B
									slave_in0_notify_r := false.B
									slave_in1_notify_r := false.B
									slave_in2_notify_r := false.B
									slave_in3_notify_r := false.B
									slave_out0_notify_r := false.B
									slave_out1_notify_r := false.B
									slave_out2_notify_r := false.B
									slave_out3_notify_r := false.B
								}
							}
						}
					}
				}
			}
		}
		when(state_r === run_0) {
			when(!((io.master_in.addr >= 0.S(32.W)) && !(8.S(32.W) <= io.master_in.addr))) {
				when(!((io.master_in.addr >= 8.S(32.W)) && !(16.S(32.W) <= io.master_in.addr))) {
					when(!((io.master_in.addr >= 16.S(32.W)) && !(24.S(32.W) <= io.master_in.addr))) {
						when(!((io.master_in.addr >= 24.S(32.W)) && !(32.S(32.W) <= io.master_in.addr))) {
							when((single_write === io.master_in.trans_type)) {
								when(io.master_in_sync) {
									state_r := run_3
									master_out_r.ack := ok
									master_out_r.data := (0).S(32.W)
									req_signal_r.addr := io.master_in.addr
									req_signal_r.data := io.master_in.data
									req_signal_r.trans_type := io.master_in.trans_type
									resp_signal_r.ack := ok
									resp_signal_r.data := (0).S(32.W)
									master_in_notify_r := false.B
									master_out_notify_r := true.B
									slave_in0_notify_r := false.B
									slave_in1_notify_r := false.B
									slave_in2_notify_r := false.B
									slave_in3_notify_r := false.B
									slave_out0_notify_r := false.B
									slave_out1_notify_r := false.B
									slave_out2_notify_r := false.B
									slave_out3_notify_r := false.B
								}
							}
						}
					}
				}
			}
		}
		when(state_r === run_0) {
			when(!(single_read === io.master_in.trans_type)) {
				when((io.master_in.addr >= 8.S(32.W))) {
					when((io.master_in.addr <= 15.S(32.W))) {
						when(io.master_in_sync) {
							state_r := run_4
							req_signal_r.addr := ((-8).S(32.W) + io.master_in.addr)
							req_signal_r.data := io.master_in.data
							req_signal_r.trans_type := io.master_in.trans_type
							resp_signal_r.ack := resp_signal_r.ack
							resp_signal_r.data := resp_signal_r.data
							slave_out1_r.addr := ((-8).S(32.W) + io.master_in.addr)
							slave_out1_r.data := io.master_in.data
							slave_out1_r.trans_type := io.master_in.trans_type
							master_in_notify_r := false.B
							master_out_notify_r := false.B
							slave_in0_notify_r := false.B
							slave_in1_notify_r := false.B
							slave_in2_notify_r := false.B
							slave_in3_notify_r := false.B
							slave_out0_notify_r := false.B
							slave_out1_notify_r := true.B
							slave_out2_notify_r := false.B
							slave_out3_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_0) {
			when((single_read === io.master_in.trans_type)) {
				when((io.master_in.addr >= 8.S(32.W))) {
					when((io.master_in.addr <= 15.S(32.W))) {
						when(io.master_in_sync) {
							state_r := run_4
							req_signal_r.addr := ((-8).S(32.W) + io.master_in.addr)
							req_signal_r.data := (0).S(32.W)
							req_signal_r.trans_type := io.master_in.trans_type
							resp_signal_r.ack := resp_signal_r.ack
							resp_signal_r.data := resp_signal_r.data
							slave_out1_r.addr := ((-8).S(32.W) + io.master_in.addr)
							slave_out1_r.data := (0).S(32.W)
							slave_out1_r.trans_type := io.master_in.trans_type
							master_in_notify_r := false.B
							master_out_notify_r := false.B
							slave_in0_notify_r := false.B
							slave_in1_notify_r := false.B
							slave_in2_notify_r := false.B
							slave_in3_notify_r := false.B
							slave_out0_notify_r := false.B
							slave_out1_notify_r := true.B
							slave_out2_notify_r := false.B
							slave_out3_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_0) {
			when(!(single_read === io.master_in.trans_type)) {
				when((io.master_in.addr >= 16.S(32.W))) {
					when((io.master_in.addr <= 23.S(32.W))) {
						when(io.master_in_sync) {
							state_r := run_6
							req_signal_r.addr := ((-16).S(32.W) + io.master_in.addr)
							req_signal_r.data := io.master_in.data
							req_signal_r.trans_type := io.master_in.trans_type
							resp_signal_r.ack := resp_signal_r.ack
							resp_signal_r.data := resp_signal_r.data
							slave_out2_r.addr := ((-16).S(32.W) + io.master_in.addr)
							slave_out2_r.data := io.master_in.data
							slave_out2_r.trans_type := io.master_in.trans_type
							master_in_notify_r := false.B
							master_out_notify_r := false.B
							slave_in0_notify_r := false.B
							slave_in1_notify_r := false.B
							slave_in2_notify_r := false.B
							slave_in3_notify_r := false.B
							slave_out0_notify_r := false.B
							slave_out1_notify_r := false.B
							slave_out2_notify_r := true.B
							slave_out3_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_0) {
			when((single_read === io.master_in.trans_type)) {
				when((io.master_in.addr >= 16.S(32.W))) {
					when((io.master_in.addr <= 23.S(32.W))) {
						when(io.master_in_sync) {
							state_r := run_6
							req_signal_r.addr := ((-16).S(32.W) + io.master_in.addr)
							req_signal_r.data := (0).S(32.W)
							req_signal_r.trans_type := io.master_in.trans_type
							resp_signal_r.ack := resp_signal_r.ack
							resp_signal_r.data := resp_signal_r.data
							slave_out2_r.addr := ((-16).S(32.W) + io.master_in.addr)
							slave_out2_r.data := (0).S(32.W)
							slave_out2_r.trans_type := io.master_in.trans_type
							master_in_notify_r := false.B
							master_out_notify_r := false.B
							slave_in0_notify_r := false.B
							slave_in1_notify_r := false.B
							slave_in2_notify_r := false.B
							slave_in3_notify_r := false.B
							slave_out0_notify_r := false.B
							slave_out1_notify_r := false.B
							slave_out2_notify_r := true.B
							slave_out3_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_0) {
			when(!(single_read === io.master_in.trans_type)) {
				when((io.master_in.addr >= 24.S(32.W))) {
					when((io.master_in.addr <= 31.S(32.W))) {
						when(io.master_in_sync) {
							state_r := run_8
							req_signal_r.addr := ((-24).S(32.W) + io.master_in.addr)
							req_signal_r.data := io.master_in.data
							req_signal_r.trans_type := io.master_in.trans_type
							resp_signal_r.ack := resp_signal_r.ack
							resp_signal_r.data := resp_signal_r.data
							slave_out3_r.addr := ((-24).S(32.W) + io.master_in.addr)
							slave_out3_r.data := io.master_in.data
							slave_out3_r.trans_type := io.master_in.trans_type
							master_in_notify_r := false.B
							master_out_notify_r := false.B
							slave_in0_notify_r := false.B
							slave_in1_notify_r := false.B
							slave_in2_notify_r := false.B
							slave_in3_notify_r := false.B
							slave_out0_notify_r := false.B
							slave_out1_notify_r := false.B
							slave_out2_notify_r := false.B
							slave_out3_notify_r := true.B
						}
					}
				}
			}
		}
		when(state_r === run_0) {
			when((single_read === io.master_in.trans_type)) {
				when((io.master_in.addr >= 24.S(32.W))) {
					when((io.master_in.addr <= 31.S(32.W))) {
						when(io.master_in_sync) {
							state_r := run_8
							req_signal_r.addr := ((-24).S(32.W) + io.master_in.addr)
							req_signal_r.data := (0).S(32.W)
							req_signal_r.trans_type := io.master_in.trans_type
							resp_signal_r.ack := resp_signal_r.ack
							resp_signal_r.data := resp_signal_r.data
							slave_out3_r.addr := ((-24).S(32.W) + io.master_in.addr)
							slave_out3_r.data := (0).S(32.W)
							slave_out3_r.trans_type := io.master_in.trans_type
							master_in_notify_r := false.B
							master_out_notify_r := false.B
							slave_in0_notify_r := false.B
							slave_in1_notify_r := false.B
							slave_in2_notify_r := false.B
							slave_in3_notify_r := false.B
							slave_out0_notify_r := false.B
							slave_out1_notify_r := false.B
							slave_out2_notify_r := false.B
							slave_out3_notify_r := true.B
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when(io.slave_out0_sync) {
				state_r := run_2
				req_signal_r.addr := req_signal_r.addr
				req_signal_r.data := req_signal_r.data
				req_signal_r.trans_type := req_signal_r.trans_type
				resp_signal_r.ack := resp_signal_r.ack
				resp_signal_r.data := resp_signal_r.data
				master_in_notify_r := false.B
				master_out_notify_r := false.B
				slave_in0_notify_r := true.B
				slave_in1_notify_r := false.B
				slave_in2_notify_r := false.B
				slave_in3_notify_r := false.B
				slave_out0_notify_r := false.B
				slave_out1_notify_r := false.B
				slave_out2_notify_r := false.B
				slave_out3_notify_r := false.B
			}
		}
		when(state_r === run_2) {
			when(!(single_write === req_signal_r.trans_type)) {
				when(io.slave_in0_sync) {
					state_r := run_3
					master_out_r.ack := io.slave_in0.ack
					master_out_r.data := io.slave_in0.data
					req_signal_r.addr := req_signal_r.addr
					req_signal_r.data := req_signal_r.data
					req_signal_r.trans_type := req_signal_r.trans_type
					resp_signal_r.ack := io.slave_in0.ack
					resp_signal_r.data := io.slave_in0.data
					master_in_notify_r := false.B
					master_out_notify_r := true.B
					slave_in0_notify_r := false.B
					slave_in1_notify_r := false.B
					slave_in2_notify_r := false.B
					slave_in3_notify_r := false.B
					slave_out0_notify_r := false.B
					slave_out1_notify_r := false.B
					slave_out2_notify_r := false.B
					slave_out3_notify_r := false.B
				}
			}
		}
		when(state_r === run_2) {
			when((single_write === req_signal_r.trans_type)) {
				when(io.slave_in0_sync) {
					state_r := run_3
					master_out_r.ack := io.slave_in0.ack
					master_out_r.data := (0).S(32.W)
					req_signal_r.addr := req_signal_r.addr
					req_signal_r.data := req_signal_r.data
					req_signal_r.trans_type := req_signal_r.trans_type
					resp_signal_r.ack := io.slave_in0.ack
					resp_signal_r.data := (0).S(32.W)
					master_in_notify_r := false.B
					master_out_notify_r := true.B
					slave_in0_notify_r := false.B
					slave_in1_notify_r := false.B
					slave_in2_notify_r := false.B
					slave_in3_notify_r := false.B
					slave_out0_notify_r := false.B
					slave_out1_notify_r := false.B
					slave_out2_notify_r := false.B
					slave_out3_notify_r := false.B
				}
			}
		}
		when(state_r === run_3) {
			when(io.master_out_sync) {
				state_r := run_0
				req_signal_r.addr := req_signal_r.addr
				req_signal_r.data := req_signal_r.data
				req_signal_r.trans_type := req_signal_r.trans_type
				resp_signal_r.ack := resp_signal_r.ack
				resp_signal_r.data := resp_signal_r.data
				master_in_notify_r := true.B
				master_out_notify_r := false.B
				slave_in0_notify_r := false.B
				slave_in1_notify_r := false.B
				slave_in2_notify_r := false.B
				slave_in3_notify_r := false.B
				slave_out0_notify_r := false.B
				slave_out1_notify_r := false.B
				slave_out2_notify_r := false.B
				slave_out3_notify_r := false.B
			}
		}
		when(state_r === run_4) {
			when(io.slave_out1_sync) {
				state_r := run_5
				req_signal_r.addr := req_signal_r.addr
				req_signal_r.data := req_signal_r.data
				req_signal_r.trans_type := req_signal_r.trans_type
				resp_signal_r.ack := resp_signal_r.ack
				resp_signal_r.data := resp_signal_r.data
				master_in_notify_r := false.B
				master_out_notify_r := false.B
				slave_in0_notify_r := false.B
				slave_in1_notify_r := true.B
				slave_in2_notify_r := false.B
				slave_in3_notify_r := false.B
				slave_out0_notify_r := false.B
				slave_out1_notify_r := false.B
				slave_out2_notify_r := false.B
				slave_out3_notify_r := false.B
			}
		}
		when(state_r === run_5) {
			when(!(single_write === req_signal_r.trans_type)) {
				when(io.slave_in1_sync) {
					state_r := run_3
					master_out_r.ack := io.slave_in1.ack
					master_out_r.data := io.slave_in1.data
					req_signal_r.addr := req_signal_r.addr
					req_signal_r.data := req_signal_r.data
					req_signal_r.trans_type := req_signal_r.trans_type
					resp_signal_r.ack := io.slave_in1.ack
					resp_signal_r.data := io.slave_in1.data
					master_in_notify_r := false.B
					master_out_notify_r := true.B
					slave_in0_notify_r := false.B
					slave_in1_notify_r := false.B
					slave_in2_notify_r := false.B
					slave_in3_notify_r := false.B
					slave_out0_notify_r := false.B
					slave_out1_notify_r := false.B
					slave_out2_notify_r := false.B
					slave_out3_notify_r := false.B
				}
			}
		}
		when(state_r === run_5) {
			when((single_write === req_signal_r.trans_type)) {
				when(io.slave_in1_sync) {
					state_r := run_3
					master_out_r.ack := io.slave_in1.ack
					master_out_r.data := (0).S(32.W)
					req_signal_r.addr := req_signal_r.addr
					req_signal_r.data := req_signal_r.data
					req_signal_r.trans_type := req_signal_r.trans_type
					resp_signal_r.ack := io.slave_in1.ack
					resp_signal_r.data := (0).S(32.W)
					master_in_notify_r := false.B
					master_out_notify_r := true.B
					slave_in0_notify_r := false.B
					slave_in1_notify_r := false.B
					slave_in2_notify_r := false.B
					slave_in3_notify_r := false.B
					slave_out0_notify_r := false.B
					slave_out1_notify_r := false.B
					slave_out2_notify_r := false.B
					slave_out3_notify_r := false.B
				}
			}
		}
		when(state_r === run_6) {
			when(io.slave_out2_sync) {
				state_r := run_7
				req_signal_r.addr := req_signal_r.addr
				req_signal_r.data := req_signal_r.data
				req_signal_r.trans_type := req_signal_r.trans_type
				resp_signal_r.ack := resp_signal_r.ack
				resp_signal_r.data := resp_signal_r.data
				master_in_notify_r := false.B
				master_out_notify_r := false.B
				slave_in0_notify_r := false.B
				slave_in1_notify_r := false.B
				slave_in2_notify_r := true.B
				slave_in3_notify_r := false.B
				slave_out0_notify_r := false.B
				slave_out1_notify_r := false.B
				slave_out2_notify_r := false.B
				slave_out3_notify_r := false.B
			}
		}
		when(state_r === run_7) {
			when(!(single_write === req_signal_r.trans_type)) {
				when(io.slave_in2_sync) {
					state_r := run_3
					master_out_r.ack := io.slave_in2.ack
					master_out_r.data := io.slave_in2.data
					req_signal_r.addr := req_signal_r.addr
					req_signal_r.data := req_signal_r.data
					req_signal_r.trans_type := req_signal_r.trans_type
					resp_signal_r.ack := io.slave_in2.ack
					resp_signal_r.data := io.slave_in2.data
					master_in_notify_r := false.B
					master_out_notify_r := true.B
					slave_in0_notify_r := false.B
					slave_in1_notify_r := false.B
					slave_in2_notify_r := false.B
					slave_in3_notify_r := false.B
					slave_out0_notify_r := false.B
					slave_out1_notify_r := false.B
					slave_out2_notify_r := false.B
					slave_out3_notify_r := false.B
				}
			}
		}
		when(state_r === run_7) {
			when((single_write === req_signal_r.trans_type)) {
				when(io.slave_in2_sync) {
					state_r := run_3
					master_out_r.ack := io.slave_in2.ack
					master_out_r.data := (0).S(32.W)
					req_signal_r.addr := req_signal_r.addr
					req_signal_r.data := req_signal_r.data
					req_signal_r.trans_type := req_signal_r.trans_type
					resp_signal_r.ack := io.slave_in2.ack
					resp_signal_r.data := (0).S(32.W)
					master_in_notify_r := false.B
					master_out_notify_r := true.B
					slave_in0_notify_r := false.B
					slave_in1_notify_r := false.B
					slave_in2_notify_r := false.B
					slave_in3_notify_r := false.B
					slave_out0_notify_r := false.B
					slave_out1_notify_r := false.B
					slave_out2_notify_r := false.B
					slave_out3_notify_r := false.B
				}
			}
		}
		when(state_r === run_8) {
			when(io.slave_out3_sync) {
				state_r := run_9
				req_signal_r.addr := req_signal_r.addr
				req_signal_r.data := req_signal_r.data
				req_signal_r.trans_type := req_signal_r.trans_type
				resp_signal_r.ack := resp_signal_r.ack
				resp_signal_r.data := resp_signal_r.data
				master_in_notify_r := false.B
				master_out_notify_r := false.B
				slave_in0_notify_r := false.B
				slave_in1_notify_r := false.B
				slave_in2_notify_r := false.B
				slave_in3_notify_r := true.B
				slave_out0_notify_r := false.B
				slave_out1_notify_r := false.B
				slave_out2_notify_r := false.B
				slave_out3_notify_r := false.B
			}
		}
		when(state_r === run_9) {
			when(!(single_write === req_signal_r.trans_type)) {
				when(io.slave_in3_sync) {
					state_r := run_3
					master_out_r.ack := io.slave_in3.ack
					master_out_r.data := io.slave_in3.data
					req_signal_r.addr := req_signal_r.addr
					req_signal_r.data := req_signal_r.data
					req_signal_r.trans_type := req_signal_r.trans_type
					resp_signal_r.ack := io.slave_in3.ack
					resp_signal_r.data := io.slave_in3.data
					master_in_notify_r := false.B
					master_out_notify_r := true.B
					slave_in0_notify_r := false.B
					slave_in1_notify_r := false.B
					slave_in2_notify_r := false.B
					slave_in3_notify_r := false.B
					slave_out0_notify_r := false.B
					slave_out1_notify_r := false.B
					slave_out2_notify_r := false.B
					slave_out3_notify_r := false.B
				}
			}
		}
		when(state_r === run_9) {
			when((single_write === req_signal_r.trans_type)) {
				when(io.slave_in3_sync) {
					state_r := run_3
					master_out_r.ack := io.slave_in3.ack
					master_out_r.data := (0).S(32.W)
					req_signal_r.addr := req_signal_r.addr
					req_signal_r.data := req_signal_r.data
					req_signal_r.trans_type := req_signal_r.trans_type
					resp_signal_r.ack := io.slave_in3.ack
					resp_signal_r.data := (0).S(32.W)
					master_in_notify_r := false.B
					master_out_notify_r := true.B
					slave_in0_notify_r := false.B
					slave_in1_notify_r := false.B
					slave_in2_notify_r := false.B
					slave_in3_notify_r := false.B
					slave_out0_notify_r := false.B
					slave_out1_notify_r := false.B
					slave_out2_notify_r := false.B
					slave_out3_notify_r := false.B
				}
			}
		}
	}

	core.dontTouch(req_signal_r)
	core.dontTouch(resp_signal_r)

	io.master_in_notify := master_in_notify_r
	io.master_out_notify := master_out_notify_r
	io.slave_in0_notify := slave_in0_notify_r
	io.slave_in1_notify := slave_in1_notify_r
	io.slave_in2_notify := slave_in2_notify_r
	io.slave_in3_notify := slave_in3_notify_r
	io.slave_out0_notify := slave_out0_notify_r
	io.slave_out1_notify := slave_out1_notify_r
	io.slave_out2_notify := slave_out2_notify_r
	io.slave_out3_notify := slave_out3_notify_r
	io.master_out := master_out_r
	io.slave_out0 := slave_out0_r
	io.slave_out1 := slave_out1_r
	io.slave_out2 := slave_out2_r
	io.slave_out3 := slave_out3_r
}

object Bus extends App {
	chisel3.Driver.execute(args, () => new Bus)
}

