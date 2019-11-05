import testbasic13_types::*;

module TestBasic13 (
	input logic clk,
	input logic rst,
	input CompoundType b_in,
	input logic b_in_sync,
	output logic b_in_notify,
	output CompoundType b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);

	TestBasic13_SECTIONS section;
	CompoundType compoundType_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section <= section_a;
			compoundType_signal.mode <= read;
			compoundType_signal.x <= 0;
			compoundType_signal.y <= 1'b0;
			b_in_notify <= 1'b1;
			b_out_notify <= 1'b0;
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
