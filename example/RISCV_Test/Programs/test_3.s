
# @author :	salaheddin hetalani
# @name   : 	test_3.s
# @purpose: 	Testing the pipline regarding all kinds of dependencies that are possible among instructions. 

.globl _start
_start:											
											    #STALL	     	     #FORWARDING
	#~~~~~~~~INST~~~~~~~~	#~InstAddress~	# ~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~      ~~NUM~~	~~~TYPE~~~    ~~NUM~~	~~~~~~TYPE~~~~~~     
	addi  x1,x0,384		# 0x00	 	# x1 = 0x180 <-- address
	addi  x2,x0,36	 	# 0x04		# x2 = 0x24	
	addi  x3,x0,60	 	# 0x08		# x3 = 0x3C
	sw    x2,0(x1)		# 0x0C		# mem[0x180..183] = 0x24000000
	sw    x3,4(x1)		# 0x10		# mem[0x184..187] = 0x3C000000	
	jalr  x0,x2,0		# 0x14
	addi  x4,x3,0		# 0x18	
	addi  x5,x2,0		# 0x1C
	add   x6,x2,x3		# 0x20
	lw    x7,4(x1)		# 0x24		# x7 = mem[0x184] = 0x3C
	add   x8,x3,x3		# 0x28		# x8 = 0x78
	jalr  x0,x7,0		# 0x2C
	add   x9,x2,x3		# 0x30
	add   x10,x3,x3		# 0x34
	add   x11,x7,x3		# 0x38		
	add   x12,x7,x2		# 0x3C		# x12 = 0x60
	sw    x12,8(x1)		# 0x40		# mem[0x188..18B] = 0x60000000		
	add   x13,x12,x12	# 0x44		# x13 = 0xC0
	lw    x14,8(x1)		# 0x48		# x14 = 0x60
	beq   x12,x3,HALT	# 0x4C		# not taken
	jalr  x14,x14,0		# 0x50		# x14 = 0x54
	add   x16,x15,x14	# 0x54
	add   x17,x14,x13	# 0x58
	add   x18,x2,x3		# 0x5C
	add   x19,x3,x13	# 0x60		# x19 = 0xFC
	lw    x20,8(x1)		# 0x64		# x20 = 0x60
	sw    x20,40(x20)	# 0x68		# mem[0x88..8B] = 0x60000000		
HALT:
	nop			
	nop			# 0x70	 	# end of ID stage of the last instruction
	nop			# 0x74	 	# end of EX stage of the last instruction
	nop			# 0x78	 	# end of MEM stage of the last instruction
	nop			# 0x7C	 	# end of WB stage of the last instruction
_end:
	ebreak
