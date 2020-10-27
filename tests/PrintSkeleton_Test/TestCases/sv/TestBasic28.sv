import top_level_types::*;
import testbasic28_types::*;

module TestBasic28 (
	input logic clk,
	input logic rst,
	input integer test_in,
	input logic test_in_sync,
	output logic test_in_notify,
	output bit[31:0] test_out,
	input logic test_out_sync,
	output logic test_out_notify
	);

	bit[31:0] bar_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			bar_signal <= 0;
			test_in_notify <= 1'b1;
			test_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule