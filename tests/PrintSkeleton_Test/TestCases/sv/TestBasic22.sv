import testbasic22_types::*;

module TestBasic22 (
	input logic clk,
	input logic rst,
	output test_compound m_out,
	output logic m_out_notify
	);

	TestBasic22_SECTIONS section;
	test_compound test_signal;
	integer unsigned test2_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section <= section_a;
			test_signal.x <= 0;
			test_signal.y <= 0;
			test2_signal <= 30;
			m_out_notify <= 1'b1;
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
