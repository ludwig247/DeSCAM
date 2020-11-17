import top_level_types::*;

module CPU (
	input logic clk,                 
	input logic rst,                   
	input MEtoCU_IF fromMemoryPort,        
	input logic fromMemoryPort_sync, 
	output logic fromMemoryPort_notify,
	output CUtoME_IF toMemoryPort,         
	input logic toMemoryPort_sync,    
	output logic toMemoryPort_notify  
	);
	
	RegfileWriteType toRegsPort;
	logic toRegsPort_notify;
	unsigned_32 fromRegsPort;

	ISS IF_ISS(
		.clk(clk), 
		.rst(rst), 
		.fromMemoryPort(fromMemoryPort), 
		.fromMemoryPort_sync(fromMemoryPort_sync), 
		.fromMemoryPort_notify(fromMemoryPort_notify),
		.fromRegsPort(fromRegsPort),
		.toMemoryPort(toMemoryPort),
		.toMemoryPort_sync(toMemoryPort_sync),
		.toMemoryPort_notify(toMemoryPort_notify),
		.toRegsPort(toRegsPort),
		.toRegsPort_notify(toRegsPort_notify)
	);

	regs_ISS IF_Reg(
		.clk(clk), 
		.rst(rst),
		.CtlToRegs_port(toRegsPort),
		.CtlToRegs_port_sync(toRegsPort_notify),
		.RegsToCtl_port(fromRegsPort)
	);
endmodule
	
		
		