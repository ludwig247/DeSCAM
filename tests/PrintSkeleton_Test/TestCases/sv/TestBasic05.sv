import top_level_types::*;
import testbasic05_types::*;

module TestBasic05 (
	input logic clk,
	input logic rst,
	input integer b_in,
	input logic b_in_sync,
	output logic b_in_notify,
	output integer b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);



	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			b_in_notify <= 1'b1;
			b_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule