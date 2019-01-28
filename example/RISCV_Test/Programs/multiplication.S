#
# @author:Don Dennis
# multiplication.s
#
# Multiplication using repeated addition
# a*b is returned in r5

# r1:a, r2:b, r3: is_neg
# r5: ans
.global _start
_start:
    addi x1, x0, 11   	#0x00
    addi x2, x0, 12   	#0x04
    addi x3, x0, 0	#0x08
    addi x5, x0, 0	#0x0C
    blt  x0, x1, LOOP	#0x10
    addi x3, x0, 1	#0x14
    addi x4, x0, -1	#0x18
    xor  x1, x1, x4	#0x1C
    addi x1, x1, 1	#0x20
LOOP:
    beq  x0, x1, DONE	#0x24
    add  x5, x5, x2	#0x28
    addi x1, x1, -1	#0x2C
    jal  x0, LOOP	#0x30
DONE: 
    beq  x0, x3, HALT	#0x34
    addi x4, x0, -1	#0x38
    xor  x5, x5, x4	#0x3C
    addi x5, x5, 1	#0x40
HALT:	
    addi x0,x0,0	#0x44	#end of ID stage
    addi x0,x0,0	#0x48	#end of EX stage
    addi x0,x0,0	#0x4C	#end of MEM stage
    addi x0,x0,0	#0x50	#end of WB stage

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall