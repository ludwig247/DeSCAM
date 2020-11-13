import top_level_types::*;
import testmasterslave24_types::*;

module TestMasterSlave24 (
	input logic clk,
	input logic rst,
	input integer s_in_1,
	input logic s_in_1_sync,
	input integer s_in_2,
	input logic s_in_2_sync,
	input integer s_in_3,
	input logic s_in_3_sync,
	output integer s_out_1,
	output integer s_out_2,
	output integer s_out_3
	);

	integer data1_signal;
	integer data2_signal;
	integer data3_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			data1_signal <= 0;
			data2_signal <= 0;
			data3_signal <= 0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule