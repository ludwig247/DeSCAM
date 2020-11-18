import top_level_types::*;
import modulestatename02_types::*;

module ModuleStateName02 (
	input logic clk,
	input logic rst,
	input integer m_in,
	output integer m_out,
	output logic m_out_notify
	);



	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			m_out_notify <= 1'b1;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule