#
# @author:Luka
# xor.s
#
# Test for xor (xor)
.globl _start

_start:
addi x1,x0,7		 # x1 = 0x7
addi x2,x0,4         # x2 = 0x4
addi x3,x0,-1        # x3 = 0x1

xor  x4,x1,x1        # x4 = 0x0
xor  x5,x1,x2        # x5 = 0x3
xor  x6,x1,x3        # x6 = 0xFFFFFFF8
xor  x7,x6,x0        # x7 = 0xFFFFFFF8
xor  x8,x0,x6        # x8 = 0xFFFFFFF8
xor  x9,x7,x7        # x9 = 0x0

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall
