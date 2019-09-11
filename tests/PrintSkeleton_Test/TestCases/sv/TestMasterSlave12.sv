import testmasterslave12_types::*;

module TestMasterSlave12 (
	input logic clk,
	input logic rst,
	input integer s_in,
	input logic s_in_sync,
	input integer s_in2,
	input logic s_in2_sync,
	output integer s_out
	);

	TestMasterSlave12_SECTIONS section;
	logic succ_signal;
	integer val_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section <= section_a;
			succ_signal <= 1'b0;
			val_signal <= 0;
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
