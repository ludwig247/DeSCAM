import top_level_types::*;
import testternary01_types::*;

module TestTernary01 (
	input logic clk,
	input logic rst,
	input integer data_in,
	input logic data_in_sync,
	output logic data_in_notify,
	output bit data_out,
	output integer valid_out,
	input logic valid_out_sync,
	output logic valid_out_notify
	);

	bit valid_signal;
	integer value_in_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			valid_signal <= 1'b0;
			value_in_signal <= 0;
			data_in_notify <= 1'b1;
			valid_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule