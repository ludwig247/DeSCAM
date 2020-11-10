import top_level_types::*;
import testmasterslave03_types::*;

module TestMasterSlave03 (
	input logic clk,
	input logic rst,
	input integer s_in,
	input logic s_in_sync,
	output integer s_out
	);

	Phases phase_signal;
	integer val_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			phase_signal <= section_a;
			val_signal <= 1337;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule