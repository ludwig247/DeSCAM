import top_level_types::*;
import testbasic00_types::*;

module TestBasic00 (
	input logic clk,
	input logic rst,
	output integer b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);

	Phases phase_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			phase_signal <= section_a;
			b_out_notify <= 1'b1;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule