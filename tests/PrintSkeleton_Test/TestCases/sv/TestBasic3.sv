import testbasic3_types::*;

module TestBasic3 (
	input logic clk,
	input logic rst,
	output integer b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);

	TestBasic3_SECTIONS section;
	logic nb_result_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section <= run;
			nb_result_signal <= 1'b0;
			b_out_notify <= 1'b1;
		end else begin
			if (section == run) begin
				// FILL OUT HERE
			end
		end
	end
endmodule
