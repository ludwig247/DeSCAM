#
# @author:Luka
# store.s
#
# Tests stores and loads in various situations
.globl _start

_start:
addi x1,x0,128		#0x00	 # address 0x80
addi x2,x0,156		#0x04	 # address 0x9C

lui   x20,5     	#0x08    # x20 = 5 << 12
auipc x21,0          	#0x0c	 # x21 = PC
auipc x22,100		#0x10	 # x22 = PC + (100 << 12)

addi  x5,x0,352 	#0x14	 # 0x160 imm
addi  x6,x0,55 		#0x18	 # 0x37 imm
addi  x7,x0,1		#0x1c	 # 0x1 imm
addi  x8,x0,3		#0x20	 # 0x3 imm

addi  x9,x0,-1		#0x24	 # 0xFFFFFFFF imm
addi  x10,x0,129	#0x28  	 # 0x81 imm
addi  x11,x0,-100	#0x2c 	 # 0xFFFFFF9C imm
	
sw    x5,0(x1)  	#0x30 	 # mem[0x80] = 0x160
sh    x6,4(x1)		#0x34 	 # mem[0x84] = 0x37
sb    x7,6(x1) 		#0x38 	 # mem[0x86] = 0x1
sb    x8,0(x1) 		#0x3c 	 # mem[0x80] = 0x3

sw    x9,0(x2)		#0x40 	 # mem[0x9C] = 0xFFFFFFFF
sw    x10,4(x2)		#0x44 	 # mem[0xA0] = 0x81
sh    x11,8(x2) 	#0x48 	 # mem[0xA4] = 0xFF9C

lw    x31,0(x2) 	#0x4c 	 # R31 = mem[0x9C] = 0xFFFFFFFF
lh    x30,0(x2)     #0x50 	 # R30 = mem[0x9C] = 0xFFFFFFFF
lhu   x29,0(x2)     #0x54 	 # R29 = mem[0x9C] = 0x0000FFFF
lb    x28,0(x2)     #0x58 	 # R28 = mem[0x9C] = 0xFFFFFFFF
lbu   x27,0(x2)     #0x5c 	 # R27 = mem[0x9C] = 0x000000FF

lb    x26,4(x2)    	#0x60 	 # R26 = mem[0xA0] = 0xFFFFFF81
lbu   x25,4(x2)    	#0x64	 # R25 = mem[0xA0] = 0x00000081

addi  x0,x0,0		#0x68	#end of ID stage of the last instruction
addi  x0,x0,0		#0x6c	#end of EX stage of the last instruction
addi  x0,x0,0		#0x70	#end of MEM stage of the last instruction
addi  x0,x0,0		#0x74	#end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall