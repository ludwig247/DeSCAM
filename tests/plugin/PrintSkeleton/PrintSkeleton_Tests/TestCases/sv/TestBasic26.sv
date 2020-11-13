import top_level_types::*;
import testbasic26_types::*;

module TestBasic26 (
	input logic clk,
	input logic rst,
	input integer m_in_1,
	input integer m_in_2,
	input integer m_in_3,
	output integer m_out_1,
	output logic m_out_1_notify,
	output integer m_out_2,
	output logic m_out_2_notify,
	output integer m_out_3,
	output logic m_out_3_notify
	);



	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			m_out_1_notify <= 1'b0;
			m_out_2_notify <= 1'b0;
			m_out_3_notify <= 1'b1;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule