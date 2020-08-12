
# @author :	Luka
# @name   : 	and.s
# @purpose: 	Test for and (and)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,7		# x1 = 0x07
	addi x2,x0,8         	# x2 = 0x08
	addi x3,x0,1         	# x3 = 0x01
	addi x4,x0,15        	# x4 = 0x0F

	and  x1,x1,x1        	# x1 = 0x07
	and  x5,x1,x3        	# x5 = 0x01
	and  x6,x1,x4        	# x6 = 0x07
	and  x7,x1,x1        	# x7 = 0x07
	and  x8,x1,x2       	# x8 = 0x00
	and  x9,x2,x4        	# x9 = 0x08
	and  x10,x3,x0       	# x10 = 0x00
	and  x11,x0,x3       	# x11 = 0x00

	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
