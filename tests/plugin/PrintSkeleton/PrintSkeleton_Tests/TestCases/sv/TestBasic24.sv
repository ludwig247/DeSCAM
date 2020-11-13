import top_level_types::*;
import testbasic24_types::*;

module TestBasic24 (
	input logic clk,
	input logic rst,
	input integer alu_in,
	output integer alu_out,
	output logic alu_out_notify,
	output integer b_out,
	input logic b_out_sync,
	output logic b_out_notify,
	input integer reg_in,
	output integer reg_out,
	output logic reg_out_notify
	);

	integer var1_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			var1_signal <= 5;
			alu_out_notify <= 1'b0;
			b_out_notify <= 1'b1;
			reg_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule