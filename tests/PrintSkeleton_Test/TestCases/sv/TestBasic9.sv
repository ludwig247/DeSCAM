import scam_model_types::*;
import testbasic9_types::*;

module TestBasic9 (
	input logic clk,
	input logic rst,
	input integer b_in,
	input logic b_in_sync,
	output logic b_in_notify,
	input integer m_in
	);

	bit nb_result_signal;
	integer var_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			nb_result_signal <= 1'b0;
			var_signal <= 1337;
			b_in_notify <= 1'b1;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule