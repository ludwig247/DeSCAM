
# @author :	Luka
# @name   : 	xori.s
# @purpose: 	Test for xor immediate (xori)

.globl _start

_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi  x1,x0,7		# x1 = 0x07

	xori  x2,x1,7         	# x2 = 0x00
	xori  x3,x1,4         	# x3 = 0x03
	xori  x4,x1,-1        	# x4 = 0xFFFFFFF8
	xori  x5,x4,0         	# x5 = 0xFFFFFFF8

	nop			
	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
