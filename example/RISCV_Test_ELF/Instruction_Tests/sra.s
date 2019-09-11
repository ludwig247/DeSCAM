
# @author :	Luka
# @name   : 	sra.s
# @purpose: 	Test for shift right arithmetic (sra)

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,64        	# x1 = 0x40
	addi x2,x0,-65       	# x2 = 0xFFFFFFBF
	addi x3,x0,1         	# x3 = 0x01
	addi x4,x0,5         	# x4 = 0x05
	addi x5,x0,2         	# x5 = 0x02
	addi x6,x0,13        	# x6 = 0x0D

	sra x7,x1,x3         	# x7 = 0x20
	sra x8,x7,x4         	# x8 = 0x01
	sra x9,x8,x0         	# x9 = 0x01
	sra x10,x9,x6        	# x10 = 0x00

	sra x11,x2,x5        	# x11 = 0xFFFFFFEF
	sra x12,x11,x6       	# x12 = 0xFFFFFFFF
	sra x13,x12,x0       	# x13 = 0xFFFFFFFF
	sra x14,x0,x4        	# x14 = 0x00

	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
