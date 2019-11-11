import scam_model_types::*;
import testbasic1_types::*;

module TestBasic1 (
	input logic clk,
	input logic rst,
	input integer b_in,
	input logic b_in_sync,
	output logic b_in_notify
	);

	Sections nextsection_signal;
	Sections section_signal;
	integer x_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			nextsection_signal <= section_a;
			section_signal <= section_a;
			x_signal <= 0;
			b_in_notify <= 1'b1;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule