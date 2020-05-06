
# @author :	Dino Mehmedagić
# @name   : 	enc_u.s
# @purpose: 	Test for U-type instructions with an attempt to average out the power dependency on data

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
     
	lui x1,0          	# x1 = 0x00 << 12 = 0x0000
	lui x2,1048575         	# x2 = 0xFFFFF << 12 = 0xFFFFF000
	lui x3,0         	# x3 = 0x0
	lui x4,1048575        	# x4 = 0xFFFFF000
	lui x5,0          	# repeat pattern
	lui x6,1048575           	
	lui x7,0         	
	lui x8,1048575   
	lui x9,0          	
	lui x10,1048575           	
	lui x11,0         	
	lui x12,1048575         
	lui x13,0          	
	lui x14,1048575           	
	lui x15,0         	
	lui x16,1048575    
	lui x17,0          	
	lui x18,1048575           	
	lui x19,0         	
	lui x20,1048575         
	lui x21,0          	
	lui x22,1048575           	
	lui x23,0         	
	lui x24,1048575     	
	lui x25,0          	
	lui x26,1048575          	
	lui x27,0         	
	lui x28,1048575         
	lui x29,0          	
	lui x30,1048575           	
	lui x31,0     

	lui x1,1048575        	# switch half, leave other half untouched
	lui x2,0         	
	lui x3,1048575           	
	lui x4,0         	
	lui x5,1048575            	
	lui x6,0         	
	lui x7,1048575           	
	lui x8,0 
	lui x9,1048575            	
	lui x10,0         	
	lui x11,1048575           	
	lui x12,0       
	lui x13,1048575            	
	lui x14,0         	
	lui x15,1048575           	
	lui x16,0  
	lui x17,0          	
	lui x18,1048575           	
	lui x19,0         	
	lui x20,1048575         
	lui x21,0          	
	lui x22,1048575           	
	lui x23,0         	
	lui x24,1048575     	
	lui x25,0          	
	lui x26,1048575          	
	lui x27,0         	
	lui x28,1048575         
	lui x29,0          	
	lui x30,1048575           	
	lui x31,0    


_end:
	ebreak

