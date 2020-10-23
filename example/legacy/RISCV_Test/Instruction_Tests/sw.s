
# @author :	Luka
# @name   : 	sw.s
# @purpose: 	Test for store word (sw)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,128		# x1 = 0x80 <-- address
	addi x2,x0,156		# x2 = 0x9C <-- address
	addi x3,x0,352 		# x3 = 0x160
	addi x4,x0,55 		# x4 = 0x37
	addi x5,x0,1		# x5 = 0x01
	addi x6,x0,-13		# x6 = 0xFFFFFFF3

	sw   x3,0(x1) 		# mem[0x80..83] = 0x60010000
	sw   x6,-4(x1)       	# mem[0x7C..7F] = 0xF3FFFFFF
	sw   x5,4(x1)        	# mem[0x84..87] = 0x01000000

	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
