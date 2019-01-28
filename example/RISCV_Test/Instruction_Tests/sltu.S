#
# @author:Luka
# sltu.s
#
# Test for set less than unsigned (sltu)
.globl _start

_start:
addi  x1,x0,7       # x1 = 7
addi  x2,x0,-12     # x2 = -12
addi  x31,x0,32     # x31 = 32
addi  x30,x0,3      # x30 = 3
addi  x29,x0,-100   # x29 = -100
addi  x28,x0,-5     # x28 = -5
addi  x27,x0,100    # x27 = -100
addi  x26,x0,-13    # x26 = -13

sltu x3,x1,x31	    # x3 = 1
sltu x4,x1,x30	    # x4 = 0
sltu x5,x1,x29      # x5 = 1
sltu x6,x2,x28      # x6 = 1
sltu x7,x2,x0       # x7 = 0
sltu x8,x2,x27      # x8 = 0
sltu x9,x2,x26      # x9 = 0
sltu x10,x2,x29     # x10 = 0

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall
