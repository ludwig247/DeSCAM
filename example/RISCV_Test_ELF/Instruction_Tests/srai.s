
# @author :	Luka
# @name   : 	srai.s
# @purpose: 	Test for shift right arithmetic immediate (srai)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,64        	# x1 = 0x40
	addi x2,x0,-65       	# x2 = 0xFFFFFFBF

	srai x3,x1,1         	# x3 = 0x20
	srai x4,x3,5         	# x4 = 0x01
	srai x5,x2,2         	# x5 = 0xFFFFFFEF
	srai x6,x5,13        	# x6 = 0xFFFFFFFF

	nop			
	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
