import top_level_types::*;
import testmasterslave06_types::*;

module TestMasterSlave06 (
	input logic clk,
	input logic rst,
	input integer s_in,
	input logic s_in_sync
	);

	Phases phase_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			phase_signal <= section_a;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule