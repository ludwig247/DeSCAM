import top_level_types::*;

module CPU_tb();

	logic clk;
	logic rst;

	MEtoCU_IF MemToCtl_port;
	wire MemToCtl_port_sync;
	wire MemToCtl_port_notify;
	CUtoME_IF CtlToMem_port;
	wire CtlToMem_port_sync;
	wire CtlToMem_port_notify;

	CPU IF_CPU(
		clk,
		rst,
		MemToCtl_port,
		MemToCtl_port_sync,
		MemToCtl_port_notify,
		CtlToMem_port,
		CtlToMem_port_sync,
		CtlToMem_port_notify
	);

	Memory IF_Memory(
		clk,
		rst,
		MemToCtl_port,
		MemToCtl_port_sync,
		MemToCtl_port_notify,
		CtlToMem_port,
		CtlToMem_port_sync,
		CtlToMem_port_notify
	);

	always
		#10 clk = ~clk;

	initial begin
		clk = 1'b0;
		rst = 1'b1;
		#20 rst = 1'b0;
		#40;
		wait (MemToCtl_port.loadedData == 1048691);
		$display("Simulation ended");
		$stop;
	end
endmodule