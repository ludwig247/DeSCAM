
# @author :	Luka
# @name   : 	slti.s
# @purpose: 	Test for set less than immediate (slti)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi  x1,x0,7       	# x1 = 0x07
	addi  x2,x0,-12     	# x2 = 0xFFFFFFF4

	slti  x3,x1,32	    	# x3 = 0x01
	slti  x4,x1,3	    	# x4 = 0x00
	slti  x5,x1,-100    	# x5 = 0x00
	slti  x6,x2,-5      	# x6 = 0x01
	slti  x7,x2,0       	# x7 = 0x01
	slti  x8,x2,100     	# x8 = 0x01
	slti  x9,x2,-13     	# x9 = 0x00
	slti  x10,x2,-100   	# x10 = 0x00

	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
