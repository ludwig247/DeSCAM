#
# @author:Luka
# addi.s
#
# Test for add immediate (addi)
.globl _start

_start:
addi x1,x0,128		 # x1 = 128
addi x2,x1,0         # x2 = x1 = 128
addi x3,x2,10        # x3 = x2 + 10 = 138
addi x4,x2,-10       # x4 = x2 - 10 = 118

addi x5,x0,-128      # x5 = -128
addi x6,x5,0         # x6 = -128
addi x7,x5,10        # x7 = -118
addi x8,x5,-10       # x8 = -138

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall