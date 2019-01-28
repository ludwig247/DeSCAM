#
# @author:Don Dennis
# push_pop.s
#
# Testing functions PUSH, POP
# and HALT. There are used as
# pseudo instructions in other programs
#
# x31: Return Address
# x30: Stack Pointer
# x3: push register
# x4: pop register

.global _start
_start:
	addi x3,x0,1345		#0x00	# value = 0x541
	addi x30,x0,64		#0x04	# stack pointer = 0x64
	jal  x31,PUSH		#0x08
	jal  x31,POP		#0x0C
HALT:
	addi x0,x0,0		#0x10	#end of ID stage
    addi x0,x0,0		#0x14	#end of EX stage
   	addi x0,x0,0		#0x18	#end of MEM stage
   	addi x0,x0,0		#0x1C	#end of WB stage
# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall

# Increments stack pointer and pushes the value in x3 to stack

PUSH:
	addi x30,x30,4		#0x24
	sw   x3, 0(x30)		#0x28
	jalr x0,x31,0		#0x2C

# Pops the value from stack to x4 and decrements stack pointer

POP:
	lw   x4,0(x30)		#0x30
	addi x30,x30,-4		#0x34
	jalr x0,x31,0		#0x38

