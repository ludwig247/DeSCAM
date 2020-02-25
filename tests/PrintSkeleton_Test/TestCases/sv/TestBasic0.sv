import top_level_types::*;
import testbasic0_types::*;

module TestBasic0 (
	input logic clk,
	input logic rst,
	output integer b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);

	Sections section_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section_signal <= section_a;
			b_out_notify <= 1'b1;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule