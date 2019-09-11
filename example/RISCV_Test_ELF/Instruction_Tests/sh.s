
# @author :	Luka
# @name   : 	sh.s
# @purpose: 	Test for store halfword (sh)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,128		# x1 = 0x80 <-- address
	addi x2,x0,156		# x2 = 0x9C <-- address
	addi x3,x0,352 		# x3 = 0x160
	addi x4,x0,55 		# x4 = 0x37
	addi x5,x0,1		# x5 = 0x01
	addi x6,x0,-13		# x6 = 0xFFFFFFF3

	sh   x3,0(x1) 		# mem[0x80..81] = 0x6001
	sh   x6,-2(x1)       	# mem[0x7E..7F] = 0xF3FF
	sh   x5,0(x2)        	# mem[0x9C..9D] = 0x0100
	sh   x4,2(x2)        	# mem[0x9E..9F] = 0x3700

	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
