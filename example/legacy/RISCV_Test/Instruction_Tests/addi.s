
# @author :	Luka
# @name   : 	addi.s
# @purpose: 	Test for add immediate (addi)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,128	     	# x1 = 0x80
	addi x2,x1,0         	# x2 = x1 = 0x80
	addi x3,x2,10        	# x3 = x2 + 10 = 0x8a
	addi x4,x2,-10       	# x4 = x2 - 10 = 0x76

	addi x5,x0,-128      	# x5 = 0xffffff80
	addi x6,x5,0         	# x6 = 0xffffff80
	addi x7,x5,10        	# x7 = 0xffffff8a
	addi x8,x5,-10       	# x8 = 0xffffff76

	nop
	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
