import scam_model_types::*;
import testbasic22_types::*;

module TestBasic22 (
	input logic clk,
	input logic rst,
	output test_compound m_out,
	output logic m_out_notify
	);

	Sections nextsection_signal;
	Sections section_signal;
	test_compound test_signal;
	bit[31:0] test2_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			nextsection_signal <= section_a;
			section_signal <= section_a;
			test_signal.x <= 0;
			test_signal.y <= 0;
			test2_signal <= 30;
			m_out_notify <= 1'b1;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule