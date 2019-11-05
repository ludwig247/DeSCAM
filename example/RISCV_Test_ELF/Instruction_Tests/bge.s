
# @author :	Luka
# @name   : 	bge.s
# @purpose: 	Test for branch greater equal (bge)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,5		# x1 = 0x05
	addi x2,x0,-6		# x2 = 0xFFFFFFFA
	addi x31,x0,0        	# x31 = 0x00
	addi x30,x0,0        	# x30 = 0x00
	addi x29,x0,0        	# x29 = 0x00
	addi x28,x0,0        	# x29 = 0x00

	bge  x1,x2,TRY1   	# taken
	addi x31,x0,15    	# x31 = 0x0F (not executed)
TRY1:
	addi x30,x0,15    	# x30 = 0x0F (executed)
	bge  x2,x1,TRY2   	# not taken
	bge  x1,x1,TRY3   	# taken
TRY2:
	addi x29,x0,15    	# x29 = 0x0F (not executed)
	addi x0,x0,0     	# halt
TRY3:
	addi x28,x0,15    	# x28 = 0x0F (executed)
	addi x0,x0,0     	# halt

	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
