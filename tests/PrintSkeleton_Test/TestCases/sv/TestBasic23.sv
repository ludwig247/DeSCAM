import scam_model_types::*;
import testbasic23_types::*;

module TestBasic23 (
	input logic clk,
	input logic rst,
	output bit[31:0] b_out,
	input logic b_out_sync,
	output logic b_out_notify,
	output integer b_out2,
	input logic b_out2_sync,
	output logic b_out2_notify
	);

	Sections nextsection_signal;
	Sections section_signal;
	integer val_signed_signal;
	bit[31:0] val_unsigned_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			nextsection_signal <= section_a;
			section_signal <= section_a;
			val_signed_signal <= -7;
			val_unsigned_signal <= 13;
			b_out_notify <= 1'b1;
			b_out2_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule