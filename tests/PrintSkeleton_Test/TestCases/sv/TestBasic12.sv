import testbasic12_types::*;

module TestBasic12 (
	input logic clk,
	input logic rst,
	input CompoundType b_in,
	input logic b_in_sync,
	output logic b_in_notify,
	output integer m_out,
	output logic m_out_notify
	);

	TestBasic12_SECTIONS section;
	CompoundType compoundType_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section <= section_a;
			compoundType_signal.mode <= read;
			compoundType_signal.x <= 0;
			compoundType_signal.y <= 1'b0;
			b_in_notify <= 1'b1;
			m_out_notify <= 1'b0;
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
