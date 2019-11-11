import scam_model_types::*;
import testmasterslave3_types::*;

module TestMasterSlave3 (
	input logic clk,
	input logic rst,
	input integer s_in,
	input logic s_in_sync,
	output integer s_out
	);

	Sections nextsection_signal;
	Sections section_signal;
	integer val_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			nextsection_signal <= section_a;
			section_signal <= section_a;
			val_signal <= 1337;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule