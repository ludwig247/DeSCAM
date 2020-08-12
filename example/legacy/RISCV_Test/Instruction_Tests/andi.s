
# @author :	Luka
# @name   : 	andi.s
# @purpose: 	Test for and immediate (andi)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,7		# x1 = 0x07
	addi x2,x0,8         	# x2 = 0x08

	andi x3,x1,1         	# x3 = 0x01
	andi x4,x1,15        	# x4 = 0x07
	andi x5,x2,7         	# x5 = 0x00
	andi x6,x2,9         	# x6 = 0x08

	nop
	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
