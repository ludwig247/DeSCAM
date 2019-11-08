

module vscale_top_verify ( 
												input clk,
												input reset,
												input reset2,
												input [15:0] inst1,
												input [15:0] inst2,
												input [15:0] data1,
												input [15:0] data2,
												//input dmem_valid_i1,
												input dmem_valid_i2
												); 

  wire        imem_read_o1;
  wire [15:0] imem_addr_o1;
  wire [15:0]  imem_data_i1;
  wire        dmem_enable_o1;
  wire        dmem_write_o1;
  wire [15:0] dmem_addr_o1;
  wire [15:0] dmem_data_o1;
  wire [15:0]  dmem_data_i1;
  wire         dmem_valid_i1;

  wire        imem_read_o2;
  wire [15:0] imem_addr_o2;
  wire [15:0]  imem_data_i2;
  wire        dmem_enable_o2;
  wire        dmem_write_o2;
  wire [15:0] dmem_addr_o2;
  wire [15:0] dmem_data_o2;
  wire [15:0]  dmem_data_i2;
  wire         dmem_valid_i2;


	reg [15:0] addr_recorder_1;
	reg [15:0] data_recorder_1;
	reg [15:0] store_recorder_1;

	reg dmem_store_flag;

	reg [15:0] addr_recorder_2;
	reg [15:0] store_recorder_2;


	assign imem_data_i1 = inst1;
	assign imem_data_i2 = inst2;

	assign dmem_data_i1 = data1;
	assign dmem_data_i2 = data2;

	assign dmem_valid_i1 = dmem_enable_o1;
	//assign dmem_valid_i2 = dmem_enable_o2;

	
	vcore cpu1(
					   .clk(clk),
					   .reset_n(reset),
					   
					   .imem_read_o(imem_read_o1),
					   .imem_addr_o(imem_addr_o1),
					   .imem_data_i(imem_data_i1),
					
					   .dmem_enable_o(dmem_enable_o1),
					   .dmem_write_o(dmem_write_o1),
					   .dmem_addr_o(dmem_addr_o1),
					   .dmem_data_o(dmem_data_o1),
					   .dmem_data_i(dmem_data_i1),
					   .dmem_valid_i(dmem_valid_i1));


	vcore cpu2(
					   .clk(clk),
					   .reset_n(reset),
					   
					   .imem_read_o(imem_read_o2),
					   .imem_addr_o(imem_addr_o2),
					   .imem_data_i(imem_data_i2),
					
					   .dmem_enable_o(dmem_enable_o2),
					   .dmem_write_o(dmem_write_o2),
					   .dmem_addr_o(dmem_addr_o2),
					   .dmem_data_o(dmem_data_o2),
					   .dmem_data_i(dmem_data_i2),
					   .dmem_valid_i(dmem_valid_i2)
							);

// memory model TODO

	always @(posedge clk)
	begin
		if (reset == 1'b0)
		begin
			addr_recorder_1 <= 16'h0;
			addr_recorder_2 <= 16'h0;
			data_recorder_1 <= 16'h0;
			store_recorder_1 <= 16'h0;
			store_recorder_2 <= 16'h0;
			dmem_store_flag <= 1'b0;
		end
		else
		begin
			if (dmem_enable_o1 == 1'b1)
			begin
				addr_recorder_1 <= dmem_addr_o1;
				if (dmem_write_o1 == 1'b1)
				begin
					dmem_store_flag <= 1'b1;
					store_recorder_1 <= dmem_data_o1;
				end
				else
				begin
					dmem_store_flag <= 1'b0;
					data_recorder_1 <= dmem_data_i1;
				end
			end
			if (dmem_enable_o2 == 1'b1)
			begin
				addr_recorder_2 <= dmem_addr_o2;
				if (dmem_write_o2 == 1'b1)
				begin
					store_recorder_2 <= dmem_data_o2;
				end
			end
		end
	end

endmodule //vscale_top_verify
