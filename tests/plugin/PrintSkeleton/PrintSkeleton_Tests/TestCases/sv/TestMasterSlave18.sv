import top_level_types::*;
import testmasterslave18_types::*;

module TestMasterSlave18 (
	input logic clk,
	input logic rst,
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