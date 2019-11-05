import testbasic0_types::*;

module TestBasic0 (
	input logic clk,
	input logic rst,
	output integer b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);

	TestBasic0_SECTIONS section;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section <= section_a;
			b_out_notify <= 1'b1;
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
