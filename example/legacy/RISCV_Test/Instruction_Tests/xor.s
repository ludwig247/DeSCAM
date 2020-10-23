
# @author :	Luka
# @name   : 	xor.s
# @purpose: 	Test for xor (xor)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,7		# x1 = 0x07
	addi x2,x0,4         	# x2 = 0x04
	addi x3,x0,-1        	# x3 = 0xFFFFFFFF

	xor  x4,x1,x1        	# x4 = 0x00
	xor  x5,x1,x2        	# x5 = 0x03
	xor  x6,x1,x3        	# x6 = 0xFFFFFFF8
	xor  x7,x6,x0        	# x7 = 0xFFFFFFF8
	xor  x8,x0,x6        	# x8 = 0xFFFFFFF8
	xor  x9,x7,x7        	# x9 = 0x00

	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
