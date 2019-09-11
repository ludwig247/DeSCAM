import testbasic7_types::*;

module TestBasic7 (
	input logic clk,
	input logic rst,
	input integer b_in,
	input logic b_in_sync,
	output logic b_in_notify,
	output integer m_out,
	output logic m_out_notify
	);

	TestBasic7_SECTIONS section;
	logic nb_result_signal;
	integer var_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section <= run;
			nb_result_signal <= 1'b0;
			var_signal <= 1337;
			b_in_notify <= 1'b1;
			m_out_notify <= 1'b0;
		end else begin
			if (section == run) begin
				// FILL OUT HERE
			end
		end
	end
endmodule
