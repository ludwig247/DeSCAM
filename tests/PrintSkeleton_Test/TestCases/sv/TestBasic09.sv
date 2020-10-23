import top_level_types::*;
import testbasic09_types::*;

module TestBasic09 (
	input logic clk,
	input logic rst,
	input integer b_in,
	input logic b_in_sync,
	output logic b_in_notify,
	input integer m_in
	);



	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			b_in_notify <= 1'b1;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule