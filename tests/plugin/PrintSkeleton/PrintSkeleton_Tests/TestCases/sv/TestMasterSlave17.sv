import top_level_types::*;
import testmasterslave17_types::*;

module TestMasterSlave17 (
	input logic clk,
	input logic rst,
	output bus_req_t s_out_1,
	output bus_req_t s_out_2,
	output bus_req_t s_out_3
	);

	bus_req_t data1_signal;
	bus_req_t data2_signal;
	bus_req_t data3_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			data1_signal.data <= 0;
			data1_signal.trans_type <= single_read;
			data2_signal.data <= 0;
			data2_signal.trans_type <= single_read;
			data3_signal.data <= 0;
			data3_signal.trans_type <= single_read;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule