import top_level_types::*;
import testbasic20_types::*;

module TestBasic20 (
	input logic clk,
	input logic rst,
	output CompoundType b_out,
	input logic b_out_sync,
	output logic b_out_notify,
	input CompoundType m_in
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