import top_level_types::*;
import testfunction2_types::*;

module TestFunction2 (
	input logic clk,
	input logic rst,
	input record_t b_in,
	input logic b_in_sync,
	output logic b_in_notify,
	output bit[31:0] b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);



	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			b_in_notify <= 1'b1;
			b_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule