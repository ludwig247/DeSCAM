import top_level_types::*;
import testbasic1_types::*;

module TestBasic1 (
	input logic clk,
	input logic rst,
	input integer b_in,
	input logic b_in_sync,
	output logic b_in_notify
	);

	Sections section_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section_signal <= section_a;
			b_in_notify <= 1'b1;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule