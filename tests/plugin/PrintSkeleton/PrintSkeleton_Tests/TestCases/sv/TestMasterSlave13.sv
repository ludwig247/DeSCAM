import top_level_types::*;
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
	output integer sh_out,
	output integer sh_out2
	);

	Phases nextphase_signal;
	Phases phase_signal;
	integer save_val_signal;
	bit succ_signal;
	integer val_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			nextphase_signal <= section_a;
			phase_signal <= section_a;
			save_val_signal <= 0;
			succ_signal <= 1'b0;
			val_signal <= 0;
			m_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule