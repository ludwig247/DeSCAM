
# @author :	Luka
# @name   : 	lui.s
# @purpose: 	Test for load upper immediate (lui)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	lui x1,5          	# x1 = 0x05 << 12 = 0x5000
	lui x2,31         	# x2 = 0x1F << 12 = 0x1F000
	#lui x3,-1         	# x3 = 0xFFFFF000
	lui x4,0          	# x4 = 0x00

	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
