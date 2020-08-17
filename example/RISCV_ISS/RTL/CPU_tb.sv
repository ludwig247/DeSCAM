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
		.clk(clk),
		.rst(rst),
		.fromMemoryPort(MemToCtl_port),
		.fromMemoryPort_sync(MemToCtl_port_notify),
		.fromMemoryPort_notify(MemToCtl_port_sync),
		.toMemoryPort(CtlToMem_port),
		.toMemoryPort_sync(CtlToMem_port_sync),
		.toMemoryPort_notify(CtlToMem_port_notify)
	);

	Memory IF_Memory(
		.clk(clk),
		.rst(rst),
		.CtlToMem_port(CtlToMem_port),
		.CtlToMem_port_sync(CtlToMem_port_notify),
		.CtlToMem_port_notify(CtlToMem_port_sync),
		.MemToCtl_port(MemToCtl_port),
		.MemToCtl_port_sync(MemToCtl_port_sync),
		.MemToCtl_port_notify(MemToCtl_port_notify)
	);

	always
		#10 clk = ~clk;

	initial begin
		clk = 1'b0;
		rst = 1'b1;
		#20 rst = 1'b0;
		#40;
		wait (MemToCtl_port.loadeddata == 1048691);
		$display("Simulation ended");
		$finish;
	end
endmodule