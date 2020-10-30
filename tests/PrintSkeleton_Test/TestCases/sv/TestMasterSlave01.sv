import top_level_types::*;
import testmasterslave01_types::*;

module TestMasterSlave01 (
	input logic clk,
	input logic rst,
	output integer s_out
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