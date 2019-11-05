import testbasic20_types::*;

module TestBasic20 (
	input logic clk,
	input logic rst,
	output CompoundType b_out,
	input logic b_out_sync,
	output logic b_out_notify,
	input CompoundType m_in
	);

	TestBasic20_SECTIONS section;
	color_t color_signal;
	CompoundType compoundType_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section <= section_a;
			color_signal <= green;
			compoundType_signal.mode <= read;
			compoundType_signal.x <= 0;
			compoundType_signal.y <= 1'b0;
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
