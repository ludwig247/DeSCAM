
# @author :	Dino Mehmedagić
# @name   : 	enc_i_l.s
# @purpose: 	Test for load with an attempt to average out the power dependency on data and the initial addi instructions

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,-1		# x1 = 0xFFFFFFFF
	addi x2,x0,256		# x2 = 0x100 -> address

	sh x1,2(x2)		# mem[0x100..103] = 0x0000FFFF
	sh x1,4(x2)		# mem[0x104..107] = 0xFFFF0000

	lw x3,0(x2)		# x3 = 0x0000FFFF
	lw x4,4(x2)		# x4 = 0xFFFF0000
	lw x5,-1(x2)		# x5 = 0x000000FF
	lw x6,1(x2)		# x6 = 0x00FFFFFF
	lw x7,-2(x2)		# x7 = 0x00000000
	lw x8,2(x2)		# x8 = 0xFFFFFFFF

	lw x9,0(x2)		
	lw x10,4(x2)		
	lw x11,-1(x2)		
	lw x12,1(x2)		
	lw x13,-2(x2)		
	lw x14,2(x2)		

	lw x15,0(x2)		
	lw x16,4(x2)		
	lw x17,-1(x2)		
	lw x18,1(x2)		
	lw x19,-2(x2)		
	lw x20,2(x2)		

	lw x21,0(x2)		
	lw x22,4(x2)		
	lw x23,-1(x2)		
	lw x24,1(x2)		
	lw x25,-2(x2)		
	lw x26,2(x2)		

	lw x27,0(x2)		
	lw x28,4(x2)		
	lw x29,-1(x2)		
	lw x30,1(x2)

	lw x3,0(x2)		#load the same value into half of the registers	
	lw x4,4(x2)		
	lw x5,-1(x2)		
	lw x6,1(x2)		
	lw x7,-2(x2)		
	lw x8,2(x2)		

	lw x9,0(x2)		
	lw x10,4(x2)		
	lw x11,-1(x2)		
	lw x12,1(x2)		
	lw x13,-2(x2)		
	lw x14,2(x2)		

	lw x15,0(x2)		
	lw x16,4(x2)

	lw x17,3(x2)		# invert other half of the registers		
	lw x18,5(x2)		
	lw x19,2(x2)		
	lw x20,-2(x2)		

	lw x21,4(x2)		
	lw x22,0(x2)		
	lw x23,3(x2)		
	lw x24,5(x2)		
	lw x25,2(x2)		
	lw x26,-2(x2)		

	lw x27,4(x2)		
	lw x28,0(x2)		
	lw x29,3(x2)		
	lw x30,5(x2)

_end:
	ebreak
