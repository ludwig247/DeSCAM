
# @author :	Luka
# @name   : 	slli.s
# @purpose: 	Test for shift left logical immediate (slli)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,8         	# x1 = 0x08

	slli x2,x1,1         	# x2 = 0x10
	slli x3,x2,2         	# x3 = 0x40
	slli x4,x3,0         	# x4 = 0x40

	nop			
	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
