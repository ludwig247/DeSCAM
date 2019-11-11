import scam_model_types::*;
import testfunction0_types::*;

module TestFunction0 (
	input logic clk,
	input logic rst,
	input integer b_in,
	input logic b_in_sync,
	output logic b_in_notify,
	output bit[31:0] b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);

	integer x_signal;
	bit[31:0] y_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			x_signal <= 0;
			y_signal <= 0;
			b_in_notify <= 1'b1;
			b_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule