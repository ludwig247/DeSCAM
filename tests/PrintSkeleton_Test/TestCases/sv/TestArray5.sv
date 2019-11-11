import scam_model_types::*;
import testarray5_types::*;

module TestArray5 (
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
	bit succ_signal;
	integer test_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			myArray_signal <= '{default:0};
			succ_signal <= 1'b0;
			test_signal <= 0;
			b_in_notify <= 1'b1;
			b_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule