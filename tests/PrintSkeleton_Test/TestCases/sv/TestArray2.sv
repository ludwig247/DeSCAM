import scam_model_types::*;
import testarray2_types::*;

module TestArray2 (
	input logic clk,
	input logic rst,
	input integer b_in,
	input logic b_in_sync,
	output logic b_in_notify,
	output integer b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);

	int_5 myArray_signal;
	integer test_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			myArray_signal <= '{default:0};
			test_signal <= 2;
			b_in_notify <= 1'b1;
			b_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule