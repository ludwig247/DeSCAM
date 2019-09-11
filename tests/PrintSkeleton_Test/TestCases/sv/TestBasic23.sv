import testbasic23_types::*;

module TestBasic23 (
	input logic clk,
	input logic rst,
	output integer unsigned b_out,
	input logic b_out_sync,
	output logic b_out_notify,
	output integer b_out2,
	input logic b_out2_sync,
	output logic b_out2_notify
	);

	TestBasic23_SECTIONS section;
	integer val_signed_signal;
	integer unsigned val_unsigned_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section <= section_a;
			val_signed_signal <= -7;
			val_unsigned_signal <= 13;
			b_out_notify <= 1'b1;
			b_out2_notify <= 1'b0;
		end else begin
			if (section == section_a) begin
				// FILL OUT HERE
			end
			if (section == section_b) begin
				// FILL OUT HERE
			end
		end
	end
endmodule
