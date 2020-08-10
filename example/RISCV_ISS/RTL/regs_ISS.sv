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
			RegsToCtl_port[0] <= 32'b0;
			RegsToCtl_port[1] <= 32'b0;
			RegsToCtl_port[2] <= 32'b0;
			RegsToCtl_port[3] <= 32'b0;
			RegsToCtl_port[4] <= 32'b0;
			RegsToCtl_port[5] <= 32'b0;
			RegsToCtl_port[6] <= 32'b0;
			RegsToCtl_port[7] <= 32'b0;
			RegsToCtl_port[8] <= 32'b0;
			RegsToCtl_port[9] <= 32'b0;
			RegsToCtl_port[10] <= 32'b0;
			RegsToCtl_port[11] <= 32'b0;
			RegsToCtl_port[12] <= 32'b0;
			RegsToCtl_port[13] <= 32'b0;
			RegsToCtl_port[14] <= 32'b0;
			RegsToCtl_port[15] <= 32'b0;
			RegsToCtl_port[16] <= 32'b0;
			RegsToCtl_port[17] <= 32'b0;
			RegsToCtl_port[18] <= 32'b0;
			RegsToCtl_port[19] <= 32'b0;
			RegsToCtl_port[20] <= 32'b0;
			RegsToCtl_port[21] <= 32'b0;
			RegsToCtl_port[22] <= 32'b0;
			RegsToCtl_port[23] <= 32'b0;
			RegsToCtl_port[24] <= 32'b0;
			RegsToCtl_port[25] <= 32'b0;
			RegsToCtl_port[26] <= 32'b0;
			RegsToCtl_port[27] <= 32'b0;
			RegsToCtl_port[28] <= 32'b0;
			RegsToCtl_port[29] <= 32'b0;
			RegsToCtl_port[30] <= 32'b0;
			RegsToCtl_port[31] <= 32'b0;
		end
		else begin
			if (CtlToRegs_port_sync == 1'b1) begin
				if (CtlToRegs_port.dst == 0) RegsToCtl_port[0] <= 32'b0;
				if (CtlToRegs_port.dst == 1) RegsToCtl_port[1] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 2) RegsToCtl_port[2] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 3) RegsToCtl_port[3] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 4) RegsToCtl_port[4] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 5) RegsToCtl_port[5] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 6) RegsToCtl_port[6] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 7) RegsToCtl_port[7] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 8) RegsToCtl_port[8] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 9) RegsToCtl_port[9] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 10) RegsToCtl_port[10] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 11) RegsToCtl_port[11] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 12) RegsToCtl_port[12] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 13) RegsToCtl_port[13] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 14) RegsToCtl_port[14] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 15) RegsToCtl_port[15] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 16) RegsToCtl_port[16] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 17) RegsToCtl_port[17] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 18) RegsToCtl_port[18] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 19) RegsToCtl_port[19] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 20) RegsToCtl_port[20] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 21) RegsToCtl_port[21] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 22) RegsToCtl_port[22] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 23) RegsToCtl_port[23] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 24) RegsToCtl_port[24] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 25) RegsToCtl_port[25] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 26) RegsToCtl_port[26] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 27) RegsToCtl_port[27] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 28) RegsToCtl_port[28] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 29) RegsToCtl_port[29] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 30) RegsToCtl_port[30] <= CtlToRegs_port.dstdata;
				if (CtlToRegs_port.dst == 31) RegsToCtl_port[31] <= CtlToRegs_port.dstdata;
			end
		end
	end
endmodule