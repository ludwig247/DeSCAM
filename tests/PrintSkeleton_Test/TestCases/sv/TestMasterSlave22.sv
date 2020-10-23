import top_level_types::*;
import testmasterslave22_types::*;

module TestMasterSlave22 (
	input logic clk,
	input logic rst,
	input integer s_in_1,
	input logic s_in_1_sync,
	input integer s_in_2,
	input logic s_in_2_sync,
	input integer s_in_3,
	input logic s_in_3_sync
	);



	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
		end else begin
				// FILL OUT HERE
		end
	end
endmodule