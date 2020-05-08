#
# @author:Don Dennis
# fibonacci.s
#
# Find the Nth fibonacci number.
# $5 holds N and ans returned in #3

addi $5,$0,9	# Replace with N
addi $1,$0,1 	#a1
addi $2,$0,0 	#a0
addi $3,$0,0 	#ans
addi $4,$0,1 	#i
FOR:
    add $3, $1, $2
    add $2, $0, $1
    add $1, $0, $3
    addi $4, $4, 1
    blt $4, $5, FOR
HALT:
    addi $0, $0, 0 # end of program
