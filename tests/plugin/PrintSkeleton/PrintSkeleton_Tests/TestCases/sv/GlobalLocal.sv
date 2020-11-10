import top_level_types::*;
import globallocal_types::*;

module GlobalLocal (
	input logic clk,
	input logic rst,
	input integer b_in,
	input logic b_in_sync,
	output logic b_in_notify,
	output integer b_out,
	input logic b_out_sync,
	output logic b_out_notify
	);

	global_enum ge_signal;
	global_enum_class gec_signal;
	local_enum le_signal;
	local_enum_class lec_signal;
	int_5 local_array_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			ge_signal <= a;
			gec_signal <= m;
			le_signal <= x;
			lec_signal <= d;
			local_array_signal <= '{default:0};
			b_in_notify <= 1'b1;
			b_out_notify <= 1'b0;
		end else begin
				// FILL OUT HERE
		end
	end
endmodule