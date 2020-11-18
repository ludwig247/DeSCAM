import top_level_types::*;
import modulestatename01_types::*;

module ModuleStateName01 (
	input logic clk,
	input logic rst,
	input integer b_in,
	input logic b_in_sync,
	output logic b_in_notify,
	output integer b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);

	integer val_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			val_signal <= 0;
			b_in_notify <= 1'b1;
			b_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule