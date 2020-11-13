import top_level_types::*;
import testbasic11_types::*;

module TestBasic11 (
	input logic clk,
	input logic rst,
	output CompoundType b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);

	CompoundType compoundType_signal;
	Phases nextphase_signal;
	Phases phase_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			compoundType_signal.mode <= read;
			compoundType_signal.x <= 0;
			compoundType_signal.y <= 1'b0;
			nextphase_signal <= section_a;
			phase_signal <= section_a;
			b_out_notify <= 1'b1;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule