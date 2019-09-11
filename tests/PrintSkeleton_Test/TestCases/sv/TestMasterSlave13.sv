import testmasterslave13_types::*;

module TestMasterSlave13 (
	input logic clk,
	input logic rst,
	input integer m_in,
	output integer m_out,
	output logic m_out_notify,
	input integer s_in,
	input logic s_in_sync,
	input integer s_in2,
	input logic s_in2_sync,
	output integer s_out,
	output integer shared_out
	);

	TestMasterSlave13_SECTIONS section;
	integer save_val_signal;
	logic succ_signal;
	integer val_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			section <= section_a;
			save_val_signal <= 0;
			succ_signal <= 1'b0;
			val_signal <= 0;
			m_out_notify <= 1'b0;
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
