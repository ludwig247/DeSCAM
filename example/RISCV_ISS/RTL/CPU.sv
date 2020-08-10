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
		clk, 
		rst, 
		fromMemoryPort, 
		fromMemoryPort_sync, 
		fromMemoryPort_notify,
		fromRegsPort,
		toMemoryPort,
		toMemoryPort_sync,
		toMemoryPort_notify,
		toRegsPort,
		toRegsPort_notify
	);

	regs_ISS IF_Reg(
		clk,
		rst,
		toRegsPort,
		toRegsPort_notify,
		fromRegsPort
	);
endmodule
	
		
		