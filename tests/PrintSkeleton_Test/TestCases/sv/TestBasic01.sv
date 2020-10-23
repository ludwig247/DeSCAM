import top_level_types::*;
import testbasic01_types::*;

module TestBasic01 (
	input logic clk,
	input logic rst,
	input integer b_in,
	input logic b_in_sync,
	output logic b_in_notify
	);

	Phases phase_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			phase_signal <= section_a;
			b_in_notify <= 1'b1;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule