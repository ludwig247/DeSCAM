import scam_model_types::*;
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

	bit nb_result_signal;
	integer var_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			nb_result_signal <= 1'b0;
			var_signal <= 4;
			b_in_notify <= 1'b1;
			b_in2_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule