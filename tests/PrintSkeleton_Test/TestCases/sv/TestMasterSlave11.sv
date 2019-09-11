import testmasterslave11_types::*;

module TestMasterSlave11 (
	input logic clk,
	input logic rst,
	input integer s_in,
	input logic s_in_sync,
	output integer s_out,
	input logic shared_in
	);

	TestMasterSlave11_SECTIONS section;
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
