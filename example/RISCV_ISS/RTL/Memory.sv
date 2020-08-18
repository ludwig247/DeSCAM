import top_level_types::*;

module Memory (
	input logic clk,
	input logic rst,
	output MEtoCU_IF MemToCtl_port,
	input logic MemToCtl_port_sync,
	output logic MemToCtl_port_notify,
	input CUtoME_IF CtlToMem_port,
	input logic CtlToMem_port_sync,
	output logic CtlToMem_port_notify
	);
	
	function mem8_type InitMemFromHex(string FilePath);
		int j;
		mem8_type ram;
		mem32_type temp;
	
		j = 0;
		$readmemh(FilePath, temp);
		for(int i = 0; i <= $size(ram); i++) begin
			ram[j+3] = temp[i][31:24];
			ram[j+2] = temp[i][23:16];
			ram[j+1] = temp[i][15:8];
			ram[j] = temp[i][7:0];
			j += 4;
		end
		return ram;
	endfunction: InitMemFromHex;

	mem8_type ram;
	MemSections section;

	always_ff @(posedge clk, posedge rst) begin
		logic[7:0] byte_temp;

		if (rst) begin
			ram = InitMemFromHex("/import/lab/users/riva/DeSCAM/example/RISCV_Test/Programs/BubbleSort.hex");
			section <= mem_req;
			MemToCtl_port.loadeddata <= 32'b0;
			CtlToMem_port_notify <= 1'b1;
			MemToCtl_port_notify <= 1'b0;
			byte_temp = 8'b0;
		end
		else begin
			case (section)
				mem_req: begin
					if (CtlToMem_port_sync == 1'b1) begin
						if (CtlToMem_port.req == me_rd) begin
							//Read Byte
							if ((CtlToMem_port.addrin < MEM_SIZE) && (CtlToMem_port.mask == mt_b)) begin
								byte_temp = ram[CtlToMem_port.addrin];
								//Sign extend
								if (byte_temp[7] == 1'b1) 
									MemToCtl_port.loadeddata <= {24'hFFFFFF, byte_temp};
								else
									MemToCtl_port.loadeddata <= {24'h000000, byte_temp};
							end
							//Read Halfword
							else if ((CtlToMem_port.addrin < MEM_SIZE-1) && (CtlToMem_port.mask == mt_h)) begin
								byte_temp = ram[CtlToMem_port.addrin + 1]; 
								//Sign-Extend
								if (byte_temp [7] == 1'b1)
									MemToCtl_port.loadeddata <= {16'hFFFF, byte_temp, ram[CtlToMem_port.addrin]};
								else
									MemToCtl_port.loadeddata <= {16'h0000, byte_temp, ram[CtlToMem_port.addrin]};
							end	
							//Read Word
							else if ((CtlToMem_port.addrin < MEM_SIZE-3) && (CtlToMem_port.mask == mt_w)) begin
								MemToCtl_port.loadeddata <= {ram[CtlToMem_port.addrin + 3],
												ram[CtlToMem_port.addrin + 2], 
												ram[CtlToMem_port.addrin + 1],
												ram[CtlToMem_port.addrin]
												};
							end
							//Read Byte Unsigned
							else if ((CtlToMem_port.addrin < MEM_SIZE) && (CtlToMem_port.mask == mt_bu)) begin
								byte_temp = ram[CtlToMem_port.addrin];
								MemToCtl_port.loadeddata <= {24'h000000, byte_temp};
							end
							//Read Halfword Unsigned
							else if ((CtlToMem_port.addrin < MEM_SIZE-1) && (CtlToMem_port.mask == mt_hu)) begin
								byte_temp = ram[CtlToMem_port.addrin + 1];
								MemToCtl_port.loadeddata <= {16'h0000, byte_temp, ram[CtlToMem_port.addrin]};
							end
						end
						else if (CtlToMem_port.req == me_wr) begin
							//Write Byte
							if ((CtlToMem_port.addrin < MEM_SIZE) && (CtlToMem_port.mask == mt_b)) 
								ram[CtlToMem_port.addrin] <= CtlToMem_port.datain[7:0];
							//Write Halfword
							else if ((CtlToMem_port.addrin < MEM_SIZE-1) && (CtlToMem_port.mask == mt_h)) begin
								ram[CtlToMem_port.addrin + 1] <= CtlToMem_port.datain[15:8];
								ram[CtlToMem_port.addrin] <= CtlToMem_port.datain[7:0];
							end
							//Write Word
							else if ((CtlToMem_port.addrin < MEM_SIZE-3) && (CtlToMem_port.mask == mt_w)) begin
								ram[CtlToMem_port.addrin + 3] <= CtlToMem_port.datain[31:24];
								ram[CtlToMem_port.addrin + 2] <= CtlToMem_port.datain[23:16];
								ram[CtlToMem_port.addrin + 1] <= CtlToMem_port.datain[15:8];
								ram[CtlToMem_port.addrin]     <= CtlToMem_port.datain[7:0];
							end
						end
						CtlToMem_port_notify <= 1'b0;
						MemToCtl_port_notify <= 1'b1;
						section <= mem_done;
					end
				end
				mem_done: begin
					if (MemToCtl_port_sync == 1'b1) begin
						MemToCtl_port_notify <= 1'b0;
						CtlToMem_port_notify <= 1'b1;
						section <= mem_req;
					end
				end
			endcase
		end
	end
endmodule