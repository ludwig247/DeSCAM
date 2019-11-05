import testmasterslave2_types::*;

module TestMasterSlave2 (
	input logic clk,
	input logic rst,
	output integer s_out
	);

	TestMasterSlave2_SECTIONS section;
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
