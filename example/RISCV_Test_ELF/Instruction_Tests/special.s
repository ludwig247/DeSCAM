
# @author :	Luka
# @name   : 	add.s
# @purpose: 	Test for addition (add)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,1		# x1 = 0x80
	addi x22,x0,2       	# x3 = 0xFFFFFFF6
	add  x3,x22,x1      	# x4 = 0xFFFFFF80

	nop
	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
