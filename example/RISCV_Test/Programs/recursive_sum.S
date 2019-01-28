#
# @author:Don Dennis
# recursive_sum.s
#
# Finds sum of the first N 
# numbers recursively. Demonstrates
# how recursive functions can be added.
# 
# x31: Return Address
# x30: Stack Pointer
# x29: Return Value
# x1 : N
.globl _start

_start:
	addi x1,x0,9		#0x00		# N = 9
	addi x30,x0,256 	#0x04		# stack pointer = 0x100
	jal  x31,FAB		#0x08
HALT:
	addi x0,x0,0		#0x0C		# end of ID stage
    addi x0,x0,0		#0x10		# end of EX stage
   	addi x0,x0,0		#0x14		# end of MEM stage
   	addi x0,x0,0		#0x18		# end of WB stage
# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall

FAB:
	addi x3,x31,0		#0x20
	jal  x31,PUSH		#0x24
	addi x4,x0,2		#0x28
	blt  x1,x4,RET_ONE	#0x2C
	add  x3,x0,x1		#0x30
	jal  x31,PUSH		#0x34
	addi x1,x1,-1		#0x38
	jal  x31,FAB		#0x3C
	jal  x31,POP		#0x40
	add  x29,x29, x3	#0x44
	addi x3,x0,0		#0x48
	beq  x3,x0,RET		#0x4C
RET_ONE: 
	addi x29,x0,1		#0x50
RET:	
	jal  x31,POP		#0x54
	add  x31,x0, x3		#0x58
	jalr x0,x31, 0		#0x5C
PUSH:
	addi x30,x30,4		#0x60
	sw   x3,0(x30)		#0x70
	jalr x0,x31,0		#0x74
POP:
	lw   x3,0(x30)		#0x78
	addi x30,x30,-4		#0x7C
	jalr x0,x31,0		#0x80

