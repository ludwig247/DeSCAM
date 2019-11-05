
# @author :	Luka
# @name   : 	auipc.s
# @purpose: 	Test for add upper immediate to PC (auipc)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	auipc x1,0          	# x1 = PC = 0x00
	auipc x2,8		# x2 = PC + (0x08 << 12) = 0x8004
	auipc x3,0          	# x3 = PC = 0x08
	auipc x4,1          	# x4 = PC + (0x01 << 12) = 0x100C

	nop
	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
