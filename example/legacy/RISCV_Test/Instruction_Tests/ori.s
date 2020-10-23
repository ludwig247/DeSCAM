
# @author :	Luka
# @name   : 	ori.s
# @purpose: 	Test for or immediate (ori)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	ori  x1,x0,7		# x1 = 0x07
	ori  x2,x1,8         	# x2 = 0x0F
	ori  x3,x2,0        	# x3 = 0x0F
	ori  x4,x3,-1        	# x4 = 0xFFFFFFFF

	nop			
	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
