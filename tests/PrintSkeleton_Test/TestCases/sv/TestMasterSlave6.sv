import top_level_types::*;
import testmasterslave6_types::*;

module TestMasterSlave6 (
	input logic clk,
	input logic rst,
	input integer s_in,
	input logic s_in_sync
	);

	Sections nextsection_signal;
	Sections section_signal;
	integer val_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			nextsection_signal <= section_a;
			section_signal <= section_a;
			val_signal <= 0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule