import top_level_types::*;
import testbasic14_types::*;

module TestBasic14 (
	input logic clk,
	input logic rst,
	input CompoundType b_in,
	input logic b_in_sync,
	output logic b_in_notify,
	output CompoundType b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);

	Phases nextphase_signal;
	Phases phase_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			nextphase_signal <= section_a;
			phase_signal <= section_a;
			b_in_notify <= 1'b1;
			b_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule