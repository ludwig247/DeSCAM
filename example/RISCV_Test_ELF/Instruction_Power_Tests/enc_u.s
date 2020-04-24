
# @author :	Dino Mehmedagić
# @name   : 	enc_u.s
# @purpose: 	Test for U-type instructions with an attempt to average out the power dependency on data and the initial instructions

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,-1		# x1 = 0xFFFFFFFF
	

END:
	nop
	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak

DEBUG:
	addi x12,x0,-1
	jal x0,END
