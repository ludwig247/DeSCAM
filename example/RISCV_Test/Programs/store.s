
# @author :	Luka
# @name   : 	store.s
# @purpose: 	Testing stores and loads in various situations.

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi  x1,x0,128		# x1 = 0x80 <-- address
	addi  x2,x0,156		# x2 = 0x9C <-- address

	lui   x20,5          	# x20 = 0x05 << 12 = 0x5000
	auipc x21,0          	# x21 = PC = 0x0C
	auipc x22,100		# x22 = PC + (100 << 12) = 0x64010

	addi  x5,x0,352 	# x5 = 0x160 <-- imm
	addi  x6,x0,55 		# x6 = 0x37 <-- imm
	addi  x7,x0,1		# x7 = 0x01 <-- imm
	addi  x8,x0,3		# x8 = 0x03 <-- imm

	addi  x9,x0,-1		# x9 = 0xFFFFFFFF <-- imm
	addi  x10,x0,129	# x10 = 0x81 <-- imm
	addi  x11,x0,-100	# x11 = 0xFFFFFF9C <-- imm

	sw    x5,0(x1)      	# mem[0x80..83] = 0x60010000
	sh    x6,4(x1)      	# mem[0x84..85] = 0x3700
	sb    x7,6(x1)      	# mem[0x86] = 0x01
	sb    x8,0(x1)      	# mem[0x80] = 0x03

	sw    x9,0(x2)		# mem[0x9C..9F] = 0xFFFFFFFF
	sw    x10,4(x2)		# mem[0xA0..A3] = 0x81000000
	sh    x11,8(x2)		# mem[0xA4..A5] = 0x9CFF

	lw    x31,0(x2)    	# x31 = mem[0x9C] = 0xFFFFFFFF
	lh    x30,0(x2)    	# x30 = mem[0x9C] = 0xFFFFFFFF
	lhu   x29,0(x2)    	# x29 = mem[0x9C] = 0x0000FFFF
	lb    x28,0(x2)    	# x28 = mem[0x9C] = 0xFFFFFFFF
	lbu   x27,0(x2)    	# x27 = mem[0x9C] = 0x000000FF

	lb    x26,4(x2)    	# x26 = mem[0xA0] = 0xFFFFFF81
	lbu   x25,4(x2)    	# x25 = mem[0xA0] = 0x00000081

	nop
	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
