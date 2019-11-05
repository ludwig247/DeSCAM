import testmasterslave4_types::*;

module TestMasterSlave4 (
	input logic clk,
	input logic rst,
	input integer s_in,
	input logic s_in_sync,
	input integer s_in2,
	input logic s_in2_sync
	);

	TestMasterSlave4_SECTIONS section;
	integer val_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section <= section_a;
			val_signal <= 1337;
		end else begin
			if (section == section_a) begin
				// FILL OUT HERE
			end
			if (section == section_b) begin
				// FILL OUT HERE
			end
		end
	end
endmodule
