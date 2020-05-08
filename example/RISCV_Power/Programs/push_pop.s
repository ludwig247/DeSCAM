#
# @author:Don Dennis
# push_pop.s
#
# Testing functions PUSH, POP
# and HALT. There are used as
# pseudo instructions in other programs
#
# $31: Return Address
# $30: Stack Pointer
# $3: push register
# $4: pop register

_START:
	addi $3,$0,1345	# value = 0x541
	addi $30,$0,64	# stack pointer = 0x64
	jal  $31,PUSH
	jal  $31,POP
HALT:
	addi $0, $0,0 #nop

# Increments stack pointer and
# pushes the value in $3 to stack
PUSH:
	addi $30,$30,4
	sw   $30,$3, 0
	jalr $0,$31,0

# Pops the value from stack to $4
# and decrements stack pointer
POP:
	lw   $4,$30,0
	addi $30,$30,-4
	jalr $0,$31,0	
