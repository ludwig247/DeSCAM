import top_level_types::*;
import testarray06_types::*;

module TestArray06 (
	input logic clk,
	input logic rst,
	output bit[31:0] b_out,
	input logic b_out_sync,
	output logic b_out_notify,
	input unsigned_4 m_in
	);



	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			b_out_notify <= 1'b1;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule