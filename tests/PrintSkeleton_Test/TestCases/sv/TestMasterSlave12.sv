import top_level_types::*;
import testmasterslave12_types::*;

module TestMasterSlave12 (
	input logic clk,
	input logic rst,
	input integer s_in,
	input logic s_in_sync,
	input integer s_in2,
	input logic s_in2_sync,
	output integer sh_out
	);

	Phases nextphase_signal;
	Phases phase_signal;
	bit succ_signal;
	integer val_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			nextphase_signal <= section_a;
			phase_signal <= section_a;
			succ_signal <= 1'b0;
			val_signal <= 0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule