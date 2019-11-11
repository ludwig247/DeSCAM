import scam_model_types::*;
import testarray4_types::*;

module TestArray4 (
	input logic clk,
	input logic rst,
	input integer m_in,
	input logic m_in_sync,
	output logic m_in_notify,
	output int_5 m_out,
	input logic m_out_sync,
	output logic m_out_notify
	);

	int_5 myArray_signal;
	integer test_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			myArray_signal <= '{default:0};
			test_signal <= 0;
			m_in_notify <= 1'b1;
			m_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule