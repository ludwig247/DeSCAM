import top_level_types::*;

module regs_ISS (
	input logic clk,
	input logic rst,
	input RegfileWriteType CtlToRegs_port,
	input logic CtlToRegs_port_sync,
	output unsigned_32 RegsToCtl_port 
	);

	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			RegsToCtl_port <= '{default:0};
		end
		else begin
			if (CtlToRegs_port_sync == 1'b1) begin
				if (CtlToRegs_port.dst == 0) RegsToCtl_port[0] <= 32'b0;
				else RegsToCtl_port[CtlToRegs_port.dst] <= CtlToRegs_port.dstdata;
			end
		end
	end
endmodule