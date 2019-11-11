import scam_model_types::*;
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

	Sections nextsection_signal;
	integer save_val_signal;
	Sections section_signal;
	bit succ_signal;
	integer val_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			nextsection_signal <= section_a;
			save_val_signal <= 0;
			section_signal <= section_a;
			succ_signal <= 1'b0;
			val_signal <= 0;
			m_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule