#
# @author:Luka
# xori.s
#
# Test for xor immediate (xori)
.globl _start

_start:
addi  x1,x0,7		  # x1 = 0x7
xori  x2,x1,7         # x2 = 0x0
xori  x3,x1,4         # x3 = 0x3
xori  x4,x1,-1        # x4 = 0xFFFFFFF8
xori  x5,x4,0         # x5 = 0xFFFFFFF8

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall
