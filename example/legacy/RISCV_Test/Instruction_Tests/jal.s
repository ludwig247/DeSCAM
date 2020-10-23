
# @author :	Luka
# @name   : 	jal.s
# @purpose: 	Test for jump and link (jal)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x31,x0,0        	# x31 = 0x00
	addi x30,x0,0        	# x30 = 0x00
	addi x29,x0,0        	# x29 = 0x00
	addi x28,x0,0        	# x29 = 0x00

	jal  x1, TRY1     	# x1 = PC + 4 = 20 = 0x14
	addi x31,x0,15    	# x31 = 0x0F (not executed)
TRY1:
	addi x30,x0,15    	# x30 = 0x0F (executed)
	jal  x2, TRY2     	# x2 = PC + 4 = 32 = 0x20
	addi x0,x0,0      	# halt
TRY2:
	addi x29,x0,15    	# x29 = 0x0F (executed)
	jal  x0, TRY3     	# JUMP
	addi x0,x0,0      	# halt
TRY3:
	addi x28,x0,15    	# x28 = 0x0F (executed)
	addi x0,x0,0      	# halt

	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
