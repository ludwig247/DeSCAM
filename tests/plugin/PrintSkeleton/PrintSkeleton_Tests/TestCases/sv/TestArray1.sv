import top_level_types::*;
import testarray1_types::*;

module TestArray1 (
	input logic clk,
	input logic rst,
	input integer m_in,
	input logic m_in_sync,
	output logic m_in_notify,
	output integer m_out,
	input logic m_out_sync,
	output logic m_out_notify
	);



	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			m_in_notify <= 1'b1;
			m_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule