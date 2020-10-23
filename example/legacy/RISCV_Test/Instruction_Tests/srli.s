
# @author :	Luka
# @name   : 	srli.s
# @purpose: 	Test for shift right logical immediate (srli)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,64        	# x1 = 0x40

	srli x2,x1,1         	# x2 = 0x20
	srli x3,x2,4         	# x3 = 0x02
	srli x4,x1,7         	# x4 = 0x00
	srli x5,x1,0        	# x5 = 0x40

	nop			
	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
