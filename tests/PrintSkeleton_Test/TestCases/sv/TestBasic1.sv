import testbasic1_types::*;

module TestBasic1 (
	input logic clk,
	input logic rst,
	input integer b_in,
	input logic b_in_sync,
	output logic b_in_notify
	);

	TestBasic1_SECTIONS section;
	integer x_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section <= section_a;
			x_signal <= 0;
			b_in_notify <= 1'b1;
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
