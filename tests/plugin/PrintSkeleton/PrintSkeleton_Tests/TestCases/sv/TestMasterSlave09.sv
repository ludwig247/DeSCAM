import top_level_types::*;
import testmasterslave09_types::*;

module TestMasterSlave09 (
	input logic clk,
	input logic rst,
	input integer s_in,
	input logic s_in_sync,
	output integer sh_out
	);

	Phases phase_signal;
	integer val_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			phase_signal <= section_a;
			val_signal <= 0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule