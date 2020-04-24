
# @author :	Dino Mehmedagić
# @name   : 	enc_r.s
# @purpose: 	Test for addition with an attempt to average out the power dependencz on data and the addi instructions

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,-1		# x1 = 0xFFFFFFFF
	addi x2,x0,1        	# x2 = 0x00000001

	add  x3,x1,x0        	# x3 = x1 + x0 = 0xFFFFFFFF x3 will not toggle at 1
	add  x4,x0,x0        	# x4 = x0 + x0 = 0x00000000 x4 will not toggle at 0
	add  x5,x3,x0        	# x5 = x3 + x0 = 0xFFFFFFFF x5 will toggle always

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x2        	# x5 = x3 + x0 = 0x00000000 

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x1        	# x5 = x3 + x0 = 0xFFFFFFFF

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x2        	# x5 = x3 + x0 = 0x00000000 

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x1        	# x5 = x3 + x0 = 0xFFFFFFFF

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x2        	# x5 = x3 + x0 = 0x00000000 

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x1        	# x5 = x3 + x0 = 0xFFFFFFFF

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x2        	# x5 = x3 + x0 = 0x00000000 

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x1        	# x5 = x3 + x0 = 0xFFFFFFFF

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x2        	# x5 = x3 + x0 = 0x00000000 

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x1        	# x5 = x3 + x0 = 0xFFFFFFFF

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x2        	# x5 = x3 + x0 = 0x00000000 

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x1        	# x5 = x3 + x0 = 0xFFFFFFFF

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x2        	# x5 = x3 + x0 = 0x00000000 

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x1        	# x5 = x3 + x0 = 0xFFFFFFFF

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x2        	# x5 = x3 + x0 = 0x00000000 

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x1        	# x5 = x3 + x0 = 0xFFFFFFFF

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x2        	# x5 = x3 + x0 = 0x00000000 

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x1        	# x5 = x3 + x0 = 0xFFFFFFFF

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x1        	# x5 = x3 + x0 = 0xFFFFFFFF

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x2        	# x5 = x3 + x0 = 0x00000000 

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x1        	# x5 = x3 + x0 = 0xFFFFFFFF

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x2        	# x5 = x3 + x0 = 0x00000000 

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x1        	# x5 = x3 + x0 = 0xFFFFFFFF

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x2        	# x5 = x3 + x0 = 0x00000000 

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x1        	# x5 = x3 + x0 = 0xFFFFFFFF

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x2        	# x5 = x3 + x0 = 0x00000000 

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x1        	# x5 = x3 + x0 = 0xFFFFFFFF

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x2        	# x5 = x3 + x0 = 0x00000000 

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x1        	# x5 = x3 + x0 = 0xFFFFFFFF

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x2        	# x5 = x3 + x0 = 0x00000000 

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x1        	# x5 = x3 + x0 = 0xFFFFFFFF

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x2        	# x5 = x3 + x0 = 0x00000000 

	add  x3,x3,x0        	# x3 = x1 + x0 = 0xFFFFFFFF 
	add  x4,x4,x0        	# x4 = x0 + x0 = 0x00000000 
	add  x5,x5,x1        	# x5 = x3 + x0 = 0xFFFFFFFF

	nop
	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
