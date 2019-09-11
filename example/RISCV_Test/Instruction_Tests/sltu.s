
# @author :	Luka
# @name   : 	sltu.s
# @purpose: 	Test for set less than unsigned (sltu)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi  x1,x0,7       	# x1 = 0x07
	addi  x2,x0,-12     	# x2 = 0xFFFFFFF4
	addi  x31,x0,32     	# x31 = 0x20
	addi  x30,x0,3      	# x30 = 0x03
	addi  x29,x0,-100   	# x29 = 0xFFFFFF9C
	addi  x28,x0,-5     	# x28 = 0xFFFFFFFB
	addi  x27,x0,100    	# x27 = 0x64
	addi  x26,x0,-13    	# x26 = 0xFFFFFFF3

	sltu x3,x1,x31	    	# x3 = 0x01
	sltu x4,x1,x30	    	# x4 = 0x00
	sltu x5,x1,x29      	# x5 = 0x01
	sltu x6,x2,x28      	# x6 = 0x01
	sltu x7,x2,x0       	# x7 = 0x00
	sltu x8,x2,x27      	# x8 = 0x00
	sltu x9,x2,x26      	# x9 = 0x00
	sltu x10,x2,x29     	# x10 = 0x00

	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
