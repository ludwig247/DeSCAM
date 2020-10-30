
# @author :	Luka
# @name   : 	sll.s
# @purpose: 	Test for shift left logical (sll)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,8         	# x1 = 0x08
	addi x2,x0,1         	# x2 = 0x01
	addi x3,x0,2         	# x3 = 0x02

	sll  x4,x1,x2        	# x4 = 0x10
	sll  x5,x4,x3        	# x5 = 0x40
	sll  x6,x5,x0        	# x6 = 0x40
	sll  x7,x0,x2        	# x6 = 0x00

	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
