#
# @author:Luka
# or.s
#
# Test for or (or)
.globl _start

_start:
addi x1,x0,7		 # x1 = 0x7
addi x2,x0,8         # x2 = 0x8
addi x3,x0,1         # x3 = 0x1
addi x4,x0,15        # x4 = 0xF

or   x1,x1,x1        # x1 = 0x7
or   x5,x1,x3        # x5 = 0x7
or   x6,x1,x4        # x6 = 0xF
or   x7,x1,x1        # x7 = 0x7
or   x8,x1,x2        # x8 = 0xF
or   x9,x2,x4        # x9 = 0xF
or   x10,x3,x0       # x10 = 0x1
or   x11,x0,x3       # x11 = 0x1

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall
