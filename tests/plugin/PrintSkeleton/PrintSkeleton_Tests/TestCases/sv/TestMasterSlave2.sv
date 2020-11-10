import top_level_types::*;
import testmasterslave2_types::*;

module TestMasterSlave2 (
	input logic clk,
	input logic rst,
	output integer s_out
	);

	Sections section_signal;
	integer val_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section_signal <= section_a;
			val_signal <= 1337;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule