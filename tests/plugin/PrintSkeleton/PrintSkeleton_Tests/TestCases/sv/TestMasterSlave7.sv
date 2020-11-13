import top_level_types::*;
import testmasterslave7_types::*;

module TestMasterSlave7 (
	input logic clk,
	input logic rst,
	input integer s_in,
	input logic s_in_sync,
	output integer s_out
	);

	Sections section_signal;
	integer val_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section_signal <= section_a;
			val_signal <= 0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule