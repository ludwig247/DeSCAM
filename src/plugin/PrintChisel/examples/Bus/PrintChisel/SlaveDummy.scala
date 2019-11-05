package slavedummy
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

class SlaveDummy extends Module {
	val io = IO(new Bundle {
		val bus_req_sync = Input(Bool())
		val bus_resp_sync = Input(Bool())
		val bus_req_notify = Output(Bool())
		val bus_resp_notify = Output(Bool())
		val bus_req = Input(new Busreqt())
		val bus_resp = Output(new Busrespt())
	})

	val bus_req_notify_r = Reg(Bool())
	val bus_resp_notify_r = Reg(Bool())
	val bus_resp_r = Reg(new Busrespt())
	val resp_signal_r = Reg(new Busrespt())
	val state_r = Reg(UInt())

	val single_read :: single_write ::  Nil = Enum(2)
	val ok :: rty :: err ::  Nil = Enum(3)
	val run_0 :: run_1 ::  Nil = Enum(2)

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
	when(reset.toBool) {
		state_r := run_0
		bus_req_r.addr := 8.S(32.W)
		bus_req_r.data := 1.S(32.W)
		bus_req_r.trans_type := single_write
		cnt_signal_r := 1.S(32.W)
		req_signal_r.addr := 8.S(32.W)
		req_signal_r.data := 1.S(32.W)
		req_signal_r.trans_type := single_write
		bus_req_notify_r := true.B
		bus_resp_notify_r := false.B
	}
	.otherwise {
		when(state_r === run_0) {
			when(io.bus_req_sync) {
				state_r := run_1
				cnt_signal_r := cnt_signal_r
				req_signal_r.addr := req_signal_r.addr
				req_signal_r.data := req_signal_r.data
				req_signal_r.trans_type := req_signal_r.trans_type
				bus_req_notify_r := false.B
				bus_resp_notify_r := true.B
			}
		}
		when(state_r === run_1) {
			when((req_signal_r.trans_type === single_read)) {
				when((cnt_signal_r === 10000000.S(32.W))) {
					when((req_signal_r.addr === 0.S(32.W))) {
						when(io.bus_resp_sync) {
							state_r := run_0
							bus_req_r.addr := (8).S(32.W)
							bus_req_r.data := (10000000).S(32.W)
							bus_req_r.trans_type := single_write
							cnt_signal_r := (10000000).S(32.W)
							req_signal_r.addr := (8).S(32.W)
							req_signal_r.data := (10000000).S(32.W)
							req_signal_r.trans_type := single_write
							bus_req_notify_r := true.B
							bus_resp_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when(!(req_signal_r.trans_type === single_read)) {
				when((cnt_signal_r === 10000000.S(32.W))) {
					when((req_signal_r.addr === 0.S(32.W))) {
						when(io.bus_resp_sync) {
							state_r := run_0
							bus_req_r.addr := (8).S(32.W)
							bus_req_r.data := (10000000).S(32.W)
							bus_req_r.trans_type := single_read
							cnt_signal_r := (10000000).S(32.W)
							req_signal_r.addr := (8).S(32.W)
							req_signal_r.data := (10000000).S(32.W)
							req_signal_r.trans_type := single_read
							bus_req_notify_r := true.B
							bus_resp_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when(!(cnt_signal_r === 10000000.S(32.W))) {
				when((req_signal_r.trans_type === single_read)) {
					when((req_signal_r.addr === 0.S(32.W))) {
						when(io.bus_resp_sync) {
							state_r := run_0
							bus_req_r.addr := (8).S(32.W)
							bus_req_r.data := ((1).S(32.W) + cnt_signal_r)
							bus_req_r.trans_type := single_write
							cnt_signal_r := ((1).S(32.W) + cnt_signal_r)
							req_signal_r.addr := (8).S(32.W)
							req_signal_r.data := ((1).S(32.W) + cnt_signal_r)
							req_signal_r.trans_type := single_write
							bus_req_notify_r := true.B
							bus_resp_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when(!(cnt_signal_r === 10000000.S(32.W))) {
				when(!(req_signal_r.trans_type === single_read)) {
					when((req_signal_r.addr === 0.S(32.W))) {
						when(io.bus_resp_sync) {
							state_r := run_0
							bus_req_r.addr := (8).S(32.W)
							bus_req_r.data := ((1).S(32.W) + cnt_signal_r)
							bus_req_r.trans_type := single_read
							cnt_signal_r := ((1).S(32.W) + cnt_signal_r)
							req_signal_r.addr := (8).S(32.W)
							req_signal_r.data := ((1).S(32.W) + cnt_signal_r)
							req_signal_r.trans_type := single_read
							bus_req_notify_r := true.B
							bus_resp_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when((req_signal_r.trans_type === single_read)) {
				when((cnt_signal_r === 10000000.S(32.W))) {
					when((req_signal_r.addr === 8.S(32.W))) {
						when(io.bus_resp_sync) {
							state_r := run_0
							bus_req_r.addr := (16).S(32.W)
							bus_req_r.data := (10000000).S(32.W)
							bus_req_r.trans_type := single_write
							cnt_signal_r := (10000000).S(32.W)
							req_signal_r.addr := (16).S(32.W)
							req_signal_r.data := (10000000).S(32.W)
							req_signal_r.trans_type := single_write
							bus_req_notify_r := true.B
							bus_resp_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when(!(req_signal_r.trans_type === single_read)) {
				when((cnt_signal_r === 10000000.S(32.W))) {
					when((req_signal_r.addr === 8.S(32.W))) {
						when(io.bus_resp_sync) {
							state_r := run_0
							bus_req_r.addr := (16).S(32.W)
							bus_req_r.data := (10000000).S(32.W)
							bus_req_r.trans_type := single_read
							cnt_signal_r := (10000000).S(32.W)
							req_signal_r.addr := (16).S(32.W)
							req_signal_r.data := (10000000).S(32.W)
							req_signal_r.trans_type := single_read
							bus_req_notify_r := true.B
							bus_resp_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when(!(cnt_signal_r === 10000000.S(32.W))) {
				when((req_signal_r.trans_type === single_read)) {
					when((req_signal_r.addr === 8.S(32.W))) {
						when(io.bus_resp_sync) {
							state_r := run_0
							bus_req_r.addr := (16).S(32.W)
							bus_req_r.data := ((1).S(32.W) + cnt_signal_r)
							bus_req_r.trans_type := single_write
							cnt_signal_r := ((1).S(32.W) + cnt_signal_r)
							req_signal_r.addr := (16).S(32.W)
							req_signal_r.data := ((1).S(32.W) + cnt_signal_r)
							req_signal_r.trans_type := single_write
							bus_req_notify_r := true.B
							bus_resp_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when(!(cnt_signal_r === 10000000.S(32.W))) {
				when(!(req_signal_r.trans_type === single_read)) {
					when((req_signal_r.addr === 8.S(32.W))) {
						when(io.bus_resp_sync) {
							state_r := run_0
							bus_req_r.addr := (16).S(32.W)
							bus_req_r.data := ((1).S(32.W) + cnt_signal_r)
							bus_req_r.trans_type := single_read
							cnt_signal_r := ((1).S(32.W) + cnt_signal_r)
							req_signal_r.addr := (16).S(32.W)
							req_signal_r.data := ((1).S(32.W) + cnt_signal_r)
							req_signal_r.trans_type := single_read
							bus_req_notify_r := true.B
							bus_resp_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when((req_signal_r.trans_type === single_read)) {
				when((cnt_signal_r === 10000000.S(32.W))) {
					when((req_signal_r.addr === 16.S(32.W))) {
						when(io.bus_resp_sync) {
							state_r := run_0
							bus_req_r.addr := (25).S(32.W)
							bus_req_r.data := (10000000).S(32.W)
							bus_req_r.trans_type := single_write
							cnt_signal_r := (10000000).S(32.W)
							req_signal_r.addr := (25).S(32.W)
							req_signal_r.data := (10000000).S(32.W)
							req_signal_r.trans_type := single_write
							bus_req_notify_r := true.B
							bus_resp_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when(!(req_signal_r.trans_type === single_read)) {
				when((cnt_signal_r === 10000000.S(32.W))) {
					when((req_signal_r.addr === 16.S(32.W))) {
						when(io.bus_resp_sync) {
							state_r := run_0
							bus_req_r.addr := (25).S(32.W)
							bus_req_r.data := (10000000).S(32.W)
							bus_req_r.trans_type := single_read
							cnt_signal_r := (10000000).S(32.W)
							req_signal_r.addr := (25).S(32.W)
							req_signal_r.data := (10000000).S(32.W)
							req_signal_r.trans_type := single_read
							bus_req_notify_r := true.B
							bus_resp_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when(!(cnt_signal_r === 10000000.S(32.W))) {
				when((req_signal_r.trans_type === single_read)) {
					when((req_signal_r.addr === 16.S(32.W))) {
						when(io.bus_resp_sync) {
							state_r := run_0
							bus_req_r.addr := (25).S(32.W)
							bus_req_r.data := ((1).S(32.W) + cnt_signal_r)
							bus_req_r.trans_type := single_write
							cnt_signal_r := ((1).S(32.W) + cnt_signal_r)
							req_signal_r.addr := (25).S(32.W)
							req_signal_r.data := ((1).S(32.W) + cnt_signal_r)
							req_signal_r.trans_type := single_write
							bus_req_notify_r := true.B
							bus_resp_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when(!(cnt_signal_r === 10000000.S(32.W))) {
				when(!(req_signal_r.trans_type === single_read)) {
					when((req_signal_r.addr === 16.S(32.W))) {
						when(io.bus_resp_sync) {
							state_r := run_0
							bus_req_r.addr := (25).S(32.W)
							bus_req_r.data := ((1).S(32.W) + cnt_signal_r)
							bus_req_r.trans_type := single_read
							cnt_signal_r := ((1).S(32.W) + cnt_signal_r)
							req_signal_r.addr := (25).S(32.W)
							req_signal_r.data := ((1).S(32.W) + cnt_signal_r)
							req_signal_r.trans_type := single_read
							bus_req_notify_r := true.B
							bus_resp_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when((req_signal_r.trans_type === single_read)) {
				when((cnt_signal_r === 10000000.S(32.W))) {
					when((req_signal_r.addr === 25.S(32.W))) {
						when(io.bus_resp_sync) {
							state_r := run_0
							bus_req_r.addr := (0).S(32.W)
							bus_req_r.data := (10000000).S(32.W)
							bus_req_r.trans_type := single_write
							cnt_signal_r := (10000000).S(32.W)
							req_signal_r.addr := (0).S(32.W)
							req_signal_r.data := (10000000).S(32.W)
							req_signal_r.trans_type := single_write
							bus_req_notify_r := true.B
							bus_resp_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when(!(req_signal_r.trans_type === single_read)) {
				when((cnt_signal_r === 10000000.S(32.W))) {
					when((req_signal_r.addr === 25.S(32.W))) {
						when(io.bus_resp_sync) {
							state_r := run_0
							bus_req_r.addr := (0).S(32.W)
							bus_req_r.data := (10000000).S(32.W)
							bus_req_r.trans_type := single_read
							cnt_signal_r := (10000000).S(32.W)
							req_signal_r.addr := (0).S(32.W)
							req_signal_r.data := (10000000).S(32.W)
							req_signal_r.trans_type := single_read
							bus_req_notify_r := true.B
							bus_resp_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when(!(req_signal_r.addr === 0.S(32.W))) {
				when(!(req_signal_r.addr === 8.S(32.W))) {
					when(!(req_signal_r.addr === 16.S(32.W))) {
						when(!(req_signal_r.addr === 25.S(32.W))) {
							when((req_signal_r.trans_type === single_read)) {
								when((cnt_signal_r === 10000000.S(32.W))) {
									when(io.bus_resp_sync) {
										state_r := run_0
										bus_req_r.addr := (0).S(32.W)
										bus_req_r.data := (10000000).S(32.W)
										bus_req_r.trans_type := single_write
										cnt_signal_r := (10000000).S(32.W)
										req_signal_r.addr := (0).S(32.W)
										req_signal_r.data := (10000000).S(32.W)
										req_signal_r.trans_type := single_write
										bus_req_notify_r := true.B
										bus_resp_notify_r := false.B
									}
								}
							}
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when(!(req_signal_r.addr === 0.S(32.W))) {
				when(!(req_signal_r.addr === 8.S(32.W))) {
					when(!(req_signal_r.addr === 16.S(32.W))) {
						when(!(req_signal_r.addr === 25.S(32.W))) {
							when(!(req_signal_r.trans_type === single_read)) {
								when((cnt_signal_r === 10000000.S(32.W))) {
									when(io.bus_resp_sync) {
										state_r := run_0
										bus_req_r.addr := (0).S(32.W)
										bus_req_r.data := (10000000).S(32.W)
										bus_req_r.trans_type := single_read
										cnt_signal_r := (10000000).S(32.W)
										req_signal_r.addr := (0).S(32.W)
										req_signal_r.data := (10000000).S(32.W)
										req_signal_r.trans_type := single_read
										bus_req_notify_r := true.B
										bus_resp_notify_r := false.B
									}
								}
							}
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when(!(cnt_signal_r === 10000000.S(32.W))) {
				when((req_signal_r.trans_type === single_read)) {
					when((req_signal_r.addr === 25.S(32.W))) {
						when(io.bus_resp_sync) {
							state_r := run_0
							bus_req_r.addr := (0).S(32.W)
							bus_req_r.data := ((1).S(32.W) + cnt_signal_r)
							bus_req_r.trans_type := single_write
							cnt_signal_r := ((1).S(32.W) + cnt_signal_r)
							req_signal_r.addr := (0).S(32.W)
							req_signal_r.data := ((1).S(32.W) + cnt_signal_r)
							req_signal_r.trans_type := single_write
							bus_req_notify_r := true.B
							bus_resp_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when(!(cnt_signal_r === 10000000.S(32.W))) {
				when(!(req_signal_r.trans_type === single_read)) {
					when((req_signal_r.addr === 25.S(32.W))) {
						when(io.bus_resp_sync) {
							state_r := run_0
							bus_req_r.addr := (0).S(32.W)
							bus_req_r.data := ((1).S(32.W) + cnt_signal_r)
							bus_req_r.trans_type := single_read
							cnt_signal_r := ((1).S(32.W) + cnt_signal_r)
							req_signal_r.addr := (0).S(32.W)
							req_signal_r.data := ((1).S(32.W) + cnt_signal_r)
							req_signal_r.trans_type := single_read
							bus_req_notify_r := true.B
							bus_resp_notify_r := false.B
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when(!(cnt_signal_r === 10000000.S(32.W))) {
				when(!(req_signal_r.addr === 0.S(32.W))) {
					when(!(req_signal_r.addr === 8.S(32.W))) {
						when(!(req_signal_r.addr === 16.S(32.W))) {
							when(!(req_signal_r.addr === 25.S(32.W))) {
								when((req_signal_r.trans_type === single_read)) {
									when(io.bus_resp_sync) {
										state_r := run_0
										bus_req_r.addr := (0).S(32.W)
										bus_req_r.data := ((1).S(32.W) + cnt_signal_r)
										bus_req_r.trans_type := single_write
										cnt_signal_r := ((1).S(32.W) + cnt_signal_r)
										req_signal_r.addr := (0).S(32.W)
										req_signal_r.data := ((1).S(32.W) + cnt_signal_r)
										req_signal_r.trans_type := single_write
										bus_req_notify_r := true.B
										bus_resp_notify_r := false.B
									}
								}
							}
						}
					}
				}
			}
		}
		when(state_r === run_1) {
			when(!(cnt_signal_r === 10000000.S(32.W))) {
				when(!(req_signal_r.addr === 0.S(32.W))) {
					when(!(req_signal_r.addr === 8.S(32.W))) {
						when(!(req_signal_r.addr === 16.S(32.W))) {
							when(!(req_signal_r.addr === 25.S(32.W))) {
								when(!(req_signal_r.trans_type === single_read)) {
									when(io.bus_resp_sync) {
										state_r := run_0
										bus_req_r.addr := (0).S(32.W)
										bus_req_r.data := ((1).S(32.W) + cnt_signal_r)
										bus_req_r.trans_type := single_read
										cnt_signal_r := ((1).S(32.W) + cnt_signal_r)
										req_signal_r.addr := (0).S(32.W)
										req_signal_r.data := ((1).S(32.W) + cnt_signal_r)
										req_signal_r.trans_type := single_read
										bus_req_notify_r := true.B
										bus_resp_notify_r := false.B
									}
								}
							}
						}
					}
				}
			}
		}
	when(reset.toBool) {
		state_r := run_0
		resp_signal_r.ack := err
		resp_signal_r.data := 0.S(32.W)
		bus_req_notify_r := true.B
		bus_resp_notify_r := false.B
	}
	.otherwise {
		when(state_r === run_0) {
			when(io.bus_req_sync) {
				state_r := run_1
				bus_resp_r.ack := ok
				bus_resp_r.data := io.bus_req.data
				resp_signal_r.ack := ok
				resp_signal_r.data := io.bus_req.data
				bus_req_notify_r := false.B
				bus_resp_notify_r := true.B
			}
		}
		when(state_r === run_1) {
			when(io.bus_resp_sync) {
				state_r := run_0
				resp_signal_r.ack := resp_signal_r.ack
				resp_signal_r.data := resp_signal_r.data
				bus_req_notify_r := true.B
				bus_resp_notify_r := false.B
			}
		}
	}

	core.dontTouch(resp_signal_r)

	io.bus_req_notify := bus_req_notify_r
	io.bus_resp_notify := bus_resp_notify_r
	io.bus_resp := bus_resp_r
}

object SlaveDummy extends App {
	chisel3.Driver.execute(args, () => new SlaveDummy)
}

