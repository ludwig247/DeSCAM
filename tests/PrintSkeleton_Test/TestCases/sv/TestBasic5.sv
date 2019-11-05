import testbasic5_types::*;

module TestBasic5 (
	input logic clk,
	input logic rst,
	input integer b_in,
	input logic b_in_sync,
	output logic b_in_notify,
	output integer b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);

	TestBasic5_SECTIONS section;
	logic nb_result_signal;
	integer var_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section <= run;
			nb_result_signal <= 1'b0;
			var_signal <= 4;
			b_in_notify <= 1'b1;
			b_out_notify <= 1'b0;
		end else begin
			if (section == run) begin
				// FILL OUT HERE
			end
		end
	end
endmodule
