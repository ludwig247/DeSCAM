import scam_model_types::*;
import testarray0_types::*;

module TestArray0 (
	input logic clk,
	input logic rst,
	input integer b_in,
	input logic b_in_sync,
	output logic b_in_notify,
	output int_2 b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);

	int_2 myArray_signal;
	integer test_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			myArray_signal <= '{default:0};
			test_signal <= 0;
			b_in_notify <= 1'b1;
			b_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule