import scam_model_types::*;
import testfunction1_types::*;

module TestFunction1 (
	input logic clk,
	input logic rst,
	input record_t b_in,
	input logic b_in_sync,
	output logic b_in_notify,
	output bit[31:0] b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);

	record_t record_var_signal;
	integer x_signal;
	bit[31:0] y_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			record_var_signal.x <= 0;
			record_var_signal.y <= 0;
			x_signal <= 0;
			y_signal <= 0;
			b_in_notify <= 1'b1;
			b_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule