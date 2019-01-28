#
# @author:Luka
# ori.s
#
# Test for or immediate (ori)
.globl _start

_start:
ori  x1,x0,7		 # x1 = 0x7
ori  x2,x1,8         # x2 = 0xF
ori  x3,x2,0         # x3 = 0xF
ori  x4,x3,-1        # x4 = 0xFFFFFFFF

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall
