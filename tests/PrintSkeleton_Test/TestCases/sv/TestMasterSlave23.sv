import top_level_types::*;
import testmasterslave23_types::*;

module TestMasterSlave23 (
	input logic clk,
	input logic rst,
	input integer s_in_1,
	input logic s_in_1_sync,
	input integer s_in_2,
	input logic s_in_2_sync,
	input integer s_in_3,
	input logic s_in_3_sync
	);

	integer data3_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			data3_signal <= 0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule