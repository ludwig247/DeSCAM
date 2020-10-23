
# @author :	Luka
# @name   : 	add.s
# @purpose: 	Test for addition (add)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,128		# x1 = 0x80
	addi x2,x0,10        	# x2 = 0x0A
	addi x3,x0,-10       	# x3 = 0xFFFFFFF6
	addi x4,x0,-128      	# x4 = 0xFFFFFF80

	add  x5,x1,x2        	# x5 = x1 + x2 = 0x8A
	add  x6,x1,x3        	# x6 = x1 + x3 = 0x76
	add  x7,x1,x0        	# x7 = x1 + x0 = 0x80
	add  x8,x0,x1        	# x8 = x0 + x1 = 0x80
	add  x9,x1,x1        	# x9 = x1 + x1 = 0x100

	add  x10,x4,x2       	# x10 = x4 + x2 = 0xFFFFFF8A
	add  x11,x4,x3       	# x11 = x4 + x3 = 0xFFFFFF76
	add  x12,x4,x0       	# x12 = x4 + x0 = 0xFFFFFF80
	add  x13,x0,x4       	# x13 = x0 + x4 = 0xFFFFFF80
	add  x14,x4,x4       	# x14 = x4 + x4 = 0xFFFFFF00

	nop
	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
