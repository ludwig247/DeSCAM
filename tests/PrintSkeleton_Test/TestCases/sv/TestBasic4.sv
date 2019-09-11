import testbasic4_types::*;

module TestBasic4 (
	input logic clk,
	input logic rst,
	output integer b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);

	TestBasic4_SECTIONS section;
	logic nb_result_signal;
	integer var_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section <= run;
			nb_result_signal <= 1'b0;
			var_signal <= 4;
			b_out_notify <= 1'b1;
		end else begin
			if (section == run) begin
				// FILL OUT HERE
			end
		end
	end
endmodule
