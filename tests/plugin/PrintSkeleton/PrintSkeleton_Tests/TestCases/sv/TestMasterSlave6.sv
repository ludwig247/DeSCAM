import top_level_types::*;
import testmasterslave6_types::*;

module TestMasterSlave6 (
	input logic clk,
	input logic rst,
	input integer s_in,
	input logic s_in_sync
	);

	Sections section_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section_signal <= section_a;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule