#
# @author:Don Dennis
# recursive_sum.s
#
# Finds sum of the first N 
# numbers recursively. Demonstrates
# how recursive functions can be added.
# 
# $31: Return Address
# $30: Stack Pointer
# $29: Return Value
# $1 : N

_START:
	addi $1,$0,9		# N = 9
	addi $30,$0,256 	# stack pointer = 0x100
	jal  $31,FAB
HALT:
	addi $0,$0,0 # end of program

FAB:
	addi $3,$31,0
	jal  $31,PUSH
	addi $4,$0,2
	blt  $1,$4,RET_ONE
	add  $3,$0,$1
	jal  $31,PUSH
	addi $1,$1,-1
	jal  $31,FAB
	jal  $31,POP
	add  $29,$29, $3
	addi $3,$0,0
	beq  $3,$0,RET
RET_ONE: 
	addi $29,$0,1
RET:
	jal  $31,POP
	add  $31,$0, $3
	jalr $0,$31, 0

PUSH:
	addi $30,$30,4
	sw   $30,$3,0
	jalr $0,$31,0
POP:
	lw   $3,$30,0
	addi $30,$30,-4
	jalr $0,$31,0	
