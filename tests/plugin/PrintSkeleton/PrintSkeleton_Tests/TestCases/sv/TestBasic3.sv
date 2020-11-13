import top_level_types::*;
import testbasic3_types::*;

module TestBasic3 (
	input logic clk,
	input logic rst,
	output integer b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);



	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			b_out_notify <= 1'b1;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule