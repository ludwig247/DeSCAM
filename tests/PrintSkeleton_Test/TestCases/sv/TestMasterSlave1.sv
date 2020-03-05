import top_level_types::*;
import testmasterslave1_types::*;

module TestMasterSlave1 (
	input logic clk,
	input logic rst,
	output integer s_out
	);



	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
		end else begin
				// FILL OUT HERE
		end
	end
endmodule