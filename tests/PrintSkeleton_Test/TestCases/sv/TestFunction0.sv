import testfunction0_types::*;

module TestFunction0 (
	input logic clk,
	input logic rst,
	input integer b_in,
	input logic b_in_sync,
	output logic b_in_notify,
	output integer unsigned b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);

	TestFunction0_SECTIONS section;
	integer x_signal;
	integer unsigned y_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section <= run;
			x_signal <= 0;
			y_signal <= 0;
			b_in_notify <= 1'b1;
			b_out_notify <= 1'b0;
		end else begin
			if (section == run) begin
				// FILL OUT HERE
			end
		end
	end
endmodule
