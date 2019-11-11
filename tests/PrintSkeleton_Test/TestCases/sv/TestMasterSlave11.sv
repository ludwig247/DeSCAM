import scam_model_types::*;
import testmasterslave11_types::*;

module TestMasterSlave11 (
	input logic clk,
	input logic rst,
	input integer s_in,
	input logic s_in_sync,
	output integer s_out,
	input bit shared_in
	);

	Sections nextsection_signal;
	Sections section_signal;
	bit succ_signal;
	integer val_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			nextsection_signal <= section_a;
			section_signal <= section_a;
			succ_signal <= 1'b0;
			val_signal <= 0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule