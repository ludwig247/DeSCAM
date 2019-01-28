#
# @author:Luka
# andi.s
#
# Test for and immediate (andi)
.globl _start

_start:
addi x1,x0,7		 # x1 = 0x7
addi x2,x0,8         # x2 = 0x8
andi x3,x1,1         # x3 = 0x1
andi x4,x1,15        # x4 = 0x7
andi x5,x2,7         # x5 = 0x0
andi x6,x2,9         # x6 = 0x8

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall