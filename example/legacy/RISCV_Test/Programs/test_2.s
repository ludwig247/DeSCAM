
# @author :	salaheddin hetalani
# @name   : 	test_2.s
# @purpose: 	Testing the pipline regarding all kinds of dependencies that are possible among instructions. 

.globl _start
_start:
											    #STALL	     	     #FORWARDING
	#~~~~~~~~INST~~~~~~~~	#~InstAddress~	# ~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~      ~~NUM~~	~~~TYPE~~~    ~~NUM~~	~~~~~~TYPE~~~~~~ 
	addi  x1,x0,24		# 0x00	 	# x1 = 0x18 
	addi  x2,x0,32	 	# 0x04		# x2 = 0x20	
	addi  x3,x0,24	 	# 0x08		# x3 = 0x18		
	jalr  x0,x3,0		# 0x0C	 	 			
	add   x4,x2,x3		# 0x10	 	# x4 = 0x00
	addi  x5,x2,4		# 0x14	 	# x5 = 0x00
	addi  x6,x0,384		# 0x18		# x6 = 0x180 <-- address
	beq   x1,x1,FINALLY	# 0x1C
	add   x7,x2,x3		# 0x20		# x7 = 0x00
	addi  x8,x2,8		# 0x24		# x8 = 0x00
FINALLY: 
	addi  x9,x2,12		# 0x28		# x9 = 0x2C
	add   x10,x9,x3		# 0x2C		# x10 = 0x44
	beq   x10,x2,HALT	# 0x30
	jalr  x0,x10,0		# 0x34	 	
	beq   x10,x2,HALT	# 0x38		
	beq   x10,x2,HALT	# 0x3C		
	addi  x0,x0,0		# 0x40
	add   x11,x10,x10	# 0x44		# x11 = 0x88	
	beq   x10,x10,STOP	# 0x48		
	beq   x2,x2,BREAK	# 0x4C
	beq   x3,x3,HALT	# 0x50
	beq   x2,x2,BREAK	# 0x54
STOP:
	sw    x3,0(x6)		# 0x58		# mem[0x180..183] = 0x18000000
	jalr  x0,x11,0		# 0x5C	
	addi  x7,x7,4		# 0x60	
	addi  x7,x7,1		# 0x64	
	addi  x8,x8,1		# 0x68
BREAK:
	beq   x3,x2,HALT	# 0x6C	
	jalr  x0,x11,0		# 0x70	
	addi  x7,x7,1		# 0x74	
	addi  x7,x7,0		# 0x78
	addi  x12,x12,12	# 0x7C	
	addi  x13,x13,13	# 0x80	
	addi  x14,x14,14	# 0x84	
	sw    x2,4(x6)		# 0x88		# mem[0x184..187] = 0x20000000
	addi  x12,x11,36	# 0x8C		# x12 = 0xAC
	beq   x3,x3,HEY		# 0x90
HEY:
	sw    x11,8(x6)		# 0x94		# mem[0x188..18B] = 0x88000000
	addi  x17,x17,17	# 0x98		# x17 = 0x11
	jalr  x0,x12,0		# 0x9C
	add   x18,x17,x17	# 0xA0
	add   x19,x18,x18	# 0xA4
	add   x20,x19,x19	# 0xA8
	
	sw    x10,12(x6)	# 0xAC		# mem[0x18C..18F] = 0x44000000
	beq   x3,x3,HALLO	# 0xB0	
	add   x18,x17,x17	# 0xB4
	add   x19,x18,x18	# 0xB8
HALLO:
	addi  x13,x12,40	# 0xBC		# x13 = 0xD4
	sw    x10,16(x6)	# 0xC0		# mem[0x190..193] = 0x44000000
	beq   x3,x2,HALT	# 0xC4
	jalr  x0,x13,0		# 0xC8		
	add   x18,x17,x17	# 0xCC
	add   x19,x18,x18	# 0xD0
	add   x20,x3,x2		# 0xD4		# x20 = 0x38
	add   x21,x20,x20	# 0xD8		# x21 = 0x70
	beq   x21,x20,HALT	# 0xDC
	jal   x22,BYE		# 0xE0
	add   x23,x21,x20	# 0xE4
	add   x24,x20,x20	# 0xE8
BYE:
	add   x25,x21,x20	# 0xEC		# x25 = 0xA8
	sw    x10,20(x6)	# 0xF0		# mem[0x194..197] = 0x44000000
	beq   x3,x2,HALT	# 0xF4
	jal   x26,HELLOAGAIN	# 0xF8
	add   x23,x21,x20	# 0xFC
	add   x24,x20,x20	# 0x100
HELLOAGAIN:
	add   x27,x25,x25	# 0x104		# x27 = 0x150	
	sw    x10,24(x6)	# 0x108		# mem[0x198..19B] = 0x44000000
	addi  x28,x27,4		# 0x10C		# x28 = 0x154
	beq   x3,x2,HALT	# 0x110
	jal   x29,FINALBYE	# 0x114		# x29 = 0x118
	add   x23,x21,x20	# 0x118
	add   x24,x20,x20	# 0x11C
FINALBYE:
	add   x30,x29,x29	# 0x120		# x30 = 0x230
HALT:
	nop			# 0x124	 	 
	nop			# 0x128	 	# end of ID stage of the last instruction
	nop			# 0x12C	 	# end of EX stage of the last instruction
	nop			# 0x130	 	# end of MEM stage of the last instruction
	nop			# 0x134 	# end of WB stage of the last instruction
_end:
	ebreak
