
# @author :	Luka
# @name   : 	jalr.s
# @purpose: 	Test for jump and link register (jalr)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x31,x0,0        	# x31 = 0x00
	addi x30,x0,0        	# x30 = 0x00
	addi x29,x0,0        	# x29 = 0x00

	jal  x1,TRY1     	# x1 = PC + 4 = 16 = 0x10
	addi x31,x0,15    	# x31 = 0x0F (not executed)
	addi x30,x0,15    	# x30 = 0x0F (executed)
	addi x0,x0,0      	# halt

	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
TRY1:
	addi x29,x0,15    	# x29 = 0x0F (executed)
	jalr x2,x1,4      	# x2 = PC + 4 = 56 = 0x38
	addi x0,x0,0      	# halt
