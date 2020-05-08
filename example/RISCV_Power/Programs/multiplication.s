#
# @author:Don Dennis
# multiplication.s
#
# Multiplication using repeated addition
# a*b is returned in r5

# r1:a, r2:b, r3: is_neg
# r5: ans
_START_:
    addi $1, $0, 11
    addi $2, $0, 12
    addi $3, $0, 0
    addi $5, $0, 0
    blt  $0, $1, LOOP
    addi $3, $0, 1
    addi $4, $0, -1
    xor  $1, $1, $4
    addi $1, $1, 1
LOOP:
    beq $0, $1, DONE
    add $5, $5, $2
    addi $1, $1, -1
    jal $0, LOOP
DONE: 
    beq $0, $3, HALT
    addi $4, $0, -1
    xor  $5, $5, $4
    addi $5, $5, 1
HALT:
    addi $0, $0, 0 # end of program
