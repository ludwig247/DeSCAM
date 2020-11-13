import top_level_types::*;
import testbasic25_types::*;

module TestBasic25 (
	input logic clk,
	input logic rst,
	input integer alu_in,
	output integer alu_out,
	output logic alu_out_notify,
	input integer reg_in,
	output integer reg_out,
	output logic reg_out_notify
	);



	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			alu_out_notify <= 1'b1;
			reg_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule