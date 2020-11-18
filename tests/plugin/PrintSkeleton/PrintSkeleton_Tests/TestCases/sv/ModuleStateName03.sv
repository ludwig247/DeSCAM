import top_level_types::*;
import modulestatename03_types::*;

module ModuleStateName03 (
	input logic clk,
	input logic rst,
	input integer m_in,
	output integer m_out,
	output logic m_out_notify,
	input integer s_in,
	input logic s_in_sync,
	output integer s_out
	);



	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			m_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule