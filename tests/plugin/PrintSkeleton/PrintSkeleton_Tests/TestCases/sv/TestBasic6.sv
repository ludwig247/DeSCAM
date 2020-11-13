import top_level_types::*;
import testbasic6_types::*;

module TestBasic6 (
	input logic clk,
	input logic rst,
	input integer b_in,
	input logic b_in_sync,
	output logic b_in_notify,
	input integer b_in2,
	input logic b_in2_sync,
	output logic b_in2_notify
	);



	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			b_in_notify <= 1'b1;
			b_in2_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule