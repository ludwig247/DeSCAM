import scam_model_types::*;
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

	bit bool_var_signal;
	global_compound_type gct_signal;
	global_enum ge_signal;
	global_enum_class gec_signal;
	integer int_var_signal;
	local_compound_type lct_signal;
	local_enum le_signal;
	local_enum_class lec_signal;
	int_5 local_array_signal;


	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			bool_var_signal <= 1'b0;
			gct_signal.b <= 1'b0;
			gct_signal.w <= 0;
			ge_signal <= a;
			gec_signal <= m;
			int_var_signal <= 0;
			lct_signal.fest <= a;
			lct_signal.x <= 0;
			lct_signal.y <= 1'b0;
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